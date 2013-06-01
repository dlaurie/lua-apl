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

/* Functions with prefix "block" receive a range (which may go up or
 *   down) as second and third arguments. These functions were initially
 *   developed in collaboration with John Hind for the `xtable` library.
 * Functions with prefix "apl" follow the conventions for APL tables.
 */

#include <stdlib.h>
#include <time.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "math.h"

/* For debugging. I've put these back too often to omit them altogether. */
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
/* */

#define store(tbl,item,idx) lua_pushvalue(L,item); lua_rawseti(L,tbl,idx)
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
  if (top==4) for(;;a+=inc) { store(1,top,a); if(a==b) break; }
  else for(;;a+=inc) { 
    if (item>top) item=4; 
    store(1,item++,a); 
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

/* `map` and `keep` might no longer be needed, check apl-lib.lua */

/* keep(count,...) */
static int tuple_keep(lua_State *L) {
  int count=lua_absindex(L,luaL_checkint(L,1));
  lua_settop(L,count+1);
  return count;
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
    lua_pushvalue(L,i); lua_rawget(L,1); 
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
   
/* where() */
static int lua_where (lua_State *L) {
  luaL_where(L,luaL_checkint(L,1));
  return 1;
}

/* ------------- Sort package ------------------------ */

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
#undef tbl
#undef low
#undef middle
#undef high
#undef cmp
#undef wrk
#undef ai
#undef v
#undef aj
#undef precedes

/* ------------------ Circle package ----------------------- */

/* Numerically stable versions of the inverse hyperbolics due to 
   W. Kahan. Those can be replaced by C builtins when the C99 
   standard is met, removing the need for math_log1p. */
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

/* tests whether [1] is an integer */
static int core_is_int(lua_State *L) {
  lua_pushinteger(L,lua_tointeger(L,1));
  lua_pushboolean(L,lua_compare(L,1,-1,LUA_OPEQ));
  return 1;
}

/* -------------------- core APL package ----------------------- */

/* An APL array `A` is a Lua table with
 * - a metatable supplying _len, __index, __newindex.
 * - A.apl_len = length at creation
 * - A.rows = number of rows (matrix only)
 * - A.cols = number of columns (matrix only)  
 * - A.apl_qr = a table or userdata containing the QR factorization 
 *      (numeric matrix which is unchanged since last fatorizion only)
 */

/* Creates a new APL array of length `len`, and initializes its items to 
   the Lua value at [init], if any, otherwise to the first `len` integers. 
   (0,+1) */
#define apl_setmetatable(L,index) \
  lua_getfield(L,LUA_REGISTRYINDEX,"apl_meta"); \
  lua_setmetatable(L,index);
#define apl_getfield(L,tbl,key) \
  lua_pushstring(L,key); lua_rawget(L,tbl);
#define apl_setfield(L,tbl,key) \
  lua_pushstring(L,key); lua_rawset(L,tbl);
static void core_new(lua_State *L, int len, int init) {
  int i, tbl=lua_gettop(L)+1;
  lua_createtable(L,len,3);
  lua_pushinteger(L,len);
  lua_setfield(L,tbl,"apl_len");           
  if (!init || lua_isnoneornil(L,init)) 
    for (i=1; i<=len; i++) { lua_pushinteger(L,i); lua_rawseti(L,tbl,i); }
  else 
    for (i=1; i<=len; i++) { lua_pushvalue(L,init); lua_rawseti(L,tbl,i); }
  apl_setmetatable(L,tbl);
}   

/* analogue of luaL_len, interrogates `apl_len` first */
static int aplL_len(lua_State *L, int tbl) {
  int l;
  apl_getfield(L,tbl,"apl_len"); 
  if (lua_isnil(L,-1)) l=lua_rawlen(L,tbl);
  else l=lua_tointeger(L,-1);
  lua_pop(L,1);   
  return l;
}

/* apl_meta.__len */
static int apl_len(lua_State *L) {
  lua_pushinteger(L,aplL_len(L,1));   
  return 1;
}

/* Indexing. Only a string index can legally penetrate to this level.
 * APL arrays are fully initialized and should not acquire holes. The 
 * Lua module catches accesses via table and function keys.
 */
static int apl_index(lua_State *L) {
  luaL_argcheck(L,lua_type(L,2)!=LUA_TNUMBER,2,"index out of range");
  luaL_checktype(L,2,LUA_TSTRING);
  luaL_checktype(L,1,LUA_TTABLE);
  lua_rawget(L,1);
  return 1;
}
static int apl_newindex(lua_State *L) {
  luaL_argcheck(L,lua_type(L,2)!=LUA_TNUMBER,2,"index out of range");
  luaL_checktype(L,2,LUA_TSTRING);
  luaL_checktype(L,1,LUA_TTABLE);
  lua_rawset(L,1);
  return 0;
}

#define apl_intfield(L,tbl,stringkey,dest) \
  lua_pushstring(L,stringkey); \
  lua_rawget(L,tbl); \
  if (!lua_isnoneornil(L,-1)) dest = lua_tointeger(L,-1); 
#define apl_getshapeinfo(a,l,m,n) \
  l=luaL_len(L,a); \
  apl_intfield(L,a,"rows",m); \
  apl_intfield(L,a,"cols",n); \
  lua_pop(L,2)
#define apl_clonefield(L,source,target,field) \
  lua_pushstring(L,field); \
  lua_rawget(L,source); \
  if (!lua_isnil(L,-1)) { \
    lua_pushstring(L,field); lua_insert(L,-2);\
    lua_rawset(L,target); }\
  else lua_pop(L,1);
#define apl_cloneshape(L,tbl,source,target) \
   if (tbl) { apl_clonefield(L,source,target,"rows"); \
              apl_clonefield(L,source,target,"cols"); }

/* stripped-down reshape: rho(v,n) makes an n-vector, rho(v,m,n) an
   m×n matrix, filled copies of v, whatever v is */
static int apl_rho(lua_State *L) {
  int i, len=luaL_checkint(L,2), m=-1, n=1;
  luaL_argcheck(L,len>=0,2,"must be a non-negative integer");
  if (!lua_isnoneornil(L,3)) { 
    m=len; n=luaL_checkint(L,3); len=m*n; 
    luaL_argcheck(L,n>=0,3,"must be a non-negative integer"); 
  }
  lua_settop(L,1);
  core_new(L,len,1);
  if (m>=0) { 
    lua_pushinteger(L,m); lua_setfield(L,2,"rows"); 
    lua_pushinteger(L,n); lua_setfield(L,2,"cols"); 
  }
  return 1;
}

/* iota(n) */
static int apl_iota(lua_State *L) {
  int i, len=luaL_checkint(L,1);
  luaL_argcheck(L,len>=0,1,"must be a non-negative integer");
  lua_settop(L,0);
  lua_pushnil(L);  
  core_new(L,len,1);
  return 1;
}

/* check compatibility of shapes */
static int check_compat(lua_State *L, int a1, int a2, int op, int *m, int *n) {
  int l1=-1,m1=-2,n1=-3, l2=-4,m2=-5,n2=-6,k=1,l=1;
  if (!lua_istable(L,a1) || !lua_istable(L,a2)) return 1;    /* scalar */    
  apl_getshapeinfo(a1,l1,m1,n1);
  apl_getshapeinfo(a2,l2,m2,n2);
  if (l1>=0 && l2>=0) { k=l1; l=l2; }  /* two vectors */
  else if(op==1) {
    if (l1<0 && l2<0) { /* two matrices */
       k=m1; l=m2;
       if (k==l) { k=n1; l=n2; }
    }
    else if (n1==1&&l2>=0) { k=m1; l=l2; } /* one-column matrix and vector */
    else if (m1==1&&l2>=0) { k=n1; l=l2; }    /* one-row matrix and vector */
    else if (l1>=0&&n2==1) { k=m2; l=l1; } /* vector and one-column matrix */
    else if (l1>=0&&m2==1) { k=n2; l=l1; }    /* vector and one-row matrix */
    else { k=l1; l=l2; }                  /* vector and incompatible matrix */ 
  }
  if(op==2) {
    if (l2>=0) { k=n1; l=l2; }       /* matrix and vector */
    else if (l1>=0) { k=l1; l=m2; }  /* vector and matrix */
    else { k=n1; l=m2; }                 /* two matrices */
  }   
  if (k==l) return 1;
  if (m&&n) { *m=k; *n=l; }
  return 0;
}

/* compat(a1,a2,op)
   For op=1, returns true if
   - either a1 or a2 is scalar
   - a1 and a2 are both vectors of the same length
   - a1 and a2 have identical shapes
   - either a1 or a2 is a vector and the other a one-row or one-column
     matrix of the same length
   For op=2, returns true if
   - either a1 or a2 is scalar
   - a1 and a2 are both vectors of the same length
   - a1 is a vector as long as the columns of a2
   - a2 is a vector as long as the rows of a1
   - a1 has as many columns as a2 has rows
  Returns false,m,n otherwise, where m and n are the two numbers that
    break compatibility 
 */
static int apl_compat(lua_State *L) {
  int m,n,op=luaL_checkint(L,3),res;
  luaL_argcheck(L,op==1||op==2,3,"must be 1 or 2");  
  res = check_compat(L,1,2,op,&m,&n);
  lua_pushboolean(L,res);
  if (res) return 1;
  lua_pushinteger(L,m); lua_pushinteger(L,n);
  return 3;
}

/* each(f,a): applies f termwise to every item in a */
static int apl_each(lua_State *L) {
  int i, n, tbl=lua_istable(L,2);
  luaL_checktype(L,1,LUA_TFUNCTION);
  luaL_argcheck(L,!lua_isnoneornil(L,2),2,"nil not allowed");
  lua_settop(L,2);
  if (!tbl) { 
    lua_call(L,1,1);
    return 1;
  }  
  n=luaL_len(L,2);
  core_new(L,n,0);
  for (i=1; i<=n; i++) {
    lua_pushvalue(L,1);
    lua_rawgeti(L,2,i);
    if (lua_isnoneornil(L,-1)) { 
      lua_rawseti(L,3,i); lua_settop(L,3); continue; 
    }    
    lua_call(L,1,1);
    lua_rawseti(L,3,i);
  }
  apl_cloneshape(L,1,2,3); 
  return 1;
}

#define f 1
#define a1 2
#define a2 3
#define r 4
#define x1 4
#define x2 5
/* both(f,a1,a2,x1,x2): 
 * Returns f(a1,a2) when a1 and a2 are both non-tables, ignoring the
   other arguments.
 * Otherwise applies f termwise, and stores the results in a fresh table,
   which is returned after copying the shape from a1, or if a1 is not 
   a table, from a2.
 * If x1 and x2 both test `false`, the lengths of a1 and a2 must match.
 * If either tests `true`, the corresponding argument is allowed to be 
   a scalar, or consist of a single value, which will be used every time.
 */
static int apl_both(lua_State *L) {
  int both1=lua_toboolean(L,x1), both2=lua_toboolean(L,x2), 
    i, n, n1=1, n2=1, s=0, tbl1=lua_istable(L,a1), tbl2=lua_istable(L,a2); 
  luaL_checktype(L,f,LUA_TFUNCTION);
  luaL_argcheck(L,!lua_isnoneornil(L,a1),a1,"nil not allowed");
  luaL_argcheck(L,!lua_isnoneornil(L,a2),a2,"nil not allowed");
  lua_settop(L,r-1);
  if (!tbl1 && !tbl2) {  /* both scalar */
    lua_call(L,2,1);
    return 1;
  }  
  if (tbl1) n1=luaL_len(L,a1); 
  if (tbl2) n2=luaL_len(L,a2);
  n = n1>n2?n1:n2;
  core_new(L,n,0);
  if (!(n1&&n2)) return 1;  /* nothing to do */
  if (n1!=1) both1=0;
  if (n2!=1) both2=0;
  if (tbl1 && both2) { s=a2; tbl2=0; }
  else if (tbl2 && both1) { s=a1; tbl1=0; }
  else { 
   luaL_argcheck(L,check_compat(L,a1,a2,1,NULL,NULL),a2,
      "shapes are incompatible");
  } 
  if (s && lua_istable(L,s)) { /* replace singleton table by its one item */
    lua_rawgeti(L,s,1); lua_replace(L,s); 
  }
  for (i=1; i<=n; i++) {
    lua_pushvalue(L,f);
    if (tbl1) lua_rawgeti(L,a1,i); else lua_pushvalue(L,a1);
    if (lua_isnoneornil(L,-1)) { 
      lua_rawseti(L,r,i); lua_settop(L,r); continue; 
    }    
    if (tbl2) lua_rawgeti(L,a2,i); else lua_pushvalue(L,a2);
    if (lua_isnoneornil(L,-1)) { 
      lua_rawseti(L,r,i); lua_settop(L,r); continue; 
    } 
    lua_call(L,2,1);
    lua_rawseti(L,r,i);
  }
  apl_cloneshape(L,tbl2,a2,r);  /* rows and cols from a2 */
  apl_cloneshape(L,tbl1,a1,r);  /* a1 overrides a2 */
  return 1;
}
#undef f
#undef r
#undef a1
#undef a2
#undef x1
#undef x2
  
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
  {"is_int", core_is_int},
  {"rho", apl_rho},
  {"iota", apl_iota},
  {"both", apl_both},
  {"each", apl_each},
  {"compat", apl_compat},
  {"circ0", math_circ0},
  {"circ4", math_circ4},
  {"circ_4", math_circ_4},
  {"acosh", math_acosh},
  {"asinh", math_asinh},
  {"atanh", math_atanh},
  {NULL, NULL}
};

static const luaL_Reg apl_meta[] = {
  {"__len", apl_len},
  {"__index", apl_index},
  {"__newindex", apl_newindex},
  {NULL, NULL}
};
 

LUAMOD_API int luaopen_apl_core (lua_State *L) {
  luaL_newlib(L, apl_meta);
  lua_setfield(L,LUA_REGISTRYINDEX,"apl_meta");
  luaL_newlib(L, funcs);
  return 1;
}


