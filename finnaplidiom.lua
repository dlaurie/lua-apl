-- File `finnaplidiom.lua`
-- Converted from <http://aplwiki.com/FinnAplIdiomLibrary> to Lua by Dirk Laurie.
-- This code is in the public domain.
-- The huge contribution of the Finnish APL Association is gratefully acknowledged.

--- FinnAPL idiom library
--
-- Usage: `idiom = require "finnaplidiom"`
-- Note that `idiom` has holes. This is tolerated for the sake of retaining the 
-- original numbering. `idiom.maxn` gives the largest index.
--
-- Brief explanation of a typical idiom
--
-- description: what it does
-- arguments: A,B,C,D,I = Any, Boolean, Character, Decimal, Integer
--            0,1,2 = scalar, vector, matrix
-- utf: APL code as UTF-8
-- iso: APL code as ISO-8859-1, compatible with the KAPL font
--

return {
[1]={description=[=[Progressive index of (without replacement)]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[((â´X)â´â‹â‹Xâ³X,Y)â³(â´Y)â´â‹â‹Xâ³Y,X]=],
   iso=[=[((ÒX)ÒèèXÉX,Y)É(ÒY)ÒèèXÉY,X]=]};
[2]={description=[=[Ascending cardinal numbers (ranking, shareable)]=],
   arguments=[[Xâ†D1]],
   utf=[=[âŒŠ.5Ã—(â‹â‹X)+âŒ½â‹â‹âŒ½X]=],
   iso=[=[Ä.5«(èèX)+÷èè÷X]=]};
[3]={description=[=[Cumulative maxima (âŒˆ\) of subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[Y[Aâ³âŒˆ\Aâ†â‹A[â‹(+\X)[Aâ†â‹Y]]]]=],
   iso=[=[Y[AÉÓ\AûèA[è(+\X)[AûèY]]]]=]};
[4]={description=[=[Cumulative minima (âŒŠ\) of subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[Y[Aâ³âŒˆ\Aâ†â‹A[â‹(+\X)[Aâ†â’Y]]]]=],
   iso=[=[Y[AÉÓ\AûèA[è(+\X)[AûçY]]]]=]};
[5]={description=[=[Progressive index of (without replacement)]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[((â‹Xâ³X,Y)â³â³â´X)â³(â‹Xâ³Y,X)â³â³â´Y]=],
   iso=[=[((èXÉX,Y)ÉÉÒX)É(èXÉY,X)ÉÉÒY]=]};
[6]={description=[=[Test if X and Y are permutations of each other]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[Y[â‹Y]^.=X[â‹X]]=],
   iso=[=[Y[èY]^.=X[èX]]=]};
[7]={description=[=[Test if X is a permutation vector]=],
   arguments=[[Xâ†I1]],
   utf=[=[X^.=â‹â‹X]=],
   iso=[=[X^.=èèX]=]};
[8]={description=[=[Grade up (â‹) for sorting subvectors of Y having lengths X]=],
   arguments=[[Yâ†D1; Xâ†I1; (â´Y) â†â†’ +/X]],
   utf=[=[A[â‹(+\(â³â´Y)âˆŠ+\â•IO,X)[Aâ†â‹Y]]]=],
   iso=[=[A[è(+\(ÉÒY)Å+\ÌIO,X)[AûèY]]]=]};
[9]={description=[=[Index of the elements of X in Y]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[(((1,A)/B)âŒŠ1+â´Y)[(â´Y)â†“(+\1,Aâ†(1â†“A)â‰ Â¯1â†“Aâ†A[B])[â‹Bâ†â‹Aâ†Y,X]]]=],
   iso=[=[(((1,A)/B)Ä1+ÒY)[(ÒY)Õ(+\1,Aû(1ÕA)¨¢1ÕAûA[B])[èBûèAûY,X]]]=]};
[10]={description=[=[Minima (âŒŠ/) of elements of subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[Y[A[X/â‹(+\X)[Aâ†â‹Y]]]]=],
   iso=[=[Y[A[X/è(+\X)[AûèY]]]]=]};
[11]={description=[=[Grade up (â‹) for sorting subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[A[â‹(+\X)[Aâ†â‹Y]]]=],
   iso=[=[A[è(+\X)[AûèY]]]=]};
[12]={description=[=[Occurences of the elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[|-âŒ¿(2,â´X)â´â‹â‹X,X]=],
   iso=[=[|-¯(2,ÒX)ÒèèX,X]=]};
[13]={description=[=[Sorting rows of matrix X into ascending order]=],
   arguments=[[Xâ†D2]],
   utf=[=[(â´X)â´(,X)[A[â‹(,â‰(âŒ½â´X)â´â³1â†‘â´X)[Aâ†â‹,X]]]]=],
   iso=[=[(ÒX)Ò(,X)[A[è(,ô(÷ÒX)ÒÉ1ÙÒX)[Aûè,X]]]]=]};
[14]={description=[=[Adding a new dimension after dimension G Y-fold]=],
   arguments=[[Gâ†I0; Yâ†I0; Xâ†A]],
   utf=[=[(â‹â‹(G+1),â³â´â´X)â‰(Y,â´X)â´X]=],
   iso=[=[(èè(G+1),ÉÒÒX)ô(Y,ÒX)ÒX]=]};
[15]={description=[=[Sorting rows of matrix X into ascending order]=],
   arguments=[[Xâ†D2]],
   utf=[=[Aâ†(â‹,X)-â•IO â‹„ (â´X)â´(,X)[â•IO+A[â‹âŒŠAÃ·Â¯1â†‘â´X]]]=],
   iso=[=[Aû(è,X)-ÌIO ş (ÒX)Ò(,X)[ÌIO+A[èÄAß¢1ÙÒX]]]=]};
[16]={description=[=[Y smallest elements of X in order of occurrence]=],
   arguments=[[Xâ†D1, Yâ†I0]],
   utf=[=[((â‹â‹X)âˆŠâ³Y)/X]=],
   iso=[=[((èèX)ÅÉY)/X]=]};
[17]={description=[=[Merging X, Y, Z ... under control of G (mesh)]=],
   arguments=[[Xâ†A1; Yâ†A1; Zâ†A1; ... ; Gâ†I1]],
   utf=[=[(X,Y,Z,...)[â‹â‹G]]=],
   iso=[=[(X,Y,Z,...)[èèG]]=]};
[18]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[Xâ†A1; Yâ†A1; Gâ†B1]],
   utf=[=[(X,Y)[â‹â‹G]]=],
   iso=[=[(X,Y)[èèG]]=]};
[19]={description=[=[Ascending cardinal numbers (ranking, all different)]=],
   arguments=[[Xâ†D1]],
   utf=[=[â‹â‹X]=],
   iso=[=[èèX]=]};
[20]={description=[=[Grade down (â’) for sorting subvectors of Y having lengths X]=],
   arguments=[[Yâ†D1; Xâ†I1; (â´Y) â†â†’ +/X]],
   utf=[=[A[â‹(+\(â³â´Y)âˆŠ+\â•IO,X)[Aâ†â’Y]]]=],
   iso=[=[A[è(+\(ÉÒY)Å+\ÌIO,X)[AûçY]]]=]};
[21]={description=[=[Maxima (âŒˆ/) of elements of subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[Y[A[X/â‹(+\X)[Aâ†â’Y]]]]=],
   iso=[=[Y[A[X/è(+\X)[AûçY]]]]=]};
[22]={description=[=[Grade down (â’) for sorting subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[A[â‹(+\X)[Aâ†â’Y]]]=],
   iso=[=[A[è(+\X)[AûçY]]]=]};
[23]={description=[=[Y largest elements of X in order of occurrence]=],
   arguments=[[Xâ†D1; Yâ†I0]],
   utf=[=[((â‹â’X)âˆŠâ³Y)/X]=],
   iso=[=[((èçX)ÅÉY)/X]=]};
[24]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[Xâ†A1; Yâ†A1; Gâ†B1]],
   utf=[=[(Y,X)[â‹â’G]]=],
   iso=[=[(Y,X)[èçG]]=]};
[25]={description=[=[Descending cardinal numbers (ranking, all different)]=],
   arguments=[[Xâ†D1]],
   utf=[=[â‹â’X]=],
   iso=[=[èçX]=]};
[26]={description=[=[Sorting rows of X according to key Y (alphabetizing)]=],
   arguments=[[Xâ†A2; Yâ†A1]],
   utf=[=[X[â‹(1+â´Y)âŠ¥Yâ³â‰X;]]=],
   iso=[=[X[è(1+ÒY)ÂYÉôX;]]=]};
[27]={description=[=[Diagonal ravel]=],
   arguments=[[Xâ†A]],
   utf=[=[(,X)[â‹+âŒ¿(â´X)âŠ¤(â³â´,X)-â•IO]]=],
   iso=[=[(,X)[è+¯(ÒX)Î(ÉÒ,X)-ÌIO]]=]};
[28]={description=[=[Grade up according to key Y]=],
   arguments=[[Yâ†A1; Xâ†A1]],
   utf=[=[â‹Yâ³X]=],
   iso=[=[èYÉX]=]};
[29]={description=[=[Test if X is a permutation vector]=],
   arguments=[[Xâ†I1]],
   utf=[=[X[â‹X]^.=â³â´X]=],
   iso=[=[X[èX]^.=ÉÒX]=]};
[30]={description=[=[Sorting a matrix into lexicographic order]=],
   arguments=[[Xâ†D2]],
   utf=[=[X[â‹+âŒ¿A<.-â‰Aâ†X,0;]]=],
   iso=[=[X[è+¯A<.-ôAûX,0;]]=]};
[31]={description=[=[Sorting words in list X according to word length]=],
   arguments=[[Xâ†C2]],
   utf=[=[X[â‹X+.â‰ ' ';]]=],
   iso=[=[X[èX+.¨' ';]]=]};
[32]={description=[=[Classification of X to classes starting with Y]=],
   arguments=[[Xâ†D1;Yâ†D1;Y<.â‰¥1âŒ½Y]],
   utf=[=[A[(B/C)-â´Y]â†B/+\~Bâ†(â´Y)<Câ†â‹Y,X+Aâ†0Ã—X â‹„ A]=],
   iso=[=[A[(B/C)-ÒY]ûB/+\~Bû(ÒY)<CûèY,X+Aû0«X ş A]=]};
[33]={description=[=[Rotate first elements (1âŒ½) of subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†A1]],
   utf=[=[Y[â‹X++\X]]=],
   iso=[=[Y[èX++\X]]=]};
[34]={description=[=[Doubling quotes (for execution)]=],
   arguments=[[Xâ†C1]],
   utf=[=[(X,'''')[(â•IO+â´X)âŒŠâ‹(â³â´X),(''''=X)/â³â´X]]=],
   iso=[=[(X,'''')[(ÌIO+ÒX)Äè(ÉÒX),(''''=X)/ÉÒX]]=]};
[35]={description=[=[Inserting Y *'s into vector X after indices G]=],
   arguments=[[Xâ†C1; Yâ†I0; Gâ†I1]],
   utf=[=[(X,'*')[(â•IO+â´X)âŒŠâ‹(â³â´X),(YÃ—â´G)â´G]]=],
   iso=[=[(X,'*')[(ÌIO+ÒX)Äè(ÉÒX),(Y«ÒG)ÒG]]=]};
[36]={description=[=[Median]=],
   arguments=[[Xâ†D1]],
   utf=[=[X[(â‹X)[âŒˆ.5Ã—â´X]]]=],
   iso=[=[X[(èX)[Ó.5«ÒX]]]=]};
[37]={description=[=[Index of last maximum element of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[Â¯1â†‘â‹X]=],
   iso=[=[¢1ÙèX]=]};
[38]={description=[=[Index of (first) minimum element of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[1â†‘â‹X]=],
   iso=[=[1ÙèX]=]};
[39]={description=[=[Expansion vector with zero after indices Y]=],
   arguments=[[Xâ†D1; Yâ†I1]],
   utf=[=[(â´X)â‰¥â‹(â³â´X),Y]=],
   iso=[=[(ÒX)¦è(ÉÒX),Y]=]};
[40]={description=[=[Catenating G elements H before indices Y in vector X]=],
   arguments=[[Xâ†A1; Yâ†I1; Gâ†I0; Hâ†A0]],
   utf=[=[Aâ†GÃ—â´,Y â‹„ ((Aâ´H),X)[â‹(Aâ´Y),â³â´X]]=],
   iso=[=[AûG«Ò,Y ş ((AÒH),X)[è(AÒY),ÉÒX]]=]};
[41]={description=[=[Catenating G elements H after indices Y in vector X]=],
   arguments=[[Xâ†A1; Yâ†I1; Gâ†I0; Hâ†A0]],
   utf=[=[Aâ†GÃ—â´,Y â‹„ (X,Aâ´H)[â‹(â³â´X),Aâ´Y]]=],
   iso=[=[AûG«Ò,Y ş (X,AÒH)[è(ÉÒX),AÒY]]=]};
[42]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[Xâ†A1; Yâ†A1; Gâ†B1]],
   utf=[=[A[â‹G]â†Aâ†Y,X â‹„ A]=],
   iso=[=[A[èG]ûAûY,X ş A]=]};
[43]={description=[=[Sorting a matrix according to Y:th column]=],
   arguments=[[Xâ†D2]],
   utf=[=[X[â‹X[;Y];]]=],
   iso=[=[X[èX[;Y];]]=]};
[44]={description=[=[Sorting indices X according to data Y]=],
   arguments=[[Xâ†I1; Yâ†D1]],
   utf=[=[X[â‹Y[X]]]=],
   iso=[=[X[èY[X]]]=]};
[45]={description=[=[Choosing sorting direction during execution]=],
   arguments=[[Xâ†D1; Yâ†I0]],
   utf=[=[â‹XÃ—(Â¯1 1)[Y]]=],
   iso=[=[èX«(¢1 1)[Y]]=]};
[46]={description=[=[Sorting Y according to X]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[Y[â‹X]]=],
   iso=[=[Y[èX]]=]};
[47]={description=[=[Sorting X into ascending order]=],
   arguments=[[Xâ†D1]],
   utf=[=[X[â‹X]]=],
   iso=[=[X[èX]]=]};
[48]={description=[=[Inverting a permutation]=],
   arguments=[[Xâ†I1]],
   utf=[=[â‹X]=],
   iso=[=[èX]=]};
[49]={description=[=[Reverse vector X on condition Y]=],
   arguments=[[Xâ†A1; Yâ†B0]],
   utf=[=[X[â’Y!â³â´X]]=],
   iso=[=[X[çY!ÉÒX]]=]};
[50]={description=[=[Sorting a matrix into reverse lexicographic order]=],
   arguments=[[Xâ†D2]],
   utf=[=[X[â’+âŒ¿A<.-â‰Aâ†X,0;]]=],
   iso=[=[X[ç+¯A<.-ôAûX,0;]]=]};
[52]={description=[=[Reversal (âŒ½) of subvectors of X having lengths Y]=],
   arguments=[[Xâ†D1; Yâ†I1]],
   utf=[=[X[âŒ½â’+\(â³â´X)âˆŠ+\â•IO,Y]]=],
   iso=[=[X[÷ç+\(ÉÒX)Å+\ÌIO,Y]]=]};
[53]={description=[=[Reversal (âŒ½) of subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†A1]],
   utf=[=[Y[âŒ½â’+\X]]=],
   iso=[=[Y[÷ç+\X]]=]};
[55]={description=[=[Indices of ones in logical vector X]=],
   arguments=[[Xâ†B1]],
   utf=[=[(+/X)â†‘â’X]=],
   iso=[=[(+/X)ÙçX]=]};
[56]={description=[=[Index of first maximum element of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[1â†‘â’X]=],
   iso=[=[1ÙçX]=]};
[57]={description=[=[Moving all blanks to end of text]=],
   arguments=[[Xâ†C1]],
   utf=[=[X[â’' 'â‰ X]]=],
   iso=[=[X[ç' '¨X]]=]};
[58]={description=[=[Sorting X into descending order]=],
   arguments=[[Xâ†D1]],
   utf=[=[X[â’X]]=],
   iso=[=[X[çX]]=]};
[59]={description=[=[Moving elements satisfying condition Y to the start of X]=],
   arguments=[[Xâ†A1; Yâ†B1]],
   utf=[=[X[â’Y]]=],
   iso=[=[X[çY]]=]};
[60]={description=[=[Interpolated value of series (X,Y) at G]=],
   arguments=[[Xâ†D1; Yâ†D1; Gâ†D0]],
   utf=[=[GâŠ¥YâŒ¹Xâˆ˜.*âŒ½-â•IO-â³â´X]=],
   iso=[=[GÂY­XÊ.*÷-ÌIO-ÉÒX]=]};
[61]={description=[=[Predicted values of exponential (curve) fit]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[*A+.Ã—(âŸY)âŒ¹Aâ†Xâˆ˜.*0 1]=],
   iso=[=[*A+.«(ğY)­AûXÊ.*0 1]=]};
[62]={description=[=[Coefficients of exponential (curve) fit of points (X,Y)]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[Aâ†(âŸY)âŒ¹Xâˆ˜.*0 1 â‹„ A[1]â†*A[1] â‹„ A]=],
   iso=[=[Aû(ğY)­XÊ.*0 1 ş A[1]û*A[1] ş A]=]};
[63]={description=[=[Predicted values of best linear fit (least squares)]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[A+.Ã—YâŒ¹Aâ†Xâˆ˜.*0 1]=],
   iso=[=[A+.«Y­AûXÊ.*0 1]=]};
[64]={description=[=[G-degree polynomial (curve) fit of points (X,Y)]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[âŒ½YâŒ¹Xâˆ˜.*0,â³G]=],
   iso=[=[÷Y­XÊ.*0,ÉG]=]};
[65]={description=[=[Best linear fit of points (X,Y) (least squares)]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[YâŒ¹Xâˆ˜.*0 1]=],
   iso=[=[Y­XÊ.*0 1]=]};
[66]={description=[=[Binary format of decimal number X]=],
   arguments=[[Xâ†I0]],
   utf=[=[â•10âŠ¥((1+âŒˆ2âŸâŒˆ/,X)â´2)âŠ¤X]=],
   iso=[=[î10Â((1+Ó2ğÓ/,X)Ò2)ÎX]=]};
[67]={description=[=[Barchart of two integer series (across the page)]=],
   arguments=[[Xâ†I2; 1â´â´X â†â†’ 2]],
   utf=[=[' *â—‹âŸ'[â•IO+2âŠ¥Xâˆ˜.â‰¥â³âŒˆ/,X]]=],
   iso=[=[' *Ïğ'[ÌIO+2ÂXÊ.¦ÉÓ/,X]]=]};
[68]={description=[=[Case structure with an encoded branch destination]=],
   arguments=[[Yâ†I1; Xâ†B1]],
   utf=[=[â†’Y[1+2âŠ¥X]]=],
   iso=[=[ıY[1+2ÂX]]=]};
[69]={description=[=[Representation of current time (24 hour clock)]=],
   arguments=[[]],
   utf=[=[Aâ†â•1000âŠ¥3â†‘3â†“â•TS â‹„ A[3 6]â†':' â‹„ A]=],
   iso=[=[Aûî1000Â3Ù3ÕÌTS ş A[3 6]û':' ş A]=]};
[70]={description=[=[Representation of current date (descending format)]=],
   arguments=[[]],
   utf=[=[Aâ†â•1000âŠ¥3â†‘â•TS â‹„ A[5 8]â†'-' â‹„ A]=],
   iso=[=[Aûî1000Â3ÙÌTS ş A[5 8]û'-' ş A]=]};
[71]={description=[=[Representation of current time (12 hour clock)]=],
   arguments=[[]],
   utf=[=[(1âŒ½,' ::',3 2â´6 0â•100âŠ¥12 0 0|3â†‘3â†“â•TS),'AP'[1+12â‰¤â•TS[4]],'M']=],
   iso=[=[(1÷,' ::',3 2Ò6 0î100Â12 0 0|3Ù3ÕÌTS),'AP'[1+12¤ÌTS[4]],'M']=]};
[73]={description=[=[Removing duplicate rows]=],
   arguments=[[Xâ†A2]],
   utf=[=[((Aâ³A)=â³â´Aâ†2âŠ¥X^.=â‰X)âŒ¿X]=],
   iso=[=[((AÉA)=ÉÒAû2ÂX^.=ôX)¯X]=]};
[74]={description=[=[Conversion from hexadecimal to decimal]=],
   arguments=[[Xâ†C]],
   utf=[=[16âŠ¥-â•IO-'0123456789ABCDEF'â³â‰X]=],
   iso=[=[16Â-ÌIO-'0123456789ABCDEF'ÉôX]=]};
[75]={description=[=[Conversion of alphanumeric string into numeric]=],
   arguments=[[Xâ†C1]],
   utf=[=[10âŠ¥Â¯1+'0123456789'â³X]=],
   iso=[=[10Â¢1+'0123456789'ÉX]=]};
[76]={description=[=[Value of polynomial with coefficients Y at points X]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[(Xâˆ˜.+,0)âŠ¥Y]=],
   iso=[=[(XÊ.+,0)ÂY]=]};
[77]={description=[=[Changing connectivity list X to a connectivity matrix]=],
   arguments=[[Xâ†C2]],
   utf=[=[Aâ†(Ã—/Bâ†0 0+âŒˆ/,X)â´0 â‹„ A[â•IO+B[1]âŠ¥-â•IO-X]â†1 â‹„ Bâ´A]=],
   iso=[=[Aû(«/Bû0 0+Ó/,X)Ò0 ş A[ÌIO+B[1]Â-ÌIO-X]û1 ş BÒA]=]};
[78]={description=[=[Present value of cash flows X at interest rate Y %]=],
   arguments=[[Xâ†D1; Yâ†D0]],
   utf=[=[(Ã·1+YÃ·100)âŠ¥âŒ½X]=],
   iso=[=[(ß1+Yß100)Â÷X]=]};
[79]={description=[=[Justifying right]=],
   arguments=[[Xâ†C]],
   utf=[=[(1-(' '=X)âŠ¥1)âŒ½X]=],
   iso=[=[(1-(' '=X)Â1)÷X]=]};
[80]={description=[=[Number of days in month X of years Y (for all leap years)]=],
   arguments=[[Xâ†I0; Yâ†I]],
   utf=[=[(12â´7â´31 30)[X]-0âŒˆÂ¯1+2âŠ¥(X=2),[.1](0â‰ 400|Y)-(0â‰ 100|Y)-0â‰ 4|Y]=],
   iso=[=[(12Ò7Ò31 30)[X]-0Ó¢1+2Â(X=2),[.1](0¨400|Y)-(0¨100|Y)-0¨4|Y]=]};
[81]={description=[=[Number of days in month X of years Y (for most leap years)]=],
   arguments=[[Xâ†I0; Yâ†I]],
   utf=[=[(12â´7â´31 30)[X]-0âŒˆÂ¯1+2âŠ¥(X=2),[.1]0â‰ 4|Y]=],
   iso=[=[(12Ò7Ò31 30)[X]-0Ó¢1+2Â(X=2),[.1]0¨4|Y]=]};
[82]={description=[=[Encoding current date]=],
   arguments=[[]],
   utf=[=[100âŠ¥100|3â†‘â•TS]=],
   iso=[=[100Â100|3ÙÌTS]=]};
[83]={description=[=[Removing trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(1-(' '=X)âŠ¥1)â†“X]=],
   iso=[=[(1-(' '=X)Â1)ÕX]=]};
[84]={description=[=[Index of first non-blank, counted from the rear]=],
   arguments=[[Xâ†C1]],
   utf=[=[(' '=X)âŠ¥1]=],
   iso=[=[(' '=X)Â1]=]};
[85]={description=[=[Indexing scattered elements]=],
   arguments=[[Xâ†A; Yâ†I2]],
   utf=[=[(,X)[â•IO+(â´X)âŠ¥Y-â•IO]]=],
   iso=[=[(,X)[ÌIO+(ÒX)ÂY-ÌIO]]=]};
[86]={description=[=[Conversion of indices Y of array X to indices of raveled X]=],
   arguments=[[Xâ†A; Yâ†I2]],
   utf=[=[â•IO+(â´X)âŠ¥Y-â•IO]=],
   iso=[=[ÌIO+(ÒX)ÂY-ÌIO]=]};
[87]={description=[=[Number of columns in array X as a scalar]=],
   arguments=[[Xâ†A]],
   utf=[=[0âŠ¥â´X]=],
   iso=[=[0ÂÒX]=]};
[88]={description=[=[Future value of cash flows X at interest rate Y %]=],
   arguments=[[Xâ†D1; Yâ†D0]],
   utf=[=[(1+YÃ·100)âŠ¥X]=],
   iso=[=[(1+Yß100)ÂX]=]};
[89]={description=[=[Sum of the elements of vector X]=],
   arguments=[[Xâ†D1]],
   utf=[=[1âŠ¥X]=],
   iso=[=[1ÂX]=]};
[90]={description=[=[Last element of numeric vector X as a scalar]=],
   arguments=[[Xâ†D1]],
   utf=[=[0âŠ¥X]=],
   iso=[=[0ÂX]=]};
[91]={description=[=[Last row of matrix X as a vector]=],
   arguments=[[Xâ†A]],
   utf=[=[0âŠ¥X]=],
   iso=[=[0ÂX]=]};
[92]={description=[=[Integer representation of logical vectors]=],
   arguments=[[Xâ†B]],
   utf=[=[2âŠ¥X]=],
   iso=[=[2ÂX]=]};
[93]={description=[=[Value of polynomial with coefficients Y at point X]=],
   arguments=[[Xâ†D0; Yâ†D]],
   utf=[=[XâŠ¥Y]=],
   iso=[=[XÂY]=]};
[94]={description=[=[Conversion from decimal to hexadecimal (X=1..255)]=],
   arguments=[[Xâ†I]],
   utf=[=[â‰'0123456789ABCDEF'[â•IO+((âŒˆâŒˆ/16âŸ,X)â´16)âŠ¤X]]=],
   iso=[=[ô'0123456789ABCDEF'[ÌIO+((ÓÓ/16ğ,X)Ò16)ÎX]]=]};
[95]={description=[=[All binary representations up to X (truth table)]=],
   arguments=[[Xâ†I0]],
   utf=[=[((âŒˆ2âŸ1+X)â´2)âŠ¤0,â³X]=],
   iso=[=[((Ó2ğ1+X)Ò2)Î0,ÉX]=]};
[96]={description=[=[Representation of X in base Y]=],
   arguments=[[Xâ†D0; Yâ†D0]],
   utf=[=[((1+âŒŠYâŸX)â´Y)âŠ¤X]=],
   iso=[=[((1+ÄYğX)ÒY)ÎX]=]};
[97]={description=[=[Digits of X separately]=],
   arguments=[[Xâ†I0]],
   utf=[=[((1+âŒŠ10âŸX)â´10)âŠ¤X]=],
   iso=[=[((1+Ä10ğX)Ò10)ÎX]=]};
[98]={description=[=[Helps locating column positions 1..X]=],
   arguments=[[Xâ†I0]],
   utf=[=[1 0â•10 10âŠ¤1-â•IO-â³X]=],
   iso=[=[1 0î10 10Î1-ÌIO-ÉX]=]};
[99]={description=[=[Conversion of characters to hexadecimal representation (â•AV)]=],
   arguments=[[Xâ†C1]],
   utf=[=[,' ',â‰'0123456789ABCDEF'[â•IO+16 16âŠ¤-â•IO-â•AVâ³X]]=],
   iso=[=[,' ',ô'0123456789ABCDEF'[ÌIO+16 16Î-ÌIO-ÌAVÉX]]=]};
[100]={description=[=[Polynomial with roots X]=],
   arguments=[[Xâ†D1]],
   utf=[=[âŒ½((0,â³â´X)âˆ˜.=+âŒ¿~A)+.Ã—(-X)Ã—.*Aâ†((â´X)â´2)âŠ¤Â¯1+â³2*â´X]=],
   iso=[=[÷((0,ÉÒX)Ê.=+¯~A)+.«(-X)«.*Aû((ÒX)Ò2)Î¢1+É2*ÒX]=]};
[101]={description=[=[Index pairs of saddle points]=],
   arguments=[[Xâ†D2]],
   utf=[=[â•IO+(â´X)âŠ¤-â•IO-(,(X=(â´X)â´âŒˆâŒ¿X)^X=â‰(âŒ½â´X)â´âŒŠ/X)/â³Ã—/â´X]=],
   iso=[=[ÌIO+(ÒX)Î-ÌIO-(,(X=(ÒX)ÒÓ¯X)^X=ô(÷ÒX)ÒÄ/X)/É«/ÒX]=]};
[102]={description=[=[Changing connectivity matrix X to a connectivity list]=],
   arguments=[[Xâ†C2]],
   utf=[=[(,X)/1+AâŠ¤Â¯1+â³Ã—/Aâ†â´X]=],
   iso=[=[(,X)/1+AÎ¢1+É«/AûÒX]=]};
[103]={description=[=[Matrix of all indices of X]=],
   arguments=[[Xâ†A]],
   utf=[=[â•IO+(â´X)âŠ¤(â³Ã—/â´X)-â•IO]=],
   iso=[=[ÌIO+(ÒX)Î(É«/ÒX)-ÌIO]=]};
[104]={description=[=[Separating a date YYMMDD to YY, MM, DD]=],
   arguments=[[Xâ†D]],
   utf=[=[â‰(3â´100)âŠ¤X]=],
   iso=[=[ô(3Ò100)ÎX]=]};
[105]={description=[=[Indices of elements Y in array X]=],
   arguments=[[Xâ†A; Yâ†A]],
   utf=[=[â•IO+(â´X)âŠ¤(-â•IO)+(,XâˆŠY)/â³â´,X]=],
   iso=[=[ÌIO+(ÒX)Î(-ÌIO)+(,XÅY)/ÉÒ,X]=]};
[106]={description=[=[All pairs of elements of â³X and â³Y]=],
   arguments=[[Xâ†I0; Yâ†I0]],
   utf=[=[â•IO+(X,Y)âŠ¤(â³XÃ—Y)-â•IO]=],
   iso=[=[ÌIO+(X,Y)Î(ÉX«Y)-ÌIO]=]};
[107]={description=[=[Matrix for choosing all subsets of X (truth table)]=],
   arguments=[[Xâ†A1]],
   utf=[=[((â´X)â´2)âŠ¤Â¯1+â³2*â´X]=],
   iso=[=[((ÒX)Ò2)Î¢1+É2*ÒX]=]};
[108]={description=[=[All binary representations with X bits (truth table)]=],
   arguments=[[Xâ†I0]],
   utf=[=[(Xâ´2)âŠ¤Â¯1+â³2*X]=],
   iso=[=[(XÒ2)Î¢1+É2*X]=]};
[109]={description=[=[Incrementing cyclic counter X with upper limit Y]=],
   arguments=[[Xâ†D; Yâ†D0]],
   utf=[=[1+YâŠ¤X]=],
   iso=[=[1+YÎX]=]};
[110]={description=[=[Decoding numeric code ABBCCC into a matrix]=],
   arguments=[[Xâ†I]],
   utf=[=[10 100 1000âŠ¤X]=],
   iso=[=[10 100 1000ÎX]=]};
[111]={description=[=[Integer and fractional parts of positive numbers]=],
   arguments=[[Xâ†D]],
   utf=[=[0 1âŠ¤X]=],
   iso=[=[0 1ÎX]=]};
[112]={description=[=[Number of decimals of elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[âŒŠ10âŸ(â('.'â‰ A)/Aâ†â•X)Ã·X]=],
   iso=[=[Ä10ğ(â('.'¨A)/AûîX)ßX]=]};
[113]={description=[=[Number of sortable columns at a time using âŠ¥ and alphabet X]=],
   arguments=[[Xâ†C1]],
   utf=[=[âŒŠ(1+â´X)âŸ2*(A=Â¯1+Aâ†2*â³128)â³1]=],
   iso=[=[Ä(1+ÒX)ğ2*(A=¢1+Aû2*É128)É1]=]};
[114]={description=[=[Playing order in a cup for X ranked players]=],
   arguments=[[Xâ†I0]],
   utf=[=[,â‰(Aâ´2)â´(2*Aâ†âŒˆ2âŸX)â†‘â³X]=],
   iso=[=[,ô(AÒ2)Ò(2*AûÓ2ğX)ÙÉX]=]};
[115]={description=[=[Arithmetic precision of the system (in decimals)]=],
   arguments=[[]],
   utf=[=[âŒŠ|10âŸ|1-3Ã—Ã·3]=],
   iso=[=[Ä|10ğ|1-3«ß3]=]};
[116]={description=[=[Number of digitpositions in integers in X]=],
   arguments=[[Xâ†I]],
   utf=[=[1+(X<0)+âŒŠ10âŸ|X+0=X]=],
   iso=[=[1+(X<0)+Ä10ğ|X+0=X]=]};
[117]={description=[=[Number of digit positions in integers in X]=],
   arguments=[[Xâ†I]],
   utf=[=[1+âŒŠ10âŸ(X=0)+XÃ—(1 Â¯10)[1+X<0]]=],
   iso=[=[1+Ä10ğ(X=0)+X«(1 ¢10)[1+X<0]]=]};
[118]={description=[=[Number of digits in positive integers in X]=],
   arguments=[[Xâ†I]],
   utf=[=[1+âŒŠ10âŸX+0=X]=],
   iso=[=[1+Ä10ğX+0=X]=]};
[119]={description=[=[Case structure according to key vector G]=],
   arguments=[[Xâ†A0; Yâ†I1; Gâ†A1]],
   utf=[=[â†’Y[Gâ³X]]=],
   iso=[=[ıY[GÉX]]=]};
[120]={description=[=[Forming a transitive closure]=],
   arguments=[[Xâ†B2]],
   utf=[=[â†’â•LCâŒˆâ³âˆ¨/,(Xâ†Xâˆ¨Xâˆ¨.^X)â‰ +X]=],
   iso=[=[ıÌLCÓÉ©/,(XûX©X©.^X)¨+X]=]};
[121]={description=[=[Case structure with integer switch]=],
   arguments=[[Xâ†I0; Yâ†I1]],
   utf=[=[â†’XâŒ½Y]=],
   iso=[=[ıX÷Y]=]};
[122]={description=[=[For-loop ending construct]=],
   arguments=[[Xâ†I0; Yâ†I0; Gâ†I0]],
   utf=[=[â†’YâŒˆâ³Gâ‰¥Xâ†X+1]=],
   iso=[=[ıYÓÉG¦XûX+1]=]};
[123]={description=[=[Conditional branch to line Y]=],
   arguments=[[Xâ†B0; Yâ†I0; Y>0]],
   utf=[=[â†’YâŒˆâ³X]=],
   iso=[=[ıYÓÉX]=]};
[124]={description=[=[Conditional branch out of program]=],
   arguments=[[Xâ†B0]],
   utf=[=[â†’0âŒŠâ³X]=],
   iso=[=[ı0ÄÉX]=]};
[125]={description=[=[Conditional branch depending on sign of X]=],
   arguments=[[Xâ†I0; Yâ†I1]],
   utf=[=[â†’Y[2+Ã—X]]=],
   iso=[=[ıY[2+«X]]=]};
[126]={description=[=[Continuing from line Y (if X>0) or exit]=],
   arguments=[[Xâ†D0; Yâ†I0]],
   utf=[=[â†’YÃ—Ã—X]=],
   iso=[=[ıY««X]=]};
[127]={description=[=[Case structure using levels with limits G]=],
   arguments=[[Xâ†D0; Gâ†D1; Yâ†I1]],
   utf=[=[â†’(Xâ‰¥G)/Y]=],
   iso=[=[ı(X¦G)/Y]=]};
[128]={description=[=[Case structure with logical switch (preferring from start)]=],
   arguments=[[Xâ†B1; Yâ†I1]],
   utf=[=[â†’X/Y]=],
   iso=[=[ıX/Y]=]};
[129]={description=[=[Conditional branch out of program]=],
   arguments=[[Xâ†B0]],
   utf=[=[â†’0Ã—â³X]=],
   iso=[=[ı0«ÉX]=]};
[132]={description=[=[Test for symmetricity of matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[ââ'1','â†‘â†“'[â•IO+^/(â´X)=âŒ½â´X],'''0~0âˆŠX=â‰X''']=],
   iso=[=[ââ'1','ÙÕ'[ÌIO+^/(ÒX)=÷ÒX],'''0~0ÅX=ôX''']=]};
[133]={description=[=[Using a variable named according to X]=],
   arguments=[[Xâ†A0; Yâ†A]],
   utf=[=[â'VAR',(â•X),'â†Y']=],
   iso=[=[â'VAR',(îX),'ûY']=]};
[134]={description=[=[Rounding to â•PP precision]=],
   arguments=[[Xâ†D1]],
   utf=[=[ââ•X]=],
   iso=[=[âîX]=]};
[135]={description=[=[Convert character or numeric data into numeric]=],
   arguments=[[Xâ†A1]],
   utf=[=[ââ•X]=],
   iso=[=[âîX]=]};
[136]={description=[=[Reshaping only one-element numeric vector X into a scalar]=],
   arguments=[[Xâ†D1]],
   utf=[=[ââ•X]=],
   iso=[=[âîX]=]};
[137]={description=[=[Graph of F(X) at points X ('X'âˆŠF)]=],
   arguments=[[Fâ†A1; Xâ†D1]],
   utf=[=[' *'[â•IO+(âŒ½(Â¯1+âŒŠ/A)+â³1+(âŒˆ/A)-âŒŠ/A)âˆ˜.=Aâ†âŒŠ.5+âF]]=],
   iso=[=[' *'[ÌIO+(÷(¢1+Ä/A)+É1+(Ó/A)-Ä/A)Ê.=AûÄ.5+âF]]=]};
[138]={description=[=[Conversion of each row to a number (default zero)]=],
   arguments=[[Xâ†C2]],
   utf=[=[(Xâˆ¨.â‰ ' ')\1â†“â'0 ',,X,' ']=],
   iso=[=[(X©.¨' ')\1Õâ'0 ',,X,' ']=]};
[139]={description=[=[Test for symmetricity of matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[â(Â¯7*A^.=âŒ½Aâ†â´X)â†‘'0~0âˆŠX=â‰X']=],
   iso=[=[â(¢7*A^.=÷AûÒX)Ù'0~0ÅX=ôX']=]};
[140]={description=[=[Execution of expression X with default value Y]=],
   arguments=[[Xâ†D1]],
   utf=[=[â((X^.=' ')/'Y'),X]=],
   iso=[=[â((X^.=' ')/'Y'),X]=]};
[141]={description=[=[Changing X if a new input value is given]=],
   arguments=[[Xâ†A]],
   utf=[=[Xâ†â,((2â†‘'X'),' ',[.5]A)[â•IO+~' '^.=Aâ†â;]]=],
   iso=[=[Xûâ,((2Ù'X'),' ',[.5]A)[ÌIO+~' '^.=Aûì;]]=]};
[142]={description=[=[Definite integral of F(X) in range Y with G steps ('X'âˆŠF)]=],
   arguments=[[Fâ†A1; Gâ†D0; Yâ†D1; â´Y â†â†’ 2]],
   utf=[=[A+.Ã—âF,0â´Xâ†Y[1]+(Aâ†--/YÃ·G)Ã—0,â³G]=],
   iso=[=[A+.«âF,0ÒXûY[1]+(Aû--/YßG)«0,ÉG]=]};
[143]={description=[=[Test if numeric and conversion to numeric form]=],
   arguments=[[Xâ†C1]],
   utf=[=[1â†“â'0 ',(^/XâˆŠ' 0123456789')/X]=],
   iso=[=[1Õâ'0 ',(^/XÅ' 0123456789')/X]=]};
[144]={description=[=[Tests the social security number (Finnish)]=],
   arguments=[[Yâ†'01...9ABC...Z'; 10=â´X]],
   utf=[=[(Â¯1â†‘X)=((~YâˆŠ'GIOQ')/Y)[1+31|â9â†‘X]]=],
   iso=[=[(¢1ÙX)=((~YÅ'GIOQ')/Y)[1+31|â9ÙX]]=]};
[145]={description=[=[Conditional execution]=],
   arguments=[[Xâ†B0]],
   utf=[=[âX/'EXPRESSION']=],
   iso=[=[âX/'EXPRESSION']=]};
[146]={description=[=[Conditional branch out of programs]=],
   arguments=[[Xâ†B0]],
   utf=[=[âX/'â†’']=],
   iso=[=[âX/'ı']=]};
[147]={description=[=[Using default value 100 if X does not exist]=],
   arguments=[[Xâ†A]],
   utf=[=[â(Â¯3*2â‰ â•NC 'X')â†‘'X100']=],
   iso=[=[â(¢3*2¨ÌNC 'X')Ù'X100']=]};
[148]={description=[=[Conditional execution]=],
   arguments=[[Xâ†B0]],
   utf=[=[âXâ†“'â ...']=],
   iso=[=[âXÕ'ã ...']=]};
[149]={description=[=[Giving a numeric default value for input]=],
   arguments=[[Xâ†D0]],
   utf=[=[1â´(ââ,',â³0'),X]=],
   iso=[=[1Ò(âì,',É0'),X]=]};
[150]={description=[=[Assign values of expressions in X to variables named in Y]=],
   arguments=[[Xâ†C2; Yâ†C2]],
   utf=[=[Aâ†â,',','(','0','â´',Y,'â†',X,')']=],
   iso=[=[Aûâ,',','(','0','Ò',Y,'û',X,')']=]};
[151]={description=[=[Evaluation of several expressions; results form a vector]=],
   arguments=[[Xâ†A]],
   utf=[=[â,',','(',',',X,')']=],
   iso=[=[â,',','(',',',X,')']=]};
[152]={description=[=[Sum of numbers in character matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[â,'+',X]=],
   iso=[=[â,'+',X]=]};
[153]={description=[=[Indexing when rank is not known beforehand]=],
   arguments=[[Xâ†A; Yâ†I]],
   utf=[=[â'X[',((Â¯1+â´â´X)â´';'),'Y]']=],
   iso=[=[â'X[',((¢1+ÒÒX)Ò';'),'Y]']=]};
[154]={description=[=[Numeric headers (elements of X) for rows of table Y]=],
   arguments=[[Xâ†D1; Yâ†A2]],
   utf=[=[(3âŒ½7 0â•Xâˆ˜.+,0),â•Y]=],
   iso=[=[(3÷7 0îXÊ.+,0),îY]=]};
[155]={description=[=[Formatting a numerical vector to run down the page]=],
   arguments=[[Xâ†D1]],
   utf=[=[â•Xâˆ˜.+,0]=],
   iso=[=[îXÊ.+,0]=]};
[156]={description=[=[Representation of current date (ascending format)]=],
   arguments=[[]],
   utf=[=[Aâ†â•âŒ½3â†‘â•TS â‹„ A[(' '=A)/â³â´A]â†'.' â‹„ A]=],
   iso=[=[Aûî÷3ÙÌTS ş A[(' '=A)/ÉÒA]û'.' ş A]=]};
[157]={description=[=[Representation of current date (American)]=],
   arguments=[[]],
   utf=[=[Aâ†â•100|1âŒ½3â†‘â•TS â‹„ A[(' '=A)/â³â´A]â†'/' â‹„ A]=],
   iso=[=[Aûî100|1÷3ÙÌTS ş A[(' '=A)/ÉÒA]û'/' ş A]=]};
[158]={description=[=[Formatting with zero values replaced with blanks]=],
   arguments=[[Xâ†A]],
   utf=[=[(â´A)â´B\(Bâ†,('0'â‰ A)âˆ¨' 'â‰ Â¯1âŒ½A)/,Aâ†' ',â•X]=],
   iso=[=[(ÒA)ÒB\(Bû,('0'¨A)©' '¨¢1÷A)/,Aû' ',îX]=]};
[159]={description=[=[Number of digit positions in scalar X (depends on â•PP)]=],
   arguments=[[Xâ†D0]],
   utf=[=[â´â•X]=],
   iso=[=[ÒîX]=]};
[160]={description=[=[Leading zeroes for X in fields of width Y]=],
   arguments=[[Xâ†I1; Yâ†I0; Xâ‰¥0]],
   utf=[=[0 1â†“(2â†‘Y+1)â•Xâˆ˜.+,10*Y]=],
   iso=[=[0 1Õ(2ÙY+1)îXÊ.+,10*Y]=]};
[161]={description=[=[Row-by-row formatting (width G) of X with Y decimals per row]=],
   arguments=[[Xâ†D2; Yâ†I1; Gâ†I0]],
   utf=[=[((1,G)Ã—â´X)â´2 1 3â‰(âŒ½G,â´X)â´(,G,[1.1]Y)â•â‰X]=],
   iso=[=[((1,G)«ÒX)Ò2 1 3ô(÷G,ÒX)Ò(,G,[1.1]Y)îôX]=]};
[163]={description=[=[Formatting X with H decimals in fields of width G]=],
   arguments=[[Xâ†D; Gâ†I1; Hâ†I1]],
   utf=[=[(,G,[1.1]H)â•X]=],
   iso=[=[(,G,[1.1]H)îX]=]};
[164]={description=[=[Y-shaped array of random numbers within ( X[1],X[2] ]]=],
   arguments=[[Xâ†I1; Yâ†I1]],
   utf=[=[X[1]+?Yâ´--/X]=],
   iso=[=[X[1]+?YÒ--/X]=]};
[165]={description=[=[Removing punctuation characters]=],
   arguments=[[Xâ†A1]],
   utf=[=[(~XâˆŠ' .,:;?''')/X]=],
   iso=[=[(~XÅ' .,:;?''')/X]=]};
[166]={description=[=[Choosing Y objects out of â³X with replacement (roll)]=],
   arguments=[[Yâ†I; Xâ†I]],
   utf=[=[?Yâ´X]=],
   iso=[=[?YÒX]=]};
[167]={description=[=[Choosing Y objects out of â³X without replacement (deal)]=],
   arguments=[[Xâ†I0; Yâ†I0]],
   utf=[=[Y?X]=],
   iso=[=[Y?X]=]};
[168]={description=[=[Arctan YÃ·X]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[((Xâ‰ 0)Ã—Â¯3â—‹YÃ·X+X=0)+â—‹((X=0)Ã—.5Ã—Ã—Y)+(X<0)Ã—1-2Ã—Y<0]=],
   iso=[=[((X¨0)«¢3ÏYßX+X=0)+Ï((X=0)«.5««Y)+(X<0)«1-2«Y<0]=]};
[169]={description=[=[Conversion from degrees to radians]=],
   arguments=[[Xâ†D]],
   utf=[=[XÃ—â—‹Ã·180]=],
   iso=[=[X«Ïß180]=]};
[170]={description=[=[Conversion from radians to degrees]=],
   arguments=[[Xâ†D]],
   utf=[=[XÃ—180Ã·â—‹1]=],
   iso=[=[X«180ßÏ1]=]};
[171]={description=[=[Rotation matrix for angle X (in radians) counter-clockwise]=],
   arguments=[[Xâ†D0]],
   utf=[=[2 2â´1 Â¯1 1 1Ã—2 1 1 2â—‹X]=],
   iso=[=[2 2Ò1 ¢1 1 1«2 1 1 2ÏX]=]};
[172]={description=[=[Number of permutations of X objects taken Y at a time]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[(!Y)Ã—Y!X]=],
   iso=[=[(!Y)«Y!X]=]};
[173]={description=[=[Value of Taylor series with coefficients Y at point X]=],
   arguments=[[Xâ†D0; Yâ†D1]],
   utf=[=[+/YÃ—(X*A)Ã·!Aâ†Â¯1+â³â´Y]=],
   iso=[=[+/Y«(X*A)ß!Aû¢1+ÉÒY]=]};
[174]={description=[=[Poisson distribution of states X with average number Y]=],
   arguments=[[Xâ†I; Yâ†D0]],
   utf=[=[(*-Y)Ã—(Y*X)Ã·!X]=],
   iso=[=[(*-Y)«(Y*X)ß!X]=]};
[175]={description=[=[Gamma function]=],
   arguments=[[Xâ†D0]],
   utf=[=[!X-1]=],
   iso=[=[!X-1]=]};
[176]={description=[=[Binomial distribution of X trials with probability Y]=],
   arguments=[[Xâ†I0; Yâ†D0]],
   utf=[=[(A!X)Ã—(Y*A)Ã—(1-Y)*X-Aâ†-â•IO-â³X+1]=],
   iso=[=[(A!X)«(Y*A)«(1-Y)*X-Aû-ÌIO-ÉX+1]=]};
[177]={description=[=[Beta function]=],
   arguments=[[Xâ†D0; Yâ†D0]],
   utf=[=[Ã·YÃ—(X-1)!Y+X-1]=],
   iso=[=[ßY«(X-1)!Y+X-1]=]};
[178]={description=[=[Selecting elements satisfying condition X, others to 1]=],
   arguments=[[Xâ†B; Yâ†D]],
   utf=[=[X!Y]=],
   iso=[=[X!Y]=]};
[179]={description=[=[Number of combinations of X objects taken Y at a time]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[Y!X]=],
   iso=[=[Y!X]=]};
[180]={description=[=[Removing elements Y from beginning and end of vector X]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[((Aâ³1)-â•IO)â†“(â•IO-(âŒ½Aâ†~XâˆŠY)â³1)â†“X]=],
   iso=[=[((AÉ1)-ÌIO)Õ(ÌIO-(÷Aû~XÅY)É1)ÕX]=]};
[181]={description=[=[Alphabetical comparison with alphabets G]=],
   arguments=[[Xâ†A; Yâ†A]],
   utf=[=[(Gâ³X)<Gâ³Y]=],
   iso=[=[(GÉX)<GÉY]=]};
[183]={description=[=[Sum over elements of X determined by elements of Y]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[X+.Ã—Yâˆ˜.=((â³â´Y)=Yâ³Y)/Y]=],
   iso=[=[X+.«YÊ.=((ÉÒY)=YÉY)/Y]=]};
[184]={description=[=[First occurrence of string X in string Y]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[(^âŒ¿(Â¯1+â³â´X)âŒ½Xâˆ˜.=Y)â³1]=],
   iso=[=[(^¯(¢1+ÉÒX)÷XÊ.=Y)É1]=]};
[185]={description=[=[Removing duplicate rows]=],
   arguments=[[Xâ†A2]],
   utf=[=[((Aâ³A)=â³â´Aâ†â•IO++âŒ¿^â€Xâˆ¨.â‰ â‰X)âŒ¿X]=],
   iso=[=[((AÉA)=ÉÒAûÌIO++¯^ÜX©.¨ôX)¯X]=]};
[186]={description=[=[First occurrence of string X in matrix Y]=],
   arguments=[[Xâ†A1; Yâ†A2; Â¯1â†‘â´Yâ†â†’â´X]],
   utf=[=[(Y^.=X)â³1]=],
   iso=[=[(Y^.=X)É1]=]};
[187]={description=[=[Indices of ones in logical vector X]=],
   arguments=[[Xâ†B1]],
   utf=[=[(+\X)â³â³+/X]=],
   iso=[=[(+\X)ÉÉ+/X]=]};
[188]={description=[=[Executing costly monadic function F on repetitive arguments]=],
   arguments=[[Xâ†A1]],
   utf=[=[(F B/X)[+\Bâ†(Xâ³X)=â³â´X]]=],
   iso=[=[(F B/X)[+\Bû(XÉX)=ÉÒX]]=]};
[189]={description=[=[Index of (first) maximum element of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[Xâ³âŒˆ/X]=],
   iso=[=[XÉÓ/X]=]};
[190]={description=[=[Index of first occurrence of elements of Y]=],
   arguments=[[Xâ†C1; Yâ†C1]],
   utf=[=[âŒŠ/Xâ³Y]=],
   iso=[=[Ä/XÉY]=]};
[191]={description=[=[Index of (first) minimum element of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[Xâ³âŒŠ/X]=],
   iso=[=[XÉÄ/X]=]};
[192]={description=[=[Test if each element of X occurs only once]=],
   arguments=[[Xâ†A1]],
   utf=[=[^/(Xâ³X)=â³â´X]=],
   iso=[=[^/(XÉX)=ÉÒX]=]};
[193]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†A1]],
   utf=[=[^/â•IO=Xâ³X]=],
   iso=[=[^/ÌIO=XÉX]=]};
[194]={description=[=[Interpretation of roman numbers]=],
   arguments=[[Xâ†A]],
   utf=[=[+/AÃ—Â¯1*A<1âŒ½Aâ†0,(1000 500 100 50 10 5 1)['MDCLXVI'â³X]]=],
   iso=[=[+/A«¢1*A<1÷Aû0,(1000 500 100 50 10 5 1)['MDCLXVI'ÉX]]=]};
[195]={description=[=[Removing elements Y from end of vector X]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(â•IO-(~âŒ½XâˆŠY)â³1)â†“X]=],
   iso=[=[(ÌIO-(~÷XÅY)É1)ÕX]=]};
[196]={description=[=[Removing trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(1-(âŒ½' 'â‰ X)â³1)â†“X]=],
   iso=[=[(1-(÷' '¨X)É1)ÕX]=]};
[198]={description=[=[Index of last occurrence of Y in X (â•IO-1 if not found)]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[((Â¯1 1)[2Ã—â•IO]+â´X)-(âŒ½X)â³Y]=],
   iso=[=[((¢1 1)[2«ÌIO]+ÒX)-(÷X)ÉY]=]};
[199]={description=[=[Index of last occurrence of Y in X (0 if not found)]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(1+â´X)-(âŒ½X)â³Y]=],
   iso=[=[(1+ÒX)-(÷X)ÉY]=]};
[200]={description=[=[Index of last occurrence of Y in X, counted from the rear]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(âŒ½X)â³Y]=],
   iso=[=[(÷X)ÉY]=]};
[201]={description=[=[Index of first occurrence of G in X (circularly) after Y]=],
   arguments=[[Xâ†A1; Yâ†I0; Gâ†A]],
   utf=[=[â•IO+(â´X)|Y+(YâŒ½X)â³G]=],
   iso=[=[ÌIO+(ÒX)|Y+(Y÷X)ÉG]=]};
[202]={description=[=[Alphabetizing X; equal alphabets in same column of Y]=],
   arguments=[[Yâ†C2; Xâ†C]],
   utf=[=[(Â¯1â†‘â´Y)|(,Y)â³X]=],
   iso=[=[(¢1ÙÒY)|(,Y)ÉX]=]};
[203]={description=[=[Changing index of an unfound element to zero]=],
   arguments=[[Yâ†A1; Xâ†A]],
   utf=[=[(1+â´Y)|Yâ³X]=],
   iso=[=[(1+ÒY)|YÉX]=]};
[204]={description=[=[Replacing elements of G in set X with corresponding Y]=],
   arguments=[[Xâ†A1, Yâ†A1, Gâ†A]],
   utf=[=[A[B/â³â´B]â†Y[(Bâ†Bâ‰¤â´Y)/Bâ†Xâ³Aâ†,G] â‹„ (â´G)â´A]=],
   iso=[=[A[B/ÉÒB]ûY[(BûB¤ÒY)/BûXÉAû,G] ş (ÒG)ÒA]=]};
[205]={description=[=[Removing duplicate elements (nub)]=],
   arguments=[[Xâ†A1]],
   utf=[=[((Xâ³X)=â³â´X)/X]=],
   iso=[=[((XÉX)=ÉÒX)/X]=]};
[206]={description=[=[First word in X]=],
   arguments=[[Xâ†C1]],
   utf=[=[(Â¯1+Xâ³' ')â†‘X]=],
   iso=[=[(¢1+XÉ' ')ÙX]=]};
[207]={description=[=[Removing elements Y from beginning of vector X]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(((~XâˆŠY)â³1)-â•IO)â†“X]=],
   iso=[=[(((~XÅY)É1)-ÌIO)ÕX]=]};
[208]={description=[=[Removing leading zeroes]=],
   arguments=[[Xâ†A1]],
   utf=[=[(Â¯1+(X='0')â³0)â†“X]=],
   iso=[=[(¢1+(X='0')É0)ÕX]=]};
[209]={description=[=[Index of first one after index Y in X]=],
   arguments=[[Gâ†I0; Xâ†B1]],
   utf=[=[Y+(Yâ†“X)â³1]=],
   iso=[=[Y+(YÕX)É1]=]};
[210]={description=[=[Changing index of an unfound element to zero (not effective)]=],
   arguments=[[Xâ†A; Yâ†A1]],
   utf=[=[(XâˆŠY)Ã—Yâ³X]=],
   iso=[=[(XÅY)«YÉX]=]};
[211]={description=[=[Indicator of first occurrence of each unique element of X]=],
   arguments=[[Xâ†A1]],
   utf=[=[(Xâ³X)=â³â´X]=],
   iso=[=[(XÉX)=ÉÒX]=]};
[212]={description=[=[Inverting a permutation]=],
   arguments=[[Xâ†I1]],
   utf=[=[Xâ³â³â´X]=],
   iso=[=[XÉÉÒX]=]};
[213]={description=[=[Index of first differing element in vectors X and Y]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[(Yâ‰ X)â³1]=],
   iso=[=[(Y¨X)É1]=]};
[214]={description=[=[Which elements of X are not in set Y (difference of sets)]=],
   arguments=[[Xâ†A; Yâ†A1]],
   utf=[=[(â•IO+â´Y)=Yâ³X]=],
   iso=[=[(ÌIO+ÒY)=YÉX]=]};
[215]={description=[=[Changing numeric code X into corresponding name in Y]=],
   arguments=[[Xâ†D; Yâ†D1; Gâ†C2]],
   utf=[=[G[Yâ³X;]]=],
   iso=[=[G[YÉX;]]=]};
[216]={description=[=[Index of key Y in key vector X]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[Xâ³Y]=],
   iso=[=[XÉY]=]};
[217]={description=[=[Conversion from characters to numeric codes]=],
   arguments=[[Xâ†A]],
   utf=[=[â•AVâ³X]=],
   iso=[=[ÌAVÉX]=]};
[218]={description=[=[Index of first satisfied condition in X]=],
   arguments=[[Xâ†B1]],
   utf=[=[Xâ³1]=],
   iso=[=[XÉ1]=]};
[219]={description=[=[Pascal's triangle of order X (binomial coefficients)]=],
   arguments=[[Xâ†I0]],
   utf=[=[â‰Aâˆ˜.!Aâ†0,â³X]=],
   iso=[=[ôAÊ.!Aû0,ÉX]=]};
[220]={description=[=[Maximum table]=],
   arguments=[[Xâ†I0]],
   utf=[=[(â³X)âˆ˜.âŒˆâ³X]=],
   iso=[=[(ÉX)Ê.ÓÉX]=]};
[221]={description=[=[Number of decimals (up to Y) of elements of X]=],
   arguments=[[Xâ†D; Yâ†I0]],
   utf=[=[0+.â‰ (âŒˆ(10*Y)Ã—10*â•IO-â³Y+1)âˆ˜.|âŒˆXÃ—10*Y]=],
   iso=[=[0+.¨(Ó(10*Y)«10*ÌIO-ÉY+1)Ê.|ÓX«10*Y]=]};
[222]={description=[=[Greatest common divisor of elements of X]=],
   arguments=[[Xâ†I1]],
   utf=[=[âŒˆ/(^/0=Aâˆ˜.|X)/Aâ†â³âŒŠ/X]=],
   iso=[=[Ó/(^/0=AÊ.|X)/AûÉÄ/X]=]};
[223]={description=[=[Divisibility table]=],
   arguments=[[Xâ†I1]],
   utf=[=[0=(â³âŒˆ/X)âˆ˜.|X]=],
   iso=[=[0=(ÉÓ/X)Ê.|X]=]};
[224]={description=[=[All primes up to X]=],
   arguments=[[Xâ†I0]],
   utf=[=[(2=+âŒ¿0=(â³X)âˆ˜.|â³X)/â³X]=],
   iso=[=[(2=+¯0=(ÉX)Ê.|ÉX)/ÉX]=]};
[225]={description=[=[Compound interest for principals Y at rates G % in times X]=],
   arguments=[[Xâ†D; Yâ†D; Gâ†D]],
   utf=[=[Yâˆ˜.Ã—(1+GÃ·100)âˆ˜.*X]=],
   iso=[=[YÊ.«(1+Gß100)Ê.*X]=]};
[226]={description=[=[Product of two polynomials with coefficients X and Y]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[+âŒ¿(â•IO-â³â´X)âŒ½Xâˆ˜.Ã—Y,0Ã—1â†“X]=],
   iso=[=[+¯(ÌIO-ÉÒX)÷XÊ.«Y,0«1ÕX]=]};
[228]={description=[=[Shur product]=],
   arguments=[[Xâ†D2; Yâ†D2]],
   utf=[=[1 2 1 2â‰Xâˆ˜.Ã—Y]=],
   iso=[=[1 2 1 2ôXÊ.«Y]=]};
[229]={description=[=[Direct matrix product]=],
   arguments=[[Xâ†D2; Yâ†D2]],
   utf=[=[1 3 2 4â‰Xâˆ˜.Ã—Y]=],
   iso=[=[1 3 2 4ôXÊ.«Y]=]};
[230]={description=[=[Multiplication table]=],
   arguments=[[Xâ†I0]],
   utf=[=[(â³X)âˆ˜.Ã—â³X]=],
   iso=[=[(ÉX)Ê.«ÉX]=]};
[231]={description=[=[Replicating a dimension of rank three array X Y-fold]=],
   arguments=[[Yâ†I0; Xâ†A3]],
   utf=[=[X[;,(Yâ´1)âˆ˜.Ã—â³(â´X)[2];]]=],
   iso=[=[X[;,(YÒ1)Ê.«É(ÒX)[2];]]=]};
[232]={description=[=[Array and its negative ('plus minus')]=],
   arguments=[[Xâ†D]],
   utf=[=[Xâˆ˜.Ã—1 Â¯1]=],
   iso=[=[XÊ.«1 ¢1]=]};
[233]={description=[=[Move set of points X into first quadrant]=],
   arguments=[[Xâ†D2]],
   utf=[=[1 2 1â‰Xâˆ˜.-âŒŠ/X]=],
   iso=[=[1 2 1ôXÊ.-Ä/X]=]};
[234]={description=[=[Test relations of elements of X to range Y; result in Â¯2..2]=],
   arguments=[[Xâ†D; Yâ†D; 2=Â¯1â†‘â´Y]],
   utf=[=[+/Ã—Xâˆ˜.-Y]=],
   iso=[=[+/«XÊ.-Y]=]};
[235]={description=[=[Occurrences of string X in string Y]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[(Y[Aâˆ˜.+Â¯1+â³â´X]^.=X)/Aâ†(A=1â†‘X)/â³â´Aâ†(1-â´X)â†“Y]=],
   iso=[=[(Y[AÊ.+¢1+ÉÒX]^.=X)/Aû(A=1ÙX)/ÉÒAû(1-ÒX)ÕY]=]};
[236]={description=[=[Sum of common parts of matrices (matrix sum)]=],
   arguments=[[Xâ†D2; Yâ†D2]],
   utf=[=[1 2 1 2â‰Xâˆ˜.+Y]=],
   iso=[=[1 2 1 2ôXÊ.+Y]=]};
[237]={description=[=[Adding X to each row of Y]=],
   arguments=[[Xâ†D1; Yâ†D2]],
   utf=[=[1 1 2â‰Xâˆ˜.+Y]=],
   iso=[=[1 1 2ôXÊ.+Y]=]};
[238]={description=[=[Adding X to each row of Y]=],
   arguments=[[Xâ†D1; Yâ†D2]],
   utf=[=[1 2 1â‰Yâˆ˜.+X]=],
   iso=[=[1 2 1ôYÊ.+X]=]};
[240]={description=[=[Adding X to each column of Y]=],
   arguments=[[Xâ†D1; Yâ†D2]],
   utf=[=[2 1 2â‰Xâˆ˜.+Y]=],
   iso=[=[2 1 2ôXÊ.+Y]=]};
[241]={description=[=[Adding X to each column of Y]=],
   arguments=[[Xâ†D1; Yâ†D2]],
   utf=[=[1 2 2â‰Yâˆ˜.+X]=],
   iso=[=[1 2 2ôYÊ.+X]=]};
[242]={description=[=[Hilbert matrix of order X]=],
   arguments=[[Xâ†I0]],
   utf=[=[Ã·Â¯1+(â³X)âˆ˜.+â³X]=],
   iso=[=[ß¢1+(ÉX)Ê.+ÉX]=]};
[243]={description=[=[Moving index of width Y for vector X]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[(0,â³(â´X)-Y)âˆ˜.+Y]=],
   iso=[=[(0,É(ÒX)-Y)Ê.+Y]=]};
[244]={description=[=[Indices of subvectors of length Y starting at X+1]=],
   arguments=[[Xâ†I1; Yâ†I0]],
   utf=[=[Xâˆ˜.+â³Y]=],
   iso=[=[XÊ.+ÉY]=]};
[245]={description=[=[Reshaping numeric vector X into a one-column matrix]=],
   arguments=[[Xâ†D1]],
   utf=[=[Xâˆ˜.+,0]=],
   iso=[=[XÊ.+,0]=]};
[246]={description=[=[Annuity coefficient: X periods at interest rate Y %]=],
   arguments=[[Xâ†I; Yâ†D]],
   utf=[=[((â´A)â´YÃ·100)Ã·Aâ†â‰1-(1+YÃ·100)âˆ˜.*-X]=],
   iso=[=[((ÒA)ÒYß100)ßAûô1-(1+Yß100)Ê.*-X]=]};
[247]={description=[=[Matrix with X[i] trailing zeroes on row i]=],
   arguments=[[Xâ†I1]],
   utf=[=[Xâˆ˜.<âŒ½â³âŒˆ/X]=],
   iso=[=[XÊ.<÷ÉÓ/X]=]};
[248]={description=[=[Matrix with X[i] leading zeroes on row i]=],
   arguments=[[Xâ†I1]],
   utf=[=[Xâˆ˜.<â³âŒˆ/X]=],
   iso=[=[XÊ.<ÉÓ/X]=]};
[249]={description=[=[Distribution of X into intervals between Y]=],
   arguments=[[Xâ†D; Yâ†D1]],
   utf=[=[+/((Â¯1â†“Y)âˆ˜.â‰¤X)^(1â†“Y)âˆ˜.>X]=],
   iso=[=[+/((¢1ÕY)Ê.¤X)^(1ÕY)Ê.>X]=]};
[250]={description=[=[Histogram (distribution barchart; down the page)]=],
   arguments=[[Xâ†I1]],
   utf=[=[' â•'[â•IO+(âŒ½â³âŒˆ/A)âˆ˜.â‰¤Aâ†+/(â³1+(âŒˆ/X)-âŒŠ/X)âˆ˜.=X]]=],
   iso=[=[' Ì'[ÌIO+(÷ÉÓ/A)Ê.¤Aû+/(É1+(Ó/X)-Ä/X)Ê.=X]]=]};
[251]={description=[=[Barchart of integer values (down the page)]=],
   arguments=[[Xâ†I1]],
   utf=[=[' â•'[â•IO+(âŒ½â³âŒˆ/X)âˆ˜.â‰¤X]]=],
   iso=[=[' Ì'[ÌIO+(÷ÉÓ/X)Ê.¤X]]=]};
[252]={description=[=[Test if X is an upper triangular matrix]=],
   arguments=[[Xâ†D2]],
   utf=[=[^/,(0â‰ X)â‰¤Aâˆ˜.â‰¤Aâ†â³1â†‘â´X]=],
   iso=[=[^/,(0¨X)¤AÊ.¤AûÉ1ÙÒX]=]};
[253]={description=[=[Number of ?s intersecting ?s (X=starts, Y=stops)]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[+/A^â‰Aâ†Xâˆ˜.â‰¤Y]=],
   iso=[=[+/A^ôAûXÊ.¤Y]=]};
[254]={description=[=[Contour levels Y at points with altitudes X]=],
   arguments=[[Xâ†D0; Yâ†D1]],
   utf=[=[Y[+âŒ¿Yâˆ˜.â‰¤X]]=],
   iso=[=[Y[+¯YÊ.¤X]]=]};
[255]={description=[=[XÃ—X upper triangular matrix]=],
   arguments=[[Xâ†I0]],
   utf=[=[(â³X)âˆ˜.â‰¤â³X]=],
   iso=[=[(ÉX)Ê.¤ÉX]=]};
[256]={description=[=[Classification of elements Y into X classes of equal size]=],
   arguments=[[Xâ†I0; Yâ†D1]],
   utf=[=[+/(AÃ—XÃ·âŒˆ/Aâ†Y-âŒŠ/Y)âˆ˜.â‰¥Â¯1+â³X]=],
   iso=[=[+/(A«XßÓ/AûY-Ä/Y)Ê.¦¢1+ÉX]=]};
[257]={description=[=[Matrix with X[i] trailing ones on row i]=],
   arguments=[[Xâ†I1]],
   utf=[=[Xâˆ˜.â‰¥âŒ½â³âŒˆ/X]=],
   iso=[=[XÊ.¦÷ÉÓ/X]=]};
[258]={description=[=[Comparison table]=],
   arguments=[[Xâ†I1]],
   utf=[=[Xâˆ˜.â‰¥â³âŒˆ/X,0]=],
   iso=[=[XÊ.¦ÉÓ/X,0]=]};
[259]={description=[=[Barchart of X with height Y (across the page)]=],
   arguments=[[Xâ†D1; Yâ†D0]],
   utf=[=[' â•'[â•IO+Xâˆ˜.â‰¥(âŒˆ/X)Ã—(â³Y)Ã·Y]]=],
   iso=[=[' Ì'[ÌIO+XÊ.¦(Ó/X)«(ÉY)ßY]]=]};
[260]={description=[=[Barchart of integer values (across the page)]=],
   arguments=[[Xâ†I1]],
   utf=[=[' â•'[â•IO+Xâˆ˜.â‰¥â³âŒˆ/X]]=],
   iso=[=[' Ì'[ÌIO+XÊ.¦ÉÓ/X]]=]};
[261]={description=[=[Matrix with X[i] leading ones on row i]=],
   arguments=[[Xâ†I1]],
   utf=[=[Xâˆ˜.â‰¥â³âŒˆ/X]=],
   iso=[=[XÊ.¦ÉÓ/X]=]};
[263]={description=[=[Test if X is a lower triangular matrix]=],
   arguments=[[Xâ†D2]],
   utf=[=[^/,(0â‰ X)â‰¤Aâˆ˜.â‰¥Aâ†â³1â†‘â´X]=],
   iso=[=[^/,(0¨X)¤AÊ.¦AûÉ1ÙÒX]=]};
[264]={description=[=[Test if X is within range [ Y[1],Y[2] )]=],
   arguments=[[Xâ†D; Yâ†D1]],
   utf=[=[â‰ /Xâˆ˜.â‰¥Y]=],
   iso=[=[¨/XÊ.¦Y]=]};
[265]={description=[=[Ordinal numbers of words in X that indices Y point to]=],
   arguments=[[Xâ†C1; Yâ†I]],
   utf=[=[â•IO++/Yâˆ˜.â‰¥(' '=X)/â³â´X]=],
   iso=[=[ÌIO++/YÊ.¦(' '=X)/ÉÒX]=]};
[266]={description=[=[Which class do elements of X belong to]=],
   arguments=[[Xâ†D]],
   utf=[=[+/Xâˆ˜.â‰¥0 50 100 1000]=],
   iso=[=[+/XÊ.¦0 50 100 1000]=]};
[267]={description=[=[XÃ—X lower triangular matrix]=],
   arguments=[[Xâ†I0]],
   utf=[=[(â³X)âˆ˜.â‰¥â³X]=],
   iso=[=[(ÉX)Ê.¦ÉX]=]};
[268]={description=[=[Moving all blanks to end of each row]=],
   arguments=[[Xâ†C]],
   utf=[=[(â´X)â´(,(+/A)âˆ˜.>-â•IO-â³Â¯1â†‘â´X)\(,Aâ†Xâ‰ ' ')/,X]=],
   iso=[=[(ÒX)Ò(,(+/A)Ê.>-ÌIO-É¢1ÙÒX)\(,AûX¨' ')/,X]=]};
[269]={description=[=[Justifying right fields of X (lengths Y) to length G]=],
   arguments=[[Xâ†A1; Yâ†I1; Gâ†I0]],
   utf=[=[(,Yâˆ˜.>âŒ½(â³G)-â•IO)\X]=],
   iso=[=[(,YÊ.>÷(ÉG)-ÌIO)\X]=]};
[270]={description=[=[Justifying left fields of X (lengths Y) to length G]=],
   arguments=[[Xâ†A1; Yâ†I1; Gâ†I0]],
   utf=[=[(,Yâˆ˜.>(â³G)-â•IO)\X]=],
   iso=[=[(,YÊ.>(ÉG)-ÌIO)\X]=]};
[271]={description=[=[Indices of elements of Y in corr. rows of X (X[i;]â³Y[i;])]=],
   arguments=[[Xâ†A2; Yâ†A2]],
   utf=[=[1++/^\1 2 1 3â‰Yâˆ˜.â‰ X]=],
   iso=[=[1++/^\1 2 1 3ôYÊ.¨X]=]};
[273]={description=[=[Indicating equal elements of X as a logical matrix]=],
   arguments=[[Xâ†A1]],
   utf=[=[â‰Xâˆ˜.=(1 1â‰<\Xâˆ˜.=X)/X]=],
   iso=[=[ôXÊ.=(1 1ô<\XÊ.=X)/X]=]};
[275]={description=[=[Changing connection matrix X (Â¯1 â†’ 1) to a node matrix]=],
   arguments=[[Xâ†I2]],
   utf=[=[(1 Â¯1âˆ˜.=â‰X)+.Ã—â³1â†‘â´â•â†X]=],
   iso=[=[(1 ¢1Ê.=ôX)+.«É1ÙÒÌûX]=]};
[276]={description=[=[Sums according to codes G]=],
   arguments=[[Xâ†A; Yâ†D; Gâ†A]],
   utf=[=[(Gâˆ˜.=X)+.Ã—Y]=],
   iso=[=[(GÊ.=X)+.«Y]=]};
[277]={description=[=[Removing duplicate elements (nub)]=],
   arguments=[[Xâ†A1]],
   utf=[=[(1 1â‰<\Xâˆ˜.=X)/X]=],
   iso=[=[(1 1ô<\XÊ.=X)/X]=]};
[278]={description=[=[Changing node matrix X (starts,ends) to a connection matrix]=],
   arguments=[[Xâ†I2]],
   utf=[=[-/(â³âŒˆ/,X)âˆ˜.=â‰X]=],
   iso=[=[-/(ÉÓ/,X)Ê.=ôX]=]};
[279]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[âˆ¨/^/0 1âˆ˜.=X]=],
   iso=[=[©/^/0 1Ê.=X]=]};
[280]={description=[=[Test if elements of X belong to corr. row of Y (X[i;]âˆŠY[i;])]=],
   arguments=[[Xâ†A2; Yâ†A2; 1â†‘â´Xâ†â†’1â†‘â´Y]],
   utf=[=[âˆ¨/1 2 1 3â‰Xâˆ˜.=Y]=],
   iso=[=[©/1 2 1 3ôXÊ.=Y]=]};
[281]={description=[=[Test if X is a permutation vector]=],
   arguments=[[Xâ†I1]],
   utf=[=[^/1=+âŒ¿Xâˆ˜.=â³â´X]=],
   iso=[=[^/1=+¯XÊ.=ÉÒX]=]};
[282]={description=[=[Occurrences of string X in string Y]=],
   arguments=[[Xâ†C1; Yâ†C1]],
   utf=[=[(^âŒ¿(Â¯1+â³â´X)âŒ½(Xâˆ˜.=Y),0)/â³1+â´Y]=],
   iso=[=[(^¯(¢1+ÉÒX)÷(XÊ.=Y),0)/É1+ÒY]=]};
[283]={description=[=[Division to Y classes with width H, minimum G]=],
   arguments=[[Xâ†D; Yâ†I0; Gâ†D0; Hâ†D0]],
   utf=[=[+/(â³Y)âˆ˜.=âŒˆ(X-G)Ã·H]=],
   iso=[=[+/(ÉY)Ê.=Ó(X-G)ßH]=]};
[285]={description=[=[Repeat matrix]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[(((Â¯1âŒ½~A)^Aâ†(Â¯1â†“X=1âŒ½X),0)/Y)âˆ˜.=Y]=],
   iso=[=[(((¢1÷~A)^Aû(¢1ÕX=1÷X),0)/Y)Ê.=Y]=]};
[286]={description=[=[XÃ—X identity matrix]=],
   arguments=[[Xâ†I0]],
   utf=[=[(â³X)âˆ˜.=â³X]=],
   iso=[=[(ÉX)Ê.=ÉX]=]};
[287]={description=[=[Maxima of elements of subsets of X specified by Y]=],
   arguments=[[Xâ†A1; Yâ†B]],
   utf=[=[A+(X-Aâ†âŒŠ/X)âŒˆ.Ã—Y]=],
   iso=[=[A+(X-AûÄ/X)Ó.«Y]=]};
[288]={description=[=[Indices of last non-blanks in rows]=],
   arguments=[[Xâ†C]],
   utf=[=[(' 'â‰ X)âŒˆ.Ã—â³Â¯1â†‘â´X]=],
   iso=[=[(' '¨X)Ó.«É¢1ÙÒX]=]};
[289]={description=[=[Maximum of X with weights Y]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[YâŒˆ.Ã—X]=],
   iso=[=[YÓ.«X]=]};
[290]={description=[=[Minimum of X with weights Y]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[YâŒŠ.Ã—X]=],
   iso=[=[YÄ.«X]=]};
[292]={description=[=[Extending a distance table to next leg]=],
   arguments=[[Xâ†D2]],
   utf=[=[Xâ†XâŒŠ.+X]=],
   iso=[=[XûXÄ.+X]=]};
[293]={description=[=[A way to combine trigonometric functions (sin X cos Y)]=],
   arguments=[[Xâ†D0; Yâ†D0]],
   utf=[=[1 2Ã—.â—‹X,Y]=],
   iso=[=[1 2«.ÏX,Y]=]};
[294]={description=[=[Sine of a complex number]=],
   arguments=[[Xâ†D; 2=1â†‘â´X]],
   utf=[=[(2 2â´1 6 2 5)Ã—.â—‹X]=],
   iso=[=[(2 2Ò1 6 2 5)«.ÏX]=]};
[295]={description=[=[Products over subsets of X specified by Y]=],
   arguments=[[Xâ†A1; Yâ†B]],
   utf=[=[XÃ—.*Y]=],
   iso=[=[X«.*Y]=]};
[296]={description=[=[Sum of squares of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[X+.*2]=],
   iso=[=[X+.*2]=]};
[297]={description=[=[Randomizing random numbers (in â•LX in a workspace)]=],
   arguments=[[]],
   utf=[=[â•RLâ†â•TS+.*2]=],
   iso=[=[ÌRLûÌTS+.*2]=]};
[298]={description=[=[Extending a transitive binary relation]=],
   arguments=[[Xâ†B2]],
   utf=[=[Xâ†Xâˆ¨.^X]=],
   iso=[=[XûX©.^X]=]};
[299]={description=[=[Test if X is within range [ Y[1;],Y[2;] )]=],
   arguments=[[Xâ†D0; Yâ†D2; 1â†‘â´Y â†â†’ 2]],
   utf=[=[X<.<Y]=],
   iso=[=[X<.<Y]=]};
[300]={description=[=[Test if X is within range ( Y[1;],Y[2;] ]]=],
   arguments=[[Xâ†D0; Yâ†D2; 1â†‘â´Y â†â†’ 2]],
   utf=[=[X<.â‰¤Y]=],
   iso=[=[X<.¤Y]=]};
[301]={description=[=[Test if X is within range ( Y[1;],Y[2;] ]]=],
   arguments=[[Xâ†D; Yâ†D2; 1â†‘â´Y â†â†’ 2]],
   utf=[=[X<.â‰¤Y]=],
   iso=[=[X<.¤Y]=]};
[302]={description=[=[Test if the elements of X are ascending]=],
   arguments=[[Xâ†D1]],
   utf=[=[X<.â‰¥1âŒ½X]=],
   iso=[=[X<.¦1÷X]=]};
[303]={description=[=[Test if X is an integer within range [ G,H )]=],
   arguments=[[Xâ†I0; Gâ†I0; Hâ†I0]],
   utf=[=[~Xâ‰¤.â‰¥(âŒˆX),G,H]=],
   iso=[=[~X¤.¦(ÓX),G,H]=]};
[304]={description=[=[Test if X is within range ( Y[1;],Y[2;] ]]=],
   arguments=[[Xâ†D; Yâ†D2; 1â†‘â´Y â†â†’ 2]],
   utf=[=[(X,[.1+â´â´X]X)>.>Y]=],
   iso=[=[(X,[.1+ÒÒX]X)>.>Y]=]};
[306]={description=[=[Removing trailing blank columns]=],
   arguments=[[Xâ†C2]],
   utf=[=[(âŒ½âˆ¨\âŒ½' 'âˆ¨.â‰ X)/X]=],
   iso=[=[(÷©\÷' '©.¨X)/X]=]};
[307]={description=[=[Removing leading blank rows]=],
   arguments=[[Xâ†C2]],
   utf=[=[(âˆ¨\Xâˆ¨.â‰ ' ')âŒ¿X]=],
   iso=[=[(©\X©.¨' ')¯X]=]};
[308]={description=[=[Removing leading blank columns]=],
   arguments=[[Xâ†C2]],
   utf=[=[(âˆ¨\' 'âˆ¨.â‰ X)/X]=],
   iso=[=[(©\' '©.¨X)/X]=]};
[309]={description=[=[Index of first occurrences of rows of X as rows of Y]=],
   arguments=[[Xâ†A, Yâ†A2]],
   utf=[=[â•IO++âŒ¿^â€Yâˆ¨.â‰ â‰X]=],
   iso=[=[ÌIO++¯^ÜY©.¨ôX]=]};
[310]={description=[=[Xâ³Y for rows of matrices]=],
   arguments=[[Xâ†A2; Yâ†A2]],
   utf=[=[â•IO++âŒ¿^â€Xâˆ¨.â‰ â‰Y]=],
   iso=[=[ÌIO++¯^ÜX©.¨ôY]=]};
[311]={description=[=[Removing duplicate blank rows]=],
   arguments=[[Xâ†C2]],
   utf=[=[(Aâˆ¨1â†“1âŒ½1,Aâ†Xâˆ¨.â‰ ' ')âŒ¿X]=],
   iso=[=[(A©1Õ1÷1,AûX©.¨' ')¯X]=]};
[312]={description=[=[Removing duplicate blank columns]=],
   arguments=[[Xâ†C2]],
   utf=[=[(Aâˆ¨1,Â¯1â†“Aâ†' 'âˆ¨.â‰ X)/X]=],
   iso=[=[(A©1,¢1ÕAû' '©.¨X)/X]=]};
[313]={description=[=[Removing blank columns]=],
   arguments=[[Xâ†C2]],
   utf=[=[(' 'âˆ¨.â‰ X)/X]=],
   iso=[=[(' '©.¨X)/X]=]};
[314]={description=[=[Removing blank rows]=],
   arguments=[[Xâ†C2]],
   utf=[=[(Xâˆ¨.â‰ ' ')âŒ¿X]=],
   iso=[=[(X©.¨' ')¯X]=]};
[315]={description=[=[Test if rows of X contain elements differing from Y]=],
   arguments=[[Xâ†A; Yâ†A0]],
   utf=[=[Xâˆ¨.â‰ Y]=],
   iso=[=[X©.¨Y]=]};
[316]={description=[=[Removing trailing blank rows]=],
   arguments=[[Xâ†C2]],
   utf=[=[(-2â†‘+/^\âŒ½X^.=' ')â†“X]=],
   iso=[=[(-2Ù+/^\÷X^.=' ')ÕX]=]};
[317]={description=[=[Removing duplicate rows]=],
   arguments=[[Xâ†A2]],
   utf=[=[(âˆ¨âŒ¿<\X^.=â‰X)âŒ¿X]=],
   iso=[=[(©¯<\X^.=ôX)¯X]=]};
[318]={description=[=[Removing duplicate rows]=],
   arguments=[[Xâ†A2]],
   utf=[=[(1 1â‰<\X^.=â‰X)âŒ¿X]=],
   iso=[=[(1 1ô<\X^.=ôX)¯X]=]};
[319]={description=[=[Test if circular lists are equal (excluding phase)]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[âˆ¨/Y^.=â‰(â³â´X)âŒ½(2â´â´X)â´X]=],
   iso=[=[©/Y^.=ô(ÉÒX)÷(2ÒÒX)ÒX]=]};
[320]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[X^.=âˆ¨/X]=],
   iso=[=[X^.=©/X]=]};
[321]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[X^.=^/X]=],
   iso=[=[X^.=^/X]=]};
[322]={description=[=[Rows of matrix X starting with string Y]=],
   arguments=[[Xâ†A2; Yâ†A1]],
   utf=[=[((((1â†‘â´X),â´Y)â†‘X)^.=Y)âŒ¿X]=],
   iso=[=[((((1ÙÒX),ÒY)ÙX)^.=Y)¯X]=]};
[323]={description=[=[Occurrences of string X in string Y]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[((-A)â†“X^.=(A,1+â´Y)â´Y)/â³(â´Y)+1-Aâ†â´X]=],
   iso=[=[((-A)ÕX^.=(A,1+ÒY)ÒY)/É(ÒY)+1-AûÒX]=]};
[324]={description=[=[Test if vector Y is a row of array X]=],
   arguments=[[Xâ†A; Yâ†A1]],
   utf=[=[1âˆŠX^.=Y]=],
   iso=[=[1ÅX^.=Y]=]};
[325]={description=[=[Comparing vector Y with rows of array X]=],
   arguments=[[Xâ†A; Yâ†A1]],
   utf=[=[X^.=Y]=],
   iso=[=[X^.=Y]=]};
[326]={description=[=[Word lengths of words in list X]=],
   arguments=[[Xâ†C]],
   utf=[=[X+.â‰ ' ']=],
   iso=[=[X+.¨' ']=]};
[327]={description=[=[Number of occurrences of scalar X in array Y]=],
   arguments=[[Xâ†A0; Yâ†A]],
   utf=[=[X+.=,Y]=],
   iso=[=[X+.=,Y]=]};
[328]={description=[=[Counting pairwise matches (equal elements) in two vectors]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[X+.=Y]=],
   iso=[=[X+.=Y]=]};
[329]={description=[=[Sum of alternating reciprocal series YÃ·X]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[Y-.Ã·X]=],
   iso=[=[Y-.ßX]=]};
[330]={description=[=[Limits X to fit in â• field Y[1 2]]=],
   arguments=[[Xâ†D; Yâ†I1]],
   utf=[=[(XâŒˆ1â†“A)âŒŠ1â†‘Aâ†(2 2â´Â¯1 1 1 Â¯.1)+.Ã—10*(-1â†“Y),-/Y+Y>99 0]=],
   iso=[=[(XÓ1ÕA)Ä1ÙAû(2 2Ò¢1 1 1 ¢.1)+.«10*(-1ÕY),-/Y+Y>99 0]=]};
[331]={description=[=[Value of polynomial with coefficients Y at point X]=],
   arguments=[[Xâ†D0; Yâ†D]],
   utf=[=[(X*Â¯1+â³â´Y)+.Ã—âŒ½Y]=],
   iso=[=[(X*¢1+ÉÒY)+.«÷Y]=]};
[332]={description=[=[Arithmetic average (mean value) of X weighted by Y]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[(Y+.Ã—X)Ã·â´X]=],
   iso=[=[(Y+.«X)ßÒX]=]};
[333]={description=[=[Scalar (dot) product of vectors]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[Y+.Ã—X]=],
   iso=[=[Y+.«X]=]};
[334]={description=[=[Sum of squares of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[X+.Ã—X]=],
   iso=[=[X+.«X]=]};
[335]={description=[=[Summation over subsets of X specified by Y]=],
   arguments=[[Xâ†A1; Yâ†B]],
   utf=[=[X+.Ã—Y]=],
   iso=[=[X+.«Y]=]};
[336]={description=[=[Matrix product]=],
   arguments=[[Xâ†D; Yâ†D; Â¯1â†‘â´X â†â†’ 1â†‘â´Y]],
   utf=[=[X+.Ã—Y]=],
   iso=[=[X+.«Y]=]};
[337]={description=[=[Sum of reciprocal series YÃ·X]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[Y+.Ã·X]=],
   iso=[=[Y+.ßX]=]};
[338]={description=[=[Groups of ones in Y pointed to by X (or trailing parts)]=],
   arguments=[[Xâ†B; Yâ†B]],
   utf=[=[Y^A=âŒˆ\XÃ—Aâ†+\Y>Â¯1â†“0,Y]=],
   iso=[=[Y^A=Ó\X«Aû+\Y>¢1Õ0,Y]=]};
[339]={description=[=[Test if X is in ascending order along direction Y]=],
   arguments=[[Xâ†D; Yâ†I0]],
   utf=[=[^/[Y]X=âŒˆ\[Y]X]=],
   iso=[=[^/[Y]X=Ó\[Y]X]=]};
[340]={description=[=[Duplicating element of X belonging to Y,1â†‘X until next found]=],
   arguments=[[Xâ†A1; Yâ†B1]],
   utf=[=[X[1âŒˆâŒˆ\YÃ—â³â´Y]]=],
   iso=[=[X[1ÓÓ\Y«ÉÒY]]=]};
[341]={description=[=[Test if X is in descending order along direction Y]=],
   arguments=[[Xâ†D; Yâ†I0]],
   utf=[=[^/[Y]X=âŒŠ\[Y]X]=],
   iso=[=[^/[Y]X=Ä\[Y]X]=]};
[342]={description=[=[Value of Taylor series with coefficients Y at point X]=],
   arguments=[[Xâ†D0; Yâ†D1]],
   utf=[=[+/YÃ—Ã—\1,XÃ·â³Â¯1+â´Y]=],
   iso=[=[+/Y««\1,XßÉ¢1+ÒY]=]};
[343]={description=[=[Alternating series (1 Â¯1 2 Â¯2 3 Â¯3 ...)]=],
   arguments=[[Xâ†I0]],
   utf=[=[-\â³X]=],
   iso=[=[-\ÉX]=]};
[346]={description=[=[Value of saddle point]=],
   arguments=[[Xâ†D2]],
   utf=[=[(<\,(X=(â´X)â´âŒˆâŒ¿X)^X=â‰(âŒ½â´X)â´âŒŠ/X)/,X]=],
   iso=[=[(<\,(X=(ÒX)ÒÓ¯X)^X=ô(÷ÒX)ÒÄ/X)/,X]=]};
[348]={description=[=[First one (turn off all ones after first one)]=],
   arguments=[[Xâ†B]],
   utf=[=[<\X]=],
   iso=[=[<\X]=]};
[350]={description=[=[Not first zero (turn on all zeroes after first zero)]=],
   arguments=[[Xâ†B]],
   utf=[=[â‰¤\X]=],
   iso=[=[¤\X]=]};
[351]={description=[=[Running parity (â‰ \) over subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[â‰ \Yâ‰ X\Aâ‰ Â¯1â†“0,Aâ†X/â‰ \Â¯1â†“0,Y]=],
   iso=[=[¨\Y¨X\A¨¢1Õ0,AûX/¨\¢1Õ0,Y]=]};
[352]={description=[=[Vector (X[1]â´1),(X[2]â´0),(X[3]â´1),...]=],
   arguments=[[Xâ†I1]],
   utf=[=[â‰ \(â³+/X)âˆŠ+\â•IO,X]=],
   iso=[=[¨\(É+/X)Å+\ÌIO,X]=]};
[353]={description=[=[Not leading zeroes(âˆ¨\) in each subvector of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[â‰ \(Yâˆ¨X)\Aâ‰ Â¯1â†“0,Aâ†(Yâˆ¨X)/Y]=],
   iso=[=[¨\(Y©X)\A¨¢1Õ0,Aû(Y©X)/Y]=]};
[354]={description=[=[Leading ones (`^\) in each subvector of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[~â‰ \(Yâ‰¤X)\Aâ‰ Â¯1â†“0,Aâ†~(Yâ‰¤X)/Y]=],
   iso=[=[~¨\(Y¤X)\A¨¢1Õ0,Aû~(Y¤X)/Y]=]};
[355]={description=[=[Locations of texts between and including quotes]=],
   arguments=[[Xâ†C1]],
   utf=[=[Aâˆ¨Â¯1â†“0,Aâ†â‰ \X='''']=],
   iso=[=[A©¢1Õ0,Aû¨\X='''']=]};
[356]={description=[=[Locations of texts between quotes]=],
   arguments=[[Xâ†C1]],
   utf=[=[A^Â¯1â†“0,Aâ†â‰ \X='''']=],
   iso=[=[A^¢1Õ0,Aû¨\X='''']=]};
[357]={description=[=[Joining pairs of ones]=],
   arguments=[[Xâ†B]],
   utf=[=[Xâˆ¨â‰ \X]=],
   iso=[=[X©¨\X]=]};
[358]={description=[=[Places between pairs of ones]=],
   arguments=[[Xâ†B]],
   utf=[=[(~X)^â‰ \X]=],
   iso=[=[(~X)^¨\X]=]};
[359]={description=[=[Running parity]=],
   arguments=[[Xâ†B]],
   utf=[=[â‰ \X]=],
   iso=[=[¨\X]=]};
[360]={description=[=[Removing leading and trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[((âŒ½âˆ¨\âŒ½A)^âˆ¨\Aâ†' 'â‰ X)/X]=],
   iso=[=[((÷©\÷A)^©\Aû' '¨X)/X]=]};
[361]={description=[=[First group of ones]=],
   arguments=[[Xâ†B]],
   utf=[=[X^^\X=âˆ¨\X]=],
   iso=[=[X^^\X=©\X]=]};
[362]={description=[=[Removing trailing blank columns]=],
   arguments=[[Xâ†C2]],
   utf=[=[(âŒ½âˆ¨\âŒ½âˆ¨âŒ¿' 'â‰ X)/X]=],
   iso=[=[(÷©\÷©¯' '¨X)/X]=]};
[363]={description=[=[Removing trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(âŒ½âˆ¨\âŒ½' 'â‰ X)/X]=],
   iso=[=[(÷©\÷' '¨X)/X]=]};
[364]={description=[=[Removing leading blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(âˆ¨\' 'â‰ X)/X]=],
   iso=[=[(©\' '¨X)/X]=]};
[365]={description=[=[Not leading zeroes (turn on all zeroes after first one)]=],
   arguments=[[Xâ†B]],
   utf=[=[âˆ¨\X]=],
   iso=[=[©\X]=]};
[366]={description=[=[Centering character array X with ragged edges]=],
   arguments=[[Xâ†C]],
   utf=[=[(A-âŒŠ0.5Ã—(Aâ†+/^\âŒ½A)++/^\Aâ†' '=âŒ½X)âŒ½X]=],
   iso=[=[(A-Ä0.5«(Aû+/^\÷A)++/^\Aû' '=÷X)÷X]=]};
[367]={description=[=[Decommenting a matrix representation of a function (â•CR)]=],
   arguments=[[Xâ†C2]],
   utf=[=[(âˆ¨/A)âŒ¿(â´X)â´(,A)\(,Aâ†^\('â'â‰ X)âˆ¨â‰ \X='''')/,X]=],
   iso=[=[(©/A)¯(ÒX)Ò(,A)\(,Aû^\('ã'¨X)©¨\X='''')/,X]=]};
[369]={description=[=[Centering character array X with only right edge ragged]=],
   arguments=[[Xâ†C]],
   utf=[=[(-âŒŠ0.5Ã—+/^\' '=âŒ½X)âŒ½X]=],
   iso=[=[(-Ä0.5«+/^\' '=÷X)÷X]=]};
[370]={description=[=[Justifying right]=],
   arguments=[[Xâ†C]],
   utf=[=[(-+/^\âŒ½' '=X)âŒ½X]=],
   iso=[=[(-+/^\÷' '=X)÷X]=]};
[371]={description=[=[Removing trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(-+/^\âŒ½' '=X)â†“X]=],
   iso=[=[(-+/^\÷' '=X)ÕX]=]};
[372]={description=[=[Justifying left]=],
   arguments=[[Xâ†C]],
   utf=[=[(+/^\' '=X)âŒ½X]=],
   iso=[=[(+/^\' '=X)÷X]=]};
[373]={description=[=[Editing X with Y '-wise]=],
   arguments=[[Xâ†C1; Yâ†C1]],
   utf=[=[((~(â´Aâ†‘X)â†‘'/'=Y)/Aâ†‘X),(1â†“Aâ†“Y),(Aâ†+/^\Yâ‰ ',')â†“X]=],
   iso=[=[((~(ÒAÙX)Ù'/'=Y)/AÙX),(1ÕAÕY),(Aû+/^\Y¨',')ÕX]=]};
[374]={description=[=[Removing leading blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(+/^\' '=X)â†“X]=],
   iso=[=[(+/^\' '=X)ÕX]=]};
[375]={description=[=[Indices of first blanks in rows of array X]=],
   arguments=[[Xâ†C]],
   utf=[=[â•IO++/^\' 'â‰ X]=],
   iso=[=[ÌIO++/^\' '¨X]=]};
[377]={description=[=[Leading ones (turn off all ones after first zero)]=],
   arguments=[[Xâ†B]],
   utf=[=[^\X]=],
   iso=[=[^\X]=]};
[378]={description=[=[Vector (X[1]â´1),(Y[1]â´0),(X[2]â´1),...]=],
   arguments=[[Xâ†I1; Yâ†I1]],
   utf=[=[(â³+/X,Y)âˆŠ+\1+Â¯1â†“0,((â³+/X)âˆŠ+\X)\Y]=],
   iso=[=[(É+/X,Y)Å+\1+¢1Õ0,((É+/X)Å+\X)\Y]=]};
[379]={description=[=[Replicate Y[i] X[i] times (for all i)]=],
   arguments=[[Xâ†I1; Yâ†A1]],
   utf=[=[((Xâ‰ 0)/Y)[+\Â¯1âŒ½(â³+/X)âˆŠ+\X]]=],
   iso=[=[((X¨0)/Y)[+\¢1÷(É+/X)Å+\X]]=]};
[380]={description=[=[Vector (Y[1]+â³X[1]),(Y[2]+â³X[2]),(Y[3]+â³X[3]),...]=],
   arguments=[[Xâ†I1; Yâ†I1; â´Xâ†â†’â´Y]],
   utf=[=[â•IO++\1+((â³+/X)âˆŠ+\â•IO,X)\Y-Â¯1â†“1,X+Y]=],
   iso=[=[ÌIO++\1+((É+/X)Å+\ÌIO,X)\Y-¢1Õ1,X+Y]=]};
[381]={description=[=[Replicate Y[i] X[i] times (for all i)]=],
   arguments=[[Xâ†I1; Yâ†A1]],
   utf=[=[Y[+\(â³+/X)âˆŠÂ¯1â†“1++\0,X]]=],
   iso=[=[Y[+\(É+/X)Å¢1Õ1++\0,X]]=]};
[382]={description=[=[Replicate Y[i] X[i] times (for all i)]=],
   arguments=[[Xâ†I1; Yâ†A1]],
   utf=[=[Y[â•IO++\(â³+/X)âˆŠâ•IO++\X]]=],
   iso=[=[Y[ÌIO++\(É+/X)ÅÌIO++\X]]=]};
[383]={description=[=[Cumulative sums (+\) over subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[+\Y-X\A-Â¯1â†“0,Aâ†X/+\Â¯1â†“0,Y]=],
   iso=[=[+\Y-X\A-¢1Õ0,AûX/+\¢1Õ0,Y]=]};
[384]={description=[=[Sums over (+/) subvectors of Y, lengths in X]=],
   arguments=[[Xâ†I1; Yâ†D1]],
   utf=[=[A-Â¯1â†“0,Aâ†(+\Y)[+\X]]=],
   iso=[=[A-¢1Õ0,Aû(+\Y)[+\X]]=]};
[386]={description=[=[X first figurate numbers]=],
   arguments=[[Xâ†I0]],
   utf=[=[+\+\â³X]=],
   iso=[=[+\+\ÉX]=]};
[387]={description=[=[Insert vector for X[i] zeroes after i:th subvector]=],
   arguments=[[Xâ†I1; Yâ†B1]],
   utf=[=[(â³(â´Y)++/X)âˆŠ+\1+Â¯1â†“0,(1âŒ½Y)\X]=],
   iso=[=[(É(ÒY)++/X)Å+\1+¢1Õ0,(1÷Y)\X]=]};
[388]={description=[=[Open a gap of X[i] after Y[G[i]] (for all i)]=],
   arguments=[[Xâ†I1; Yâ†A1; Gâ†I1]],
   utf=[=[((â³(â´Y)++/X)âˆŠ+\1+Â¯1â†“0,((â³â´Y)âˆŠG)\X)\Y]=],
   iso=[=[((É(ÒY)++/X)Å+\1+¢1Õ0,((ÉÒY)ÅG)\X)\Y]=]};
[389]={description=[=[Open a gap of X[i] before Y[G[i]] (for all i)]=],
   arguments=[[Xâ†I1; Yâ†A1; Gâ†I1]],
   utf=[=[((â³(â´Y)++/X)âˆŠ+\1+((â³â´Y)âˆŠG)\X)\Y]=],
   iso=[=[((É(ÒY)++/X)Å+\1+((ÉÒY)ÅG)\X)\Y]=]};
[390]={description=[=[Changing lengths X of subvectors to starting indicators]=],
   arguments=[[Xâ†I1]],
   utf=[=[Aâ†(+/X)â´0 â‹„ A[+\Â¯1â†“â•IO,X]â†1 â‹„ A]=],
   iso=[=[Aû(+/X)Ò0 ş A[+\¢1ÕÌIO,X]û1 ş A]=]};
[391]={description=[=[Changing lengths X of subvectors to ending indicators]=],
   arguments=[[Xâ†I1]],
   utf=[=[(â³+/X)âˆŠ(+\X)-~â•IO]=],
   iso=[=[(É+/X)Å(+\X)-~ÌIO]=]};
[392]={description=[=[Changing lengths X of subvectors to starting indicators]=],
   arguments=[[Xâ†I1]],
   utf=[=[(â³+/X)âˆŠ+\â•IO,X]=],
   iso=[=[(É+/X)Å+\ÌIO,X]=]};
[393]={description=[=[Insert vector for X[i] elements before i:th element]=],
   arguments=[[Xâ†I1]],
   utf=[=[(â³+/A)âˆŠ+\Aâ†1+X]=],
   iso=[=[(É+/A)Å+\Aû1+X]=]};
[394]={description=[=[Sums over (+/) subvectors of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†D1]],
   utf=[=[A-Â¯1â†“0,Aâ†(1âŒ½X)/+\Y]=],
   iso=[=[A-¢1Õ0,Aû(1÷X)/+\Y]=]};
[395]={description=[=[Fifo stock Y decremented with X units]=],
   arguments=[[Yâ†D1; Xâ†D0]],
   utf=[=[G-Â¯1â†“0,Gâ†0âŒˆ(+\Y)-X]=],
   iso=[=[G-¢1Õ0,Gû0Ó(+\Y)-X]=]};
[396]={description=[=[Locations of texts between and including quotes]=],
   arguments=[[Xâ†C1]],
   utf=[=[Aâˆ¨Â¯1â†“0,Aâ†2|+\X='''']=],
   iso=[=[A©¢1Õ0,Aû2|+\X='''']=]};
[397]={description=[=[Locations of texts between quotes]=],
   arguments=[[Xâ†C1]],
   utf=[=[A^Â¯1â†“0,Aâ†2|+\X='''']=],
   iso=[=[A^¢1Õ0,Aû2|+\X='''']=]};
[398]={description=[=[X:th subvector of Y (subvectors separated by Y[1])]=],
   arguments=[[Yâ†A1; Xâ†I0]],
   utf=[=[1â†“(X=+\Y=1â†‘Y)/Y]=],
   iso=[=[1Õ(X=+\Y=1ÙY)/Y]=]};
[399]={description=[=[Locating field number Y starting with first element of X]=],
   arguments=[[Yâ†I0; Xâ†C1]],
   utf=[=[(Y=+\X=1â†‘X)/X]=],
   iso=[=[(Y=+\X=1ÙX)/X]=]};
[400]={description=[=[Sum elements of X marked by succeeding identicals in Y]=],
   arguments=[[Xâ†D1; Yâ†D1]],
   utf=[=[A-Â¯1â†“0,Aâ†(Yâ‰ 1â†“Y,0)/+\X]=],
   iso=[=[A-¢1Õ0,Aû(Y¨1ÕY,0)/+\X]=]};
[401]={description=[=[Groups of ones in Y pointed to by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[Y^AâˆŠ(X^Y)/Aâ†+\Y>Â¯1â†“0,Y]=],
   iso=[=[Y^AÅ(X^Y)/Aû+\Y>¢1Õ0,Y]=]};
[402]={description=[=[ith starting indicators X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[(+\X)âˆŠY/â³â´Y]=],
   iso=[=[(+\X)ÅY/ÉÒY]=]};
[403]={description=[=[G:th subvector of Y (subvectors indicated by X)]=],
   arguments=[[Xâ†B1; Yâ†A1; Gâ†I0]],
   utf=[=[(G=+\X)/Y]=],
   iso=[=[(G=+\X)/Y]=]};
[404]={description=[=[Running sum of Y consecutive elements of X]=],
   arguments=[[Xâ†D1; Yâ†I0]],
   utf=[=[((Y-1)â†“A)-0,(-Y)â†“Aâ†+\X]=],
   iso=[=[((Y-1)ÕA)-0,(-Y)ÕAû+\X]=]};
[405]={description=[=[Depth of parentheses]=],
   arguments=[[Xâ†C1]],
   utf=[=[+\('('=X)-Â¯1â†“0,')'=X]=],
   iso=[=[+\('('=X)-¢1Õ0,')'=X]=]};
[406]={description=[=[Starting positions of subvectors having lengths X]=],
   arguments=[[Xâ†I1]],
   utf=[=[+\Â¯1â†“â•IO,X]=],
   iso=[=[+\¢1ÕÌIO,X]=]};
[407]={description=[=[Changing lengths X of subvectors of Y to ending indicators]=],
   arguments=[[Xâ†I1]],
   utf=[=[(â³â´Y)âˆŠ(+\X)-~â•IO]=],
   iso=[=[(ÉÒY)Å(+\X)-~ÌIO]=]};
[408]={description=[=[Changing lengths X of subvectors of Y to starting indicators]=],
   arguments=[[Xâ†I1]],
   utf=[=[(â³â´Y)âˆŠ+\â•IO,X]=],
   iso=[=[(ÉÒY)Å+\ÌIO,X]=]};
[409]={description=[=[X first triangular numbers]=],
   arguments=[[Xâ†I0]],
   utf=[=[+\â³X]=],
   iso=[=[+\ÉX]=]};
[410]={description=[=[Cumulative sum]=],
   arguments=[[Xâ†D]],
   utf=[=[+\X]=],
   iso=[=[+\X]=]};
[411]={description=[=[Complementary angle (arccos sin X)]=],
   arguments=[[Xâ†D0]],
   utf=[=[â—‹/Â¯2 1,X]=],
   iso=[=[Ï/¢2 1,X]=]};
[412]={description=[=[Evaluating a two-row determinant]=],
   arguments=[[Xâ†D2]],
   utf=[=[-/Ã—/0 1âŠ–X]=],
   iso=[=[-/«/0 1áX]=]};
[413]={description=[=[Evaluating a two-row determinant]=],
   arguments=[[Xâ†D2]],
   utf=[=[-/Ã—âŒ¿0 1âŒ½X]=],
   iso=[=[-/«¯0 1÷X]=]};
[414]={description=[=[Area of triangle with side lengths in X (Heron's formula)]=],
   arguments=[[Xâ†D1; 3 â†â†’ â´X]],
   utf=[=[(Ã—/(+/XÃ·2)-0,X)*.5]=],
   iso=[=[(«/(+/Xß2)-0,X)*.5]=]};
[415]={description=[=[Juxtapositioning planes of rank 3 array X]=],
   arguments=[[Xâ†A3]],
   utf=[=[(Ã—âŒ¿2 2â´1,â´X)â´2 1 3â‰X]=],
   iso=[=[(«¯2 2Ò1,ÒX)Ò2 1 3ôX]=]};
[416]={description=[=[Number of rows in array X (also of a vector)]=],
   arguments=[[Xâ†A]],
   utf=[=[Ã—/Â¯1â†“â´X]=],
   iso=[=[«/¢1ÕÒX]=]};
[417]={description=[=[(Real) solution of quadratic equation with coefficients X]=],
   arguments=[[Xâ†D1; 3 â†â†’ â´X]],
   utf=[=[(-X[2]-Â¯1 1Ã—((X[2]*2)-Ã—/4,X[1 3])*.5)Ã·2Ã—X[1]]=],
   iso=[=[(-X[2]-¢1 1«((X[2]*2)-«/4,X[1 3])*.5)ß2«X[1]]=]};
[418]={description=[=[Reshaping planes of rank 3 array to rows of a matrix]=],
   arguments=[[Xâ†A3]],
   utf=[=[(Ã—/2 2â´1,â´X)â´X]=],
   iso=[=[(«/2 2Ò1,ÒX)ÒX]=]};
[419]={description=[=[Reshaping planes of rank 3 array to a matrix]=],
   arguments=[[Xâ†A3]],
   utf=[=[(Ã—/2 2â´(â´X),1)â´X]=],
   iso=[=[(«/2 2Ò(ÒX),1)ÒX]=]};
[420]={description=[=[Number of elements (also of a scalar)]=],
   arguments=[[Xâ†A]],
   utf=[=[Ã—/â´X]=],
   iso=[=[«/ÒX]=]};
[421]={description=[=[Product of elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[Ã—/X]=],
   iso=[=[«/X]=]};
[422]={description=[=[Alternating product]=],
   arguments=[[Xâ†D]],
   utf=[=[Ã·/X]=],
   iso=[=[ß/X]=]};
[423]={description=[=[Centering text line X into a field of width Y]=],
   arguments=[[Xâ†C1; Yâ†I0]],
   utf=[=[Yâ†‘((âŒŠ-/.5Ã—Y,â´X)â´' '),X]=],
   iso=[=[YÙ((Ä-/.5«Y,ÒX)Ò' '),X]=]};
[424]={description=[=[Alternating sum]=],
   arguments=[[Xâ†D]],
   utf=[=[-/X]=],
   iso=[=[-/X]=]};
[425]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†D1]],
   utf=[=[(âŒˆ/X)=âŒŠ/X]=],
   iso=[=[(Ó/X)=Ä/X]=]};
[426]={description=[=[Size of range of elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[(âŒˆ/X)-âŒŠ/X]=],
   iso=[=[(Ó/X)-Ä/X]=]};
[427]={description=[=[Conversion of set of positive integers X to a mask]=],
   arguments=[[Xâ†I1]],
   utf=[=[(â³âŒˆ/X)âˆŠX]=],
   iso=[=[(ÉÓ/X)ÅX]=]};
[428]={description=[=[Negative infinity; the smallest representable value]=],
   arguments=[[]],
   utf=[=[âŒˆ/â³0]=],
   iso=[=[Ó/É0]=]};
[429]={description=[=[Vectors as column matrices in catenation beneath each other]=],
   arguments=[[Xâ†A1/2; Yâ†A1/2]],
   utf=[=[X,[1+.5Ã—âŒˆ/(â´â´X),â´â´Y]Y]=],
   iso=[=[X,[1+.5«Ó/(ÒÒX),ÒÒY]Y]=]};
[430]={description=[=[Vectors as row matrices in catenation upon each other]=],
   arguments=[[Xâ†A1/2; Yâ†A1/2]],
   utf=[=[X,[.5Ã—âŒˆ/(â´â´X),â´â´Y]Y]=],
   iso=[=[X,[.5«Ó/(ÒÒX),ÒÒY]Y]=]};
[431]={description=[=[Quick membership (âˆŠ) for positive integers]=],
   arguments=[[Xâ†I1; Yâ†I1]],
   utf=[=[Aâ†(âŒˆ/X,Y)â´0 â‹„ A[Y]â†1 â‹„ A[X]]=],
   iso=[=[Aû(Ó/X,Y)Ò0 ş A[Y]û1 ş A[X]]=]};
[432]={description=[=[Positive maximum, at least zero (also for empty X)]=],
   arguments=[[Xâ†D1]],
   utf=[=[âŒˆ/X,0]=],
   iso=[=[Ó/X,0]=]};
[433]={description=[=[Maximum of elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[âŒˆ/X]=],
   iso=[=[Ó/X]=]};
[434]={description=[=[Positive infinity; the largest representable value]=],
   arguments=[[]],
   utf=[=[âŒŠ/â³0]=],
   iso=[=[Ä/É0]=]};
[435]={description=[=[Minimum of elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[âŒŠ/X]=],
   iso=[=[Ä/X]=]};
[436]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[â²/0 1âˆŠX]=],
   iso=[=[°/0 1ÅX]=]};
[437]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[(^/X)âˆ¨~âˆ¨/X]=],
   iso=[=[(^/X)©~©/X]=]};
[438]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[(^/X)=âˆ¨/X]=],
   iso=[=[(^/X)=©/X]=]};
[439]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[^/XÃ·âˆ¨/X]=],
   iso=[=[^/Xß©/X]=]};
[440]={description=[=[Removing duplicate rows from ordered matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[(Â¯1âŒ½1â†“(âˆ¨/Xâ‰ Â¯1âŠ–X),1)âŒ¿X]=],
   iso=[=[(¢1÷1Õ(©/X¨¢1áX),1)¯X]=]};
[441]={description=[=[Vector having as many ones as X has rows]=],
   arguments=[[Xâ†A2]],
   utf=[=[âˆ¨/0/X]=],
   iso=[=[©/0/X]=]};
[442]={description=[=[Test if X and Y have elements in common]=],
   arguments=[[Xâ†A; Yâ†A1]],
   utf=[=[âˆ¨/YâˆŠX]=],
   iso=[=[©/YÅX]=]};
[443]={description=[=[None, neither]=],
   arguments=[[Xâ†B]],
   utf=[=[~âˆ¨/X]=],
   iso=[=[~©/X]=]};
[444]={description=[=[Any, anyone]=],
   arguments=[[Xâ†B]],
   utf=[=[âˆ¨/X]=],
   iso=[=[©/X]=]};
[445]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[â‰ /0 1âˆŠX]=],
   iso=[=[¨/0 1ÅX]=]};
[446]={description=[=[Parity]=],
   arguments=[[Xâ†B]],
   utf=[=[â‰ /X]=],
   iso=[=[¨/X]=]};
[447]={description=[=[Number of areas intersecting areas in X]=],
   arguments=[[Xâ†D3 (n Ã— 2 Ã— dim)]],
   utf=[=[+/A^â‰Aâ†^/X[;Aâ´1;]â‰¤2 1 3â‰X[;(Aâ†1â†‘â´X)â´2;]]=],
   iso=[=[+/A^ôAû^/X[;AÒ1;]¤2 1 3ôX[;(Aû1ÙÒX)Ò2;]]=]};
[448]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[^/X/1âŒ½X]=],
   iso=[=[^/X/1÷X]=]};
[449]={description=[=[Comparison of successive rows]=],
   arguments=[[Xâ†A2]],
   utf=[=[^/X=1âŠ–X]=],
   iso=[=[^/X=1áX]=]};
[450]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†A1]],
   utf=[=[^/X=1âŒ½X]=],
   iso=[=[^/X=1÷X]=]};
[451]={description=[=[Test if X is a valid APL name]=],
   arguments=[[Xâ†C1]],
   utf=[=[^/((1â†‘X)âˆŠ10â†“A),XâˆŠAâ†'0..9A..Za..z']=],
   iso=[=[^/((1ÙX)Å10ÕA),XÅAû'0..9A..Za..z']=]};
[452]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†A1]],
   utf=[=[^/X=1â†‘X]=],
   iso=[=[^/X=1ÙX]=]};
[453]={description=[=[Identity of two sets]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[^/(XâˆŠY),YâˆŠX]=],
   iso=[=[^/(XÅY),YÅX]=]};
[454]={description=[=[Test if X is a permutation vector]=],
   arguments=[[Xâ†I1]],
   utf=[=[^/(â³â´X)âˆŠX]=],
   iso=[=[^/(ÉÒX)ÅX]=]};
[455]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[~^/XâˆŠ~X]=],
   iso=[=[~^/XÅ~X]=]};
[456]={description=[=[Test if X is boolean]=],
   arguments=[[Xâ†A]],
   utf=[=[^/,XâˆŠ0 1]=],
   iso=[=[^/,XÅ0 1]=]};
[457]={description=[=[Test if Y is a subset of X (Y âŠ‚ X)]=],
   arguments=[[Xâ†A; Yâ†A1]],
   utf=[=[^/YâˆŠX]=],
   iso=[=[^/YÅX]=]};
[458]={description=[=[Test if arrays of equal shape are identical]=],
   arguments=[[Xâ†A; Yâ†A; â´X â†â†’ â´Y]],
   utf=[=[^/,X=Y]=],
   iso=[=[^/,X=Y]=]};
[459]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†A1]],
   utf=[=[^/X=X[1]]=],
   iso=[=[^/X=X[1]]=]};
[460]={description=[=[Blank rows]=],
   arguments=[[Xâ†C2]],
   utf=[=[^/' '=X]=],
   iso=[=[^/' '=X]=]};
[461]={description=[=[All, both]=],
   arguments=[[Xâ†B]],
   utf=[=[^/X]=],
   iso=[=[^/X]=]};
[462]={description=[=[Standard deviation of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[((+/(X-(+/X)Ã·â´X)*2)Ã·â´X)*.5]=],
   iso=[=[((+/(X-(+/X)ßÒX)*2)ßÒX)*.5]=]};
[463]={description=[=[Y:th moment of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[(+/(X-(+/X)Ã·â´X)*Y)Ã·â´X]=],
   iso=[=[(+/(X-(+/X)ßÒX)*Y)ßÒX]=]};
[464]={description=[=[Variance (dispersion) of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[(+/(X-(+/X)Ã·â´X)*2)Ã·â´X]=],
   iso=[=[(+/(X-(+/X)ßÒX)*2)ßÒX]=]};
[465]={description=[=[Arithmetic average (mean value), also for an empty array]=],
   arguments=[[Xâ†D]],
   utf=[=[(+/,X)Ã·1âŒˆâ´,X]=],
   iso=[=[(+/,X)ß1ÓÒ,X]=]};
[466]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[Xâ†B1]],
   utf=[=[0=(â´X)|+/X]=],
   iso=[=[0=(ÒX)|+/X]=]};
[467]={description=[=[Average (mean value) of columns of matrix X]=],
   arguments=[[Xâ†D2]],
   utf=[=[(+âŒ¿X)Ã·1â†‘(â´X),1]=],
   iso=[=[(+¯X)ß1Ù(ÒX),1]=]};
[468]={description=[=[Average (mean value) of rows of matrix X]=],
   arguments=[[Xâ†D2]],
   utf=[=[(+/X)Ã·Â¯1â†‘1,â´X]=],
   iso=[=[(+/X)ß¢1Ù1,ÒX]=]};
[469]={description=[=[Number of occurrences of scalar X in array Y]=],
   arguments=[[Xâ†A0; Yâ†A]],
   utf=[=[+/X=,Y]=],
   iso=[=[+/X=,Y]=]};
[470]={description=[=[Average (mean value) of elements of X along direction Y]=],
   arguments=[[Xâ†D; Yâ†I0]],
   utf=[=[(+/[Y]X)Ã·(â´X)[Y]]=],
   iso=[=[(+/[Y]X)ß(ÒX)[Y]]=]};
[471]={description=[=[Arithmetic average (mean value)]=],
   arguments=[[Xâ†D1]],
   utf=[=[(+/X)Ã·â´X]=],
   iso=[=[(+/X)ßÒX]=]};
[472]={description=[=[Resistance of parallel resistors]=],
   arguments=[[Xâ†D1]],
   utf=[=[Ã·+/Ã·X]=],
   iso=[=[ß+/ßX]=]};
[473]={description=[=[Sum of elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[474]={description=[=[Row sum of a matrix]=],
   arguments=[[Xâ†D2]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[475]={description=[=[Column sum of a matrix]=],
   arguments=[[Xâ†D2]],
   utf=[=[+âŒ¿X]=],
   iso=[=[+¯X]=]};
[476]={description=[=[Reshaping one-element vector X into a scalar]=],
   arguments=[[Xâ†A1]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[477]={description=[=[Number of elements satisfying condition X]=],
   arguments=[[Xâ†B1]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[478]={description=[=[Scan from end with function âº]=],
   arguments=[[Xâ†A]],
   utf=[=[âŒ½âº\âŒ½X]=],
   iso=[=[÷Á\÷X]=]};
[479]={description=[=[The index of positive integers in Y]=],
   arguments=[[Xâ†I; Yâ†I1]],
   utf=[=[Aâ†9999â´â•IO+â´Y â‹„ A[âŒ½Y]â†âŒ½â³â´Y â‹„ A[X]]=],
   iso=[=[Aû9999ÒÌIO+ÒY ş A[÷Y]û÷ÉÒY ş A[X]]=]};
[480]={description=[=['Transpose' of matrix X with column fields of width Y]=],
   arguments=[[Xâ†A2; Gâ†I0]],
   utf=[=[((âŒ½A)Ã—1,Y)â´2 1 3â‰(1âŒ½Y,Aâ†(â´X)Ã·1,Y)â´X]=],
   iso=[=[((÷A)«1,Y)Ò2 1 3ô(1÷Y,Aû(ÒX)ß1,Y)ÒX]=]};
[482]={description=[=[Adding X to each column of Y]=],
   arguments=[[Xâ†D1; Yâ†D; (â´X)=1â†‘â´Y]],
   utf=[=[Y+â‰(âŒ½â´Y)â´X]=],
   iso=[=[Y+ô(÷ÒY)ÒX]=]};
[483]={description=[=[Matrix with shape of Y and X as its columns]=],
   arguments=[[Xâ†A1; Yâ†A2]],
   utf=[=[â‰(âŒ½â´Y)â´X]=],
   iso=[=[ô(÷ÒY)ÒX]=]};
[484]={description=[=[Derivate of polynomial X]=],
   arguments=[[Xâ†D1]],
   utf=[=[Â¯1â†“XÃ—âŒ½Â¯1+â³â´X]=],
   iso=[=[¢1ÕX«÷¢1+ÉÒX]=]};
[485]={description=[=[Reverse vector X on condition Y]=],
   arguments=[[Xâ†A1; Yâ†B0]],
   utf=[=[,âŒ½[â•IO+Y](1,â´X)â´X]=],
   iso=[=[,÷[ÌIO+Y](1,ÒX)ÒX]=]};
[486]={description=[=[Reshaping vector X into a one-column matrix]=],
   arguments=[[Xâ†A1]],
   utf=[=[(âŒ½1,â´X)â´X]=],
   iso=[=[(÷1,ÒX)ÒX]=]};
[487]={description=[=[Avoiding parentheses with help of reversal]=],
   arguments=[[]],
   utf=[=[(âŒ½1, ...)]=],
   iso=[=[(÷1, ...)]=]};
[488]={description=[=[Vector (cross) product of vectors]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[((1âŒ½X)Ã—Â¯1âŒ½Y)-(Â¯1âŒ½X)Ã—1âŒ½Y]=],
   iso=[=[((1÷X)«¢1÷Y)-(¢1÷X)«1÷Y]=]};
[489]={description=[=[A magic square, side X]=],
   arguments=[[Xâ†I0; 1=2|X]],
   utf=[=[AâŠ–(Aâ†(â³X)-âŒˆXÃ·2)âŒ½(X,X)â´â³XÃ—X]=],
   iso=[=[Aá(Aû(ÉX)-ÓXß2)÷(X,X)ÒÉX«X]=]};
[490]={description=[=[Removing duplicates from an ordered vector]=],
   arguments=[[Xâ†A1]],
   utf=[=[(Â¯1âŒ½1â†“(Xâ‰ Â¯1âŒ½X),1)/X]=],
   iso=[=[(¢1÷1Õ(X¨¢1÷X),1)/X]=]};
[491]={description=[=[An expression giving itself]=],
   arguments=[[]],
   utf=[=[1âŒ½22â´11â´'''1âŒ½22â´11â´''']=],
   iso=[=[1÷22Ò11Ò'''1÷22Ò11Ò''']=]};
[492]={description=[=[Transpose matrix X on condition Y]=],
   arguments=[[Xâ†A2; Yâ†B0]],
   utf=[=[(YâŒ½1 2)â‰X]=],
   iso=[=[(Y÷1 2)ôX]=]};
[493]={description=[=[Any element true (âˆ¨/) on each subvector of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[(X/Y)â‰¥A/1âŒ½Aâ†(Yâˆ¨X)/X]=],
   iso=[=[(X/Y)¦A/1÷Aû(Y©X)/X]=]};
[494]={description=[=[All elements true (^/) on each subvector of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[(X/Y)^A/1âŒ½Aâ†(Yâ‰¤X)/X]=],
   iso=[=[(X/Y)^A/1÷Aû(Y¤X)/X]=]};
[495]={description=[=[Removing leading, multiple and trailing Y's]=],
   arguments=[[Xâ†A1; Yâ†A0]],
   utf=[=[(1â†‘A)â†“(Aâ²1âŒ½Aâ†Y=X)/X]=],
   iso=[=[(1ÙA)Õ(A°1÷AûY=X)/X]=]};
[496]={description=[=[Changing starting indicators X of subvectors to lengths]=],
   arguments=[[Xâ†B1]],
   utf=[=[A-Â¯1â†“0,Aâ†(1âŒ½X)/â³â´X]=],
   iso=[=[A-¢1Õ0,Aû(1÷X)/ÉÒX]=]};
[498]={description=[=[(Cyclic) compression of successive blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(Aâˆ¨1âŒ½Aâ†Xâ‰ ' ')/X]=],
   iso=[=[(A©1÷AûX¨' ')/X]=]};
[499]={description=[=[Aligning columns of matrix X to diagonals]=],
   arguments=[[Xâ†A2]],
   utf=[=[(1-â³Â¯1â†‘â´X)âŒ½X]=],
   iso=[=[(1-É¢1ÙÒX)÷X]=]};
[500]={description=[=[Aligning diagonals of matrix X to columns]=],
   arguments=[[Xâ†A2]],
   utf=[=[(Â¯1+â³Â¯1â†‘â´X)âŒ½X]=],
   iso=[=[(¢1+É¢1ÙÒX)÷X]=]};
[501]={description=[=[Diagonal matrix with elements of X]=],
   arguments=[[Xâ†D1]],
   utf=[=[0 Â¯1â†“(-â³â´X)âŒ½((2â´â´X)â´0),X]=],
   iso=[=[0 ¢1Õ(-ÉÒX)÷((2ÒÒX)Ò0),X]=]};
[502]={description=[=[Test if elements differ from previous ones (non-empty X)]=],
   arguments=[[Xâ†A1]],
   utf=[=[1,1â†“Xâ‰ Â¯1âŒ½X]=],
   iso=[=[1,1ÕX¨¢1÷X]=]};
[503]={description=[=[Test if elements differ from next ones (non-empty X)]=],
   arguments=[[Xâ†A1]],
   utf=[=[(Â¯1â†“Xâ‰ 1âŒ½X),1]=],
   iso=[=[(¢1ÕX¨1÷X),1]=]};
[504]={description=[=[Replacing first element of X with Y]=],
   arguments=[[Xâ†A1; Yâ†A0]],
   utf=[=[Â¯1âŒ½1â†“X,Y]=],
   iso=[=[¢1÷1ÕX,Y]=]};
[505]={description=[=[Replacing last element of X with Y]=],
   arguments=[[Xâ†A1; Yâ†A0]],
   utf=[=[1âŒ½Â¯1â†“Y,X]=],
   iso=[=[1÷¢1ÕY,X]=]};
[506]={description=[=[Ending points for X in indices pointed by Y]=],
   arguments=[[Xâ†A1; Yâ†I1]],
   utf=[=[1âŒ½(â³â´X)âˆŠY]=],
   iso=[=[1÷(ÉÒX)ÅY]=]};
[507]={description=[=[Leftmost neighboring elements cyclically]=],
   arguments=[[Xâ†A]],
   utf=[=[Â¯1âŒ½X]=],
   iso=[=[¢1÷X]=]};
[508]={description=[=[Rightmost neighboring elements cyclically]=],
   arguments=[[Xâ†A]],
   utf=[=[1âŒ½X]=],
   iso=[=[1÷X]=]};
[509]={description=[=[Applying to columns action defined on rows]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[â‰ ... â‰X]=],
   iso=[=[ô ... ôX]=]};
[510]={description=[=[Retrieving scattered elements Y from matrix X]=],
   arguments=[[Xâ†A2; Yâ†I2]],
   utf=[=[1 1â‰X[Y[1;];Y[2;]]]=],
   iso=[=[1 1ôX[Y[1;];Y[2;]]]=]};
[511]={description=[=[Successive transposes of G (X after Y: Xâ‰Yâ‰G)]=],
   arguments=[[Xâ†I1; Yâ†I1]],
   utf=[=[X[Y]â‰G]=],
   iso=[=[X[Y]ôG]=]};
[512]={description=[=[Major diagonal of array X]=],
   arguments=[[Xâ†A]],
   utf=[=[(1*â´X)â‰X]=],
   iso=[=[(1*ÒX)ôX]=]};
[513]={description=[=[Reshaping a 400Ã—12 character matrix to fit into one page]=],
   arguments=[[Xâ†C2]],
   utf=[=[40 120â´2 1 3â‰10 40 12â´X]=],
   iso=[=[40 120Ò2 1 3ô10 40 12ÒX]=]};
[514]={description=[=[Transpose of planes of a rank three array]=],
   arguments=[[Xâ†A3]],
   utf=[=[1 3 2â‰X]=],
   iso=[=[1 3 2ôX]=]};
[515]={description=[=[Major diagonal of matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[1 1â‰X]=],
   iso=[=[1 1ôX]=]};
[516]={description=[=[Selecting specific elements from a 'large' outer product]=],
   arguments=[[Xâ†A; Yâ†A; Gâ†I1]],
   utf=[=[Gâ‰Xâˆ˜.âºY]=],
   iso=[=[GôXÊ.ÁY]=]};
[517]={description=[=[Test for antisymmetricity of square matrix X]=],
   arguments=[[Xâ†D2]],
   utf=[=[~0âˆŠX=-â‰X]=],
   iso=[=[~0ÅX=-ôX]=]};
[518]={description=[=[Test for symmetricity of square matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[~0âˆŠX=â‰X]=],
   iso=[=[~0ÅX=ôX]=]};
[519]={description=[=[Matrix with X columns Y]=],
   arguments=[[Xâ†I0; Yâ†D1]],
   utf=[=[â‰(X,â´Y)â´Y]=],
   iso=[=[ô(X,ÒY)ÒY]=]};
[520]={description=[=[Limiting X between Y[1] and Y[2], inclusive]=],
   arguments=[[Xâ†D; Yâ†D1]],
   utf=[=[Y[1]âŒˆY[2]âŒŠX]=],
   iso=[=[Y[1]ÓY[2]ÄX]=]};
[521]={description=[=[Inserting vector Y to the end of matrix X]=],
   arguments=[[Xâ†A2; Yâ†A1]],
   utf=[=[(Aâ†‘X),[â³1](1â†“Aâ†(â´X)âŒˆ0,â´Y)â†‘Y]=],
   iso=[=[(AÙX),[É1](1ÕAû(ÒX)Ó0,ÒY)ÙY]=]};
[522]={description=[=[Widening matrix X to be compatible with Y]=],
   arguments=[[Xâ†A2; Yâ†A2]],
   utf=[=[((0 1Ã—â´Y)âŒˆâ´X)â†‘X]=],
   iso=[=[((0 1«ÒY)ÓÒX)ÙX]=]};
[523]={description=[=[Lengthening matrix X to be compatible with Y]=],
   arguments=[[Xâ†A2; Yâ†A2]],
   utf=[=[((1 0Ã—â´Y)âŒˆâ´X)â†‘X]=],
   iso=[=[((1 0«ÒY)ÓÒX)ÙX]=]};
[524]={description=[=[Reshaping non-empty lower-rank array X into a matrix]=],
   arguments=[[Xâ†A; 2â‰¥â´â´X]],
   utf=[=[(1âŒˆÂ¯2â†‘â´X)â´X]=],
   iso=[=[(1Ó¢2ÙÒX)ÒX]=]};
[525]={description=[=[Take of at most X elements from Y]=],
   arguments=[[Xâ†I; Yâ†A]],
   utf=[=[(XâŒŠâ´Y)â†‘Y]=],
   iso=[=[(XÄÒY)ÙY]=]};
[526]={description=[=[Limiting indices and giving a default value G]=],
   arguments=[[Xâ†A1; Yâ†I; Gâ†A0]],
   utf=[=[(X,G)[(1+â´X)âŒŠY]]=],
   iso=[=[(X,G)[(1+ÒX)ÄY]]=]};
[527]={description=[=[Reshaping X into a matrix of width Y]=],
   arguments=[[Xâ†D, Yâ†I0]],
   utf=[=[((âŒˆ(â´,X)Ã·Y),Y)â´X]=],
   iso=[=[((Ó(Ò,X)ßY),Y)ÒX]=]};
[528]={description=[=[Rounding to nearest even integer]=],
   arguments=[[Xâ†D]],
   utf=[=[âŒŠX+1â‰¤2|X]=],
   iso=[=[ÄX+1¤2|X]=]};
[529]={description=[=[Rounding, to nearest even integer for .5 = 1||X]=],
   arguments=[[Xâ†D]],
   utf=[=[âŒŠX+.5Ã—.5â‰ 2|X]=],
   iso=[=[ÄX+.5«.5¨2|X]=]};
[530]={description=[=[Rounding, to nearest even integer for .5 = 1||X]=],
   arguments=[[Xâ†D]],
   utf=[=[âŒŠX+.5Ã—.5â‰ 2|X]=],
   iso=[=[ÄX+.5«.5¨2|X]=]};
[531]={description=[=[Arithmetic progression from X to Y with step G]=],
   arguments=[[Xâ†D0; Yâ†D0; Gâ†D0]],
   utf=[=[X+(GÃ—Ã—Y-X)Ã—(â³1+|âŒŠ(Y-X)Ã·G)-â•IO]=],
   iso=[=[X+(G««Y-X)«(É1+|Ä(Y-X)ßG)-ÌIO]=]};
[532]={description=[=[Centering text line X into a field of width Y]=],
   arguments=[[Xâ†C1; Yâ†I0]],
   utf=[=[(-âŒŠ.5Ã—Y+â´X)â†‘X]=],
   iso=[=[(-Ä.5«Y+ÒX)ÙX]=]};
[533]={description=[=[Test if integer]=],
   arguments=[[Xâ†D]],
   utf=[=[X=âŒŠX]=],
   iso=[=[X=ÄX]=]};
[534]={description=[=[Rounding currencies to nearest 5 subunits]=],
   arguments=[[Xâ†D]],
   utf=[=[.05Ã—âŒŠ.5+XÃ·.05]=],
   iso=[=[.05«Ä.5+Xß.05]=]};
[535]={description=[=[First part of numeric code ABBB]=],
   arguments=[[Xâ†I]],
   utf=[=[âŒŠXÃ·1000]=],
   iso=[=[ÄXß1000]=]};
[536]={description=[=[Rounding to X decimals]=],
   arguments=[[Xâ†I; Yâ†D]],
   utf=[=[(10*-X)Ã—âŒŠ0.5+YÃ—10*X]=],
   iso=[=[(10*-X)«Ä0.5+Y«10*X]=]};
[537]={description=[=[Rounding to nearest hundredth]=],
   arguments=[[]],
   utf=[=[Xâ†D]=],
   iso=[=[XûD]=]};
[0]={description=[=[nil]=],
   arguments=[[]],
   utf=[=[nil]=],
   iso=[=[nil]=]};
[538]={description=[=[Rounding to nearest integer]=],
   arguments=[[Xâ†D]],
   utf=[=[âŒŠ0.5+X]=],
   iso=[=[Ä0.5+X]=]};
[539]={description=[=[Demote floating point representations to integers]=],
   arguments=[[Xâ†I]],
   utf=[=[âŒŠX]=],
   iso=[=[ÄX]=]};
[540]={description=[=[Test if X is a leap year]=],
   arguments=[[Xâ†I]],
   utf=[=[(0=400|X)âˆ¨(0â‰ 100|X)^0=4|X]=],
   iso=[=[(0=400|X)©(0¨100|X)^0=4|X]=]};
[541]={description=[=[Framing]=],
   arguments=[[Xâ†C2]],
   utf=[=['_',[1]('|',X,'|'),[1]'Â¯']=],
   iso=[=['_',[1]('|',X,'|'),[1]'¢']=]};
[542]={description=[=[Magnitude of fractional part]=],
   arguments=[[Xâ†D]],
   utf=[=[1||X]=],
   iso=[=[1||X]=]};
[543]={description=[=[Fractional part with sign]=],
   arguments=[[Xâ†D]],
   utf=[=[(Ã—X)|X]=],
   iso=[=[(«X)|X]=]};
[544]={description=[=[Increasing the dimension of X to multiple of Y]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[X,(Y|-â´X)â†‘0/X]=],
   iso=[=[X,(Y|-ÒX)Ù0/X]=]};
[545]={description=[=[Removing every Y:th element of X]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[(0â‰ Y|â³â´X)/X]=],
   iso=[=[(0¨Y|ÉÒX)/X]=]};
[546]={description=[=[Taking every Y:th element of X]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[(0=Y|â³â´X)/X]=],
   iso=[=[(0=Y|ÉÒX)/X]=]};
[547]={description=[=[Divisors of X]=],
   arguments=[[Xâ†I0]],
   utf=[=[(0=A|X)/Aâ†â³X]=],
   iso=[=[(0=A|X)/AûÉX]=]};
[548]={description=[=[Removing every second element of X]=],
   arguments=[[Xâ†A1]],
   utf=[=[(2|â³â´X)/X]=],
   iso=[=[(2|ÉÒX)/X]=]};
[549]={description=[=[Elements of X divisible by Y]=],
   arguments=[[Xâ†D1; Yâ†D0/1]],
   utf=[=[(0=Y|X)/X]=],
   iso=[=[(0=Y|X)/X]=]};
[550]={description=[=[Ravel of a matrix to Y[1] columns with a gap of Y[2]]=],
   arguments=[[Xâ†A2; Yâ†I1]],
   utf=[=[(AÃ—Y[1]*Â¯1 1)â´(Aâ†(â´X)+(Y[1]|-1â†‘â´X),Y[2])â†‘X]=],
   iso=[=[(A«Y[1]*¢1 1)Ò(Aû(ÒX)+(Y[1]|-1ÙÒX),Y[2])ÙX]=]};
[551]={description=[=[Test if even]=],
   arguments=[[Xâ†I]],
   utf=[=[~2|X]=],
   iso=[=[~2|X]=]};
[552]={description=[=[Last part of numeric code ABBB]=],
   arguments=[[Xâ†I]],
   utf=[=[1000|X]=],
   iso=[=[1000|X]=]};
[553]={description=[=[Fractional part]=],
   arguments=[[Xâ†D]],
   utf=[=[1|X]=],
   iso=[=[1|X]=]};
[554]={description=[=[Increasing absolute value without change of sign]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[(Ã—X)Ã—Y+|X]=],
   iso=[=[(«X)«Y+|X]=]};
[555]={description=[=[Rounding to zero values of X close to zero]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[XÃ—Yâ‰¤|X]=],
   iso=[=[X«Y¤|X]=]};
[556]={description=[=[Square of elements of X without change of sign]=],
   arguments=[[Xâ†D]],
   utf=[=[XÃ—|X]=],
   iso=[=[X«|X]=]};
[557]={description=[=[Choosing according to signum]=],
   arguments=[[Xâ†D; Yâ†A1]],
   utf=[=[Y[2+Ã—X]]=],
   iso=[=[Y[2+«X]]=]};
[558]={description=[=[Not first zero (â‰¤\) in each subvector of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[~(B^X)âˆ¨(Bâˆ¨X)\A>Â¯1â†“0,Aâ†(Bâˆ¨X)/Bâ†~Y]=],
   iso=[=[~(B^X)©(B©X)\A>¢1Õ0,Aû(B©X)/Bû~Y]=]};
[559]={description=[=[First one (<\) in each subvector of Y indicated by X]=],
   arguments=[[Xâ†B1; Yâ†B1]],
   utf=[=[(Y^X)âˆ¨(Yâˆ¨X)\A>Â¯1â†“0,Aâ†(Yâˆ¨X)/Y]=],
   iso=[=[(Y^X)©(Y©X)\A>¢1Õ0,Aû(Y©X)/Y]=]};
[560]={description=[=[Replacing elements of X in set Y with blanks/zeroes]=],
   arguments=[[Xâ†A0; Yâ†A1]],
   utf=[=[A\(Aâ†~XâˆŠY)/X]=],
   iso=[=[A\(Aû~XÅY)/X]=]};
[561]={description=[=[Replacing elements of X not in set Y with blanks/zeroes]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[A\(Aâ†XâˆŠY)/X]=],
   iso=[=[A\(AûXÅY)/X]=]};
[562]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[Xâ†A1; Yâ†A1; Gâ†B1]],
   utf=[=[Aâ†G\X â‹„ A[(~G)/â³â´G]â†Y â‹„ A]=],
   iso=[=[AûG\X ş A[(~G)/ÉÒG]ûY ş A]=]};
[563]={description=[=[Replacing elements of X not satisfying Y with blanks/zeroes]=],
   arguments=[[Xâ†A; Yâ†B1]],
   utf=[=[Y\Y/X]=],
   iso=[=[Y\Y/X]=]};
[564]={description=[=[Adding an empty row into X after rows Y]=],
   arguments=[[Xâ†A2; Yâ†I1]],
   utf=[=[(~(â³(â´Y)+1â´â´X)âˆŠY+â³â´Y)â€X]=],
   iso=[=[(~(É(ÒY)+1ÒÒX)ÅY+ÉÒY)ÜX]=]};
[565]={description=[=[Test if numeric]=],
   arguments=[[Xâ†A1]],
   utf=[=[0âˆŠ0\0â´X]=],
   iso=[=[0Å0\0ÒX]=]};
[566]={description=[=[Adding an empty row into X after row Y]=],
   arguments=[[Xâ†A2; Yâ†I0]],
   utf=[=[((Y+1)â‰ â³1+1â´â´X)â€X]=],
   iso=[=[((Y+1)¨É1+1ÒÒX)ÜX]=]};
[567]={description=[=[Underlining words]=],
   arguments=[[Xâ†C1]],
   utf=[=[X,[â•IO-.1](' 'â‰ X)\'Â¯']=],
   iso=[=[X,[ÌIO-.1](' '¨X)\'¢']=]};
[568]={description=[=[Using boolean matrix Y in expanding X]=],
   arguments=[[Xâ†A1; Yâ†B2]],
   utf=[=[(â´Y)â´(,Y)\X]=],
   iso=[=[(ÒY)Ò(,Y)\X]=]};
[569]={description=[=[Spacing out text]=],
   arguments=[[Xâ†C1]],
   utf=[=[((2Ã—â´X)â´1 0)\X]=],
   iso=[=[((2«ÒX)Ò1 0)\X]=]};
[570]={description=[=[Lengths of groups of ones in X]=],
   arguments=[[Xâ†B1]],
   utf=[=[(A>0)/Aâ†(1â†“A)-1+Â¯1â†“Aâ†(~A)/â³â´Aâ†0,X,0]=],
   iso=[=[(A>0)/Aû(1ÕA)-1+¢1ÕAû(~A)/ÉÒAû0,X,0]=]};
[571]={description=[=[Syllabization of a Finnish word X]=],
   arguments=[[Xâ†A1]],
   utf=[=[(~AâˆŠ1,â´X)/Aâ†A/â³â´Aâ†(1â†“A,0)â†~XâˆŠ'aeiouyÃ„Ã–']=],
   iso=[=[(~AÅ1,ÒX)/AûA/ÉÒAû(1ÕA,0)û~XÅ'aeiouyÃ„Ã–']=]};
[572]={description=[=[Choosing a string according to boolean value G]=],
   arguments=[[Xâ†C1; Yâ†C1; Gâ†B0]],
   utf=[=[(G/X),(~G)/Y]=],
   iso=[=[(G/X),(~G)/Y]=]};
[573]={description=[=[Removing leading, multiple and trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(' '=1â†‘X)â†“((1â†“A,0)âˆ¨Aâ†' 'â‰ X)/X]=],
   iso=[=[(' '=1ÙX)Õ((1ÕA,0)©Aû' '¨X)/X]=]};
[575]={description=[=[Removing columns Y from array X]=],
   arguments=[[Xâ†A; Yâ†I1]],
   utf=[=[(~(â³Â¯1â†‘â´X)âˆŠY)/X]=],
   iso=[=[(~(É¢1ÙÒX)ÅY)/X]=]};
[576]={description=[=[Removing trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(Â¯1â†‘(' 'â‰ X)/â³â´X)â´X]=],
   iso=[=[(¢1Ù(' '¨X)/ÉÒX)ÒX]=]};
[577]={description=[=[Lengths of subvectors of X having equal elements]=],
   arguments=[[Xâ†A1]],
   utf=[=[(1â†“A)-Â¯1â†“Aâ†(A,1)/â³1+â´Aâ†1,(1â†“X)â‰ Â¯1â†“X]=],
   iso=[=[(1ÕA)-¢1ÕAû(A,1)/É1+ÒAû1,(1ÕX)¨¢1ÕX]=]};
[578]={description=[=[Field lengths of vector X; G â†â†’ ending indices]=],
   arguments=[[Xâ†A1; Gâ†I1]],
   utf=[=[G-Â¯1â†“0,Gâ†(~â•IO)+(((1â†“X)â‰ Â¯1â†“X),1)/â³â´X]=],
   iso=[=[G-¢1Õ0,Gû(~ÌIO)+(((1ÕX)¨¢1ÕX),1)/ÉÒX]=]};
[580]={description=[=[Removing multiple and trailing blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[((1â†“A,0)âˆ¨Aâ†' 'â‰ X)/X]=],
   iso=[=[((1ÕA,0)©Aû' '¨X)/X]=]};
[581]={description=[=[Removing leading and multiple blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(Aâˆ¨Â¯1â†“0,Aâ†' 'â‰ X)/X]=],
   iso=[=[(A©¢1Õ0,Aû' '¨X)/X]=]};
[582]={description=[=[Removing multiple blanks]=],
   arguments=[[Xâ†C1]],
   utf=[=[(Aâˆ¨Â¯1â†“1,Aâ†' 'â‰ X)/X]=],
   iso=[=[(A©¢1Õ1,Aû' '¨X)/X]=]};
[583]={description=[=[Removing duplicate Y's from vector X]=],
   arguments=[[Xâ†A1; Yâ†A0]],
   utf=[=[(Aâˆ¨Â¯1â†“1,Aâ†Xâ‰ Y)/X]=],
   iso=[=[(A©¢1Õ1,AûX¨Y)/X]=]};
[584]={description=[=[Indices of all occurrences of elements of Y in X]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(XâˆŠY)/â³â´X]=],
   iso=[=[(XÅY)/ÉÒX]=]};
[585]={description=[=[Union of sets, ?]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[Y,(~XâˆŠY)/X]=],
   iso=[=[Y,(~XÅY)/X]=]};
[586]={description=[=[Elements of X not in Y (difference of sets)]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(~XâˆŠY)/X]=],
   iso=[=[(~XÅY)/X]=]};
[587]={description=[=[Rows of non-empty matrix X starting with a character in Y]=],
   arguments=[[Xâ†A2; Yâ†A1]],
   utf=[=[(X[;1]âˆŠY)âŒ¿X]=],
   iso=[=[(X[;1]ÅY)¯X]=]};
[588]={description=[=[Intersection of sets, â]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(XâˆŠY)/X]=],
   iso=[=[(XÅY)/X]=]};
[589]={description=[=[Reduction with function âº in dimension Y, rank unchanged]=],
   arguments=[[Yâ†I0; Xâ†A]],
   utf=[=[((â´X)*Yâ‰ â³â´â´X)â´ âº/[Y]X]=],
   iso=[=[((ÒX)*Y¨ÉÒÒX)Ò Á/[Y]X]=]};
[590]={description=[=[Replacing all values X in G with Y]=],
   arguments=[[Xâ†A0; Yâ†A0; Gâ†A]],
   utf=[=[A[(A=X)/â³â´Aâ†,G]â†Y â‹„ (â´G)â´A]=],
   iso=[=[A[(A=X)/ÉÒAû,G]ûY ş (ÒG)ÒA]=]};
[591]={description=[=[Indices of all occurrences of Y in X]=],
   arguments=[[Xâ†A1; Yâ†A0]],
   utf=[=[(Y=X)/â³â´X]=],
   iso=[=[(Y=X)/ÉÒX]=]};
[592]={description=[=[Replacing elements of G satisfying X with Y]=],
   arguments=[[Yâ†A0; Xâ†B1; Gâ†A1]],
   utf=[=[G[X/â³â´G]â†Y]=],
   iso=[=[G[X/ÉÒG]ûY]=]};
[593]={description=[=[Removing duplicates from positive integers]=],
   arguments=[[Xâ†I1]],
   utf=[=[Aâ†9999â´0 â‹„ A[X]â†1 â‹„ A/â³9999]=],
   iso=[=[Aû9999Ò0 ş A[X]û1 ş A/É9999]=]};
[594]={description=[=[Indices of ones in logical vector X]=],
   arguments=[[Xâ†B1]],
   utf=[=[X/â³â´X]=],
   iso=[=[X/ÉÒX]=]};
[595]={description=[=[Conditional in text]=],
   arguments=[[Xâ†B0]],
   utf=[=[((~X)/'IN'),'CORRECT']=],
   iso=[=[((~X)/'IN'),'CORRECT']=]};
[596]={description=[=[Removing blanks]=],
   arguments=[[Xâ†A1]],
   utf=[=[(' 'â‰ X)/X]=],
   iso=[=[(' '¨X)/X]=]};
[597]={description=[=[Removing elements Y from vector X]=],
   arguments=[[Xâ†A1; Yâ†A0]],
   utf=[=[(Xâ‰ Y)/X]=],
   iso=[=[(X¨Y)/X]=]};
[598]={description=[=[Vector to expand a new element after each one in X]=],
   arguments=[[Xâ†B1]],
   utf=[=[(,X,[1.5]1)/,X,[1.5]~X]=],
   iso=[=[(,X,[1.5]1)/,X,[1.5]~X]=]};
[599]={description=[=[Reduction with FUNCTION âº without respect to shape]=],
   arguments=[[Xâ†D]],
   utf=[=[âº/,X]=],
   iso=[=[Á/,X]=]};
[600]={description=[=[Reshaping scalar X into a one-element vector]=],
   arguments=[[Xâ†A]],
   utf=[=[1/X]=],
   iso=[=[1/X]=]};
[601]={description=[=[Empty matrix]=],
   arguments=[[Xâ†A2]],
   utf=[=[0âŒ¿X]=],
   iso=[=[0¯X]=]};
[602]={description=[=[Selecting elements of X satisfying condition Y]=],
   arguments=[[Xâ†A; Yâ†B1]],
   utf=[=[Y/X]=],
   iso=[=[Y/X]=]};
[603]={description=[=[Inserting vector X into matrix Y after row G]=],
   arguments=[[Xâ†A1; Yâ†A2; Gâ†I0]],
   utf=[=[Y[â³G;],[1]((1â†“â´Y)â†‘X),[1](2â†‘G)â†“Y]=],
   iso=[=[Y[ÉG;],[1]((1ÕÒY)ÙX),[1](2ÙG)ÕY]=]};
[604]={description=[=[Filling X with last element of X to length Y]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[Yâ†‘X,Yâ´Â¯1â†‘X]=],
   iso=[=[YÙX,YÒ¢1ÙX]=]};
[605]={description=[=[Input of row Y of text matrix X]=],
   arguments=[[Xâ†C2; Yâ†I0]],
   utf=[=[X[Y;]â†(1â†‘â´X)â†‘â]=],
   iso=[=[X[Y;]û(1ÙÒX)Ùì]=]};
[606]={description=[=[First ones in groups of ones]=],
   arguments=[[Xâ†B]],
   utf=[=[X>((-â´â´X)â†‘Â¯1)â†“0,X]=],
   iso=[=[X>((-ÒÒX)Ù¢1)Õ0,X]=]};
[607]={description=[=[Inserting X into Y after index G]=],
   arguments=[[Xâ†A1; Yâ†A1; Gâ†I0]],
   utf=[=[(Gâ†‘Y),X,Gâ†“Y]=],
   iso=[=[(GÙY),X,GÕY]=]};
[608]={description=[=[Pairwise differences of successive columns (inverse of +\)]=],
   arguments=[[Xâ†D]],
   utf=[=[X-((-â´â´X)â†‘Â¯1)â†“0,X]=],
   iso=[=[X-((-ÒÒX)Ù¢1)Õ0,X]=]};
[609]={description=[=[Leftmost neighboring elements]=],
   arguments=[[Xâ†D]],
   utf=[=[((-â´â´X)â†‘Â¯1)â†“0,X]=],
   iso=[=[((-ÒÒX)Ù¢1)Õ0,X]=]};
[610]={description=[=[Rightmost neighboring elements]=],
   arguments=[[Xâ†D]],
   utf=[=[((-â´â´X)â†‘1)â†“X,0]=],
   iso=[=[((-ÒÒX)Ù1)ÕX,0]=]};
[611]={description=[=[Shifting vector X right with Y without rotate]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[(-â´X)â†‘(-Y)â†“X]=],
   iso=[=[(-ÒX)Ù(-Y)ÕX]=]};
[612]={description=[=[Shifting vector X left with Y without rotate]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[(â´X)â†‘Yâ†“X]=],
   iso=[=[(ÒX)ÙYÕX]=]};
[613]={description=[=[Drop of Y first rows from matrix X]=],
   arguments=[[Xâ†A2; Yâ†I0]],
   utf=[=[(2â†‘Y)â†“X]=],
   iso=[=[(2ÙY)ÕX]=]};
[614]={description=[=[Test if numeric]=],
   arguments=[[Xâ†A]],
   utf=[=[0âˆŠ1â†‘0â´X]=],
   iso=[=[0Å1Ù0ÒX]=]};
[615]={description=[=[Reshaping non-empty lower-rank array X into a matrix]=],
   arguments=[[Xâ†A; 2â‰¥â´â´X]],
   utf=[=[(Â¯2â†‘1 1,â´X)â´X]=],
   iso=[=[(¢2Ù1 1,ÒX)ÒX]=]};
[616]={description=[=[Giving a character default value for input]=],
   arguments=[[Xâ†C0]],
   utf=[=[1â†‘â,X]=],
   iso=[=[1Ùì,X]=]};
[617]={description=[=[Adding scalar Y to last element of X]=],
   arguments=[[Xâ†D; Yâ†D0]],
   utf=[=[X+(-â´X)â†‘Y]=],
   iso=[=[X+(-ÒX)ÙY]=]};
[618]={description=[=[Number of rows in matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[1â†‘â´X]=],
   iso=[=[1ÙÒX]=]};
[619]={description=[=[Number of columns in matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[Â¯1â†‘â´X]=],
   iso=[=[¢1ÙÒX]=]};
[620]={description=[=[Ending points for X fields of width Y]=],
   arguments=[[Xâ†I0; Yâ†I0]],
   utf=[=[(XÃ—Y)â´(-Y)â†‘1]=],
   iso=[=[(X«Y)Ò(-Y)Ù1]=]};
[621]={description=[=[Starting points for X fields of width Y]=],
   arguments=[[Xâ†I0; Yâ†I0]],
   utf=[=[(XÃ—Y)â´Yâ†‘1]=],
   iso=[=[(X«Y)ÒYÙ1]=]};
[622]={description=[=[Zero or space depending on the type of X (fill element)]=],
   arguments=[[Xâ†A]],
   utf=[=[1â†‘0â´X]=],
   iso=[=[1Ù0ÒX]=]};
[623]={description=[=[Forming first row of a matrix to be expanded]=],
   arguments=[[Xâ†A1]],
   utf=[=[1 80â´80â†‘X]=],
   iso=[=[1 80Ò80ÙX]=]};
[624]={description=[=[Vector of length Y with X ones on the left, the rest zeroes]=],
   arguments=[[Xâ†I0; Yâ†I0]],
   utf=[=[Yâ†‘Xâ´1]=],
   iso=[=[YÙXÒ1]=]};
[625]={description=[=[Justifying text X to right edge of field of width Y]=],
   arguments=[[Yâ†I0; Xâ†C1]],
   utf=[=[(-Y)â†‘X]=],
   iso=[=[(-Y)ÙX]=]};
[627]={description=[=[Starting points of groups of equal elements (non-empty X)]=],
   arguments=[[Xâ†A1]],
   utf=[=[1,(1â†“X)â‰ Â¯1â†“X]=],
   iso=[=[1,(1ÕX)¨¢1ÕX]=]};
[628]={description=[=[Ending points of groups of equal elements (non-empty X)]=],
   arguments=[[Xâ†A1]],
   utf=[=[((1â†“X)â‰ Â¯1â†“X),1]=],
   iso=[=[((1ÕX)¨¢1ÕX),1]=]};
[629]={description=[=[Pairwise ratios of successive elements of vector X]=],
   arguments=[[Xâ†D1]],
   utf=[=[(1â†“X)Ã·Â¯1â†“X]=],
   iso=[=[(1ÕX)ß¢1ÕX]=]};
[630]={description=[=[Pairwise differences of successive elements of vector X]=],
   arguments=[[Xâ†D1]],
   utf=[=[(1â†“X)-Â¯1â†“X]=],
   iso=[=[(1ÕX)-¢1ÕX]=]};
[631]={description=[=[Differences of successive elements of X along direction Y]=],
   arguments=[[Xâ†D; Yâ†I0]],
   utf=[=[X-(-Y=â³â´â´X)â†“0,[Y]X]=],
   iso=[=[X-(-Y=ÉÒÒX)Õ0,[Y]X]=]};
[632]={description=[=[Ascending series of integers Y..X (for small Y and X)]=],
   arguments=[[Xâ†I0; Yâ†I0]],
   utf=[=[(Y-1)â†“â³X]=],
   iso=[=[(Y-1)ÕÉX]=]};
[633]={description=[=[First ones in groups of ones]=],
   arguments=[[Xâ†B1]],
   utf=[=[X>Â¯1â†“0,X]=],
   iso=[=[X>¢1Õ0,X]=]};
[634]={description=[=[Last ones in groups of ones]=],
   arguments=[[Xâ†B1]],
   utf=[=[X>1â†“X,0]=],
   iso=[=[X>1ÕX,0]=]};
[635]={description=[=[List of names in X (one per row)]=],
   arguments=[[Xâ†C2]],
   utf=[=[1â†“,',',X]=],
   iso=[=[1Õ,',',X]=]};
[636]={description=[=[Selection of X or Y depending on condition G]=],
   arguments=[[Xâ†A0; Yâ†A0; Gâ†B0]],
   utf=[=[''â´Gâ†“X,Y]=],
   iso=[=[''ÒGÕX,Y]=]};
[637]={description=[=[Restoring argument of cumulative sum (inverse of +\)]=],
   arguments=[[Xâ†D1]],
   utf=[=[X-Â¯1â†“0,X]=],
   iso=[=[X-¢1Õ0,X]=]};
[638]={description=[=[Drop of Y first rows from matrix X]=],
   arguments=[[Xâ†A2; Yâ†I0]],
   utf=[=[(Y,0)â†“X]=],
   iso=[=[(Y,0)ÕX]=]};
[639]={description=[=[Drop of Y first columns from matrix X]=],
   arguments=[[Xâ†A2; Yâ†I0]],
   utf=[=[(0,Y)â†“X]=],
   iso=[=[(0,Y)ÕX]=]};
[640]={description=[=[Number of rows in matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[Â¯1â†“â´X]=],
   iso=[=[¢1ÕÒX]=]};
[641]={description=[=[Number of columns in matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[1â†“â´X]=],
   iso=[=[1ÕÒX]=]};
[642]={description=[=[Conditional drop of Y elements from array X]=],
   arguments=[[Xâ†A; Yâ†I1; Gâ†B1]],
   utf=[=[(YÃ—G)â†“X]=],
   iso=[=[(Y«G)ÕX]=]};
[643]={description=[=[Conditional drop of last element of X]=],
   arguments=[[Xâ†A1; Yâ†B0]],
   utf=[=[(-Y)â†“X]=],
   iso=[=[(-Y)ÕX]=]};
[644]={description=[=[Expansion vector with zero after indices Y]=],
   arguments=[[Xâ†A1; Yâ†I1]],
   utf=[=[~(â³(â´Y)+â´X)âˆŠY+â³â´Y]=],
   iso=[=[~(É(ÒY)+ÒX)ÅY+ÉÒY]=]};
[645]={description=[=[Boolean vector of length Y with zeroes in locations X]=],
   arguments=[[Xâ†I; Yâ†I0]],
   utf=[=[(~(â³Y)âˆŠX)]=],
   iso=[=[(~(ÉY)ÅX)]=]};
[646]={description=[=[Starting points for X in indices pointed by Y]=],
   arguments=[[Xâ†A1; Yâ†I1]],
   utf=[=[(â³â´X)âˆŠY]=],
   iso=[=[(ÉÒX)ÅY]=]};
[647]={description=[=[Boolean vector of length Y with ones in locations X]=],
   arguments=[[Xâ†I; Yâ†I0]],
   utf=[=[(â³Y)âˆŠX]=],
   iso=[=[(ÉY)ÅX]=]};
[648]={description=[=[Check for input in range 1..X]=],
   arguments=[[Xâ†A]],
   utf=[=[(Yâ†â•)âˆŠâ³X]=],
   iso=[=[(YûÌ)ÅÉX]=]};
[649]={description=[=[Test if arrays are identical]=],
   arguments=[[Xâ†A; Yâ†A]],
   utf=[=[~0âˆŠX=Y]=],
   iso=[=[~0ÅX=Y]=]};
[650]={description=[=[Zeroing elements of Y depending on their values]=],
   arguments=[[Yâ†D; Xâ†D]],
   utf=[=[YÃ—~YâˆŠX]=],
   iso=[=[Y«~YÅX]=]};
[651]={description=[=[Test if single or scalar]=],
   arguments=[[Xâ†A]],
   utf=[=[1âˆŠâ´,X]=],
   iso=[=[1ÅÒ,X]=]};
[652]={description=[=[Test if vector]=],
   arguments=[[Xâ†A]],
   utf=[=[1âˆŠâ´â´X]=],
   iso=[=[1ÅÒÒX]=]};
[653]={description=[=[Test if X is an empty array]=],
   arguments=[[Xâ†A]],
   utf=[=[0âˆŠâ´X]=],
   iso=[=[0ÅÒX]=]};
[654]={description=[=[Inverting a permutation]=],
   arguments=[[Xâ†I1]],
   utf=[=[Aâ†â³â´X â‹„ A[X]â†A â‹„ A]=],
   iso=[=[AûÉÒX ş A[X]ûA ş A]=]};
[655]={description=[=[All axes of array X]=],
   arguments=[[Xâ†A]],
   utf=[=[â³â´â´X]=],
   iso=[=[ÉÒÒX]=]};
[656]={description=[=[All indices of vector X]=],
   arguments=[[Xâ†A1]],
   utf=[=[â³â´X]=],
   iso=[=[ÉÒX]=]};
[657]={description=[=[Arithmetic progression of Y numbers from X with step G]=],
   arguments=[[Xâ†D0; Yâ†D0; Gâ†D0]],
   utf=[=[X+GÃ—(â³Y)-â•IO]=],
   iso=[=[X+G«(ÉY)-ÌIO]=]};
[658]={description=[=[Consecutive integers from X to Y (arithmetic progression)]=],
   arguments=[[Xâ†I0; Yâ†I0]],
   utf=[=[(X-â•IO)+â³1+Y-X]=],
   iso=[=[(X-ÌIO)+É1+Y-X]=]};
[659]={description=[=[Empty numeric vector]=],
   arguments=[[]],
   utf=[=[â³0]=],
   iso=[=[É0]=]};
[660]={description=[=[Index origin (â•IO) as a vector]=],
   arguments=[[]],
   utf=[=[â³1]=],
   iso=[=[É1]=]};
[661]={description=[=[Demote non-boolean representations to booleans]=],
   arguments=[[Xâ†B]],
   utf=[=[0âˆ¨X]=],
   iso=[=[0©X]=]};
[662]={description=[=[Test if X is within range ( Y[1],Y[2] )]=],
   arguments=[[Xâ†D; Yâ†D1]],
   utf=[=[Y[1]<X)^X<Y[2]]=],
   iso=[=[Y[1]<X)^X<Y[2]]=]};
[663]={description=[=[Test if X is within range [ Y[1],Y[2] ]]=],
   arguments=[[Xâ†D; Yâ†D1; 2=â´Y]],
   utf=[=[(Y[1]â‰¤X)^(Xâ‰¤Y[2])]=],
   iso=[=[(Y[1]¤X)^(X¤Y[2])]=]};
[664]={description=[=[Zeroing all boolean values]=],
   arguments=[[Xâ†B]],
   utf=[=[0^X]=],
   iso=[=[0^X]=]};
[666]={description=[=[Selection of elements of X and Y depending on condition G]=],
   arguments=[[Xâ†D; Yâ†D; Gâ†B]],
   utf=[=[(XÃ—G)+YÃ—~G]=],
   iso=[=[(X«G)+Y«~G]=]};
[667]={description=[=[Changing an index origin dependent result to be as â•IO=1]=],
   arguments=[[Xâ†I]],
   utf=[=[(~â•IO)+X]=],
   iso=[=[(~ÌIO)+X]=]};
[668]={description=[=[Conditional change of elements of Y to one according to X]=],
   arguments=[[Yâ†D; Xâ†B]],
   utf=[=[Y*~X]=],
   iso=[=[Y*~X]=]};
[669]={description=[=[X implies Y]=],
   arguments=[[Xâ†B; Yâ†B]],
   utf=[=[Xâ‰¤Y]=],
   iso=[=[X¤Y]=]};
[670]={description=[=[X but not Y]=],
   arguments=[[Xâ†B; Yâ†B]],
   utf=[=[X>Y]=],
   iso=[=[X>Y]=]};
[671]={description=[=[Avoiding division by zero error (gets value zero)]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[(0â‰ X)Ã—YÃ·X+0=X]=],
   iso=[=[(0¨X)«YßX+0=X]=]};
[672]={description=[=[Exclusive or]=],
   arguments=[[Xâ†B; Yâ†B]],
   utf=[=[Xâ‰ Y]=],
   iso=[=[X¨Y]=]};
[673]={description=[=[Replacing zeroes with corresponding elements of Y]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[X+YÃ—X=0]=],
   iso=[=[X+Y«X=0]=]};
[674]={description=[=[Kronecker delta of X and Y (element of identity matrix)]=],
   arguments=[[Xâ†I; Yâ†I]],
   utf=[=[Y=X]=],
   iso=[=[Y=X]=]};
[675]={description=[=[Catenating Y elements G after every element of X]=],
   arguments=[[Xâ†A1; Yâ†I0; Gâ†A]],
   utf=[=[,X,((â´X),Y)â´G]=],
   iso=[=[,X,((ÒX),Y)ÒG]=]};
[676]={description=[=[Catenating Y elements G before every element of X]=],
   arguments=[[Xâ†A1; Yâ†I0; Gâ†A0]],
   utf=[=[,(((â´X),Y)â´G),X]=],
   iso=[=[,(((ÒX),Y)ÒG),X]=]};
[677]={description=[=[Merging vectors X and Y alternately]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[,Y,[â•IO+.5]X]=],
   iso=[=[,Y,[ÌIO+.5]X]=]};
[678]={description=[=[Inserting Y after each element of X]=],
   arguments=[[Xâ†A1; Yâ†A0]],
   utf=[=[,X,[1.1]Y]=],
   iso=[=[,X,[1.1]Y]=]};
[679]={description=[=[Spacing out text]=],
   arguments=[[Xâ†C1]],
   utf=[=[,X,[1.1]' ']=],
   iso=[=[,X,[1.1]' ']=]};
[680]={description=[=[Reshaping X into a matrix of width Y]=],
   arguments=[[Xâ†D, Yâ†I0]],
   utf=[=[(((â´,X),1)Ã—Y*Â¯1 1)â´X]=],
   iso=[=[(((Ò,X),1)«Y*¢1 1)ÒX]=]};
[681]={description=[=[Temporary ravel of X for indexing with G]=],
   arguments=[[Xâ†A; Yâ†A; Gâ†I]],
   utf=[=[Aâ†â´X â‹„ Xâ†,X â‹„ X[G]â†Y â‹„ Xâ†Aâ´X]=],
   iso=[=[AûÒX ş Xû,X ş X[G]ûY ş XûAÒX]=]};
[682]={description=[=[Temporary ravel of X for indexing with G]=],
   arguments=[[Xâ†A; Yâ†A; Gâ†I]],
   utf=[=[Aâ†,X â‹„ A[G]â†Y â‹„ Xâ†(â´X)â´A]=],
   iso=[=[Aû,X ş A[G]ûY ş Xû(ÒX)ÒA]=]};
[683]={description=[=[First column as a matrix]=],
   arguments=[[Xâ†A2]],
   utf=[=[X[;,1]]=],
   iso=[=[X[;,1]]=]};
[684]={description=[=[Number of elements (also of a scalar)]=],
   arguments=[[Xâ†A]],
   utf=[=[â´,X]=],
   iso=[=[Ò,X]=]};
[685]={description=[=[Separating variable length lines]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[X,â•TC[2],Y]=],
   iso=[=[X,ÌTC[2],Y]=]};
[686]={description=[=[XÃ—X identity matrix]=],
   arguments=[[Xâ†I0]],
   utf=[=[(X,X)â´1,Xâ´0]=],
   iso=[=[(X,X)Ò1,XÒ0]=]};
[687]={description=[=[Array and its negative ('plus minus')]=],
   arguments=[[Xâ†D]],
   utf=[=[X,[.5+â´â´X]-X]=],
   iso=[=[X,[.5+ÒÒX]-X]=]};
[688]={description=[=[Underlining a string]=],
   arguments=[[Xâ†C1]],
   utf=[=[X,[â•IO-.1]'Â¯']=],
   iso=[=[X,[ÌIO-.1]'¢']=]};
[689]={description=[=[Forming a two-column matrix]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[X,[1.1]Y]=],
   iso=[=[X,[1.1]Y]=]};
[690]={description=[=[Forming a two-row matrix]=],
   arguments=[[Xâ†A1; Yâ†A1]],
   utf=[=[X,[.1]Y]=],
   iso=[=[X,[.1]Y]=]};
[691]={description=[=[Selection of X or Y depending on condition G]=],
   arguments=[[Xâ†A0; Yâ†A0; Gâ†B0]],
   utf=[=[(X,Y)[â•IO+G]]=],
   iso=[=[(X,Y)[ÌIO+G]]=]};
[692]={description=[=[Increasing rank of Y to rank of X]=],
   arguments=[[Xâ†A; Yâ†A]],
   utf=[=[((((â´â´X)-â´â´Y)â´1),â´Y)â´Y]=],
   iso=[=[((((ÒÒX)-ÒÒY)Ò1),ÒY)ÒY]=]};
[693]={description=[=[Identity matrix of shape of matrix X]=],
   arguments=[[Xâ†D2]],
   utf=[=[(â´X)â´1,0Ã—X]=],
   iso=[=[(ÒX)Ò1,0«X]=]};
[694]={description=[=[Reshaping vector X into a two-column matrix]=],
   arguments=[[Xâ†A1]],
   utf=[=[((0.5Ã—â´X),2)â´X]=],
   iso=[=[((0.5«ÒX),2)ÒX]=]};
[696]={description=[=[Reshaping vector X into a one-row matrix]=],
   arguments=[[Xâ†A1]],
   utf=[=[(1,â´X)â´X]=],
   iso=[=[(1,ÒX)ÒX]=]};
[697]={description=[=[Reshaping vector X into a one-column matrix]=],
   arguments=[[Xâ†A1]],
   utf=[=[((â´X),1)â´X]=],
   iso=[=[((ÒX),1)ÒX]=]};
[698]={description=[=[Forming a Y-row matrix with all rows alike (X)]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[(Y,â´X)â´X]=],
   iso=[=[(Y,ÒX)ÒX]=]};
[699]={description=[=[Handling array X temporarily as a vector]=],
   arguments=[[Xâ†A]],
   utf=[=[(â´X)â´ ... ,X]=],
   iso=[=[(ÒX)Ò ... ,X]=]};
[700]={description=[=[Joining sentences]=],
   arguments=[[Xâ†A; Yâ†A1]],
   utf=[=[Y,0â´X]=],
   iso=[=[Y,0ÒX]=]};
[701]={description=[=[Entering from terminal data exceeding input (printing) width]=],
   arguments=[[Xâ†D]],
   utf=[=[Xâ†0 2 1 2 5 8 0 4 5,â•]=],
   iso=[=[Xû0 2 1 2 5 8 0 4 5,Ì]=]};
[702]={description=[=[Value of fixed-degree polynomial Y at points X]=],
   arguments=[[Yâ†D1; Xâ†D]],
   utf=[=[Y[3]+XÃ—Y[2]+XÃ—Y[1]]=],
   iso=[=[Y[3]+X«Y[2]+X«Y[1]]=]};
[703]={description=[=[Number of columns in array X]=],
   arguments=[[Xâ†A]],
   utf=[=[(â´X)[â´â´X]]=],
   iso=[=[(ÒX)[ÒÒX]]=]};
[704]={description=[=[Number of rows in matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[(â´X)[1]]=],
   iso=[=[(ÒX)[1]]=]};
[705]={description=[=[Number of columns in matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[(â´X)[2]]=],
   iso=[=[(ÒX)[2]]=]};
[706]={description=[=[Conditional elementwise change of sign]=],
   arguments=[[Yâ†D; Xâ†B]],
   utf=[=[YÃ—(1 Â¯1)[1+X]]=],
   iso=[=[Y«(1 ¢1)[1+X]]=]};
[707]={description=[=[Selection depending on index origin]=],
   arguments=[[Xâ†A1]],
   utf=[=[X[2Ã—â•IO]]=],
   iso=[=[X[2«ÌIO]]=]};
[708]={description=[=[Indexing with boolean value X (plotting a curve)]=],
   arguments=[[Xâ†B]],
   utf=[=[' *'[â•IO+X]]=],
   iso=[=[' *'[ÌIO+X]]=]};
[709]={description=[=[Indexing independent of index origin]=],
   arguments=[[Xâ†A1; Yâ†I]],
   utf=[=[X[â•IO+Y]]=],
   iso=[=[X[ÌIO+Y]]=]};
[710]={description=[=[Selection depending on index origin]=],
   arguments=[[Xâ†A1]],
   utf=[=[X[1]]=],
   iso=[=[X[1]]=]};
[711]={description=[=[Zeroing a vector (without change of size)]=],
   arguments=[[Xâ†D1]],
   utf=[=[X[]â†0]=],
   iso=[=[X[]û0]=]};
[712]={description=[=[First column as a vector]=],
   arguments=[[Xâ†A2]],
   utf=[=[X[;1]]=],
   iso=[=[X[;1]]=]};
[713]={description=[=[Rank of array X]=],
   arguments=[[Xâ†A]],
   utf=[=[â´â´X]=],
   iso=[=[ÒÒX]=]};
[715]={description=[=[Duplicating vector X Y times]=],
   arguments=[[Xâ†A1; Yâ†I0]],
   utf=[=[(YÃ—â´X)â´X]=],
   iso=[=[(Y«ÒX)ÒX]=]};
[716]={description=[=[Adding X to each row of Y]=],
   arguments=[[Xâ†D1; Yâ†D; (â´X)=Â¯1â†‘â´Y]],
   utf=[=[Y+(â´Y)â´X]=],
   iso=[=[Y+(ÒY)ÒX]=]};
[717]={description=[=[Array with shape of Y and X as its rows]=],
   arguments=[[Xâ†A1; Yâ†A]],
   utf=[=[(â´Y)â´X]=],
   iso=[=[(ÒY)ÒX]=]};
[718]={description=[=[Number of rows in matrix X]=],
   arguments=[[Xâ†A2]],
   utf=[=[1â´â´X]=],
   iso=[=[1ÒÒX]=]};
[720]={description=[=[Forming an initially empty array to be expanded]=],
   arguments=[[]],
   utf=[=[0 80â´0]=],
   iso=[=[0 80Ò0]=]};
[721]={description=[=[Output of an empty line]=],
   arguments=[[Xâ†A]],
   utf=[=[0â´Xâ†]=],
   iso=[=[0ÒXû]=]};
[722]={description=[=[Reshaping first element of X into a scalar]=],
   arguments=[[Xâ†A]],
   utf=[=[''â´X]=],
   iso=[=[''ÒX]=]};
[723]={description=[=[Corner element of a (non-empty) array]=],
   arguments=[[Xâ†A]],
   utf=[=[1â´X]=],
   iso=[=[1ÒX]=]};
[724]={description=[=[Continued fraction]=],
   arguments=[[]],
   utf=[=[1+Ã·2+Ã·3+Ã·4+Ã·5+Ã·6+Ã· ...]=],
   iso=[=[1+ß2+ß3+ß4+ß5+ß6+ß ...]=]};
[725]={description=[=[Force 0Ã·0 into DOMAIN ERROR in division]=],
   arguments=[[Xâ†D; Yâ†D]],
   utf=[=[YÃ—Ã·X]=],
   iso=[=[Y«ßX]=]};
[726]={description=[=[Conditional elementwise change of sign]=],
   arguments=[[Xâ†D; Yâ†B; â´X â†â†’ â´Y]],
   utf=[=[XÃ—Â¯1*Y]=],
   iso=[=[X«¢1*Y]=]};
[727]={description=[=[Zero array of shape and size of X]=],
   arguments=[[Xâ†D]],
   utf=[=[0Ã—X]=],
   iso=[=[0«X]=]};
[728]={description=[=[Selecting elements satisfying condition Y, zeroing others]=],
   arguments=[[Xâ†D; Yâ†B]],
   utf=[=[YÃ—X]=],
   iso=[=[Y«X]=]};
[729]={description=[=[Number and its negative ('plus minus')]=],
   arguments=[[Xâ†D0]],
   utf=[=[1 Â¯1Ã—X]=],
   iso=[=[1 ¢1«X]=]};
[730]={description=[=[Changing an index origin dependent result to be as â•IO=0]=],
   arguments=[[Xâ†I]],
   utf=[=[-â•IO-X]=],
   iso=[=[-ÌIO-X]=]};
[731]={description=[=[Changing an index origin dependent argument to act as â•IO=1]=],
   arguments=[[Xâ†I]],
   utf=[=[(â•IO-1)+X]=],
   iso=[=[(ÌIO-1)+X]=]};
[732]={description=[=[Output of assigned numeric value]=],
   arguments=[[Xâ†D]],
   utf=[=[+Xâ†]=],
   iso=[=[+Xû]=]};
[733]={description=[=[Changing an index origin dependent argument to act as â•IO=0]=],
   arguments=[[Xâ†I]],
   utf=[=[â•IO+X]=],
   iso=[=[ÌIO+X]=]};
[734]={description=[=[Selecting elements satisfying condition Y, others to one]=],
   arguments=[[Xâ†D; Yâ†B]],
   utf=[=[X*Y]=],
   iso=[=[X*Y]=]};
[736]={description=[=[Setting a constant with hyphens]=],
   arguments=[[]],
   utf=[=[â•LXâ†â]=],
   iso=[=[ÌLXûì]=]};
[737]={description=[=[Output of assigned value]=],
   arguments=[[Xâ†A]],
   utf=[=[â•â†Xâ†]=],
   iso=[=[ÌûXû]=]};
[738]={description=[=[Syntax error to stop execution]=],
   arguments=[[]],
   utf=[=[*]=],
   iso=[=[*]=]};
[888]={description=[=[Meaning of life]=],
   arguments=[[]],
   utf=[=[ââŠ–â•âŠƒâŠ‚|âŒŠ-*+â—‹âŒˆÃ—Ã·!âŒ½â‰âŒ¹~â´â‹â’,âŸ?â³0]=],
   iso=[=[âáîØÚ|Ä-*+ÏÓ«ß!÷ô­~Òèç,ğ?É0]=]};
   maxn=888}
