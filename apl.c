/* apl.c  (c) 2012-2013 Dirk Laurie

   Core routines for apl.lua
   Same license as Lua 5.2.2 (c) 1994-2012 Lua.org, PUC-Rio

*/

/* on Linux compile with `cc -shared apl.c -o apl_core.so` */

/* on Windows, define the symbols 'LUA_BUILD_AS_DLL' and 'LUA_LIB' and
 * compile and link with stub library lua52.lib (for lua52.dll)
 * generating apl_core.dll. If necessary, generate lua52.lib and lua52.dll
 * by compiling Lua sources with 'LUA_BUILD_AS_DLL' defined.
*/

#include <stdlib.h>
#include <time.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "math.h"

/* For debugging. I've put these back too often to omit them altogether.
static void stackprint(lua_State *L, int from) {
   int top=lua_gettop(L);
   printf("Stack:");
   while (from<=top) {
     printf(" %s",luaL_tolstring(L,from++,NULL));
     lua_pop(L,1); }
   printf("\n");
}
static void arrayprint(lua_State *L, int from, int to) {
   printf("Array:");
   while (from<=to) { lua_rawgeti(L,1,from++); 
     printf(" %s",luaL_tolstring(L,-1,NULL)); 
     lua_pop(L,2); }
   printf("\n");
}
 */

#define store(tbl,item,idx) lua_pushvalue(L,item); lua_rawseti(L,1,idx)
#define move(a,from,to) lua_rawgeti(L,a,from); lua_rawseti(L,a,to)
#define swap(a,x,y) lua_rawgeti(L,a,x); lua_rawgeti(L,a,y); \
  lua_rawseti(L,a,x); lua_rawseti(L,a,y); 

/* get(tbl,a,b) */
static int block_get(lua_State *L) {
  int a=luaL_checkint(L,2), b=luaL_checkint(L,3), inc, count;
  luaL_checktype(L,1,LUA_TTABLE);
  inc = a<=b ? 1 : -1; 
  count = (b-a)*inc+1;
  lua_settop(L,1);
  if (!lua_checkstack(L,count)) luaL_error(
     L, "stack overflow: 'get' needs %d values",count);
  for(;;a+=inc) { lua_rawgeti(L,1,a); if(a==b) break; } 
  return count;
}

/* set(tbl,a,b,...) */
static int block_set(lua_State *L) {
  int a=luaL_checkint(L,2), b, top=lua_gettop(L), count=top-3, 
      inc, item=4;
  luaL_checktype(L,1,LUA_TTABLE);
  b = (lua_isnoneornil(L,3)) ? a+count-1 : luaL_checkint(L,3);
  if (count<1) return 0;  
  inc = a<=b ? 1 : -1; 
  if (top==4) for(;;a+=inc) { store(tbl,top,a); if(a==b) break; }
  else for(;;a+=inc) { 
    if (item>top) item=4; 
    store(tbl,item++,a); 
    if(a==b) break; 
  }
  lua_pushvalue(L,1);
  return 1;
}   

/* move(tbl,a1,b1,a2[,b2]) */
static int block_move(lua_State *L) {
  int a1=luaL_checkint(L,2), b1=luaL_checkint(L,3), 
      a2=luaL_checkint(L,4), b2, inc1, inc2;
  luaL_checktype(L,1,LUA_TTABLE);
  inc1 = a1<=b1 ? 1 : -1; 
  if (lua_isnoneornil(L,5)) { inc2=inc1; b2=a2+b1-a1; }
  else {
    b2=luaL_checkint(L,5);
    inc2 = a2<=b2 ? 1 : -1; 
    luaL_argcheck(L,(b1-a1)*inc1==(b2-a2)*inc2,5,
       "source and destination must have the same length");
  }
  lua_settop(L,1);
  if (inc1!=inc2) { /* reverse direction */
    for(;(a1-b2)*inc1<0;a1+=inc1,a2+=inc2) { move(1,a1,a2); }
    for(;(b1-a2)*inc1>0;b1-=inc1,b2-=inc2) { move(1,b1,b2); }
    for(;(a2-a1)*inc1>0;a1+=inc1,a2+=inc2) { swap(1,a1,a2); }  
  }
  else if ((a2-a1)*inc1<0) 
    for (;;a1+=inc1,a2+=inc2) { move(1,a1,a2); if (a1==b1) break; }
  else for (;;b1-=inc1,b2-=inc2) { move(1,b1,b2); if (a1==b1) break; }
  lua_pushvalue(L,1);
  return 1;   
}

/* transpose(tbl,m,n,tblT) */  
static int block_transpose(lua_State *L) {
   int i,j, m=luaL_checkint(L,2), n=luaL_checkint(L,3);
   luaL_checktype(L,1,LUA_TTABLE); luaL_checktype(L,4,LUA_TTABLE);
   luaL_argcheck(L,!lua_compare(L,1,4,LUA_OPEQ),1,
     "not supported: in-place transposition");
   for (i=0; i<m; i++) for (j=0; j<n; j++) {
      lua_rawgeti(L,1,j+i*n+1); lua_rawseti(L,4,i+j*m+1);}
   return 1;
}

/* map(table_or_monadic_function,...) */
static void tuple_call(lua_State *L) {
  int i, top=lua_gettop(L);
  for (i=2; i<=top; i++) {
    lua_pushvalue(L,1); lua_pushvalue(L,i); lua_call(L,1,1); 
    lua_replace(L,i);
  }
}
static void tuple_index(lua_State *L) {
  int i, top=lua_gettop(L);
  for (i=2; i<=top; i++) {
    lua_pushvalue(L,i); lua_gettable(L,1); 
    lua_replace(L,i); 
  }
}
static int tuple_map(lua_State *L) {
  if (lua_type(L,1)==LUA_TFUNCTION) tuple_call(L);
  else if  (lua_type(L,1)==LUA_TTABLE) tuple_index(L);
  else return 0; 
  return lua_gettop(L)-1; 
}

/* pick(tbl,a,b,fct[,count]) */
static int block_pick(lua_State *L) {
  int i, j=0, inc=1, a=luaL_checkint(L,2), b=luaL_checkint(L,3);
  luaL_checktype(L,4,LUA_TFUNCTION);
  if (lua_isnoneornil(L,5)) j=1; 
  else { j=luaL_checkint(L,5); if (j<=0) return 0; }
  if (b<a) inc=-1;
  for(;;a+=inc) {  
    lua_settop(L,4);
    lua_pushvalue(L,4); lua_rawgeti(L,1,a); lua_call(L,1,1); 
    if (lua_toboolean(L,-1)) j--;
    if (j==0) { lua_pushinteger(L,a); return 1; }
    if(a==b) break; 
  }
  return 0;
}  
   
/* keep(count,...) */
static int tuple_keep(lua_State *L) {
  int count=lua_absindex(L,luaL_checkint(L,1));
  lua_settop(L,count+1);
  return count;
}

/* where() */
static int lua_where (lua_State *L) {
  luaL_where(L,luaL_checkint(L,1));
  return 1;
}

#define tbl 1
#define low 2
#define middle 3
#define high 4
#define cmp 5
#define wrk 6
#define ai 7
#define precedes(i,j) (lua_isnoneornil(L,cmp)? lua_compare(L,i,j,LUA_OPLT): \
    (lua_pushvalue(L,cmp), lua_pushvalue(L,i), lua_pushvalue(L,j), \
    lua_call(L,2,1), test=lua_toboolean(L,-1), lua_pop(L,1), test))

/* merge(tbl,low,middle,high,cmp) */
static int block_merge(lua_State *L) {
  int lo=luaL_checkint(L,low), mid=luaL_checkint(L,middle), 
    hi=luaL_checkint(L,high), i, j, k, test;  
  if (hi<=mid || mid<=lo) return 0;
  luaL_checktype(L,tbl,LUA_TTABLE); 
  if (!lua_isnoneornil(L,cmp)) {
    luaL_checktype(L,cmp,LUA_TFUNCTION);
#ifdef CHECK_COMPARISON_FUNCTION
    lua_settop(L,ai-1);
    lua_rawgeti(L,tbl,lo);
    luaL_argcheck(L,!precedes(ai,ai),cmp,"invalid order function for sorting");
#endif
  }
  lua_settop(L,wrk-1);
  lua_createtable(L,mid-lo+1,0);
  for (i=1,j=lo;j<=mid;i++,j++) { lua_rawgeti(L,tbl,j); lua_rawseti(L,wrk,i); }  
  lua_rawgeti(L,tbl,j); lua_rawgeti(L,wrk,1); 
  for (i=1,k=lo; k<j && j<=hi; k++)
    if (precedes(ai,ai+1)) {
      lua_insert(L,ai); 
      lua_rawseti(L,tbl,k); 
      lua_rawgeti(L,tbl,++j);
      lua_insert(L,ai);
    } else { 
      lua_rawseti(L,tbl,k); 
      lua_rawgeti(L,wrk,++i); 
    }    
  for (;k<j;k++,i++) { lua_rawgeti(L,wrk,i); lua_rawseti(L,tbl,k); }
}
    
/* sort(tbl,l,r,cmp) */
#undef cmp
#undef precedes
#define cmp 4
#define v 5
#define aj 6
#define precedes(i,j) (lua_isnoneornil(L,cmp)? lua_compare(L,i,j,LUA_OPLT): \
    (lua_pushvalue(L,cmp), lua_pushvalue(L,i), lua_pushvalue(L,j), \
    lua_call(L,2,1), test=lua_toboolean(L,-1), lua_pop(L,1), test))
static int block_sort(lua_State *L) {
  int first=luaL_checkint(L,2), last=luaL_checkint(L,3), i, j, k, test;  
  if (last<=first) return 0;
  luaL_checktype(L,tbl,LUA_TTABLE); 
  if (!lua_isnoneornil(L,cmp)) {
    luaL_checktype(L,cmp,LUA_TFUNCTION);
#ifdef CHECK_COMPARISON_FUNCTION
    lua_settop(L,v-1);
    lua_rawgeti(L,tbl,first);
    luaL_argcheck(L,!precedes(v,v),cmp,"invalid order function for sorting");
#endif
  }
/* insert sort */
  lua_settop(L,v-1);
  for(i=first+1;i<=last;i++) {
    k=first;
    lua_rawgeti(L,tbl,i);
    for (j=i;j>first;j--) {
      lua_rawgeti(L,tbl,j-1);
      if (precedes(v,aj)) { lua_rawseti(L,tbl,j); }
      else { lua_settop(L,v); k=j; break; }
    }
    lua_rawseti(L,tbl,k); 
  }
  return 0;
}

/* Auxiliary package for the circle functions. Numerically stable
   versions of the inverse hyperbolics due to W. Kahan. Those can be
   replaced by C builtins when the C99 standard is met, removing the
   need for math_log1p. */
static lua_Number math_log1p (lua_Number x) {
  lua_Number u=1+x;
  if (u==1) return x;
  return log(u)*x/(u-1);
}

static int math_circ0 (lua_State *L) {
  lua_Number x=luaL_checknumber(L, 1);
  lua_pushnumber(L, sqrt(1-x*x));
  return 1;
}

static int math_circ4 (lua_State *L) {
  lua_Number x=luaL_checknumber(L, 1);
  lua_pushnumber(L, sqrt(1+x*x));
  return 1;
}

static int math_circ_4 (lua_State *L) {
  lua_Number x=luaL_checknumber(L, 1);
  lua_pushnumber(L, sqrt(x*x-1));
  return 1;
}

static int math_acosh (lua_State *L) {
  lua_Number x=luaL_checknumber(L, 1);
  lua_pushnumber(L, log(x+sqrt(x*x-1)));
  return 1;
}

static int math_asinh (lua_State *L) {
  lua_Number x=luaL_checknumber(L, 1);
  lua_Number s=fabs(x);
  s=math_log1p(s*(1+s/(sqrt(1+x*x)+1)));
  if (x<0) s=-s;
  lua_pushnumber(L,s);
  return 1;
}   

static int math_atanh (lua_State *L) {
  lua_Number x=luaL_checknumber(L, 1);
  lua_Number s=fabs(x);
  s=math_log1p(2*s/(1-s))/2;
  if (x<0) s=-s;
  lua_pushnumber(L,s);
  return 1;
}   

static const luaL_Reg funcs[] = {
  {"get", block_get},
  {"set", block_set},
  {"move", block_move},
  {"transpose", block_transpose},
  {"pick", block_pick},
  {"map", tuple_map},
  {"keep", tuple_keep},
  {"where", lua_where},
  {"sort", block_sort},
  {"merge", block_merge},
  {"circ0", math_circ0},
  {"circ4", math_circ4},
  {"circ_4", math_circ_4},
  {"acosh", math_acosh},
  {"asinh", math_asinh},
  {"atanh", math_atanh},
  {NULL, NULL}
};

LUAMOD_API int luaopen_apl_core (lua_State *L) {
  luaL_newlib(L, funcs);
  return 1;
}

