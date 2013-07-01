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
   arguments=[[X←A1; Y←A1]],
   utf=[=[((⍴X)⍴⍋⍋X⍳X,Y)⍳(⍴Y)⍴⍋⍋X⍳Y,X]=],
   iso=[=[((�X)���X�X,Y)�(�Y)���X�Y,X]=]};
[2]={description=[=[Ascending cardinal numbers (ranking, shareable)]=],
   arguments=[[X←D1]],
   utf=[=[⌊.5×(⍋⍋X)+⌽⍋⍋⌽X]=],
   iso=[=[�.5�(��X)+����X]=]};
[3]={description=[=[Cumulative maxima (⌈\) of subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[Y[A⍳⌈\A←⍋A[⍋(+\X)[A←⍋Y]]]]=],
   iso=[=[Y[A��\A��A[�(+\X)[A��Y]]]]=]};
[4]={description=[=[Cumulative minima (⌊\) of subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[Y[A⍳⌈\A←⍋A[⍋(+\X)[A←⍒Y]]]]=],
   iso=[=[Y[A��\A��A[�(+\X)[A��Y]]]]=]};
[5]={description=[=[Progressive index of (without replacement)]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[((⍋X⍳X,Y)⍳⍳⍴X)⍳(⍋X⍳Y,X)⍳⍳⍴Y]=],
   iso=[=[((�X�X,Y)���X)�(�X�Y,X)���Y]=]};
[6]={description=[=[Test if X and Y are permutations of each other]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[Y[⍋Y]^.=X[⍋X]]=],
   iso=[=[Y[�Y]^.=X[�X]]=]};
[7]={description=[=[Test if X is a permutation vector]=],
   arguments=[[X←I1]],
   utf=[=[X^.=⍋⍋X]=],
   iso=[=[X^.=��X]=]};
[8]={description=[=[Grade up (⍋) for sorting subvectors of Y having lengths X]=],
   arguments=[[Y←D1; X←I1; (⍴Y) ←→ +/X]],
   utf=[=[A[⍋(+\(⍳⍴Y)∊+\⎕IO,X)[A←⍋Y]]]=],
   iso=[=[A[�(+\(��Y)�+\�IO,X)[A��Y]]]=]};
[9]={description=[=[Index of the elements of X in Y]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[(((1,A)/B)⌊1+⍴Y)[(⍴Y)↓(+\1,A←(1↓A)≠¯1↓A←A[B])[⍋B←⍋A←Y,X]]]=],
   iso=[=[(((1,A)/B)�1+�Y)[(�Y)�(+\1,A�(1�A)��1�A�A[B])[�B��A�Y,X]]]=]};
[10]={description=[=[Minima (⌊/) of elements of subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[Y[A[X/⍋(+\X)[A←⍋Y]]]]=],
   iso=[=[Y[A[X/�(+\X)[A��Y]]]]=]};
[11]={description=[=[Grade up (⍋) for sorting subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[A[⍋(+\X)[A←⍋Y]]]=],
   iso=[=[A[�(+\X)[A��Y]]]=]};
[12]={description=[=[Occurences of the elements of X]=],
   arguments=[[X←D1]],
   utf=[=[|-⌿(2,⍴X)⍴⍋⍋X,X]=],
   iso=[=[|-�(2,�X)���X,X]=]};
[13]={description=[=[Sorting rows of matrix X into ascending order]=],
   arguments=[[X←D2]],
   utf=[=[(⍴X)⍴(,X)[A[⍋(,⍉(⌽⍴X)⍴⍳1↑⍴X)[A←⍋,X]]]]=],
   iso=[=[(�X)�(,X)[A[�(,�(��X)��1��X)[A��,X]]]]=]};
[14]={description=[=[Adding a new dimension after dimension G Y-fold]=],
   arguments=[[G←I0; Y←I0; X←A]],
   utf=[=[(⍋⍋(G+1),⍳⍴⍴X)⍉(Y,⍴X)⍴X]=],
   iso=[=[(��(G+1),���X)�(Y,�X)�X]=]};
[15]={description=[=[Sorting rows of matrix X into ascending order]=],
   arguments=[[X←D2]],
   utf=[=[A←(⍋,X)-⎕IO ⋄ (⍴X)⍴(,X)[⎕IO+A[⍋⌊A÷¯1↑⍴X]]]=],
   iso=[=[A�(�,X)-�IO � (�X)�(,X)[�IO+A[��Aߢ1��X]]]=]};
[16]={description=[=[Y smallest elements of X in order of occurrence]=],
   arguments=[[X←D1, Y←I0]],
   utf=[=[((⍋⍋X)∊⍳Y)/X]=],
   iso=[=[((��X)��Y)/X]=]};
[17]={description=[=[Merging X, Y, Z ... under control of G (mesh)]=],
   arguments=[[X←A1; Y←A1; Z←A1; ... ; G←I1]],
   utf=[=[(X,Y,Z,...)[⍋⍋G]]=],
   iso=[=[(X,Y,Z,...)[��G]]=]};
[18]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[X←A1; Y←A1; G←B1]],
   utf=[=[(X,Y)[⍋⍋G]]=],
   iso=[=[(X,Y)[��G]]=]};
[19]={description=[=[Ascending cardinal numbers (ranking, all different)]=],
   arguments=[[X←D1]],
   utf=[=[⍋⍋X]=],
   iso=[=[��X]=]};
[20]={description=[=[Grade down (⍒) for sorting subvectors of Y having lengths X]=],
   arguments=[[Y←D1; X←I1; (⍴Y) ←→ +/X]],
   utf=[=[A[⍋(+\(⍳⍴Y)∊+\⎕IO,X)[A←⍒Y]]]=],
   iso=[=[A[�(+\(��Y)�+\�IO,X)[A��Y]]]=]};
[21]={description=[=[Maxima (⌈/) of elements of subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[Y[A[X/⍋(+\X)[A←⍒Y]]]]=],
   iso=[=[Y[A[X/�(+\X)[A��Y]]]]=]};
[22]={description=[=[Grade down (⍒) for sorting subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[A[⍋(+\X)[A←⍒Y]]]=],
   iso=[=[A[�(+\X)[A��Y]]]=]};
[23]={description=[=[Y largest elements of X in order of occurrence]=],
   arguments=[[X←D1; Y←I0]],
   utf=[=[((⍋⍒X)∊⍳Y)/X]=],
   iso=[=[((��X)��Y)/X]=]};
[24]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[X←A1; Y←A1; G←B1]],
   utf=[=[(Y,X)[⍋⍒G]]=],
   iso=[=[(Y,X)[��G]]=]};
[25]={description=[=[Descending cardinal numbers (ranking, all different)]=],
   arguments=[[X←D1]],
   utf=[=[⍋⍒X]=],
   iso=[=[��X]=]};
[26]={description=[=[Sorting rows of X according to key Y (alphabetizing)]=],
   arguments=[[X←A2; Y←A1]],
   utf=[=[X[⍋(1+⍴Y)⊥Y⍳⍉X;]]=],
   iso=[=[X[�(1+�Y)�Y��X;]]=]};
[27]={description=[=[Diagonal ravel]=],
   arguments=[[X←A]],
   utf=[=[(,X)[⍋+⌿(⍴X)⊤(⍳⍴,X)-⎕IO]]=],
   iso=[=[(,X)[�+�(�X)�(��,X)-�IO]]=]};
[28]={description=[=[Grade up according to key Y]=],
   arguments=[[Y←A1; X←A1]],
   utf=[=[⍋Y⍳X]=],
   iso=[=[�Y�X]=]};
[29]={description=[=[Test if X is a permutation vector]=],
   arguments=[[X←I1]],
   utf=[=[X[⍋X]^.=⍳⍴X]=],
   iso=[=[X[�X]^.=��X]=]};
[30]={description=[=[Sorting a matrix into lexicographic order]=],
   arguments=[[X←D2]],
   utf=[=[X[⍋+⌿A<.-⍉A←X,0;]]=],
   iso=[=[X[�+�A<.-�A�X,0;]]=]};
[31]={description=[=[Sorting words in list X according to word length]=],
   arguments=[[X←C2]],
   utf=[=[X[⍋X+.≠' ';]]=],
   iso=[=[X[�X+.�' ';]]=]};
[32]={description=[=[Classification of X to classes starting with Y]=],
   arguments=[[X←D1;Y←D1;Y<.≥1⌽Y]],
   utf=[=[A[(B/C)-⍴Y]←B/+\~B←(⍴Y)<C←⍋Y,X+A←0×X ⋄ A]=],
   iso=[=[A[(B/C)-�Y]�B/+\~B�(�Y)<C��Y,X+A�0�X � A]=]};
[33]={description=[=[Rotate first elements (1⌽) of subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←A1]],
   utf=[=[Y[⍋X++\X]]=],
   iso=[=[Y[�X++\X]]=]};
[34]={description=[=[Doubling quotes (for execution)]=],
   arguments=[[X←C1]],
   utf=[=[(X,'''')[(⎕IO+⍴X)⌊⍋(⍳⍴X),(''''=X)/⍳⍴X]]=],
   iso=[=[(X,'''')[(�IO+�X)��(��X),(''''=X)/��X]]=]};
[35]={description=[=[Inserting Y *'s into vector X after indices G]=],
   arguments=[[X←C1; Y←I0; G←I1]],
   utf=[=[(X,'*')[(⎕IO+⍴X)⌊⍋(⍳⍴X),(Y×⍴G)⍴G]]=],
   iso=[=[(X,'*')[(�IO+�X)��(��X),(Y��G)�G]]=]};
[36]={description=[=[Median]=],
   arguments=[[X←D1]],
   utf=[=[X[(⍋X)[⌈.5×⍴X]]]=],
   iso=[=[X[(�X)[�.5��X]]]=]};
[37]={description=[=[Index of last maximum element of X]=],
   arguments=[[X←D1]],
   utf=[=[¯1↑⍋X]=],
   iso=[=[�1��X]=]};
[38]={description=[=[Index of (first) minimum element of X]=],
   arguments=[[X←D1]],
   utf=[=[1↑⍋X]=],
   iso=[=[1��X]=]};
[39]={description=[=[Expansion vector with zero after indices Y]=],
   arguments=[[X←D1; Y←I1]],
   utf=[=[(⍴X)≥⍋(⍳⍴X),Y]=],
   iso=[=[(�X)��(��X),Y]=]};
[40]={description=[=[Catenating G elements H before indices Y in vector X]=],
   arguments=[[X←A1; Y←I1; G←I0; H←A0]],
   utf=[=[A←G×⍴,Y ⋄ ((A⍴H),X)[⍋(A⍴Y),⍳⍴X]]=],
   iso=[=[A�G��,Y � ((A�H),X)[�(A�Y),��X]]=]};
[41]={description=[=[Catenating G elements H after indices Y in vector X]=],
   arguments=[[X←A1; Y←I1; G←I0; H←A0]],
   utf=[=[A←G×⍴,Y ⋄ (X,A⍴H)[⍋(⍳⍴X),A⍴Y]]=],
   iso=[=[A�G��,Y � (X,A�H)[�(��X),A�Y]]=]};
[42]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[X←A1; Y←A1; G←B1]],
   utf=[=[A[⍋G]←A←Y,X ⋄ A]=],
   iso=[=[A[�G]�A�Y,X � A]=]};
[43]={description=[=[Sorting a matrix according to Y:th column]=],
   arguments=[[X←D2]],
   utf=[=[X[⍋X[;Y];]]=],
   iso=[=[X[�X[;Y];]]=]};
[44]={description=[=[Sorting indices X according to data Y]=],
   arguments=[[X←I1; Y←D1]],
   utf=[=[X[⍋Y[X]]]=],
   iso=[=[X[�Y[X]]]=]};
[45]={description=[=[Choosing sorting direction during execution]=],
   arguments=[[X←D1; Y←I0]],
   utf=[=[⍋X×(¯1 1)[Y]]=],
   iso=[=[�X�(�1 1)[Y]]=]};
[46]={description=[=[Sorting Y according to X]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[Y[⍋X]]=],
   iso=[=[Y[�X]]=]};
[47]={description=[=[Sorting X into ascending order]=],
   arguments=[[X←D1]],
   utf=[=[X[⍋X]]=],
   iso=[=[X[�X]]=]};
[48]={description=[=[Inverting a permutation]=],
   arguments=[[X←I1]],
   utf=[=[⍋X]=],
   iso=[=[�X]=]};
[49]={description=[=[Reverse vector X on condition Y]=],
   arguments=[[X←A1; Y←B0]],
   utf=[=[X[⍒Y!⍳⍴X]]=],
   iso=[=[X[�Y!��X]]=]};
[50]={description=[=[Sorting a matrix into reverse lexicographic order]=],
   arguments=[[X←D2]],
   utf=[=[X[⍒+⌿A<.-⍉A←X,0;]]=],
   iso=[=[X[�+�A<.-�A�X,0;]]=]};
[52]={description=[=[Reversal (⌽) of subvectors of X having lengths Y]=],
   arguments=[[X←D1; Y←I1]],
   utf=[=[X[⌽⍒+\(⍳⍴X)∊+\⎕IO,Y]]=],
   iso=[=[X[��+\(��X)�+\�IO,Y]]=]};
[53]={description=[=[Reversal (⌽) of subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←A1]],
   utf=[=[Y[⌽⍒+\X]]=],
   iso=[=[Y[��+\X]]=]};
[55]={description=[=[Indices of ones in logical vector X]=],
   arguments=[[X←B1]],
   utf=[=[(+/X)↑⍒X]=],
   iso=[=[(+/X)��X]=]};
[56]={description=[=[Index of first maximum element of X]=],
   arguments=[[X←D1]],
   utf=[=[1↑⍒X]=],
   iso=[=[1��X]=]};
[57]={description=[=[Moving all blanks to end of text]=],
   arguments=[[X←C1]],
   utf=[=[X[⍒' '≠X]]=],
   iso=[=[X[�' '�X]]=]};
[58]={description=[=[Sorting X into descending order]=],
   arguments=[[X←D1]],
   utf=[=[X[⍒X]]=],
   iso=[=[X[�X]]=]};
[59]={description=[=[Moving elements satisfying condition Y to the start of X]=],
   arguments=[[X←A1; Y←B1]],
   utf=[=[X[⍒Y]]=],
   iso=[=[X[�Y]]=]};
[60]={description=[=[Interpolated value of series (X,Y) at G]=],
   arguments=[[X←D1; Y←D1; G←D0]],
   utf=[=[G⊥Y⌹X∘.*⌽-⎕IO-⍳⍴X]=],
   iso=[=[G�Y�X�.*�-�IO-��X]=]};
[61]={description=[=[Predicted values of exponential (curve) fit]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[*A+.×(⍟Y)⌹A←X∘.*0 1]=],
   iso=[=[*A+.�(�Y)�A�X�.*0 1]=]};
[62]={description=[=[Coefficients of exponential (curve) fit of points (X,Y)]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[A←(⍟Y)⌹X∘.*0 1 ⋄ A[1]←*A[1] ⋄ A]=],
   iso=[=[A�(�Y)�X�.*0 1 � A[1]�*A[1] � A]=]};
[63]={description=[=[Predicted values of best linear fit (least squares)]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[A+.×Y⌹A←X∘.*0 1]=],
   iso=[=[A+.�Y�A�X�.*0 1]=]};
[64]={description=[=[G-degree polynomial (curve) fit of points (X,Y)]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[⌽Y⌹X∘.*0,⍳G]=],
   iso=[=[�Y�X�.*0,�G]=]};
[65]={description=[=[Best linear fit of points (X,Y) (least squares)]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[Y⌹X∘.*0 1]=],
   iso=[=[Y�X�.*0 1]=]};
[66]={description=[=[Binary format of decimal number X]=],
   arguments=[[X←I0]],
   utf=[=[⍕10⊥((1+⌈2⍟⌈/,X)⍴2)⊤X]=],
   iso=[=[�10�((1+�2��/,X)�2)�X]=]};
[67]={description=[=[Barchart of two integer series (across the page)]=],
   arguments=[[X←I2; 1⍴⍴X ←→ 2]],
   utf=[=[' *○⍟'[⎕IO+2⊥X∘.≥⍳⌈/,X]]=],
   iso=[=[' *��'[�IO+2�X�.���/,X]]=]};
[68]={description=[=[Case structure with an encoded branch destination]=],
   arguments=[[Y←I1; X←B1]],
   utf=[=[→Y[1+2⊥X]]=],
   iso=[=[�Y[1+2�X]]=]};
[69]={description=[=[Representation of current time (24 hour clock)]=],
   arguments=[[]],
   utf=[=[A←⍕1000⊥3↑3↓⎕TS ⋄ A[3 6]←':' ⋄ A]=],
   iso=[=[A��1000�3�3��TS � A[3 6]�':' � A]=]};
[70]={description=[=[Representation of current date (descending format)]=],
   arguments=[[]],
   utf=[=[A←⍕1000⊥3↑⎕TS ⋄ A[5 8]←'-' ⋄ A]=],
   iso=[=[A��1000�3��TS � A[5 8]�'-' � A]=]};
[71]={description=[=[Representation of current time (12 hour clock)]=],
   arguments=[[]],
   utf=[=[(1⌽,' ::',3 2⍴6 0⍕100⊥12 0 0|3↑3↓⎕TS),'AP'[1+12≤⎕TS[4]],'M']=],
   iso=[=[(1�,' ::',3 2�6 0�100�12 0 0|3�3��TS),'AP'[1+12��TS[4]],'M']=]};
[73]={description=[=[Removing duplicate rows]=],
   arguments=[[X←A2]],
   utf=[=[((A⍳A)=⍳⍴A←2⊥X^.=⍉X)⌿X]=],
   iso=[=[((A�A)=��A�2�X^.=�X)�X]=]};
[74]={description=[=[Conversion from hexadecimal to decimal]=],
   arguments=[[X←C]],
   utf=[=[16⊥-⎕IO-'0123456789ABCDEF'⍳⍉X]=],
   iso=[=[16�-�IO-'0123456789ABCDEF'��X]=]};
[75]={description=[=[Conversion of alphanumeric string into numeric]=],
   arguments=[[X←C1]],
   utf=[=[10⊥¯1+'0123456789'⍳X]=],
   iso=[=[10¢1+'0123456789'�X]=]};
[76]={description=[=[Value of polynomial with coefficients Y at points X]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[(X∘.+,0)⊥Y]=],
   iso=[=[(X�.+,0)�Y]=]};
[77]={description=[=[Changing connectivity list X to a connectivity matrix]=],
   arguments=[[X←C2]],
   utf=[=[A←(×/B←0 0+⌈/,X)⍴0 ⋄ A[⎕IO+B[1]⊥-⎕IO-X]←1 ⋄ B⍴A]=],
   iso=[=[A�(�/B�0 0+�/,X)�0 � A[�IO+B[1]�-�IO-X]�1 � B�A]=]};
[78]={description=[=[Present value of cash flows X at interest rate Y %]=],
   arguments=[[X←D1; Y←D0]],
   utf=[=[(÷1+Y÷100)⊥⌽X]=],
   iso=[=[(�1+Y�100)��X]=]};
[79]={description=[=[Justifying right]=],
   arguments=[[X←C]],
   utf=[=[(1-(' '=X)⊥1)⌽X]=],
   iso=[=[(1-(' '=X)�1)�X]=]};
[80]={description=[=[Number of days in month X of years Y (for all leap years)]=],
   arguments=[[X←I0; Y←I]],
   utf=[=[(12⍴7⍴31 30)[X]-0⌈¯1+2⊥(X=2),[.1](0≠400|Y)-(0≠100|Y)-0≠4|Y]=],
   iso=[=[(12�7�31 30)[X]-0Ӣ1+2�(X=2),[.1](0�400|Y)-(0�100|Y)-0�4|Y]=]};
[81]={description=[=[Number of days in month X of years Y (for most leap years)]=],
   arguments=[[X←I0; Y←I]],
   utf=[=[(12⍴7⍴31 30)[X]-0⌈¯1+2⊥(X=2),[.1]0≠4|Y]=],
   iso=[=[(12�7�31 30)[X]-0Ӣ1+2�(X=2),[.1]0�4|Y]=]};
[82]={description=[=[Encoding current date]=],
   arguments=[[]],
   utf=[=[100⊥100|3↑⎕TS]=],
   iso=[=[100�100|3��TS]=]};
[83]={description=[=[Removing trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[(1-(' '=X)⊥1)↓X]=],
   iso=[=[(1-(' '=X)�1)�X]=]};
[84]={description=[=[Index of first non-blank, counted from the rear]=],
   arguments=[[X←C1]],
   utf=[=[(' '=X)⊥1]=],
   iso=[=[(' '=X)�1]=]};
[85]={description=[=[Indexing scattered elements]=],
   arguments=[[X←A; Y←I2]],
   utf=[=[(,X)[⎕IO+(⍴X)⊥Y-⎕IO]]=],
   iso=[=[(,X)[�IO+(�X)�Y-�IO]]=]};
[86]={description=[=[Conversion of indices Y of array X to indices of raveled X]=],
   arguments=[[X←A; Y←I2]],
   utf=[=[⎕IO+(⍴X)⊥Y-⎕IO]=],
   iso=[=[�IO+(�X)�Y-�IO]=]};
[87]={description=[=[Number of columns in array X as a scalar]=],
   arguments=[[X←A]],
   utf=[=[0⊥⍴X]=],
   iso=[=[0��X]=]};
[88]={description=[=[Future value of cash flows X at interest rate Y %]=],
   arguments=[[X←D1; Y←D0]],
   utf=[=[(1+Y÷100)⊥X]=],
   iso=[=[(1+Y�100)�X]=]};
[89]={description=[=[Sum of the elements of vector X]=],
   arguments=[[X←D1]],
   utf=[=[1⊥X]=],
   iso=[=[1�X]=]};
[90]={description=[=[Last element of numeric vector X as a scalar]=],
   arguments=[[X←D1]],
   utf=[=[0⊥X]=],
   iso=[=[0�X]=]};
[91]={description=[=[Last row of matrix X as a vector]=],
   arguments=[[X←A]],
   utf=[=[0⊥X]=],
   iso=[=[0�X]=]};
[92]={description=[=[Integer representation of logical vectors]=],
   arguments=[[X←B]],
   utf=[=[2⊥X]=],
   iso=[=[2�X]=]};
[93]={description=[=[Value of polynomial with coefficients Y at point X]=],
   arguments=[[X←D0; Y←D]],
   utf=[=[X⊥Y]=],
   iso=[=[X�Y]=]};
[94]={description=[=[Conversion from decimal to hexadecimal (X=1..255)]=],
   arguments=[[X←I]],
   utf=[=[⍉'0123456789ABCDEF'[⎕IO+((⌈⌈/16⍟,X)⍴16)⊤X]]=],
   iso=[=[�'0123456789ABCDEF'[�IO+((��/16�,X)�16)�X]]=]};
[95]={description=[=[All binary representations up to X (truth table)]=],
   arguments=[[X←I0]],
   utf=[=[((⌈2⍟1+X)⍴2)⊤0,⍳X]=],
   iso=[=[((�2�1+X)�2)�0,�X]=]};
[96]={description=[=[Representation of X in base Y]=],
   arguments=[[X←D0; Y←D0]],
   utf=[=[((1+⌊Y⍟X)⍴Y)⊤X]=],
   iso=[=[((1+�Y�X)�Y)�X]=]};
[97]={description=[=[Digits of X separately]=],
   arguments=[[X←I0]],
   utf=[=[((1+⌊10⍟X)⍴10)⊤X]=],
   iso=[=[((1+�10�X)�10)�X]=]};
[98]={description=[=[Helps locating column positions 1..X]=],
   arguments=[[X←I0]],
   utf=[=[1 0⍕10 10⊤1-⎕IO-⍳X]=],
   iso=[=[1 0�10 10�1-�IO-�X]=]};
[99]={description=[=[Conversion of characters to hexadecimal representation (⎕AV)]=],
   arguments=[[X←C1]],
   utf=[=[,' ',⍉'0123456789ABCDEF'[⎕IO+16 16⊤-⎕IO-⎕AV⍳X]]=],
   iso=[=[,' ',�'0123456789ABCDEF'[�IO+16 16�-�IO-�AV�X]]=]};
[100]={description=[=[Polynomial with roots X]=],
   arguments=[[X←D1]],
   utf=[=[⌽((0,⍳⍴X)∘.=+⌿~A)+.×(-X)×.*A←((⍴X)⍴2)⊤¯1+⍳2*⍴X]=],
   iso=[=[�((0,��X)�.=+�~A)+.�(-X)�.*A�((�X)�2)΢1+�2*�X]=]};
[101]={description=[=[Index pairs of saddle points]=],
   arguments=[[X←D2]],
   utf=[=[⎕IO+(⍴X)⊤-⎕IO-(,(X=(⍴X)⍴⌈⌿X)^X=⍉(⌽⍴X)⍴⌊/X)/⍳×/⍴X]=],
   iso=[=[�IO+(�X)�-�IO-(,(X=(�X)�ӯX)^X=�(��X)��/X)/ɫ/�X]=]};
[102]={description=[=[Changing connectivity matrix X to a connectivity list]=],
   arguments=[[X←C2]],
   utf=[=[(,X)/1+A⊤¯1+⍳×/A←⍴X]=],
   iso=[=[(,X)/1+A΢1+ɫ/A��X]=]};
[103]={description=[=[Matrix of all indices of X]=],
   arguments=[[X←A]],
   utf=[=[⎕IO+(⍴X)⊤(⍳×/⍴X)-⎕IO]=],
   iso=[=[�IO+(�X)�(ɫ/�X)-�IO]=]};
[104]={description=[=[Separating a date YYMMDD to YY, MM, DD]=],
   arguments=[[X←D]],
   utf=[=[⍉(3⍴100)⊤X]=],
   iso=[=[�(3�100)�X]=]};
[105]={description=[=[Indices of elements Y in array X]=],
   arguments=[[X←A; Y←A]],
   utf=[=[⎕IO+(⍴X)⊤(-⎕IO)+(,X∊Y)/⍳⍴,X]=],
   iso=[=[�IO+(�X)�(-�IO)+(,X�Y)/��,X]=]};
[106]={description=[=[All pairs of elements of ⍳X and ⍳Y]=],
   arguments=[[X←I0; Y←I0]],
   utf=[=[⎕IO+(X,Y)⊤(⍳X×Y)-⎕IO]=],
   iso=[=[�IO+(X,Y)�(�X�Y)-�IO]=]};
[107]={description=[=[Matrix for choosing all subsets of X (truth table)]=],
   arguments=[[X←A1]],
   utf=[=[((⍴X)⍴2)⊤¯1+⍳2*⍴X]=],
   iso=[=[((�X)�2)΢1+�2*�X]=]};
[108]={description=[=[All binary representations with X bits (truth table)]=],
   arguments=[[X←I0]],
   utf=[=[(X⍴2)⊤¯1+⍳2*X]=],
   iso=[=[(X�2)΢1+�2*X]=]};
[109]={description=[=[Incrementing cyclic counter X with upper limit Y]=],
   arguments=[[X←D; Y←D0]],
   utf=[=[1+Y⊤X]=],
   iso=[=[1+Y�X]=]};
[110]={description=[=[Decoding numeric code ABBCCC into a matrix]=],
   arguments=[[X←I]],
   utf=[=[10 100 1000⊤X]=],
   iso=[=[10 100 1000�X]=]};
[111]={description=[=[Integer and fractional parts of positive numbers]=],
   arguments=[[X←D]],
   utf=[=[0 1⊤X]=],
   iso=[=[0 1�X]=]};
[112]={description=[=[Number of decimals of elements of X]=],
   arguments=[[X←D1]],
   utf=[=[⌊10⍟(⍎('.'≠A)/A←⍕X)÷X]=],
   iso=[=[�10�(�('.'�A)/A��X)�X]=]};
[113]={description=[=[Number of sortable columns at a time using ⊥ and alphabet X]=],
   arguments=[[X←C1]],
   utf=[=[⌊(1+⍴X)⍟2*(A=¯1+A←2*⍳128)⍳1]=],
   iso=[=[�(1+�X)�2*(A=�1+A�2*�128)�1]=]};
[114]={description=[=[Playing order in a cup for X ranked players]=],
   arguments=[[X←I0]],
   utf=[=[,⍉(A⍴2)⍴(2*A←⌈2⍟X)↑⍳X]=],
   iso=[=[,�(A�2)�(2*A��2�X)��X]=]};
[115]={description=[=[Arithmetic precision of the system (in decimals)]=],
   arguments=[[]],
   utf=[=[⌊|10⍟|1-3×÷3]=],
   iso=[=[�|10�|1-3��3]=]};
[116]={description=[=[Number of digitpositions in integers in X]=],
   arguments=[[X←I]],
   utf=[=[1+(X<0)+⌊10⍟|X+0=X]=],
   iso=[=[1+(X<0)+�10�|X+0=X]=]};
[117]={description=[=[Number of digit positions in integers in X]=],
   arguments=[[X←I]],
   utf=[=[1+⌊10⍟(X=0)+X×(1 ¯10)[1+X<0]]=],
   iso=[=[1+�10�(X=0)+X�(1 �10)[1+X<0]]=]};
[118]={description=[=[Number of digits in positive integers in X]=],
   arguments=[[X←I]],
   utf=[=[1+⌊10⍟X+0=X]=],
   iso=[=[1+�10�X+0=X]=]};
[119]={description=[=[Case structure according to key vector G]=],
   arguments=[[X←A0; Y←I1; G←A1]],
   utf=[=[→Y[G⍳X]]=],
   iso=[=[�Y[G�X]]=]};
[120]={description=[=[Forming a transitive closure]=],
   arguments=[[X←B2]],
   utf=[=[→⎕LC⌈⍳∨/,(X←X∨X∨.^X)≠+X]=],
   iso=[=[��LC�ɩ/,(X�X�X�.^X)�+X]=]};
[121]={description=[=[Case structure with integer switch]=],
   arguments=[[X←I0; Y←I1]],
   utf=[=[→X⌽Y]=],
   iso=[=[�X�Y]=]};
[122]={description=[=[For-loop ending construct]=],
   arguments=[[X←I0; Y←I0; G←I0]],
   utf=[=[→Y⌈⍳G≥X←X+1]=],
   iso=[=[�Y��G�X�X+1]=]};
[123]={description=[=[Conditional branch to line Y]=],
   arguments=[[X←B0; Y←I0; Y>0]],
   utf=[=[→Y⌈⍳X]=],
   iso=[=[�Y��X]=]};
[124]={description=[=[Conditional branch out of program]=],
   arguments=[[X←B0]],
   utf=[=[→0⌊⍳X]=],
   iso=[=[�0��X]=]};
[125]={description=[=[Conditional branch depending on sign of X]=],
   arguments=[[X←I0; Y←I1]],
   utf=[=[→Y[2+×X]]=],
   iso=[=[�Y[2+�X]]=]};
[126]={description=[=[Continuing from line Y (if X>0) or exit]=],
   arguments=[[X←D0; Y←I0]],
   utf=[=[→Y××X]=],
   iso=[=[�Y��X]=]};
[127]={description=[=[Case structure using levels with limits G]=],
   arguments=[[X←D0; G←D1; Y←I1]],
   utf=[=[→(X≥G)/Y]=],
   iso=[=[�(X�G)/Y]=]};
[128]={description=[=[Case structure with logical switch (preferring from start)]=],
   arguments=[[X←B1; Y←I1]],
   utf=[=[→X/Y]=],
   iso=[=[�X/Y]=]};
[129]={description=[=[Conditional branch out of program]=],
   arguments=[[X←B0]],
   utf=[=[→0×⍳X]=],
   iso=[=[�0��X]=]};
[132]={description=[=[Test for symmetricity of matrix X]=],
   arguments=[[X←A2]],
   utf=[=[⍎⍎'1','↑↓'[⎕IO+^/(⍴X)=⌽⍴X],'''0~0∊X=⍉X''']=],
   iso=[=[��'1','��'[�IO+^/(�X)=��X],'''0~0�X=�X''']=]};
[133]={description=[=[Using a variable named according to X]=],
   arguments=[[X←A0; Y←A]],
   utf=[=[⍎'VAR',(⍕X),'←Y']=],
   iso=[=[�'VAR',(�X),'�Y']=]};
[134]={description=[=[Rounding to ⎕PP precision]=],
   arguments=[[X←D1]],
   utf=[=[⍎⍕X]=],
   iso=[=[��X]=]};
[135]={description=[=[Convert character or numeric data into numeric]=],
   arguments=[[X←A1]],
   utf=[=[⍎⍕X]=],
   iso=[=[��X]=]};
[136]={description=[=[Reshaping only one-element numeric vector X into a scalar]=],
   arguments=[[X←D1]],
   utf=[=[⍎⍕X]=],
   iso=[=[��X]=]};
[137]={description=[=[Graph of F(X) at points X ('X'∊F)]=],
   arguments=[[F←A1; X←D1]],
   utf=[=[' *'[⎕IO+(⌽(¯1+⌊/A)+⍳1+(⌈/A)-⌊/A)∘.=A←⌊.5+⍎F]]=],
   iso=[=[' *'[�IO+(�(�1+�/A)+�1+(�/A)-�/A)�.=A��.5+�F]]=]};
[138]={description=[=[Conversion of each row to a number (default zero)]=],
   arguments=[[X←C2]],
   utf=[=[(X∨.≠' ')\1↓⍎'0 ',,X,' ']=],
   iso=[=[(X�.�' ')\1��'0 ',,X,' ']=]};
[139]={description=[=[Test for symmetricity of matrix X]=],
   arguments=[[X←A2]],
   utf=[=[⍎(¯7*A^.=⌽A←⍴X)↑'0~0∊X=⍉X']=],
   iso=[=[�(�7*A^.=�A��X)�'0~0�X=�X']=]};
[140]={description=[=[Execution of expression X with default value Y]=],
   arguments=[[X←D1]],
   utf=[=[⍎((X^.=' ')/'Y'),X]=],
   iso=[=[�((X^.=' ')/'Y'),X]=]};
[141]={description=[=[Changing X if a new input value is given]=],
   arguments=[[X←A]],
   utf=[=[X←⍎,((2↑'X'),' ',[.5]A)[⎕IO+~' '^.=A←⍞;]]=],
   iso=[=[X��,((2�'X'),' ',[.5]A)[�IO+~' '^.=A��;]]=]};
[142]={description=[=[Definite integral of F(X) in range Y with G steps ('X'∊F)]=],
   arguments=[[F←A1; G←D0; Y←D1; ⍴Y ←→ 2]],
   utf=[=[A+.×⍎F,0⍴X←Y[1]+(A←--/Y÷G)×0,⍳G]=],
   iso=[=[A+.��F,0�X�Y[1]+(A�--/Y�G)�0,�G]=]};
[143]={description=[=[Test if numeric and conversion to numeric form]=],
   arguments=[[X←C1]],
   utf=[=[1↓⍎'0 ',(^/X∊' 0123456789')/X]=],
   iso=[=[1��'0 ',(^/X�' 0123456789')/X]=]};
[144]={description=[=[Tests the social security number (Finnish)]=],
   arguments=[[Y←'01...9ABC...Z'; 10=⍴X]],
   utf=[=[(¯1↑X)=((~Y∊'GIOQ')/Y)[1+31|⍎9↑X]]=],
   iso=[=[(�1�X)=((~Y�'GIOQ')/Y)[1+31|�9�X]]=]};
[145]={description=[=[Conditional execution]=],
   arguments=[[X←B0]],
   utf=[=[⍎X/'EXPRESSION']=],
   iso=[=[�X/'EXPRESSION']=]};
[146]={description=[=[Conditional branch out of programs]=],
   arguments=[[X←B0]],
   utf=[=[⍎X/'→']=],
   iso=[=[�X/'�']=]};
[147]={description=[=[Using default value 100 if X does not exist]=],
   arguments=[[X←A]],
   utf=[=[⍎(¯3*2≠⎕NC 'X')↑'X100']=],
   iso=[=[�(�3*2��NC 'X')�'X100']=]};
[148]={description=[=[Conditional execution]=],
   arguments=[[X←B0]],
   utf=[=[⍎X↓'⍝ ...']=],
   iso=[=[�X�'� ...']=]};
[149]={description=[=[Giving a numeric default value for input]=],
   arguments=[[X←D0]],
   utf=[=[1⍴(⍎⍞,',⍳0'),X]=],
   iso=[=[1�(��,',�0'),X]=]};
[150]={description=[=[Assign values of expressions in X to variables named in Y]=],
   arguments=[[X←C2; Y←C2]],
   utf=[=[A←⍎,',','(','0','⍴',Y,'←',X,')']=],
   iso=[=[A��,',','(','0','�',Y,'�',X,')']=]};
[151]={description=[=[Evaluation of several expressions; results form a vector]=],
   arguments=[[X←A]],
   utf=[=[⍎,',','(',',',X,')']=],
   iso=[=[�,',','(',',',X,')']=]};
[152]={description=[=[Sum of numbers in character matrix X]=],
   arguments=[[X←A2]],
   utf=[=[⍎,'+',X]=],
   iso=[=[�,'+',X]=]};
[153]={description=[=[Indexing when rank is not known beforehand]=],
   arguments=[[X←A; Y←I]],
   utf=[=[⍎'X[',((¯1+⍴⍴X)⍴';'),'Y]']=],
   iso=[=[�'X[',((�1+��X)�';'),'Y]']=]};
[154]={description=[=[Numeric headers (elements of X) for rows of table Y]=],
   arguments=[[X←D1; Y←A2]],
   utf=[=[(3⌽7 0⍕X∘.+,0),⍕Y]=],
   iso=[=[(3�7 0�X�.+,0),�Y]=]};
[155]={description=[=[Formatting a numerical vector to run down the page]=],
   arguments=[[X←D1]],
   utf=[=[⍕X∘.+,0]=],
   iso=[=[�X�.+,0]=]};
[156]={description=[=[Representation of current date (ascending format)]=],
   arguments=[[]],
   utf=[=[A←⍕⌽3↑⎕TS ⋄ A[(' '=A)/⍳⍴A]←'.' ⋄ A]=],
   iso=[=[A���3��TS � A[(' '=A)/��A]�'.' � A]=]};
[157]={description=[=[Representation of current date (American)]=],
   arguments=[[]],
   utf=[=[A←⍕100|1⌽3↑⎕TS ⋄ A[(' '=A)/⍳⍴A]←'/' ⋄ A]=],
   iso=[=[A��100|1�3��TS � A[(' '=A)/��A]�'/' � A]=]};
[158]={description=[=[Formatting with zero values replaced with blanks]=],
   arguments=[[X←A]],
   utf=[=[(⍴A)⍴B\(B←,('0'≠A)∨' '≠¯1⌽A)/,A←' ',⍕X]=],
   iso=[=[(�A)�B\(B�,('0'�A)�' '��1�A)/,A�' ',�X]=]};
[159]={description=[=[Number of digit positions in scalar X (depends on ⎕PP)]=],
   arguments=[[X←D0]],
   utf=[=[⍴⍕X]=],
   iso=[=[��X]=]};
[160]={description=[=[Leading zeroes for X in fields of width Y]=],
   arguments=[[X←I1; Y←I0; X≥0]],
   utf=[=[0 1↓(2↑Y+1)⍕X∘.+,10*Y]=],
   iso=[=[0 1�(2�Y+1)�X�.+,10*Y]=]};
[161]={description=[=[Row-by-row formatting (width G) of X with Y decimals per row]=],
   arguments=[[X←D2; Y←I1; G←I0]],
   utf=[=[((1,G)×⍴X)⍴2 1 3⍉(⌽G,⍴X)⍴(,G,[1.1]Y)⍕⍉X]=],
   iso=[=[((1,G)��X)�2 1 3�(�G,�X)�(,G,[1.1]Y)��X]=]};
[163]={description=[=[Formatting X with H decimals in fields of width G]=],
   arguments=[[X←D; G←I1; H←I1]],
   utf=[=[(,G,[1.1]H)⍕X]=],
   iso=[=[(,G,[1.1]H)�X]=]};
[164]={description=[=[Y-shaped array of random numbers within ( X[1],X[2] ]]=],
   arguments=[[X←I1; Y←I1]],
   utf=[=[X[1]+?Y⍴--/X]=],
   iso=[=[X[1]+?Y�--/X]=]};
[165]={description=[=[Removing punctuation characters]=],
   arguments=[[X←A1]],
   utf=[=[(~X∊' .,:;?''')/X]=],
   iso=[=[(~X�' .,:;?''')/X]=]};
[166]={description=[=[Choosing Y objects out of ⍳X with replacement (roll)]=],
   arguments=[[Y←I; X←I]],
   utf=[=[?Y⍴X]=],
   iso=[=[?Y�X]=]};
[167]={description=[=[Choosing Y objects out of ⍳X without replacement (deal)]=],
   arguments=[[X←I0; Y←I0]],
   utf=[=[Y?X]=],
   iso=[=[Y?X]=]};
[168]={description=[=[Arctan Y÷X]=],
   arguments=[[X←D; Y←D]],
   utf=[=[((X≠0)×¯3○Y÷X+X=0)+○((X=0)×.5××Y)+(X<0)×1-2×Y<0]=],
   iso=[=[((X�0)��3�Y�X+X=0)+�((X=0)�.5��Y)+(X<0)�1-2�Y<0]=]};
[169]={description=[=[Conversion from degrees to radians]=],
   arguments=[[X←D]],
   utf=[=[X×○÷180]=],
   iso=[=[X���180]=]};
[170]={description=[=[Conversion from radians to degrees]=],
   arguments=[[X←D]],
   utf=[=[X×180÷○1]=],
   iso=[=[X�180��1]=]};
[171]={description=[=[Rotation matrix for angle X (in radians) counter-clockwise]=],
   arguments=[[X←D0]],
   utf=[=[2 2⍴1 ¯1 1 1×2 1 1 2○X]=],
   iso=[=[2 2�1 �1 1 1�2 1 1 2�X]=]};
[172]={description=[=[Number of permutations of X objects taken Y at a time]=],
   arguments=[[X←D; Y←D]],
   utf=[=[(!Y)×Y!X]=],
   iso=[=[(!Y)�Y!X]=]};
[173]={description=[=[Value of Taylor series with coefficients Y at point X]=],
   arguments=[[X←D0; Y←D1]],
   utf=[=[+/Y×(X*A)÷!A←¯1+⍳⍴Y]=],
   iso=[=[+/Y�(X*A)�!A��1+��Y]=]};
[174]={description=[=[Poisson distribution of states X with average number Y]=],
   arguments=[[X←I; Y←D0]],
   utf=[=[(*-Y)×(Y*X)÷!X]=],
   iso=[=[(*-Y)�(Y*X)�!X]=]};
[175]={description=[=[Gamma function]=],
   arguments=[[X←D0]],
   utf=[=[!X-1]=],
   iso=[=[!X-1]=]};
[176]={description=[=[Binomial distribution of X trials with probability Y]=],
   arguments=[[X←I0; Y←D0]],
   utf=[=[(A!X)×(Y*A)×(1-Y)*X-A←-⎕IO-⍳X+1]=],
   iso=[=[(A!X)�(Y*A)�(1-Y)*X-A�-�IO-�X+1]=]};
[177]={description=[=[Beta function]=],
   arguments=[[X←D0; Y←D0]],
   utf=[=[÷Y×(X-1)!Y+X-1]=],
   iso=[=[�Y�(X-1)!Y+X-1]=]};
[178]={description=[=[Selecting elements satisfying condition X, others to 1]=],
   arguments=[[X←B; Y←D]],
   utf=[=[X!Y]=],
   iso=[=[X!Y]=]};
[179]={description=[=[Number of combinations of X objects taken Y at a time]=],
   arguments=[[X←D; Y←D]],
   utf=[=[Y!X]=],
   iso=[=[Y!X]=]};
[180]={description=[=[Removing elements Y from beginning and end of vector X]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[((A⍳1)-⎕IO)↓(⎕IO-(⌽A←~X∊Y)⍳1)↓X]=],
   iso=[=[((A�1)-�IO)�(�IO-(�A�~X�Y)�1)�X]=]};
[181]={description=[=[Alphabetical comparison with alphabets G]=],
   arguments=[[X←A; Y←A]],
   utf=[=[(G⍳X)<G⍳Y]=],
   iso=[=[(G�X)<G�Y]=]};
[183]={description=[=[Sum over elements of X determined by elements of Y]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[X+.×Y∘.=((⍳⍴Y)=Y⍳Y)/Y]=],
   iso=[=[X+.�Y�.=((��Y)=Y�Y)/Y]=]};
[184]={description=[=[First occurrence of string X in string Y]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[(^⌿(¯1+⍳⍴X)⌽X∘.=Y)⍳1]=],
   iso=[=[(^�(�1+��X)�X�.=Y)�1]=]};
[185]={description=[=[Removing duplicate rows]=],
   arguments=[[X←A2]],
   utf=[=[((A⍳A)=⍳⍴A←⎕IO++⌿^⍀X∨.≠⍉X)⌿X]=],
   iso=[=[((A�A)=��A��IO++�^�X�.��X)�X]=]};
[186]={description=[=[First occurrence of string X in matrix Y]=],
   arguments=[[X←A1; Y←A2; ¯1↑⍴Y←→⍴X]],
   utf=[=[(Y^.=X)⍳1]=],
   iso=[=[(Y^.=X)�1]=]};
[187]={description=[=[Indices of ones in logical vector X]=],
   arguments=[[X←B1]],
   utf=[=[(+\X)⍳⍳+/X]=],
   iso=[=[(+\X)��+/X]=]};
[188]={description=[=[Executing costly monadic function F on repetitive arguments]=],
   arguments=[[X←A1]],
   utf=[=[(F B/X)[+\B←(X⍳X)=⍳⍴X]]=],
   iso=[=[(F B/X)[+\B�(X�X)=��X]]=]};
[189]={description=[=[Index of (first) maximum element of X]=],
   arguments=[[X←D1]],
   utf=[=[X⍳⌈/X]=],
   iso=[=[X��/X]=]};
[190]={description=[=[Index of first occurrence of elements of Y]=],
   arguments=[[X←C1; Y←C1]],
   utf=[=[⌊/X⍳Y]=],
   iso=[=[�/X�Y]=]};
[191]={description=[=[Index of (first) minimum element of X]=],
   arguments=[[X←D1]],
   utf=[=[X⍳⌊/X]=],
   iso=[=[X��/X]=]};
[192]={description=[=[Test if each element of X occurs only once]=],
   arguments=[[X←A1]],
   utf=[=[^/(X⍳X)=⍳⍴X]=],
   iso=[=[^/(X�X)=��X]=]};
[193]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←A1]],
   utf=[=[^/⎕IO=X⍳X]=],
   iso=[=[^/�IO=X�X]=]};
[194]={description=[=[Interpretation of roman numbers]=],
   arguments=[[X←A]],
   utf=[=[+/A×¯1*A<1⌽A←0,(1000 500 100 50 10 5 1)['MDCLXVI'⍳X]]=],
   iso=[=[+/A��1*A<1�A�0,(1000 500 100 50 10 5 1)['MDCLXVI'�X]]=]};
[195]={description=[=[Removing elements Y from end of vector X]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(⎕IO-(~⌽X∊Y)⍳1)↓X]=],
   iso=[=[(�IO-(~�X�Y)�1)�X]=]};
[196]={description=[=[Removing trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[(1-(⌽' '≠X)⍳1)↓X]=],
   iso=[=[(1-(�' '�X)�1)�X]=]};
[198]={description=[=[Index of last occurrence of Y in X (⎕IO-1 if not found)]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[((¯1 1)[2×⎕IO]+⍴X)-(⌽X)⍳Y]=],
   iso=[=[((�1 1)[2��IO]+�X)-(�X)�Y]=]};
[199]={description=[=[Index of last occurrence of Y in X (0 if not found)]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(1+⍴X)-(⌽X)⍳Y]=],
   iso=[=[(1+�X)-(�X)�Y]=]};
[200]={description=[=[Index of last occurrence of Y in X, counted from the rear]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(⌽X)⍳Y]=],
   iso=[=[(�X)�Y]=]};
[201]={description=[=[Index of first occurrence of G in X (circularly) after Y]=],
   arguments=[[X←A1; Y←I0; G←A]],
   utf=[=[⎕IO+(⍴X)|Y+(Y⌽X)⍳G]=],
   iso=[=[�IO+(�X)|Y+(Y�X)�G]=]};
[202]={description=[=[Alphabetizing X; equal alphabets in same column of Y]=],
   arguments=[[Y←C2; X←C]],
   utf=[=[(¯1↑⍴Y)|(,Y)⍳X]=],
   iso=[=[(�1��Y)|(,Y)�X]=]};
[203]={description=[=[Changing index of an unfound element to zero]=],
   arguments=[[Y←A1; X←A]],
   utf=[=[(1+⍴Y)|Y⍳X]=],
   iso=[=[(1+�Y)|Y�X]=]};
[204]={description=[=[Replacing elements of G in set X with corresponding Y]=],
   arguments=[[X←A1, Y←A1, G←A]],
   utf=[=[A[B/⍳⍴B]←Y[(B←B≤⍴Y)/B←X⍳A←,G] ⋄ (⍴G)⍴A]=],
   iso=[=[A[B/��B]�Y[(B�B��Y)/B�X�A�,G] � (�G)�A]=]};
[205]={description=[=[Removing duplicate elements (nub)]=],
   arguments=[[X←A1]],
   utf=[=[((X⍳X)=⍳⍴X)/X]=],
   iso=[=[((X�X)=��X)/X]=]};
[206]={description=[=[First word in X]=],
   arguments=[[X←C1]],
   utf=[=[(¯1+X⍳' ')↑X]=],
   iso=[=[(�1+X�' ')�X]=]};
[207]={description=[=[Removing elements Y from beginning of vector X]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(((~X∊Y)⍳1)-⎕IO)↓X]=],
   iso=[=[(((~X�Y)�1)-�IO)�X]=]};
[208]={description=[=[Removing leading zeroes]=],
   arguments=[[X←A1]],
   utf=[=[(¯1+(X='0')⍳0)↓X]=],
   iso=[=[(�1+(X='0')�0)�X]=]};
[209]={description=[=[Index of first one after index Y in X]=],
   arguments=[[G←I0; X←B1]],
   utf=[=[Y+(Y↓X)⍳1]=],
   iso=[=[Y+(Y�X)�1]=]};
[210]={description=[=[Changing index of an unfound element to zero (not effective)]=],
   arguments=[[X←A; Y←A1]],
   utf=[=[(X∊Y)×Y⍳X]=],
   iso=[=[(X�Y)�Y�X]=]};
[211]={description=[=[Indicator of first occurrence of each unique element of X]=],
   arguments=[[X←A1]],
   utf=[=[(X⍳X)=⍳⍴X]=],
   iso=[=[(X�X)=��X]=]};
[212]={description=[=[Inverting a permutation]=],
   arguments=[[X←I1]],
   utf=[=[X⍳⍳⍴X]=],
   iso=[=[X���X]=]};
[213]={description=[=[Index of first differing element in vectors X and Y]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[(Y≠X)⍳1]=],
   iso=[=[(Y�X)�1]=]};
[214]={description=[=[Which elements of X are not in set Y (difference of sets)]=],
   arguments=[[X←A; Y←A1]],
   utf=[=[(⎕IO+⍴Y)=Y⍳X]=],
   iso=[=[(�IO+�Y)=Y�X]=]};
[215]={description=[=[Changing numeric code X into corresponding name in Y]=],
   arguments=[[X←D; Y←D1; G←C2]],
   utf=[=[G[Y⍳X;]]=],
   iso=[=[G[Y�X;]]=]};
[216]={description=[=[Index of key Y in key vector X]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[X⍳Y]=],
   iso=[=[X�Y]=]};
[217]={description=[=[Conversion from characters to numeric codes]=],
   arguments=[[X←A]],
   utf=[=[⎕AV⍳X]=],
   iso=[=[�AV�X]=]};
[218]={description=[=[Index of first satisfied condition in X]=],
   arguments=[[X←B1]],
   utf=[=[X⍳1]=],
   iso=[=[X�1]=]};
[219]={description=[=[Pascal's triangle of order X (binomial coefficients)]=],
   arguments=[[X←I0]],
   utf=[=[⍉A∘.!A←0,⍳X]=],
   iso=[=[�A�.!A�0,�X]=]};
[220]={description=[=[Maximum table]=],
   arguments=[[X←I0]],
   utf=[=[(⍳X)∘.⌈⍳X]=],
   iso=[=[(�X)�.��X]=]};
[221]={description=[=[Number of decimals (up to Y) of elements of X]=],
   arguments=[[X←D; Y←I0]],
   utf=[=[0+.≠(⌈(10*Y)×10*⎕IO-⍳Y+1)∘.|⌈X×10*Y]=],
   iso=[=[0+.�(�(10*Y)�10*�IO-�Y+1)�.|�X�10*Y]=]};
[222]={description=[=[Greatest common divisor of elements of X]=],
   arguments=[[X←I1]],
   utf=[=[⌈/(^/0=A∘.|X)/A←⍳⌊/X]=],
   iso=[=[�/(^/0=A�.|X)/A���/X]=]};
[223]={description=[=[Divisibility table]=],
   arguments=[[X←I1]],
   utf=[=[0=(⍳⌈/X)∘.|X]=],
   iso=[=[0=(��/X)�.|X]=]};
[224]={description=[=[All primes up to X]=],
   arguments=[[X←I0]],
   utf=[=[(2=+⌿0=(⍳X)∘.|⍳X)/⍳X]=],
   iso=[=[(2=+�0=(�X)�.|�X)/�X]=]};
[225]={description=[=[Compound interest for principals Y at rates G % in times X]=],
   arguments=[[X←D; Y←D; G←D]],
   utf=[=[Y∘.×(1+G÷100)∘.*X]=],
   iso=[=[Y�.�(1+G�100)�.*X]=]};
[226]={description=[=[Product of two polynomials with coefficients X and Y]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[+⌿(⎕IO-⍳⍴X)⌽X∘.×Y,0×1↓X]=],
   iso=[=[+�(�IO-��X)�X�.�Y,0�1�X]=]};
[228]={description=[=[Shur product]=],
   arguments=[[X←D2; Y←D2]],
   utf=[=[1 2 1 2⍉X∘.×Y]=],
   iso=[=[1 2 1 2�X�.�Y]=]};
[229]={description=[=[Direct matrix product]=],
   arguments=[[X←D2; Y←D2]],
   utf=[=[1 3 2 4⍉X∘.×Y]=],
   iso=[=[1 3 2 4�X�.�Y]=]};
[230]={description=[=[Multiplication table]=],
   arguments=[[X←I0]],
   utf=[=[(⍳X)∘.×⍳X]=],
   iso=[=[(�X)�.��X]=]};
[231]={description=[=[Replicating a dimension of rank three array X Y-fold]=],
   arguments=[[Y←I0; X←A3]],
   utf=[=[X[;,(Y⍴1)∘.×⍳(⍴X)[2];]]=],
   iso=[=[X[;,(Y�1)�.��(�X)[2];]]=]};
[232]={description=[=[Array and its negative ('plus minus')]=],
   arguments=[[X←D]],
   utf=[=[X∘.×1 ¯1]=],
   iso=[=[X�.�1 �1]=]};
[233]={description=[=[Move set of points X into first quadrant]=],
   arguments=[[X←D2]],
   utf=[=[1 2 1⍉X∘.-⌊/X]=],
   iso=[=[1 2 1�X�.-�/X]=]};
[234]={description=[=[Test relations of elements of X to range Y; result in ¯2..2]=],
   arguments=[[X←D; Y←D; 2=¯1↑⍴Y]],
   utf=[=[+/×X∘.-Y]=],
   iso=[=[+/�X�.-Y]=]};
[235]={description=[=[Occurrences of string X in string Y]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[(Y[A∘.+¯1+⍳⍴X]^.=X)/A←(A=1↑X)/⍳⍴A←(1-⍴X)↓Y]=],
   iso=[=[(Y[A�.+�1+��X]^.=X)/A�(A=1�X)/��A�(1-�X)�Y]=]};
[236]={description=[=[Sum of common parts of matrices (matrix sum)]=],
   arguments=[[X←D2; Y←D2]],
   utf=[=[1 2 1 2⍉X∘.+Y]=],
   iso=[=[1 2 1 2�X�.+Y]=]};
[237]={description=[=[Adding X to each row of Y]=],
   arguments=[[X←D1; Y←D2]],
   utf=[=[1 1 2⍉X∘.+Y]=],
   iso=[=[1 1 2�X�.+Y]=]};
[238]={description=[=[Adding X to each row of Y]=],
   arguments=[[X←D1; Y←D2]],
   utf=[=[1 2 1⍉Y∘.+X]=],
   iso=[=[1 2 1�Y�.+X]=]};
[240]={description=[=[Adding X to each column of Y]=],
   arguments=[[X←D1; Y←D2]],
   utf=[=[2 1 2⍉X∘.+Y]=],
   iso=[=[2 1 2�X�.+Y]=]};
[241]={description=[=[Adding X to each column of Y]=],
   arguments=[[X←D1; Y←D2]],
   utf=[=[1 2 2⍉Y∘.+X]=],
   iso=[=[1 2 2�Y�.+X]=]};
[242]={description=[=[Hilbert matrix of order X]=],
   arguments=[[X←I0]],
   utf=[=[÷¯1+(⍳X)∘.+⍳X]=],
   iso=[=[ߢ1+(�X)�.+�X]=]};
[243]={description=[=[Moving index of width Y for vector X]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[(0,⍳(⍴X)-Y)∘.+Y]=],
   iso=[=[(0,�(�X)-Y)�.+Y]=]};
[244]={description=[=[Indices of subvectors of length Y starting at X+1]=],
   arguments=[[X←I1; Y←I0]],
   utf=[=[X∘.+⍳Y]=],
   iso=[=[X�.+�Y]=]};
[245]={description=[=[Reshaping numeric vector X into a one-column matrix]=],
   arguments=[[X←D1]],
   utf=[=[X∘.+,0]=],
   iso=[=[X�.+,0]=]};
[246]={description=[=[Annuity coefficient: X periods at interest rate Y %]=],
   arguments=[[X←I; Y←D]],
   utf=[=[((⍴A)⍴Y÷100)÷A←⍉1-(1+Y÷100)∘.*-X]=],
   iso=[=[((�A)�Y�100)�A��1-(1+Y�100)�.*-X]=]};
[247]={description=[=[Matrix with X[i] trailing zeroes on row i]=],
   arguments=[[X←I1]],
   utf=[=[X∘.<⌽⍳⌈/X]=],
   iso=[=[X�.<���/X]=]};
[248]={description=[=[Matrix with X[i] leading zeroes on row i]=],
   arguments=[[X←I1]],
   utf=[=[X∘.<⍳⌈/X]=],
   iso=[=[X�.<��/X]=]};
[249]={description=[=[Distribution of X into intervals between Y]=],
   arguments=[[X←D; Y←D1]],
   utf=[=[+/((¯1↓Y)∘.≤X)^(1↓Y)∘.>X]=],
   iso=[=[+/((�1�Y)�.�X)^(1�Y)�.>X]=]};
[250]={description=[=[Histogram (distribution barchart; down the page)]=],
   arguments=[[X←I1]],
   utf=[=[' ⎕'[⎕IO+(⌽⍳⌈/A)∘.≤A←+/(⍳1+(⌈/X)-⌊/X)∘.=X]]=],
   iso=[=[' �'[�IO+(���/A)�.�A�+/(�1+(�/X)-�/X)�.=X]]=]};
[251]={description=[=[Barchart of integer values (down the page)]=],
   arguments=[[X←I1]],
   utf=[=[' ⎕'[⎕IO+(⌽⍳⌈/X)∘.≤X]]=],
   iso=[=[' �'[�IO+(���/X)�.�X]]=]};
[252]={description=[=[Test if X is an upper triangular matrix]=],
   arguments=[[X←D2]],
   utf=[=[^/,(0≠X)≤A∘.≤A←⍳1↑⍴X]=],
   iso=[=[^/,(0�X)�A�.�A��1��X]=]};
[253]={description=[=[Number of ?s intersecting ?s (X=starts, Y=stops)]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[+/A^⍉A←X∘.≤Y]=],
   iso=[=[+/A^�A�X�.�Y]=]};
[254]={description=[=[Contour levels Y at points with altitudes X]=],
   arguments=[[X←D0; Y←D1]],
   utf=[=[Y[+⌿Y∘.≤X]]=],
   iso=[=[Y[+�Y�.�X]]=]};
[255]={description=[=[X×X upper triangular matrix]=],
   arguments=[[X←I0]],
   utf=[=[(⍳X)∘.≤⍳X]=],
   iso=[=[(�X)�.��X]=]};
[256]={description=[=[Classification of elements Y into X classes of equal size]=],
   arguments=[[X←I0; Y←D1]],
   utf=[=[+/(A×X÷⌈/A←Y-⌊/Y)∘.≥¯1+⍳X]=],
   iso=[=[+/(A�X��/A�Y-�/Y)�.��1+�X]=]};
[257]={description=[=[Matrix with X[i] trailing ones on row i]=],
   arguments=[[X←I1]],
   utf=[=[X∘.≥⌽⍳⌈/X]=],
   iso=[=[X�.����/X]=]};
[258]={description=[=[Comparison table]=],
   arguments=[[X←I1]],
   utf=[=[X∘.≥⍳⌈/X,0]=],
   iso=[=[X�.���/X,0]=]};
[259]={description=[=[Barchart of X with height Y (across the page)]=],
   arguments=[[X←D1; Y←D0]],
   utf=[=[' ⎕'[⎕IO+X∘.≥(⌈/X)×(⍳Y)÷Y]]=],
   iso=[=[' �'[�IO+X�.�(�/X)�(�Y)�Y]]=]};
[260]={description=[=[Barchart of integer values (across the page)]=],
   arguments=[[X←I1]],
   utf=[=[' ⎕'[⎕IO+X∘.≥⍳⌈/X]]=],
   iso=[=[' �'[�IO+X�.���/X]]=]};
[261]={description=[=[Matrix with X[i] leading ones on row i]=],
   arguments=[[X←I1]],
   utf=[=[X∘.≥⍳⌈/X]=],
   iso=[=[X�.���/X]=]};
[263]={description=[=[Test if X is a lower triangular matrix]=],
   arguments=[[X←D2]],
   utf=[=[^/,(0≠X)≤A∘.≥A←⍳1↑⍴X]=],
   iso=[=[^/,(0�X)�A�.�A��1��X]=]};
[264]={description=[=[Test if X is within range [ Y[1],Y[2] )]=],
   arguments=[[X←D; Y←D1]],
   utf=[=[≠/X∘.≥Y]=],
   iso=[=[�/X�.�Y]=]};
[265]={description=[=[Ordinal numbers of words in X that indices Y point to]=],
   arguments=[[X←C1; Y←I]],
   utf=[=[⎕IO++/Y∘.≥(' '=X)/⍳⍴X]=],
   iso=[=[�IO++/Y�.�(' '=X)/��X]=]};
[266]={description=[=[Which class do elements of X belong to]=],
   arguments=[[X←D]],
   utf=[=[+/X∘.≥0 50 100 1000]=],
   iso=[=[+/X�.�0 50 100 1000]=]};
[267]={description=[=[X×X lower triangular matrix]=],
   arguments=[[X←I0]],
   utf=[=[(⍳X)∘.≥⍳X]=],
   iso=[=[(�X)�.��X]=]};
[268]={description=[=[Moving all blanks to end of each row]=],
   arguments=[[X←C]],
   utf=[=[(⍴X)⍴(,(+/A)∘.>-⎕IO-⍳¯1↑⍴X)\(,A←X≠' ')/,X]=],
   iso=[=[(�X)�(,(+/A)�.>-�IO-ɢ1��X)\(,A�X�' ')/,X]=]};
[269]={description=[=[Justifying right fields of X (lengths Y) to length G]=],
   arguments=[[X←A1; Y←I1; G←I0]],
   utf=[=[(,Y∘.>⌽(⍳G)-⎕IO)\X]=],
   iso=[=[(,Y�.>�(�G)-�IO)\X]=]};
[270]={description=[=[Justifying left fields of X (lengths Y) to length G]=],
   arguments=[[X←A1; Y←I1; G←I0]],
   utf=[=[(,Y∘.>(⍳G)-⎕IO)\X]=],
   iso=[=[(,Y�.>(�G)-�IO)\X]=]};
[271]={description=[=[Indices of elements of Y in corr. rows of X (X[i;]⍳Y[i;])]=],
   arguments=[[X←A2; Y←A2]],
   utf=[=[1++/^\1 2 1 3⍉Y∘.≠X]=],
   iso=[=[1++/^\1 2 1 3�Y�.�X]=]};
[273]={description=[=[Indicating equal elements of X as a logical matrix]=],
   arguments=[[X←A1]],
   utf=[=[⍉X∘.=(1 1⍉<\X∘.=X)/X]=],
   iso=[=[�X�.=(1 1�<\X�.=X)/X]=]};
[275]={description=[=[Changing connection matrix X (¯1 → 1) to a node matrix]=],
   arguments=[[X←I2]],
   utf=[=[(1 ¯1∘.=⍉X)+.×⍳1↑⍴⎕←X]=],
   iso=[=[(1 �1�.=�X)+.��1����X]=]};
[276]={description=[=[Sums according to codes G]=],
   arguments=[[X←A; Y←D; G←A]],
   utf=[=[(G∘.=X)+.×Y]=],
   iso=[=[(G�.=X)+.�Y]=]};
[277]={description=[=[Removing duplicate elements (nub)]=],
   arguments=[[X←A1]],
   utf=[=[(1 1⍉<\X∘.=X)/X]=],
   iso=[=[(1 1�<\X�.=X)/X]=]};
[278]={description=[=[Changing node matrix X (starts,ends) to a connection matrix]=],
   arguments=[[X←I2]],
   utf=[=[-/(⍳⌈/,X)∘.=⍉X]=],
   iso=[=[-/(��/,X)�.=�X]=]};
[279]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[∨/^/0 1∘.=X]=],
   iso=[=[�/^/0 1�.=X]=]};
[280]={description=[=[Test if elements of X belong to corr. row of Y (X[i;]∊Y[i;])]=],
   arguments=[[X←A2; Y←A2; 1↑⍴X←→1↑⍴Y]],
   utf=[=[∨/1 2 1 3⍉X∘.=Y]=],
   iso=[=[�/1 2 1 3�X�.=Y]=]};
[281]={description=[=[Test if X is a permutation vector]=],
   arguments=[[X←I1]],
   utf=[=[^/1=+⌿X∘.=⍳⍴X]=],
   iso=[=[^/1=+�X�.=��X]=]};
[282]={description=[=[Occurrences of string X in string Y]=],
   arguments=[[X←C1; Y←C1]],
   utf=[=[(^⌿(¯1+⍳⍴X)⌽(X∘.=Y),0)/⍳1+⍴Y]=],
   iso=[=[(^�(�1+��X)�(X�.=Y),0)/�1+�Y]=]};
[283]={description=[=[Division to Y classes with width H, minimum G]=],
   arguments=[[X←D; Y←I0; G←D0; H←D0]],
   utf=[=[+/(⍳Y)∘.=⌈(X-G)÷H]=],
   iso=[=[+/(�Y)�.=�(X-G)�H]=]};
[285]={description=[=[Repeat matrix]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[(((¯1⌽~A)^A←(¯1↓X=1⌽X),0)/Y)∘.=Y]=],
   iso=[=[(((�1�~A)^A�(�1�X=1�X),0)/Y)�.=Y]=]};
[286]={description=[=[X×X identity matrix]=],
   arguments=[[X←I0]],
   utf=[=[(⍳X)∘.=⍳X]=],
   iso=[=[(�X)�.=�X]=]};
[287]={description=[=[Maxima of elements of subsets of X specified by Y]=],
   arguments=[[X←A1; Y←B]],
   utf=[=[A+(X-A←⌊/X)⌈.×Y]=],
   iso=[=[A+(X-A��/X)�.�Y]=]};
[288]={description=[=[Indices of last non-blanks in rows]=],
   arguments=[[X←C]],
   utf=[=[(' '≠X)⌈.×⍳¯1↑⍴X]=],
   iso=[=[(' '�X)�.�ɢ1��X]=]};
[289]={description=[=[Maximum of X with weights Y]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[Y⌈.×X]=],
   iso=[=[Y�.�X]=]};
[290]={description=[=[Minimum of X with weights Y]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[Y⌊.×X]=],
   iso=[=[Y�.�X]=]};
[292]={description=[=[Extending a distance table to next leg]=],
   arguments=[[X←D2]],
   utf=[=[X←X⌊.+X]=],
   iso=[=[X�X�.+X]=]};
[293]={description=[=[A way to combine trigonometric functions (sin X cos Y)]=],
   arguments=[[X←D0; Y←D0]],
   utf=[=[1 2×.○X,Y]=],
   iso=[=[1 2�.�X,Y]=]};
[294]={description=[=[Sine of a complex number]=],
   arguments=[[X←D; 2=1↑⍴X]],
   utf=[=[(2 2⍴1 6 2 5)×.○X]=],
   iso=[=[(2 2�1 6 2 5)�.�X]=]};
[295]={description=[=[Products over subsets of X specified by Y]=],
   arguments=[[X←A1; Y←B]],
   utf=[=[X×.*Y]=],
   iso=[=[X�.*Y]=]};
[296]={description=[=[Sum of squares of X]=],
   arguments=[[X←D1]],
   utf=[=[X+.*2]=],
   iso=[=[X+.*2]=]};
[297]={description=[=[Randomizing random numbers (in ⎕LX in a workspace)]=],
   arguments=[[]],
   utf=[=[⎕RL←⎕TS+.*2]=],
   iso=[=[�RL��TS+.*2]=]};
[298]={description=[=[Extending a transitive binary relation]=],
   arguments=[[X←B2]],
   utf=[=[X←X∨.^X]=],
   iso=[=[X�X�.^X]=]};
[299]={description=[=[Test if X is within range [ Y[1;],Y[2;] )]=],
   arguments=[[X←D0; Y←D2; 1↑⍴Y ←→ 2]],
   utf=[=[X<.<Y]=],
   iso=[=[X<.<Y]=]};
[300]={description=[=[Test if X is within range ( Y[1;],Y[2;] ]]=],
   arguments=[[X←D0; Y←D2; 1↑⍴Y ←→ 2]],
   utf=[=[X<.≤Y]=],
   iso=[=[X<.�Y]=]};
[301]={description=[=[Test if X is within range ( Y[1;],Y[2;] ]]=],
   arguments=[[X←D; Y←D2; 1↑⍴Y ←→ 2]],
   utf=[=[X<.≤Y]=],
   iso=[=[X<.�Y]=]};
[302]={description=[=[Test if the elements of X are ascending]=],
   arguments=[[X←D1]],
   utf=[=[X<.≥1⌽X]=],
   iso=[=[X<.�1�X]=]};
[303]={description=[=[Test if X is an integer within range [ G,H )]=],
   arguments=[[X←I0; G←I0; H←I0]],
   utf=[=[~X≤.≥(⌈X),G,H]=],
   iso=[=[~X�.�(�X),G,H]=]};
[304]={description=[=[Test if X is within range ( Y[1;],Y[2;] ]]=],
   arguments=[[X←D; Y←D2; 1↑⍴Y ←→ 2]],
   utf=[=[(X,[.1+⍴⍴X]X)>.>Y]=],
   iso=[=[(X,[.1+��X]X)>.>Y]=]};
[306]={description=[=[Removing trailing blank columns]=],
   arguments=[[X←C2]],
   utf=[=[(⌽∨\⌽' '∨.≠X)/X]=],
   iso=[=[(��\�' '�.�X)/X]=]};
[307]={description=[=[Removing leading blank rows]=],
   arguments=[[X←C2]],
   utf=[=[(∨\X∨.≠' ')⌿X]=],
   iso=[=[(�\X�.�' ')�X]=]};
[308]={description=[=[Removing leading blank columns]=],
   arguments=[[X←C2]],
   utf=[=[(∨\' '∨.≠X)/X]=],
   iso=[=[(�\' '�.�X)/X]=]};
[309]={description=[=[Index of first occurrences of rows of X as rows of Y]=],
   arguments=[[X←A, Y←A2]],
   utf=[=[⎕IO++⌿^⍀Y∨.≠⍉X]=],
   iso=[=[�IO++�^�Y�.��X]=]};
[310]={description=[=[X⍳Y for rows of matrices]=],
   arguments=[[X←A2; Y←A2]],
   utf=[=[⎕IO++⌿^⍀X∨.≠⍉Y]=],
   iso=[=[�IO++�^�X�.��Y]=]};
[311]={description=[=[Removing duplicate blank rows]=],
   arguments=[[X←C2]],
   utf=[=[(A∨1↓1⌽1,A←X∨.≠' ')⌿X]=],
   iso=[=[(A�1�1�1,A�X�.�' ')�X]=]};
[312]={description=[=[Removing duplicate blank columns]=],
   arguments=[[X←C2]],
   utf=[=[(A∨1,¯1↓A←' '∨.≠X)/X]=],
   iso=[=[(A�1,�1�A�' '�.�X)/X]=]};
[313]={description=[=[Removing blank columns]=],
   arguments=[[X←C2]],
   utf=[=[(' '∨.≠X)/X]=],
   iso=[=[(' '�.�X)/X]=]};
[314]={description=[=[Removing blank rows]=],
   arguments=[[X←C2]],
   utf=[=[(X∨.≠' ')⌿X]=],
   iso=[=[(X�.�' ')�X]=]};
[315]={description=[=[Test if rows of X contain elements differing from Y]=],
   arguments=[[X←A; Y←A0]],
   utf=[=[X∨.≠Y]=],
   iso=[=[X�.�Y]=]};
[316]={description=[=[Removing trailing blank rows]=],
   arguments=[[X←C2]],
   utf=[=[(-2↑+/^\⌽X^.=' ')↓X]=],
   iso=[=[(-2�+/^\�X^.=' ')�X]=]};
[317]={description=[=[Removing duplicate rows]=],
   arguments=[[X←A2]],
   utf=[=[(∨⌿<\X^.=⍉X)⌿X]=],
   iso=[=[(��<\X^.=�X)�X]=]};
[318]={description=[=[Removing duplicate rows]=],
   arguments=[[X←A2]],
   utf=[=[(1 1⍉<\X^.=⍉X)⌿X]=],
   iso=[=[(1 1�<\X^.=�X)�X]=]};
[319]={description=[=[Test if circular lists are equal (excluding phase)]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[∨/Y^.=⍉(⍳⍴X)⌽(2⍴⍴X)⍴X]=],
   iso=[=[�/Y^.=�(��X)�(2��X)�X]=]};
[320]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[X^.=∨/X]=],
   iso=[=[X^.=�/X]=]};
[321]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[X^.=^/X]=],
   iso=[=[X^.=^/X]=]};
[322]={description=[=[Rows of matrix X starting with string Y]=],
   arguments=[[X←A2; Y←A1]],
   utf=[=[((((1↑⍴X),⍴Y)↑X)^.=Y)⌿X]=],
   iso=[=[((((1��X),�Y)�X)^.=Y)�X]=]};
[323]={description=[=[Occurrences of string X in string Y]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[((-A)↓X^.=(A,1+⍴Y)⍴Y)/⍳(⍴Y)+1-A←⍴X]=],
   iso=[=[((-A)�X^.=(A,1+�Y)�Y)/�(�Y)+1-A��X]=]};
[324]={description=[=[Test if vector Y is a row of array X]=],
   arguments=[[X←A; Y←A1]],
   utf=[=[1∊X^.=Y]=],
   iso=[=[1�X^.=Y]=]};
[325]={description=[=[Comparing vector Y with rows of array X]=],
   arguments=[[X←A; Y←A1]],
   utf=[=[X^.=Y]=],
   iso=[=[X^.=Y]=]};
[326]={description=[=[Word lengths of words in list X]=],
   arguments=[[X←C]],
   utf=[=[X+.≠' ']=],
   iso=[=[X+.�' ']=]};
[327]={description=[=[Number of occurrences of scalar X in array Y]=],
   arguments=[[X←A0; Y←A]],
   utf=[=[X+.=,Y]=],
   iso=[=[X+.=,Y]=]};
[328]={description=[=[Counting pairwise matches (equal elements) in two vectors]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[X+.=Y]=],
   iso=[=[X+.=Y]=]};
[329]={description=[=[Sum of alternating reciprocal series Y÷X]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[Y-.÷X]=],
   iso=[=[Y-.�X]=]};
[330]={description=[=[Limits X to fit in ⍕ field Y[1 2]]=],
   arguments=[[X←D; Y←I1]],
   utf=[=[(X⌈1↓A)⌊1↑A←(2 2⍴¯1 1 1 ¯.1)+.×10*(-1↓Y),-/Y+Y>99 0]=],
   iso=[=[(X�1�A)�1�A�(2 2Ң1 1 1 �.1)+.�10*(-1�Y),-/Y+Y>99 0]=]};
[331]={description=[=[Value of polynomial with coefficients Y at point X]=],
   arguments=[[X←D0; Y←D]],
   utf=[=[(X*¯1+⍳⍴Y)+.×⌽Y]=],
   iso=[=[(X*�1+��Y)+.��Y]=]};
[332]={description=[=[Arithmetic average (mean value) of X weighted by Y]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[(Y+.×X)÷⍴X]=],
   iso=[=[(Y+.�X)��X]=]};
[333]={description=[=[Scalar (dot) product of vectors]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[Y+.×X]=],
   iso=[=[Y+.�X]=]};
[334]={description=[=[Sum of squares of X]=],
   arguments=[[X←D1]],
   utf=[=[X+.×X]=],
   iso=[=[X+.�X]=]};
[335]={description=[=[Summation over subsets of X specified by Y]=],
   arguments=[[X←A1; Y←B]],
   utf=[=[X+.×Y]=],
   iso=[=[X+.�Y]=]};
[336]={description=[=[Matrix product]=],
   arguments=[[X←D; Y←D; ¯1↑⍴X ←→ 1↑⍴Y]],
   utf=[=[X+.×Y]=],
   iso=[=[X+.�Y]=]};
[337]={description=[=[Sum of reciprocal series Y÷X]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[Y+.÷X]=],
   iso=[=[Y+.�X]=]};
[338]={description=[=[Groups of ones in Y pointed to by X (or trailing parts)]=],
   arguments=[[X←B; Y←B]],
   utf=[=[Y^A=⌈\X×A←+\Y>¯1↓0,Y]=],
   iso=[=[Y^A=�\X�A�+\Y>�1�0,Y]=]};
[339]={description=[=[Test if X is in ascending order along direction Y]=],
   arguments=[[X←D; Y←I0]],
   utf=[=[^/[Y]X=⌈\[Y]X]=],
   iso=[=[^/[Y]X=�\[Y]X]=]};
[340]={description=[=[Duplicating element of X belonging to Y,1↑X until next found]=],
   arguments=[[X←A1; Y←B1]],
   utf=[=[X[1⌈⌈\Y×⍳⍴Y]]=],
   iso=[=[X[1��\Y���Y]]=]};
[341]={description=[=[Test if X is in descending order along direction Y]=],
   arguments=[[X←D; Y←I0]],
   utf=[=[^/[Y]X=⌊\[Y]X]=],
   iso=[=[^/[Y]X=�\[Y]X]=]};
[342]={description=[=[Value of Taylor series with coefficients Y at point X]=],
   arguments=[[X←D0; Y←D1]],
   utf=[=[+/Y××\1,X÷⍳¯1+⍴Y]=],
   iso=[=[+/Y��\1,X�ɢ1+�Y]=]};
[343]={description=[=[Alternating series (1 ¯1 2 ¯2 3 ¯3 ...)]=],
   arguments=[[X←I0]],
   utf=[=[-\⍳X]=],
   iso=[=[-\�X]=]};
[346]={description=[=[Value of saddle point]=],
   arguments=[[X←D2]],
   utf=[=[(<\,(X=(⍴X)⍴⌈⌿X)^X=⍉(⌽⍴X)⍴⌊/X)/,X]=],
   iso=[=[(<\,(X=(�X)�ӯX)^X=�(��X)��/X)/,X]=]};
[348]={description=[=[First one (turn off all ones after first one)]=],
   arguments=[[X←B]],
   utf=[=[<\X]=],
   iso=[=[<\X]=]};
[350]={description=[=[Not first zero (turn on all zeroes after first zero)]=],
   arguments=[[X←B]],
   utf=[=[≤\X]=],
   iso=[=[�\X]=]};
[351]={description=[=[Running parity (≠\) over subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[≠\Y≠X\A≠¯1↓0,A←X/≠\¯1↓0,Y]=],
   iso=[=[�\Y�X\A��1�0,A�X/�\�1�0,Y]=]};
[352]={description=[=[Vector (X[1]⍴1),(X[2]⍴0),(X[3]⍴1),...]=],
   arguments=[[X←I1]],
   utf=[=[≠\(⍳+/X)∊+\⎕IO,X]=],
   iso=[=[�\(�+/X)�+\�IO,X]=]};
[353]={description=[=[Not leading zeroes(∨\) in each subvector of Y indicated by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[≠\(Y∨X)\A≠¯1↓0,A←(Y∨X)/Y]=],
   iso=[=[�\(Y�X)\A��1�0,A�(Y�X)/Y]=]};
[354]={description=[=[Leading ones (`^\) in each subvector of Y indicated by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[~≠\(Y≤X)\A≠¯1↓0,A←~(Y≤X)/Y]=],
   iso=[=[~�\(Y�X)\A��1�0,A�~(Y�X)/Y]=]};
[355]={description=[=[Locations of texts between and including quotes]=],
   arguments=[[X←C1]],
   utf=[=[A∨¯1↓0,A←≠\X='''']=],
   iso=[=[A��1�0,A��\X='''']=]};
[356]={description=[=[Locations of texts between quotes]=],
   arguments=[[X←C1]],
   utf=[=[A^¯1↓0,A←≠\X='''']=],
   iso=[=[A^�1�0,A��\X='''']=]};
[357]={description=[=[Joining pairs of ones]=],
   arguments=[[X←B]],
   utf=[=[X∨≠\X]=],
   iso=[=[X��\X]=]};
[358]={description=[=[Places between pairs of ones]=],
   arguments=[[X←B]],
   utf=[=[(~X)^≠\X]=],
   iso=[=[(~X)^�\X]=]};
[359]={description=[=[Running parity]=],
   arguments=[[X←B]],
   utf=[=[≠\X]=],
   iso=[=[�\X]=]};
[360]={description=[=[Removing leading and trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[((⌽∨\⌽A)^∨\A←' '≠X)/X]=],
   iso=[=[((��\�A)^�\A�' '�X)/X]=]};
[361]={description=[=[First group of ones]=],
   arguments=[[X←B]],
   utf=[=[X^^\X=∨\X]=],
   iso=[=[X^^\X=�\X]=]};
[362]={description=[=[Removing trailing blank columns]=],
   arguments=[[X←C2]],
   utf=[=[(⌽∨\⌽∨⌿' '≠X)/X]=],
   iso=[=[(��\���' '�X)/X]=]};
[363]={description=[=[Removing trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[(⌽∨\⌽' '≠X)/X]=],
   iso=[=[(��\�' '�X)/X]=]};
[364]={description=[=[Removing leading blanks]=],
   arguments=[[X←C1]],
   utf=[=[(∨\' '≠X)/X]=],
   iso=[=[(�\' '�X)/X]=]};
[365]={description=[=[Not leading zeroes (turn on all zeroes after first one)]=],
   arguments=[[X←B]],
   utf=[=[∨\X]=],
   iso=[=[�\X]=]};
[366]={description=[=[Centering character array X with ragged edges]=],
   arguments=[[X←C]],
   utf=[=[(A-⌊0.5×(A←+/^\⌽A)++/^\A←' '=⌽X)⌽X]=],
   iso=[=[(A-�0.5�(A�+/^\�A)++/^\A�' '=�X)�X]=]};
[367]={description=[=[Decommenting a matrix representation of a function (⎕CR)]=],
   arguments=[[X←C2]],
   utf=[=[(∨/A)⌿(⍴X)⍴(,A)\(,A←^\('⍝'≠X)∨≠\X='''')/,X]=],
   iso=[=[(�/A)�(�X)�(,A)\(,A�^\('�'�X)��\X='''')/,X]=]};
[369]={description=[=[Centering character array X with only right edge ragged]=],
   arguments=[[X←C]],
   utf=[=[(-⌊0.5×+/^\' '=⌽X)⌽X]=],
   iso=[=[(-�0.5�+/^\' '=�X)�X]=]};
[370]={description=[=[Justifying right]=],
   arguments=[[X←C]],
   utf=[=[(-+/^\⌽' '=X)⌽X]=],
   iso=[=[(-+/^\�' '=X)�X]=]};
[371]={description=[=[Removing trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[(-+/^\⌽' '=X)↓X]=],
   iso=[=[(-+/^\�' '=X)�X]=]};
[372]={description=[=[Justifying left]=],
   arguments=[[X←C]],
   utf=[=[(+/^\' '=X)⌽X]=],
   iso=[=[(+/^\' '=X)�X]=]};
[373]={description=[=[Editing X with Y '-wise]=],
   arguments=[[X←C1; Y←C1]],
   utf=[=[((~(⍴A↑X)↑'/'=Y)/A↑X),(1↓A↓Y),(A←+/^\Y≠',')↓X]=],
   iso=[=[((~(�A�X)�'/'=Y)/A�X),(1�A�Y),(A�+/^\Y�',')�X]=]};
[374]={description=[=[Removing leading blanks]=],
   arguments=[[X←C1]],
   utf=[=[(+/^\' '=X)↓X]=],
   iso=[=[(+/^\' '=X)�X]=]};
[375]={description=[=[Indices of first blanks in rows of array X]=],
   arguments=[[X←C]],
   utf=[=[⎕IO++/^\' '≠X]=],
   iso=[=[�IO++/^\' '�X]=]};
[377]={description=[=[Leading ones (turn off all ones after first zero)]=],
   arguments=[[X←B]],
   utf=[=[^\X]=],
   iso=[=[^\X]=]};
[378]={description=[=[Vector (X[1]⍴1),(Y[1]⍴0),(X[2]⍴1),...]=],
   arguments=[[X←I1; Y←I1]],
   utf=[=[(⍳+/X,Y)∊+\1+¯1↓0,((⍳+/X)∊+\X)\Y]=],
   iso=[=[(�+/X,Y)�+\1+�1�0,((�+/X)�+\X)\Y]=]};
[379]={description=[=[Replicate Y[i] X[i] times (for all i)]=],
   arguments=[[X←I1; Y←A1]],
   utf=[=[((X≠0)/Y)[+\¯1⌽(⍳+/X)∊+\X]]=],
   iso=[=[((X�0)/Y)[+\�1�(�+/X)�+\X]]=]};
[380]={description=[=[Vector (Y[1]+⍳X[1]),(Y[2]+⍳X[2]),(Y[3]+⍳X[3]),...]=],
   arguments=[[X←I1; Y←I1; ⍴X←→⍴Y]],
   utf=[=[⎕IO++\1+((⍳+/X)∊+\⎕IO,X)\Y-¯1↓1,X+Y]=],
   iso=[=[�IO++\1+((�+/X)�+\�IO,X)\Y-�1�1,X+Y]=]};
[381]={description=[=[Replicate Y[i] X[i] times (for all i)]=],
   arguments=[[X←I1; Y←A1]],
   utf=[=[Y[+\(⍳+/X)∊¯1↓1++\0,X]]=],
   iso=[=[Y[+\(�+/X)Ţ1�1++\0,X]]=]};
[382]={description=[=[Replicate Y[i] X[i] times (for all i)]=],
   arguments=[[X←I1; Y←A1]],
   utf=[=[Y[⎕IO++\(⍳+/X)∊⎕IO++\X]]=],
   iso=[=[Y[�IO++\(�+/X)��IO++\X]]=]};
[383]={description=[=[Cumulative sums (+\) over subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[+\Y-X\A-¯1↓0,A←X/+\¯1↓0,Y]=],
   iso=[=[+\Y-X\A-�1�0,A�X/+\�1�0,Y]=]};
[384]={description=[=[Sums over (+/) subvectors of Y, lengths in X]=],
   arguments=[[X←I1; Y←D1]],
   utf=[=[A-¯1↓0,A←(+\Y)[+\X]]=],
   iso=[=[A-�1�0,A�(+\Y)[+\X]]=]};
[386]={description=[=[X first figurate numbers]=],
   arguments=[[X←I0]],
   utf=[=[+\+\⍳X]=],
   iso=[=[+\+\�X]=]};
[387]={description=[=[Insert vector for X[i] zeroes after i:th subvector]=],
   arguments=[[X←I1; Y←B1]],
   utf=[=[(⍳(⍴Y)++/X)∊+\1+¯1↓0,(1⌽Y)\X]=],
   iso=[=[(�(�Y)++/X)�+\1+�1�0,(1�Y)\X]=]};
[388]={description=[=[Open a gap of X[i] after Y[G[i]] (for all i)]=],
   arguments=[[X←I1; Y←A1; G←I1]],
   utf=[=[((⍳(⍴Y)++/X)∊+\1+¯1↓0,((⍳⍴Y)∊G)\X)\Y]=],
   iso=[=[((�(�Y)++/X)�+\1+�1�0,((��Y)�G)\X)\Y]=]};
[389]={description=[=[Open a gap of X[i] before Y[G[i]] (for all i)]=],
   arguments=[[X←I1; Y←A1; G←I1]],
   utf=[=[((⍳(⍴Y)++/X)∊+\1+((⍳⍴Y)∊G)\X)\Y]=],
   iso=[=[((�(�Y)++/X)�+\1+((��Y)�G)\X)\Y]=]};
[390]={description=[=[Changing lengths X of subvectors to starting indicators]=],
   arguments=[[X←I1]],
   utf=[=[A←(+/X)⍴0 ⋄ A[+\¯1↓⎕IO,X]←1 ⋄ A]=],
   iso=[=[A�(+/X)�0 � A[+\�1��IO,X]�1 � A]=]};
[391]={description=[=[Changing lengths X of subvectors to ending indicators]=],
   arguments=[[X←I1]],
   utf=[=[(⍳+/X)∊(+\X)-~⎕IO]=],
   iso=[=[(�+/X)�(+\X)-~�IO]=]};
[392]={description=[=[Changing lengths X of subvectors to starting indicators]=],
   arguments=[[X←I1]],
   utf=[=[(⍳+/X)∊+\⎕IO,X]=],
   iso=[=[(�+/X)�+\�IO,X]=]};
[393]={description=[=[Insert vector for X[i] elements before i:th element]=],
   arguments=[[X←I1]],
   utf=[=[(⍳+/A)∊+\A←1+X]=],
   iso=[=[(�+/A)�+\A�1+X]=]};
[394]={description=[=[Sums over (+/) subvectors of Y indicated by X]=],
   arguments=[[X←B1; Y←D1]],
   utf=[=[A-¯1↓0,A←(1⌽X)/+\Y]=],
   iso=[=[A-�1�0,A�(1�X)/+\Y]=]};
[395]={description=[=[Fifo stock Y decremented with X units]=],
   arguments=[[Y←D1; X←D0]],
   utf=[=[G-¯1↓0,G←0⌈(+\Y)-X]=],
   iso=[=[G-�1�0,G�0�(+\Y)-X]=]};
[396]={description=[=[Locations of texts between and including quotes]=],
   arguments=[[X←C1]],
   utf=[=[A∨¯1↓0,A←2|+\X='''']=],
   iso=[=[A��1�0,A�2|+\X='''']=]};
[397]={description=[=[Locations of texts between quotes]=],
   arguments=[[X←C1]],
   utf=[=[A^¯1↓0,A←2|+\X='''']=],
   iso=[=[A^�1�0,A�2|+\X='''']=]};
[398]={description=[=[X:th subvector of Y (subvectors separated by Y[1])]=],
   arguments=[[Y←A1; X←I0]],
   utf=[=[1↓(X=+\Y=1↑Y)/Y]=],
   iso=[=[1�(X=+\Y=1�Y)/Y]=]};
[399]={description=[=[Locating field number Y starting with first element of X]=],
   arguments=[[Y←I0; X←C1]],
   utf=[=[(Y=+\X=1↑X)/X]=],
   iso=[=[(Y=+\X=1�X)/X]=]};
[400]={description=[=[Sum elements of X marked by succeeding identicals in Y]=],
   arguments=[[X←D1; Y←D1]],
   utf=[=[A-¯1↓0,A←(Y≠1↓Y,0)/+\X]=],
   iso=[=[A-�1�0,A�(Y�1�Y,0)/+\X]=]};
[401]={description=[=[Groups of ones in Y pointed to by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[Y^A∊(X^Y)/A←+\Y>¯1↓0,Y]=],
   iso=[=[Y^A�(X^Y)/A�+\Y>�1�0,Y]=]};
[402]={description=[=[ith starting indicators X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[(+\X)∊Y/⍳⍴Y]=],
   iso=[=[(+\X)�Y/��Y]=]};
[403]={description=[=[G:th subvector of Y (subvectors indicated by X)]=],
   arguments=[[X←B1; Y←A1; G←I0]],
   utf=[=[(G=+\X)/Y]=],
   iso=[=[(G=+\X)/Y]=]};
[404]={description=[=[Running sum of Y consecutive elements of X]=],
   arguments=[[X←D1; Y←I0]],
   utf=[=[((Y-1)↓A)-0,(-Y)↓A←+\X]=],
   iso=[=[((Y-1)�A)-0,(-Y)�A�+\X]=]};
[405]={description=[=[Depth of parentheses]=],
   arguments=[[X←C1]],
   utf=[=[+\('('=X)-¯1↓0,')'=X]=],
   iso=[=[+\('('=X)-�1�0,')'=X]=]};
[406]={description=[=[Starting positions of subvectors having lengths X]=],
   arguments=[[X←I1]],
   utf=[=[+\¯1↓⎕IO,X]=],
   iso=[=[+\�1��IO,X]=]};
[407]={description=[=[Changing lengths X of subvectors of Y to ending indicators]=],
   arguments=[[X←I1]],
   utf=[=[(⍳⍴Y)∊(+\X)-~⎕IO]=],
   iso=[=[(��Y)�(+\X)-~�IO]=]};
[408]={description=[=[Changing lengths X of subvectors of Y to starting indicators]=],
   arguments=[[X←I1]],
   utf=[=[(⍳⍴Y)∊+\⎕IO,X]=],
   iso=[=[(��Y)�+\�IO,X]=]};
[409]={description=[=[X first triangular numbers]=],
   arguments=[[X←I0]],
   utf=[=[+\⍳X]=],
   iso=[=[+\�X]=]};
[410]={description=[=[Cumulative sum]=],
   arguments=[[X←D]],
   utf=[=[+\X]=],
   iso=[=[+\X]=]};
[411]={description=[=[Complementary angle (arccos sin X)]=],
   arguments=[[X←D0]],
   utf=[=[○/¯2 1,X]=],
   iso=[=[�/�2 1,X]=]};
[412]={description=[=[Evaluating a two-row determinant]=],
   arguments=[[X←D2]],
   utf=[=[-/×/0 1⊖X]=],
   iso=[=[-/�/0 1�X]=]};
[413]={description=[=[Evaluating a two-row determinant]=],
   arguments=[[X←D2]],
   utf=[=[-/×⌿0 1⌽X]=],
   iso=[=[-/��0 1�X]=]};
[414]={description=[=[Area of triangle with side lengths in X (Heron's formula)]=],
   arguments=[[X←D1; 3 ←→ ⍴X]],
   utf=[=[(×/(+/X÷2)-0,X)*.5]=],
   iso=[=[(�/(+/X�2)-0,X)*.5]=]};
[415]={description=[=[Juxtapositioning planes of rank 3 array X]=],
   arguments=[[X←A3]],
   utf=[=[(×⌿2 2⍴1,⍴X)⍴2 1 3⍉X]=],
   iso=[=[(��2 2�1,�X)�2 1 3�X]=]};
[416]={description=[=[Number of rows in array X (also of a vector)]=],
   arguments=[[X←A]],
   utf=[=[×/¯1↓⍴X]=],
   iso=[=[�/�1��X]=]};
[417]={description=[=[(Real) solution of quadratic equation with coefficients X]=],
   arguments=[[X←D1; 3 ←→ ⍴X]],
   utf=[=[(-X[2]-¯1 1×((X[2]*2)-×/4,X[1 3])*.5)÷2×X[1]]=],
   iso=[=[(-X[2]-�1 1�((X[2]*2)-�/4,X[1 3])*.5)�2�X[1]]=]};
[418]={description=[=[Reshaping planes of rank 3 array to rows of a matrix]=],
   arguments=[[X←A3]],
   utf=[=[(×/2 2⍴1,⍴X)⍴X]=],
   iso=[=[(�/2 2�1,�X)�X]=]};
[419]={description=[=[Reshaping planes of rank 3 array to a matrix]=],
   arguments=[[X←A3]],
   utf=[=[(×/2 2⍴(⍴X),1)⍴X]=],
   iso=[=[(�/2 2�(�X),1)�X]=]};
[420]={description=[=[Number of elements (also of a scalar)]=],
   arguments=[[X←A]],
   utf=[=[×/⍴X]=],
   iso=[=[�/�X]=]};
[421]={description=[=[Product of elements of X]=],
   arguments=[[X←D1]],
   utf=[=[×/X]=],
   iso=[=[�/X]=]};
[422]={description=[=[Alternating product]=],
   arguments=[[X←D]],
   utf=[=[÷/X]=],
   iso=[=[�/X]=]};
[423]={description=[=[Centering text line X into a field of width Y]=],
   arguments=[[X←C1; Y←I0]],
   utf=[=[Y↑((⌊-/.5×Y,⍴X)⍴' '),X]=],
   iso=[=[Y�((�-/.5�Y,�X)�' '),X]=]};
[424]={description=[=[Alternating sum]=],
   arguments=[[X←D]],
   utf=[=[-/X]=],
   iso=[=[-/X]=]};
[425]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←D1]],
   utf=[=[(⌈/X)=⌊/X]=],
   iso=[=[(�/X)=�/X]=]};
[426]={description=[=[Size of range of elements of X]=],
   arguments=[[X←D1]],
   utf=[=[(⌈/X)-⌊/X]=],
   iso=[=[(�/X)-�/X]=]};
[427]={description=[=[Conversion of set of positive integers X to a mask]=],
   arguments=[[X←I1]],
   utf=[=[(⍳⌈/X)∊X]=],
   iso=[=[(��/X)�X]=]};
[428]={description=[=[Negative infinity; the smallest representable value]=],
   arguments=[[]],
   utf=[=[⌈/⍳0]=],
   iso=[=[�/�0]=]};
[429]={description=[=[Vectors as column matrices in catenation beneath each other]=],
   arguments=[[X←A1/2; Y←A1/2]],
   utf=[=[X,[1+.5×⌈/(⍴⍴X),⍴⍴Y]Y]=],
   iso=[=[X,[1+.5��/(��X),��Y]Y]=]};
[430]={description=[=[Vectors as row matrices in catenation upon each other]=],
   arguments=[[X←A1/2; Y←A1/2]],
   utf=[=[X,[.5×⌈/(⍴⍴X),⍴⍴Y]Y]=],
   iso=[=[X,[.5��/(��X),��Y]Y]=]};
[431]={description=[=[Quick membership (∊) for positive integers]=],
   arguments=[[X←I1; Y←I1]],
   utf=[=[A←(⌈/X,Y)⍴0 ⋄ A[Y]←1 ⋄ A[X]]=],
   iso=[=[A�(�/X,Y)�0 � A[Y]�1 � A[X]]=]};
[432]={description=[=[Positive maximum, at least zero (also for empty X)]=],
   arguments=[[X←D1]],
   utf=[=[⌈/X,0]=],
   iso=[=[�/X,0]=]};
[433]={description=[=[Maximum of elements of X]=],
   arguments=[[X←D1]],
   utf=[=[⌈/X]=],
   iso=[=[�/X]=]};
[434]={description=[=[Positive infinity; the largest representable value]=],
   arguments=[[]],
   utf=[=[⌊/⍳0]=],
   iso=[=[�/�0]=]};
[435]={description=[=[Minimum of elements of X]=],
   arguments=[[X←D1]],
   utf=[=[⌊/X]=],
   iso=[=[�/X]=]};
[436]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[⍲/0 1∊X]=],
   iso=[=[�/0 1�X]=]};
[437]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[(^/X)∨~∨/X]=],
   iso=[=[(^/X)�~�/X]=]};
[438]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[(^/X)=∨/X]=],
   iso=[=[(^/X)=�/X]=]};
[439]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[^/X÷∨/X]=],
   iso=[=[^/Xߩ/X]=]};
[440]={description=[=[Removing duplicate rows from ordered matrix X]=],
   arguments=[[X←A2]],
   utf=[=[(¯1⌽1↓(∨/X≠¯1⊖X),1)⌿X]=],
   iso=[=[(�1�1�(�/X��1�X),1)�X]=]};
[441]={description=[=[Vector having as many ones as X has rows]=],
   arguments=[[X←A2]],
   utf=[=[∨/0/X]=],
   iso=[=[�/0/X]=]};
[442]={description=[=[Test if X and Y have elements in common]=],
   arguments=[[X←A; Y←A1]],
   utf=[=[∨/Y∊X]=],
   iso=[=[�/Y�X]=]};
[443]={description=[=[None, neither]=],
   arguments=[[X←B]],
   utf=[=[~∨/X]=],
   iso=[=[~�/X]=]};
[444]={description=[=[Any, anyone]=],
   arguments=[[X←B]],
   utf=[=[∨/X]=],
   iso=[=[�/X]=]};
[445]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[≠/0 1∊X]=],
   iso=[=[�/0 1�X]=]};
[446]={description=[=[Parity]=],
   arguments=[[X←B]],
   utf=[=[≠/X]=],
   iso=[=[�/X]=]};
[447]={description=[=[Number of areas intersecting areas in X]=],
   arguments=[[X←D3 (n × 2 × dim)]],
   utf=[=[+/A^⍉A←^/X[;A⍴1;]≤2 1 3⍉X[;(A←1↑⍴X)⍴2;]]=],
   iso=[=[+/A^�A�^/X[;A�1;]�2 1 3�X[;(A�1��X)�2;]]=]};
[448]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[^/X/1⌽X]=],
   iso=[=[^/X/1�X]=]};
[449]={description=[=[Comparison of successive rows]=],
   arguments=[[X←A2]],
   utf=[=[^/X=1⊖X]=],
   iso=[=[^/X=1�X]=]};
[450]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←A1]],
   utf=[=[^/X=1⌽X]=],
   iso=[=[^/X=1�X]=]};
[451]={description=[=[Test if X is a valid APL name]=],
   arguments=[[X←C1]],
   utf=[=[^/((1↑X)∊10↓A),X∊A←'0..9A..Za..z']=],
   iso=[=[^/((1�X)�10�A),X�A�'0..9A..Za..z']=]};
[452]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←A1]],
   utf=[=[^/X=1↑X]=],
   iso=[=[^/X=1�X]=]};
[453]={description=[=[Identity of two sets]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[^/(X∊Y),Y∊X]=],
   iso=[=[^/(X�Y),Y�X]=]};
[454]={description=[=[Test if X is a permutation vector]=],
   arguments=[[X←I1]],
   utf=[=[^/(⍳⍴X)∊X]=],
   iso=[=[^/(��X)�X]=]};
[455]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[~^/X∊~X]=],
   iso=[=[~^/X�~X]=]};
[456]={description=[=[Test if X is boolean]=],
   arguments=[[X←A]],
   utf=[=[^/,X∊0 1]=],
   iso=[=[^/,X�0 1]=]};
[457]={description=[=[Test if Y is a subset of X (Y ⊂ X)]=],
   arguments=[[X←A; Y←A1]],
   utf=[=[^/Y∊X]=],
   iso=[=[^/Y�X]=]};
[458]={description=[=[Test if arrays of equal shape are identical]=],
   arguments=[[X←A; Y←A; ⍴X ←→ ⍴Y]],
   utf=[=[^/,X=Y]=],
   iso=[=[^/,X=Y]=]};
[459]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←A1]],
   utf=[=[^/X=X[1]]=],
   iso=[=[^/X=X[1]]=]};
[460]={description=[=[Blank rows]=],
   arguments=[[X←C2]],
   utf=[=[^/' '=X]=],
   iso=[=[^/' '=X]=]};
[461]={description=[=[All, both]=],
   arguments=[[X←B]],
   utf=[=[^/X]=],
   iso=[=[^/X]=]};
[462]={description=[=[Standard deviation of X]=],
   arguments=[[X←D1]],
   utf=[=[((+/(X-(+/X)÷⍴X)*2)÷⍴X)*.5]=],
   iso=[=[((+/(X-(+/X)��X)*2)��X)*.5]=]};
[463]={description=[=[Y:th moment of X]=],
   arguments=[[X←D1]],
   utf=[=[(+/(X-(+/X)÷⍴X)*Y)÷⍴X]=],
   iso=[=[(+/(X-(+/X)��X)*Y)��X]=]};
[464]={description=[=[Variance (dispersion) of X]=],
   arguments=[[X←D1]],
   utf=[=[(+/(X-(+/X)÷⍴X)*2)÷⍴X]=],
   iso=[=[(+/(X-(+/X)��X)*2)��X]=]};
[465]={description=[=[Arithmetic average (mean value), also for an empty array]=],
   arguments=[[X←D]],
   utf=[=[(+/,X)÷1⌈⍴,X]=],
   iso=[=[(+/,X)�1��,X]=]};
[466]={description=[=[Test if all elements of vector X are equal]=],
   arguments=[[X←B1]],
   utf=[=[0=(⍴X)|+/X]=],
   iso=[=[0=(�X)|+/X]=]};
[467]={description=[=[Average (mean value) of columns of matrix X]=],
   arguments=[[X←D2]],
   utf=[=[(+⌿X)÷1↑(⍴X),1]=],
   iso=[=[(+�X)�1�(�X),1]=]};
[468]={description=[=[Average (mean value) of rows of matrix X]=],
   arguments=[[X←D2]],
   utf=[=[(+/X)÷¯1↑1,⍴X]=],
   iso=[=[(+/X)ߢ1�1,�X]=]};
[469]={description=[=[Number of occurrences of scalar X in array Y]=],
   arguments=[[X←A0; Y←A]],
   utf=[=[+/X=,Y]=],
   iso=[=[+/X=,Y]=]};
[470]={description=[=[Average (mean value) of elements of X along direction Y]=],
   arguments=[[X←D; Y←I0]],
   utf=[=[(+/[Y]X)÷(⍴X)[Y]]=],
   iso=[=[(+/[Y]X)�(�X)[Y]]=]};
[471]={description=[=[Arithmetic average (mean value)]=],
   arguments=[[X←D1]],
   utf=[=[(+/X)÷⍴X]=],
   iso=[=[(+/X)��X]=]};
[472]={description=[=[Resistance of parallel resistors]=],
   arguments=[[X←D1]],
   utf=[=[÷+/÷X]=],
   iso=[=[�+/�X]=]};
[473]={description=[=[Sum of elements of X]=],
   arguments=[[X←D1]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[474]={description=[=[Row sum of a matrix]=],
   arguments=[[X←D2]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[475]={description=[=[Column sum of a matrix]=],
   arguments=[[X←D2]],
   utf=[=[+⌿X]=],
   iso=[=[+�X]=]};
[476]={description=[=[Reshaping one-element vector X into a scalar]=],
   arguments=[[X←A1]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[477]={description=[=[Number of elements satisfying condition X]=],
   arguments=[[X←B1]],
   utf=[=[+/X]=],
   iso=[=[+/X]=]};
[478]={description=[=[Scan from end with function ⍺]=],
   arguments=[[X←A]],
   utf=[=[⌽⍺\⌽X]=],
   iso=[=[��\�X]=]};
[479]={description=[=[The index of positive integers in Y]=],
   arguments=[[X←I; Y←I1]],
   utf=[=[A←9999⍴⎕IO+⍴Y ⋄ A[⌽Y]←⌽⍳⍴Y ⋄ A[X]]=],
   iso=[=[A�9999��IO+�Y � A[�Y]����Y � A[X]]=]};
[480]={description=[=['Transpose' of matrix X with column fields of width Y]=],
   arguments=[[X←A2; G←I0]],
   utf=[=[((⌽A)×1,Y)⍴2 1 3⍉(1⌽Y,A←(⍴X)÷1,Y)⍴X]=],
   iso=[=[((�A)�1,Y)�2 1 3�(1�Y,A�(�X)�1,Y)�X]=]};
[482]={description=[=[Adding X to each column of Y]=],
   arguments=[[X←D1; Y←D; (⍴X)=1↑⍴Y]],
   utf=[=[Y+⍉(⌽⍴Y)⍴X]=],
   iso=[=[Y+�(��Y)�X]=]};
[483]={description=[=[Matrix with shape of Y and X as its columns]=],
   arguments=[[X←A1; Y←A2]],
   utf=[=[⍉(⌽⍴Y)⍴X]=],
   iso=[=[�(��Y)�X]=]};
[484]={description=[=[Derivate of polynomial X]=],
   arguments=[[X←D1]],
   utf=[=[¯1↓X×⌽¯1+⍳⍴X]=],
   iso=[=[�1�X���1+��X]=]};
[485]={description=[=[Reverse vector X on condition Y]=],
   arguments=[[X←A1; Y←B0]],
   utf=[=[,⌽[⎕IO+Y](1,⍴X)⍴X]=],
   iso=[=[,�[�IO+Y](1,�X)�X]=]};
[486]={description=[=[Reshaping vector X into a one-column matrix]=],
   arguments=[[X←A1]],
   utf=[=[(⌽1,⍴X)⍴X]=],
   iso=[=[(�1,�X)�X]=]};
[487]={description=[=[Avoiding parentheses with help of reversal]=],
   arguments=[[]],
   utf=[=[(⌽1, ...)]=],
   iso=[=[(�1, ...)]=]};
[488]={description=[=[Vector (cross) product of vectors]=],
   arguments=[[X←D; Y←D]],
   utf=[=[((1⌽X)×¯1⌽Y)-(¯1⌽X)×1⌽Y]=],
   iso=[=[((1�X)��1�Y)-(�1�X)�1�Y]=]};
[489]={description=[=[A magic square, side X]=],
   arguments=[[X←I0; 1=2|X]],
   utf=[=[A⊖(A←(⍳X)-⌈X÷2)⌽(X,X)⍴⍳X×X]=],
   iso=[=[A�(A�(�X)-�X�2)�(X,X)��X�X]=]};
[490]={description=[=[Removing duplicates from an ordered vector]=],
   arguments=[[X←A1]],
   utf=[=[(¯1⌽1↓(X≠¯1⌽X),1)/X]=],
   iso=[=[(�1�1�(X��1�X),1)/X]=]};
[491]={description=[=[An expression giving itself]=],
   arguments=[[]],
   utf=[=[1⌽22⍴11⍴'''1⌽22⍴11⍴''']=],
   iso=[=[1�22�11�'''1�22�11�''']=]};
[492]={description=[=[Transpose matrix X on condition Y]=],
   arguments=[[X←A2; Y←B0]],
   utf=[=[(Y⌽1 2)⍉X]=],
   iso=[=[(Y�1 2)�X]=]};
[493]={description=[=[Any element true (∨/) on each subvector of Y indicated by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[(X/Y)≥A/1⌽A←(Y∨X)/X]=],
   iso=[=[(X/Y)�A/1�A�(Y�X)/X]=]};
[494]={description=[=[All elements true (^/) on each subvector of Y indicated by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[(X/Y)^A/1⌽A←(Y≤X)/X]=],
   iso=[=[(X/Y)^A/1�A�(Y�X)/X]=]};
[495]={description=[=[Removing leading, multiple and trailing Y's]=],
   arguments=[[X←A1; Y←A0]],
   utf=[=[(1↑A)↓(A⍲1⌽A←Y=X)/X]=],
   iso=[=[(1�A)�(A�1�A�Y=X)/X]=]};
[496]={description=[=[Changing starting indicators X of subvectors to lengths]=],
   arguments=[[X←B1]],
   utf=[=[A-¯1↓0,A←(1⌽X)/⍳⍴X]=],
   iso=[=[A-�1�0,A�(1�X)/��X]=]};
[498]={description=[=[(Cyclic) compression of successive blanks]=],
   arguments=[[X←C1]],
   utf=[=[(A∨1⌽A←X≠' ')/X]=],
   iso=[=[(A�1�A�X�' ')/X]=]};
[499]={description=[=[Aligning columns of matrix X to diagonals]=],
   arguments=[[X←A2]],
   utf=[=[(1-⍳¯1↑⍴X)⌽X]=],
   iso=[=[(1-ɢ1��X)�X]=]};
[500]={description=[=[Aligning diagonals of matrix X to columns]=],
   arguments=[[X←A2]],
   utf=[=[(¯1+⍳¯1↑⍴X)⌽X]=],
   iso=[=[(�1+ɢ1��X)�X]=]};
[501]={description=[=[Diagonal matrix with elements of X]=],
   arguments=[[X←D1]],
   utf=[=[0 ¯1↓(-⍳⍴X)⌽((2⍴⍴X)⍴0),X]=],
   iso=[=[0 �1�(-��X)�((2��X)�0),X]=]};
[502]={description=[=[Test if elements differ from previous ones (non-empty X)]=],
   arguments=[[X←A1]],
   utf=[=[1,1↓X≠¯1⌽X]=],
   iso=[=[1,1�X��1�X]=]};
[503]={description=[=[Test if elements differ from next ones (non-empty X)]=],
   arguments=[[X←A1]],
   utf=[=[(¯1↓X≠1⌽X),1]=],
   iso=[=[(�1�X�1�X),1]=]};
[504]={description=[=[Replacing first element of X with Y]=],
   arguments=[[X←A1; Y←A0]],
   utf=[=[¯1⌽1↓X,Y]=],
   iso=[=[�1�1�X,Y]=]};
[505]={description=[=[Replacing last element of X with Y]=],
   arguments=[[X←A1; Y←A0]],
   utf=[=[1⌽¯1↓Y,X]=],
   iso=[=[1��1�Y,X]=]};
[506]={description=[=[Ending points for X in indices pointed by Y]=],
   arguments=[[X←A1; Y←I1]],
   utf=[=[1⌽(⍳⍴X)∊Y]=],
   iso=[=[1�(��X)�Y]=]};
[507]={description=[=[Leftmost neighboring elements cyclically]=],
   arguments=[[X←A]],
   utf=[=[¯1⌽X]=],
   iso=[=[�1�X]=]};
[508]={description=[=[Rightmost neighboring elements cyclically]=],
   arguments=[[X←A]],
   utf=[=[1⌽X]=],
   iso=[=[1�X]=]};
[509]={description=[=[Applying to columns action defined on rows]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[⍉ ... ⍉X]=],
   iso=[=[� ... �X]=]};
[510]={description=[=[Retrieving scattered elements Y from matrix X]=],
   arguments=[[X←A2; Y←I2]],
   utf=[=[1 1⍉X[Y[1;];Y[2;]]]=],
   iso=[=[1 1�X[Y[1;];Y[2;]]]=]};
[511]={description=[=[Successive transposes of G (X after Y: X⍉Y⍉G)]=],
   arguments=[[X←I1; Y←I1]],
   utf=[=[X[Y]⍉G]=],
   iso=[=[X[Y]�G]=]};
[512]={description=[=[Major diagonal of array X]=],
   arguments=[[X←A]],
   utf=[=[(1*⍴X)⍉X]=],
   iso=[=[(1*�X)�X]=]};
[513]={description=[=[Reshaping a 400×12 character matrix to fit into one page]=],
   arguments=[[X←C2]],
   utf=[=[40 120⍴2 1 3⍉10 40 12⍴X]=],
   iso=[=[40 120�2 1 3�10 40 12�X]=]};
[514]={description=[=[Transpose of planes of a rank three array]=],
   arguments=[[X←A3]],
   utf=[=[1 3 2⍉X]=],
   iso=[=[1 3 2�X]=]};
[515]={description=[=[Major diagonal of matrix X]=],
   arguments=[[X←A2]],
   utf=[=[1 1⍉X]=],
   iso=[=[1 1�X]=]};
[516]={description=[=[Selecting specific elements from a 'large' outer product]=],
   arguments=[[X←A; Y←A; G←I1]],
   utf=[=[G⍉X∘.⍺Y]=],
   iso=[=[G�X�.�Y]=]};
[517]={description=[=[Test for antisymmetricity of square matrix X]=],
   arguments=[[X←D2]],
   utf=[=[~0∊X=-⍉X]=],
   iso=[=[~0�X=-�X]=]};
[518]={description=[=[Test for symmetricity of square matrix X]=],
   arguments=[[X←A2]],
   utf=[=[~0∊X=⍉X]=],
   iso=[=[~0�X=�X]=]};
[519]={description=[=[Matrix with X columns Y]=],
   arguments=[[X←I0; Y←D1]],
   utf=[=[⍉(X,⍴Y)⍴Y]=],
   iso=[=[�(X,�Y)�Y]=]};
[520]={description=[=[Limiting X between Y[1] and Y[2], inclusive]=],
   arguments=[[X←D; Y←D1]],
   utf=[=[Y[1]⌈Y[2]⌊X]=],
   iso=[=[Y[1]�Y[2]�X]=]};
[521]={description=[=[Inserting vector Y to the end of matrix X]=],
   arguments=[[X←A2; Y←A1]],
   utf=[=[(A↑X),[⍳1](1↓A←(⍴X)⌈0,⍴Y)↑Y]=],
   iso=[=[(A�X),[�1](1�A�(�X)�0,�Y)�Y]=]};
[522]={description=[=[Widening matrix X to be compatible with Y]=],
   arguments=[[X←A2; Y←A2]],
   utf=[=[((0 1×⍴Y)⌈⍴X)↑X]=],
   iso=[=[((0 1��Y)��X)�X]=]};
[523]={description=[=[Lengthening matrix X to be compatible with Y]=],
   arguments=[[X←A2; Y←A2]],
   utf=[=[((1 0×⍴Y)⌈⍴X)↑X]=],
   iso=[=[((1 0��Y)��X)�X]=]};
[524]={description=[=[Reshaping non-empty lower-rank array X into a matrix]=],
   arguments=[[X←A; 2≥⍴⍴X]],
   utf=[=[(1⌈¯2↑⍴X)⍴X]=],
   iso=[=[(1Ӣ2��X)�X]=]};
[525]={description=[=[Take of at most X elements from Y]=],
   arguments=[[X←I; Y←A]],
   utf=[=[(X⌊⍴Y)↑Y]=],
   iso=[=[(X��Y)�Y]=]};
[526]={description=[=[Limiting indices and giving a default value G]=],
   arguments=[[X←A1; Y←I; G←A0]],
   utf=[=[(X,G)[(1+⍴X)⌊Y]]=],
   iso=[=[(X,G)[(1+�X)�Y]]=]};
[527]={description=[=[Reshaping X into a matrix of width Y]=],
   arguments=[[X←D, Y←I0]],
   utf=[=[((⌈(⍴,X)÷Y),Y)⍴X]=],
   iso=[=[((�(�,X)�Y),Y)�X]=]};
[528]={description=[=[Rounding to nearest even integer]=],
   arguments=[[X←D]],
   utf=[=[⌊X+1≤2|X]=],
   iso=[=[�X+1�2|X]=]};
[529]={description=[=[Rounding, to nearest even integer for .5 = 1||X]=],
   arguments=[[X←D]],
   utf=[=[⌊X+.5×.5≠2|X]=],
   iso=[=[�X+.5�.5�2|X]=]};
[530]={description=[=[Rounding, to nearest even integer for .5 = 1||X]=],
   arguments=[[X←D]],
   utf=[=[⌊X+.5×.5≠2|X]=],
   iso=[=[�X+.5�.5�2|X]=]};
[531]={description=[=[Arithmetic progression from X to Y with step G]=],
   arguments=[[X←D0; Y←D0; G←D0]],
   utf=[=[X+(G××Y-X)×(⍳1+|⌊(Y-X)÷G)-⎕IO]=],
   iso=[=[X+(G��Y-X)�(�1+|�(Y-X)�G)-�IO]=]};
[532]={description=[=[Centering text line X into a field of width Y]=],
   arguments=[[X←C1; Y←I0]],
   utf=[=[(-⌊.5×Y+⍴X)↑X]=],
   iso=[=[(-�.5�Y+�X)�X]=]};
[533]={description=[=[Test if integer]=],
   arguments=[[X←D]],
   utf=[=[X=⌊X]=],
   iso=[=[X=�X]=]};
[534]={description=[=[Rounding currencies to nearest 5 subunits]=],
   arguments=[[X←D]],
   utf=[=[.05×⌊.5+X÷.05]=],
   iso=[=[.05��.5+X�.05]=]};
[535]={description=[=[First part of numeric code ABBB]=],
   arguments=[[X←I]],
   utf=[=[⌊X÷1000]=],
   iso=[=[�X�1000]=]};
[536]={description=[=[Rounding to X decimals]=],
   arguments=[[X←I; Y←D]],
   utf=[=[(10*-X)×⌊0.5+Y×10*X]=],
   iso=[=[(10*-X)��0.5+Y�10*X]=]};
[537]={description=[=[Rounding to nearest hundredth]=],
   arguments=[[]],
   utf=[=[X←D]=],
   iso=[=[X�D]=]};
[0]={description=[=[nil]=],
   arguments=[[]],
   utf=[=[nil]=],
   iso=[=[nil]=]};
[538]={description=[=[Rounding to nearest integer]=],
   arguments=[[X←D]],
   utf=[=[⌊0.5+X]=],
   iso=[=[�0.5+X]=]};
[539]={description=[=[Demote floating point representations to integers]=],
   arguments=[[X←I]],
   utf=[=[⌊X]=],
   iso=[=[�X]=]};
[540]={description=[=[Test if X is a leap year]=],
   arguments=[[X←I]],
   utf=[=[(0=400|X)∨(0≠100|X)^0=4|X]=],
   iso=[=[(0=400|X)�(0�100|X)^0=4|X]=]};
[541]={description=[=[Framing]=],
   arguments=[[X←C2]],
   utf=[=['_',[1]('|',X,'|'),[1]'¯']=],
   iso=[=['_',[1]('|',X,'|'),[1]'�']=]};
[542]={description=[=[Magnitude of fractional part]=],
   arguments=[[X←D]],
   utf=[=[1||X]=],
   iso=[=[1||X]=]};
[543]={description=[=[Fractional part with sign]=],
   arguments=[[X←D]],
   utf=[=[(×X)|X]=],
   iso=[=[(�X)|X]=]};
[544]={description=[=[Increasing the dimension of X to multiple of Y]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[X,(Y|-⍴X)↑0/X]=],
   iso=[=[X,(Y|-�X)�0/X]=]};
[545]={description=[=[Removing every Y:th element of X]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[(0≠Y|⍳⍴X)/X]=],
   iso=[=[(0�Y|��X)/X]=]};
[546]={description=[=[Taking every Y:th element of X]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[(0=Y|⍳⍴X)/X]=],
   iso=[=[(0=Y|��X)/X]=]};
[547]={description=[=[Divisors of X]=],
   arguments=[[X←I0]],
   utf=[=[(0=A|X)/A←⍳X]=],
   iso=[=[(0=A|X)/A��X]=]};
[548]={description=[=[Removing every second element of X]=],
   arguments=[[X←A1]],
   utf=[=[(2|⍳⍴X)/X]=],
   iso=[=[(2|��X)/X]=]};
[549]={description=[=[Elements of X divisible by Y]=],
   arguments=[[X←D1; Y←D0/1]],
   utf=[=[(0=Y|X)/X]=],
   iso=[=[(0=Y|X)/X]=]};
[550]={description=[=[Ravel of a matrix to Y[1] columns with a gap of Y[2]]=],
   arguments=[[X←A2; Y←I1]],
   utf=[=[(A×Y[1]*¯1 1)⍴(A←(⍴X)+(Y[1]|-1↑⍴X),Y[2])↑X]=],
   iso=[=[(A�Y[1]*�1 1)�(A�(�X)+(Y[1]|-1��X),Y[2])�X]=]};
[551]={description=[=[Test if even]=],
   arguments=[[X←I]],
   utf=[=[~2|X]=],
   iso=[=[~2|X]=]};
[552]={description=[=[Last part of numeric code ABBB]=],
   arguments=[[X←I]],
   utf=[=[1000|X]=],
   iso=[=[1000|X]=]};
[553]={description=[=[Fractional part]=],
   arguments=[[X←D]],
   utf=[=[1|X]=],
   iso=[=[1|X]=]};
[554]={description=[=[Increasing absolute value without change of sign]=],
   arguments=[[X←D; Y←D]],
   utf=[=[(×X)×Y+|X]=],
   iso=[=[(�X)�Y+|X]=]};
[555]={description=[=[Rounding to zero values of X close to zero]=],
   arguments=[[X←D; Y←D]],
   utf=[=[X×Y≤|X]=],
   iso=[=[X�Y�|X]=]};
[556]={description=[=[Square of elements of X without change of sign]=],
   arguments=[[X←D]],
   utf=[=[X×|X]=],
   iso=[=[X�|X]=]};
[557]={description=[=[Choosing according to signum]=],
   arguments=[[X←D; Y←A1]],
   utf=[=[Y[2+×X]]=],
   iso=[=[Y[2+�X]]=]};
[558]={description=[=[Not first zero (≤\) in each subvector of Y indicated by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[~(B^X)∨(B∨X)\A>¯1↓0,A←(B∨X)/B←~Y]=],
   iso=[=[~(B^X)�(B�X)\A>�1�0,A�(B�X)/B�~Y]=]};
[559]={description=[=[First one (<\) in each subvector of Y indicated by X]=],
   arguments=[[X←B1; Y←B1]],
   utf=[=[(Y^X)∨(Y∨X)\A>¯1↓0,A←(Y∨X)/Y]=],
   iso=[=[(Y^X)�(Y�X)\A>�1�0,A�(Y�X)/Y]=]};
[560]={description=[=[Replacing elements of X in set Y with blanks/zeroes]=],
   arguments=[[X←A0; Y←A1]],
   utf=[=[A\(A←~X∊Y)/X]=],
   iso=[=[A\(A�~X�Y)/X]=]};
[561]={description=[=[Replacing elements of X not in set Y with blanks/zeroes]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[A\(A←X∊Y)/X]=],
   iso=[=[A\(A�X�Y)/X]=]};
[562]={description=[=[Merging X and Y under control of G (mesh)]=],
   arguments=[[X←A1; Y←A1; G←B1]],
   utf=[=[A←G\X ⋄ A[(~G)/⍳⍴G]←Y ⋄ A]=],
   iso=[=[A�G\X � A[(~G)/��G]�Y � A]=]};
[563]={description=[=[Replacing elements of X not satisfying Y with blanks/zeroes]=],
   arguments=[[X←A; Y←B1]],
   utf=[=[Y\Y/X]=],
   iso=[=[Y\Y/X]=]};
[564]={description=[=[Adding an empty row into X after rows Y]=],
   arguments=[[X←A2; Y←I1]],
   utf=[=[(~(⍳(⍴Y)+1⍴⍴X)∊Y+⍳⍴Y)⍀X]=],
   iso=[=[(~(�(�Y)+1��X)�Y+��Y)�X]=]};
[565]={description=[=[Test if numeric]=],
   arguments=[[X←A1]],
   utf=[=[0∊0\0⍴X]=],
   iso=[=[0�0\0�X]=]};
[566]={description=[=[Adding an empty row into X after row Y]=],
   arguments=[[X←A2; Y←I0]],
   utf=[=[((Y+1)≠⍳1+1⍴⍴X)⍀X]=],
   iso=[=[((Y+1)��1+1��X)�X]=]};
[567]={description=[=[Underlining words]=],
   arguments=[[X←C1]],
   utf=[=[X,[⎕IO-.1](' '≠X)\'¯']=],
   iso=[=[X,[�IO-.1](' '�X)\'�']=]};
[568]={description=[=[Using boolean matrix Y in expanding X]=],
   arguments=[[X←A1; Y←B2]],
   utf=[=[(⍴Y)⍴(,Y)\X]=],
   iso=[=[(�Y)�(,Y)\X]=]};
[569]={description=[=[Spacing out text]=],
   arguments=[[X←C1]],
   utf=[=[((2×⍴X)⍴1 0)\X]=],
   iso=[=[((2��X)�1 0)\X]=]};
[570]={description=[=[Lengths of groups of ones in X]=],
   arguments=[[X←B1]],
   utf=[=[(A>0)/A←(1↓A)-1+¯1↓A←(~A)/⍳⍴A←0,X,0]=],
   iso=[=[(A>0)/A�(1�A)-1+�1�A�(~A)/��A�0,X,0]=]};
[571]={description=[=[Syllabization of a Finnish word X]=],
   arguments=[[X←A1]],
   utf=[=[(~A∊1,⍴X)/A←A/⍳⍴A←(1↓A,0)←~X∊'aeiouyÄÖ']=],
   iso=[=[(~A�1,�X)/A�A/��A�(1�A,0)�~X�'aeiouyÄÖ']=]};
[572]={description=[=[Choosing a string according to boolean value G]=],
   arguments=[[X←C1; Y←C1; G←B0]],
   utf=[=[(G/X),(~G)/Y]=],
   iso=[=[(G/X),(~G)/Y]=]};
[573]={description=[=[Removing leading, multiple and trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[(' '=1↑X)↓((1↓A,0)∨A←' '≠X)/X]=],
   iso=[=[(' '=1�X)�((1�A,0)�A�' '�X)/X]=]};
[575]={description=[=[Removing columns Y from array X]=],
   arguments=[[X←A; Y←I1]],
   utf=[=[(~(⍳¯1↑⍴X)∊Y)/X]=],
   iso=[=[(~(ɢ1��X)�Y)/X]=]};
[576]={description=[=[Removing trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[(¯1↑(' '≠X)/⍳⍴X)⍴X]=],
   iso=[=[(�1�(' '�X)/��X)�X]=]};
[577]={description=[=[Lengths of subvectors of X having equal elements]=],
   arguments=[[X←A1]],
   utf=[=[(1↓A)-¯1↓A←(A,1)/⍳1+⍴A←1,(1↓X)≠¯1↓X]=],
   iso=[=[(1�A)-�1�A�(A,1)/�1+�A�1,(1�X)��1�X]=]};
[578]={description=[=[Field lengths of vector X; G ←→ ending indices]=],
   arguments=[[X←A1; G←I1]],
   utf=[=[G-¯1↓0,G←(~⎕IO)+(((1↓X)≠¯1↓X),1)/⍳⍴X]=],
   iso=[=[G-�1�0,G�(~�IO)+(((1�X)��1�X),1)/��X]=]};
[580]={description=[=[Removing multiple and trailing blanks]=],
   arguments=[[X←C1]],
   utf=[=[((1↓A,0)∨A←' '≠X)/X]=],
   iso=[=[((1�A,0)�A�' '�X)/X]=]};
[581]={description=[=[Removing leading and multiple blanks]=],
   arguments=[[X←C1]],
   utf=[=[(A∨¯1↓0,A←' '≠X)/X]=],
   iso=[=[(A��1�0,A�' '�X)/X]=]};
[582]={description=[=[Removing multiple blanks]=],
   arguments=[[X←C1]],
   utf=[=[(A∨¯1↓1,A←' '≠X)/X]=],
   iso=[=[(A��1�1,A�' '�X)/X]=]};
[583]={description=[=[Removing duplicate Y's from vector X]=],
   arguments=[[X←A1; Y←A0]],
   utf=[=[(A∨¯1↓1,A←X≠Y)/X]=],
   iso=[=[(A��1�1,A�X�Y)/X]=]};
[584]={description=[=[Indices of all occurrences of elements of Y in X]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(X∊Y)/⍳⍴X]=],
   iso=[=[(X�Y)/��X]=]};
[585]={description=[=[Union of sets, ?]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[Y,(~X∊Y)/X]=],
   iso=[=[Y,(~X�Y)/X]=]};
[586]={description=[=[Elements of X not in Y (difference of sets)]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(~X∊Y)/X]=],
   iso=[=[(~X�Y)/X]=]};
[587]={description=[=[Rows of non-empty matrix X starting with a character in Y]=],
   arguments=[[X←A2; Y←A1]],
   utf=[=[(X[;1]∊Y)⌿X]=],
   iso=[=[(X[;1]�Y)�X]=]};
[588]={description=[=[Intersection of sets, ⍞]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(X∊Y)/X]=],
   iso=[=[(X�Y)/X]=]};
[589]={description=[=[Reduction with function ⍺ in dimension Y, rank unchanged]=],
   arguments=[[Y←I0; X←A]],
   utf=[=[((⍴X)*Y≠⍳⍴⍴X)⍴ ⍺/[Y]X]=],
   iso=[=[((�X)*Y����X)� �/[Y]X]=]};
[590]={description=[=[Replacing all values X in G with Y]=],
   arguments=[[X←A0; Y←A0; G←A]],
   utf=[=[A[(A=X)/⍳⍴A←,G]←Y ⋄ (⍴G)⍴A]=],
   iso=[=[A[(A=X)/��A�,G]�Y � (�G)�A]=]};
[591]={description=[=[Indices of all occurrences of Y in X]=],
   arguments=[[X←A1; Y←A0]],
   utf=[=[(Y=X)/⍳⍴X]=],
   iso=[=[(Y=X)/��X]=]};
[592]={description=[=[Replacing elements of G satisfying X with Y]=],
   arguments=[[Y←A0; X←B1; G←A1]],
   utf=[=[G[X/⍳⍴G]←Y]=],
   iso=[=[G[X/��G]�Y]=]};
[593]={description=[=[Removing duplicates from positive integers]=],
   arguments=[[X←I1]],
   utf=[=[A←9999⍴0 ⋄ A[X]←1 ⋄ A/⍳9999]=],
   iso=[=[A�9999�0 � A[X]�1 � A/�9999]=]};
[594]={description=[=[Indices of ones in logical vector X]=],
   arguments=[[X←B1]],
   utf=[=[X/⍳⍴X]=],
   iso=[=[X/��X]=]};
[595]={description=[=[Conditional in text]=],
   arguments=[[X←B0]],
   utf=[=[((~X)/'IN'),'CORRECT']=],
   iso=[=[((~X)/'IN'),'CORRECT']=]};
[596]={description=[=[Removing blanks]=],
   arguments=[[X←A1]],
   utf=[=[(' '≠X)/X]=],
   iso=[=[(' '�X)/X]=]};
[597]={description=[=[Removing elements Y from vector X]=],
   arguments=[[X←A1; Y←A0]],
   utf=[=[(X≠Y)/X]=],
   iso=[=[(X�Y)/X]=]};
[598]={description=[=[Vector to expand a new element after each one in X]=],
   arguments=[[X←B1]],
   utf=[=[(,X,[1.5]1)/,X,[1.5]~X]=],
   iso=[=[(,X,[1.5]1)/,X,[1.5]~X]=]};
[599]={description=[=[Reduction with FUNCTION ⍺ without respect to shape]=],
   arguments=[[X←D]],
   utf=[=[⍺/,X]=],
   iso=[=[�/,X]=]};
[600]={description=[=[Reshaping scalar X into a one-element vector]=],
   arguments=[[X←A]],
   utf=[=[1/X]=],
   iso=[=[1/X]=]};
[601]={description=[=[Empty matrix]=],
   arguments=[[X←A2]],
   utf=[=[0⌿X]=],
   iso=[=[0�X]=]};
[602]={description=[=[Selecting elements of X satisfying condition Y]=],
   arguments=[[X←A; Y←B1]],
   utf=[=[Y/X]=],
   iso=[=[Y/X]=]};
[603]={description=[=[Inserting vector X into matrix Y after row G]=],
   arguments=[[X←A1; Y←A2; G←I0]],
   utf=[=[Y[⍳G;],[1]((1↓⍴Y)↑X),[1](2↑G)↓Y]=],
   iso=[=[Y[�G;],[1]((1��Y)�X),[1](2�G)�Y]=]};
[604]={description=[=[Filling X with last element of X to length Y]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[Y↑X,Y⍴¯1↑X]=],
   iso=[=[Y�X,YҢ1�X]=]};
[605]={description=[=[Input of row Y of text matrix X]=],
   arguments=[[X←C2; Y←I0]],
   utf=[=[X[Y;]←(1↑⍴X)↑⍞]=],
   iso=[=[X[Y;]�(1��X)��]=]};
[606]={description=[=[First ones in groups of ones]=],
   arguments=[[X←B]],
   utf=[=[X>((-⍴⍴X)↑¯1)↓0,X]=],
   iso=[=[X>((-��X)٢1)�0,X]=]};
[607]={description=[=[Inserting X into Y after index G]=],
   arguments=[[X←A1; Y←A1; G←I0]],
   utf=[=[(G↑Y),X,G↓Y]=],
   iso=[=[(G�Y),X,G�Y]=]};
[608]={description=[=[Pairwise differences of successive columns (inverse of +\)]=],
   arguments=[[X←D]],
   utf=[=[X-((-⍴⍴X)↑¯1)↓0,X]=],
   iso=[=[X-((-��X)٢1)�0,X]=]};
[609]={description=[=[Leftmost neighboring elements]=],
   arguments=[[X←D]],
   utf=[=[((-⍴⍴X)↑¯1)↓0,X]=],
   iso=[=[((-��X)٢1)�0,X]=]};
[610]={description=[=[Rightmost neighboring elements]=],
   arguments=[[X←D]],
   utf=[=[((-⍴⍴X)↑1)↓X,0]=],
   iso=[=[((-��X)�1)�X,0]=]};
[611]={description=[=[Shifting vector X right with Y without rotate]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[(-⍴X)↑(-Y)↓X]=],
   iso=[=[(-�X)�(-Y)�X]=]};
[612]={description=[=[Shifting vector X left with Y without rotate]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[(⍴X)↑Y↓X]=],
   iso=[=[(�X)�Y�X]=]};
[613]={description=[=[Drop of Y first rows from matrix X]=],
   arguments=[[X←A2; Y←I0]],
   utf=[=[(2↑Y)↓X]=],
   iso=[=[(2�Y)�X]=]};
[614]={description=[=[Test if numeric]=],
   arguments=[[X←A]],
   utf=[=[0∊1↑0⍴X]=],
   iso=[=[0�1�0�X]=]};
[615]={description=[=[Reshaping non-empty lower-rank array X into a matrix]=],
   arguments=[[X←A; 2≥⍴⍴X]],
   utf=[=[(¯2↑1 1,⍴X)⍴X]=],
   iso=[=[(�2�1 1,�X)�X]=]};
[616]={description=[=[Giving a character default value for input]=],
   arguments=[[X←C0]],
   utf=[=[1↑⍞,X]=],
   iso=[=[1��,X]=]};
[617]={description=[=[Adding scalar Y to last element of X]=],
   arguments=[[X←D; Y←D0]],
   utf=[=[X+(-⍴X)↑Y]=],
   iso=[=[X+(-�X)�Y]=]};
[618]={description=[=[Number of rows in matrix X]=],
   arguments=[[X←A2]],
   utf=[=[1↑⍴X]=],
   iso=[=[1��X]=]};
[619]={description=[=[Number of columns in matrix X]=],
   arguments=[[X←A2]],
   utf=[=[¯1↑⍴X]=],
   iso=[=[�1��X]=]};
[620]={description=[=[Ending points for X fields of width Y]=],
   arguments=[[X←I0; Y←I0]],
   utf=[=[(X×Y)⍴(-Y)↑1]=],
   iso=[=[(X�Y)�(-Y)�1]=]};
[621]={description=[=[Starting points for X fields of width Y]=],
   arguments=[[X←I0; Y←I0]],
   utf=[=[(X×Y)⍴Y↑1]=],
   iso=[=[(X�Y)�Y�1]=]};
[622]={description=[=[Zero or space depending on the type of X (fill element)]=],
   arguments=[[X←A]],
   utf=[=[1↑0⍴X]=],
   iso=[=[1�0�X]=]};
[623]={description=[=[Forming first row of a matrix to be expanded]=],
   arguments=[[X←A1]],
   utf=[=[1 80⍴80↑X]=],
   iso=[=[1 80�80�X]=]};
[624]={description=[=[Vector of length Y with X ones on the left, the rest zeroes]=],
   arguments=[[X←I0; Y←I0]],
   utf=[=[Y↑X⍴1]=],
   iso=[=[Y�X�1]=]};
[625]={description=[=[Justifying text X to right edge of field of width Y]=],
   arguments=[[Y←I0; X←C1]],
   utf=[=[(-Y)↑X]=],
   iso=[=[(-Y)�X]=]};
[627]={description=[=[Starting points of groups of equal elements (non-empty X)]=],
   arguments=[[X←A1]],
   utf=[=[1,(1↓X)≠¯1↓X]=],
   iso=[=[1,(1�X)��1�X]=]};
[628]={description=[=[Ending points of groups of equal elements (non-empty X)]=],
   arguments=[[X←A1]],
   utf=[=[((1↓X)≠¯1↓X),1]=],
   iso=[=[((1�X)��1�X),1]=]};
[629]={description=[=[Pairwise ratios of successive elements of vector X]=],
   arguments=[[X←D1]],
   utf=[=[(1↓X)÷¯1↓X]=],
   iso=[=[(1�X)ߢ1�X]=]};
[630]={description=[=[Pairwise differences of successive elements of vector X]=],
   arguments=[[X←D1]],
   utf=[=[(1↓X)-¯1↓X]=],
   iso=[=[(1�X)-�1�X]=]};
[631]={description=[=[Differences of successive elements of X along direction Y]=],
   arguments=[[X←D; Y←I0]],
   utf=[=[X-(-Y=⍳⍴⍴X)↓0,[Y]X]=],
   iso=[=[X-(-Y=���X)�0,[Y]X]=]};
[632]={description=[=[Ascending series of integers Y..X (for small Y and X)]=],
   arguments=[[X←I0; Y←I0]],
   utf=[=[(Y-1)↓⍳X]=],
   iso=[=[(Y-1)��X]=]};
[633]={description=[=[First ones in groups of ones]=],
   arguments=[[X←B1]],
   utf=[=[X>¯1↓0,X]=],
   iso=[=[X>�1�0,X]=]};
[634]={description=[=[Last ones in groups of ones]=],
   arguments=[[X←B1]],
   utf=[=[X>1↓X,0]=],
   iso=[=[X>1�X,0]=]};
[635]={description=[=[List of names in X (one per row)]=],
   arguments=[[X←C2]],
   utf=[=[1↓,',',X]=],
   iso=[=[1�,',',X]=]};
[636]={description=[=[Selection of X or Y depending on condition G]=],
   arguments=[[X←A0; Y←A0; G←B0]],
   utf=[=[''⍴G↓X,Y]=],
   iso=[=[''�G�X,Y]=]};
[637]={description=[=[Restoring argument of cumulative sum (inverse of +\)]=],
   arguments=[[X←D1]],
   utf=[=[X-¯1↓0,X]=],
   iso=[=[X-�1�0,X]=]};
[638]={description=[=[Drop of Y first rows from matrix X]=],
   arguments=[[X←A2; Y←I0]],
   utf=[=[(Y,0)↓X]=],
   iso=[=[(Y,0)�X]=]};
[639]={description=[=[Drop of Y first columns from matrix X]=],
   arguments=[[X←A2; Y←I0]],
   utf=[=[(0,Y)↓X]=],
   iso=[=[(0,Y)�X]=]};
[640]={description=[=[Number of rows in matrix X]=],
   arguments=[[X←A2]],
   utf=[=[¯1↓⍴X]=],
   iso=[=[�1��X]=]};
[641]={description=[=[Number of columns in matrix X]=],
   arguments=[[X←A2]],
   utf=[=[1↓⍴X]=],
   iso=[=[1��X]=]};
[642]={description=[=[Conditional drop of Y elements from array X]=],
   arguments=[[X←A; Y←I1; G←B1]],
   utf=[=[(Y×G)↓X]=],
   iso=[=[(Y�G)�X]=]};
[643]={description=[=[Conditional drop of last element of X]=],
   arguments=[[X←A1; Y←B0]],
   utf=[=[(-Y)↓X]=],
   iso=[=[(-Y)�X]=]};
[644]={description=[=[Expansion vector with zero after indices Y]=],
   arguments=[[X←A1; Y←I1]],
   utf=[=[~(⍳(⍴Y)+⍴X)∊Y+⍳⍴Y]=],
   iso=[=[~(�(�Y)+�X)�Y+��Y]=]};
[645]={description=[=[Boolean vector of length Y with zeroes in locations X]=],
   arguments=[[X←I; Y←I0]],
   utf=[=[(~(⍳Y)∊X)]=],
   iso=[=[(~(�Y)�X)]=]};
[646]={description=[=[Starting points for X in indices pointed by Y]=],
   arguments=[[X←A1; Y←I1]],
   utf=[=[(⍳⍴X)∊Y]=],
   iso=[=[(��X)�Y]=]};
[647]={description=[=[Boolean vector of length Y with ones in locations X]=],
   arguments=[[X←I; Y←I0]],
   utf=[=[(⍳Y)∊X]=],
   iso=[=[(�Y)�X]=]};
[648]={description=[=[Check for input in range 1..X]=],
   arguments=[[X←A]],
   utf=[=[(Y←⎕)∊⍳X]=],
   iso=[=[(Y��)��X]=]};
[649]={description=[=[Test if arrays are identical]=],
   arguments=[[X←A; Y←A]],
   utf=[=[~0∊X=Y]=],
   iso=[=[~0�X=Y]=]};
[650]={description=[=[Zeroing elements of Y depending on their values]=],
   arguments=[[Y←D; X←D]],
   utf=[=[Y×~Y∊X]=],
   iso=[=[Y�~Y�X]=]};
[651]={description=[=[Test if single or scalar]=],
   arguments=[[X←A]],
   utf=[=[1∊⍴,X]=],
   iso=[=[1��,X]=]};
[652]={description=[=[Test if vector]=],
   arguments=[[X←A]],
   utf=[=[1∊⍴⍴X]=],
   iso=[=[1���X]=]};
[653]={description=[=[Test if X is an empty array]=],
   arguments=[[X←A]],
   utf=[=[0∊⍴X]=],
   iso=[=[0��X]=]};
[654]={description=[=[Inverting a permutation]=],
   arguments=[[X←I1]],
   utf=[=[A←⍳⍴X ⋄ A[X]←A ⋄ A]=],
   iso=[=[A���X � A[X]�A � A]=]};
[655]={description=[=[All axes of array X]=],
   arguments=[[X←A]],
   utf=[=[⍳⍴⍴X]=],
   iso=[=[���X]=]};
[656]={description=[=[All indices of vector X]=],
   arguments=[[X←A1]],
   utf=[=[⍳⍴X]=],
   iso=[=[��X]=]};
[657]={description=[=[Arithmetic progression of Y numbers from X with step G]=],
   arguments=[[X←D0; Y←D0; G←D0]],
   utf=[=[X+G×(⍳Y)-⎕IO]=],
   iso=[=[X+G�(�Y)-�IO]=]};
[658]={description=[=[Consecutive integers from X to Y (arithmetic progression)]=],
   arguments=[[X←I0; Y←I0]],
   utf=[=[(X-⎕IO)+⍳1+Y-X]=],
   iso=[=[(X-�IO)+�1+Y-X]=]};
[659]={description=[=[Empty numeric vector]=],
   arguments=[[]],
   utf=[=[⍳0]=],
   iso=[=[�0]=]};
[660]={description=[=[Index origin (⎕IO) as a vector]=],
   arguments=[[]],
   utf=[=[⍳1]=],
   iso=[=[�1]=]};
[661]={description=[=[Demote non-boolean representations to booleans]=],
   arguments=[[X←B]],
   utf=[=[0∨X]=],
   iso=[=[0�X]=]};
[662]={description=[=[Test if X is within range ( Y[1],Y[2] )]=],
   arguments=[[X←D; Y←D1]],
   utf=[=[Y[1]<X)^X<Y[2]]=],
   iso=[=[Y[1]<X)^X<Y[2]]=]};
[663]={description=[=[Test if X is within range [ Y[1],Y[2] ]]=],
   arguments=[[X←D; Y←D1; 2=⍴Y]],
   utf=[=[(Y[1]≤X)^(X≤Y[2])]=],
   iso=[=[(Y[1]�X)^(X�Y[2])]=]};
[664]={description=[=[Zeroing all boolean values]=],
   arguments=[[X←B]],
   utf=[=[0^X]=],
   iso=[=[0^X]=]};
[666]={description=[=[Selection of elements of X and Y depending on condition G]=],
   arguments=[[X←D; Y←D; G←B]],
   utf=[=[(X×G)+Y×~G]=],
   iso=[=[(X�G)+Y�~G]=]};
[667]={description=[=[Changing an index origin dependent result to be as ⎕IO=1]=],
   arguments=[[X←I]],
   utf=[=[(~⎕IO)+X]=],
   iso=[=[(~�IO)+X]=]};
[668]={description=[=[Conditional change of elements of Y to one according to X]=],
   arguments=[[Y←D; X←B]],
   utf=[=[Y*~X]=],
   iso=[=[Y*~X]=]};
[669]={description=[=[X implies Y]=],
   arguments=[[X←B; Y←B]],
   utf=[=[X≤Y]=],
   iso=[=[X�Y]=]};
[670]={description=[=[X but not Y]=],
   arguments=[[X←B; Y←B]],
   utf=[=[X>Y]=],
   iso=[=[X>Y]=]};
[671]={description=[=[Avoiding division by zero error (gets value zero)]=],
   arguments=[[X←D; Y←D]],
   utf=[=[(0≠X)×Y÷X+0=X]=],
   iso=[=[(0�X)�Y�X+0=X]=]};
[672]={description=[=[Exclusive or]=],
   arguments=[[X←B; Y←B]],
   utf=[=[X≠Y]=],
   iso=[=[X�Y]=]};
[673]={description=[=[Replacing zeroes with corresponding elements of Y]=],
   arguments=[[X←D; Y←D]],
   utf=[=[X+Y×X=0]=],
   iso=[=[X+Y�X=0]=]};
[674]={description=[=[Kronecker delta of X and Y (element of identity matrix)]=],
   arguments=[[X←I; Y←I]],
   utf=[=[Y=X]=],
   iso=[=[Y=X]=]};
[675]={description=[=[Catenating Y elements G after every element of X]=],
   arguments=[[X←A1; Y←I0; G←A]],
   utf=[=[,X,((⍴X),Y)⍴G]=],
   iso=[=[,X,((�X),Y)�G]=]};
[676]={description=[=[Catenating Y elements G before every element of X]=],
   arguments=[[X←A1; Y←I0; G←A0]],
   utf=[=[,(((⍴X),Y)⍴G),X]=],
   iso=[=[,(((�X),Y)�G),X]=]};
[677]={description=[=[Merging vectors X and Y alternately]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[,Y,[⎕IO+.5]X]=],
   iso=[=[,Y,[�IO+.5]X]=]};
[678]={description=[=[Inserting Y after each element of X]=],
   arguments=[[X←A1; Y←A0]],
   utf=[=[,X,[1.1]Y]=],
   iso=[=[,X,[1.1]Y]=]};
[679]={description=[=[Spacing out text]=],
   arguments=[[X←C1]],
   utf=[=[,X,[1.1]' ']=],
   iso=[=[,X,[1.1]' ']=]};
[680]={description=[=[Reshaping X into a matrix of width Y]=],
   arguments=[[X←D, Y←I0]],
   utf=[=[(((⍴,X),1)×Y*¯1 1)⍴X]=],
   iso=[=[(((�,X),1)�Y*�1 1)�X]=]};
[681]={description=[=[Temporary ravel of X for indexing with G]=],
   arguments=[[X←A; Y←A; G←I]],
   utf=[=[A←⍴X ⋄ X←,X ⋄ X[G]←Y ⋄ X←A⍴X]=],
   iso=[=[A��X � X�,X � X[G]�Y � X�A�X]=]};
[682]={description=[=[Temporary ravel of X for indexing with G]=],
   arguments=[[X←A; Y←A; G←I]],
   utf=[=[A←,X ⋄ A[G]←Y ⋄ X←(⍴X)⍴A]=],
   iso=[=[A�,X � A[G]�Y � X�(�X)�A]=]};
[683]={description=[=[First column as a matrix]=],
   arguments=[[X←A2]],
   utf=[=[X[;,1]]=],
   iso=[=[X[;,1]]=]};
[684]={description=[=[Number of elements (also of a scalar)]=],
   arguments=[[X←A]],
   utf=[=[⍴,X]=],
   iso=[=[�,X]=]};
[685]={description=[=[Separating variable length lines]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[X,⎕TC[2],Y]=],
   iso=[=[X,�TC[2],Y]=]};
[686]={description=[=[X×X identity matrix]=],
   arguments=[[X←I0]],
   utf=[=[(X,X)⍴1,X⍴0]=],
   iso=[=[(X,X)�1,X�0]=]};
[687]={description=[=[Array and its negative ('plus minus')]=],
   arguments=[[X←D]],
   utf=[=[X,[.5+⍴⍴X]-X]=],
   iso=[=[X,[.5+��X]-X]=]};
[688]={description=[=[Underlining a string]=],
   arguments=[[X←C1]],
   utf=[=[X,[⎕IO-.1]'¯']=],
   iso=[=[X,[�IO-.1]'�']=]};
[689]={description=[=[Forming a two-column matrix]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[X,[1.1]Y]=],
   iso=[=[X,[1.1]Y]=]};
[690]={description=[=[Forming a two-row matrix]=],
   arguments=[[X←A1; Y←A1]],
   utf=[=[X,[.1]Y]=],
   iso=[=[X,[.1]Y]=]};
[691]={description=[=[Selection of X or Y depending on condition G]=],
   arguments=[[X←A0; Y←A0; G←B0]],
   utf=[=[(X,Y)[⎕IO+G]]=],
   iso=[=[(X,Y)[�IO+G]]=]};
[692]={description=[=[Increasing rank of Y to rank of X]=],
   arguments=[[X←A; Y←A]],
   utf=[=[((((⍴⍴X)-⍴⍴Y)⍴1),⍴Y)⍴Y]=],
   iso=[=[((((��X)-��Y)�1),�Y)�Y]=]};
[693]={description=[=[Identity matrix of shape of matrix X]=],
   arguments=[[X←D2]],
   utf=[=[(⍴X)⍴1,0×X]=],
   iso=[=[(�X)�1,0�X]=]};
[694]={description=[=[Reshaping vector X into a two-column matrix]=],
   arguments=[[X←A1]],
   utf=[=[((0.5×⍴X),2)⍴X]=],
   iso=[=[((0.5��X),2)�X]=]};
[696]={description=[=[Reshaping vector X into a one-row matrix]=],
   arguments=[[X←A1]],
   utf=[=[(1,⍴X)⍴X]=],
   iso=[=[(1,�X)�X]=]};
[697]={description=[=[Reshaping vector X into a one-column matrix]=],
   arguments=[[X←A1]],
   utf=[=[((⍴X),1)⍴X]=],
   iso=[=[((�X),1)�X]=]};
[698]={description=[=[Forming a Y-row matrix with all rows alike (X)]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[(Y,⍴X)⍴X]=],
   iso=[=[(Y,�X)�X]=]};
[699]={description=[=[Handling array X temporarily as a vector]=],
   arguments=[[X←A]],
   utf=[=[(⍴X)⍴ ... ,X]=],
   iso=[=[(�X)� ... ,X]=]};
[700]={description=[=[Joining sentences]=],
   arguments=[[X←A; Y←A1]],
   utf=[=[Y,0⍴X]=],
   iso=[=[Y,0�X]=]};
[701]={description=[=[Entering from terminal data exceeding input (printing) width]=],
   arguments=[[X←D]],
   utf=[=[X←0 2 1 2 5 8 0 4 5,⎕]=],
   iso=[=[X�0 2 1 2 5 8 0 4 5,�]=]};
[702]={description=[=[Value of fixed-degree polynomial Y at points X]=],
   arguments=[[Y←D1; X←D]],
   utf=[=[Y[3]+X×Y[2]+X×Y[1]]=],
   iso=[=[Y[3]+X�Y[2]+X�Y[1]]=]};
[703]={description=[=[Number of columns in array X]=],
   arguments=[[X←A]],
   utf=[=[(⍴X)[⍴⍴X]]=],
   iso=[=[(�X)[��X]]=]};
[704]={description=[=[Number of rows in matrix X]=],
   arguments=[[X←A2]],
   utf=[=[(⍴X)[1]]=],
   iso=[=[(�X)[1]]=]};
[705]={description=[=[Number of columns in matrix X]=],
   arguments=[[X←A2]],
   utf=[=[(⍴X)[2]]=],
   iso=[=[(�X)[2]]=]};
[706]={description=[=[Conditional elementwise change of sign]=],
   arguments=[[Y←D; X←B]],
   utf=[=[Y×(1 ¯1)[1+X]]=],
   iso=[=[Y�(1 �1)[1+X]]=]};
[707]={description=[=[Selection depending on index origin]=],
   arguments=[[X←A1]],
   utf=[=[X[2×⎕IO]]=],
   iso=[=[X[2��IO]]=]};
[708]={description=[=[Indexing with boolean value X (plotting a curve)]=],
   arguments=[[X←B]],
   utf=[=[' *'[⎕IO+X]]=],
   iso=[=[' *'[�IO+X]]=]};
[709]={description=[=[Indexing independent of index origin]=],
   arguments=[[X←A1; Y←I]],
   utf=[=[X[⎕IO+Y]]=],
   iso=[=[X[�IO+Y]]=]};
[710]={description=[=[Selection depending on index origin]=],
   arguments=[[X←A1]],
   utf=[=[X[1]]=],
   iso=[=[X[1]]=]};
[711]={description=[=[Zeroing a vector (without change of size)]=],
   arguments=[[X←D1]],
   utf=[=[X[]←0]=],
   iso=[=[X[]�0]=]};
[712]={description=[=[First column as a vector]=],
   arguments=[[X←A2]],
   utf=[=[X[;1]]=],
   iso=[=[X[;1]]=]};
[713]={description=[=[Rank of array X]=],
   arguments=[[X←A]],
   utf=[=[⍴⍴X]=],
   iso=[=[��X]=]};
[715]={description=[=[Duplicating vector X Y times]=],
   arguments=[[X←A1; Y←I0]],
   utf=[=[(Y×⍴X)⍴X]=],
   iso=[=[(Y��X)�X]=]};
[716]={description=[=[Adding X to each row of Y]=],
   arguments=[[X←D1; Y←D; (⍴X)=¯1↑⍴Y]],
   utf=[=[Y+(⍴Y)⍴X]=],
   iso=[=[Y+(�Y)�X]=]};
[717]={description=[=[Array with shape of Y and X as its rows]=],
   arguments=[[X←A1; Y←A]],
   utf=[=[(⍴Y)⍴X]=],
   iso=[=[(�Y)�X]=]};
[718]={description=[=[Number of rows in matrix X]=],
   arguments=[[X←A2]],
   utf=[=[1⍴⍴X]=],
   iso=[=[1��X]=]};
[720]={description=[=[Forming an initially empty array to be expanded]=],
   arguments=[[]],
   utf=[=[0 80⍴0]=],
   iso=[=[0 80�0]=]};
[721]={description=[=[Output of an empty line]=],
   arguments=[[X←A]],
   utf=[=[0⍴X←]=],
   iso=[=[0�X�]=]};
[722]={description=[=[Reshaping first element of X into a scalar]=],
   arguments=[[X←A]],
   utf=[=[''⍴X]=],
   iso=[=[''�X]=]};
[723]={description=[=[Corner element of a (non-empty) array]=],
   arguments=[[X←A]],
   utf=[=[1⍴X]=],
   iso=[=[1�X]=]};
[724]={description=[=[Continued fraction]=],
   arguments=[[]],
   utf=[=[1+÷2+÷3+÷4+÷5+÷6+÷ ...]=],
   iso=[=[1+�2+�3+�4+�5+�6+� ...]=]};
[725]={description=[=[Force 0÷0 into DOMAIN ERROR in division]=],
   arguments=[[X←D; Y←D]],
   utf=[=[Y×÷X]=],
   iso=[=[Y��X]=]};
[726]={description=[=[Conditional elementwise change of sign]=],
   arguments=[[X←D; Y←B; ⍴X ←→ ⍴Y]],
   utf=[=[X×¯1*Y]=],
   iso=[=[X��1*Y]=]};
[727]={description=[=[Zero array of shape and size of X]=],
   arguments=[[X←D]],
   utf=[=[0×X]=],
   iso=[=[0�X]=]};
[728]={description=[=[Selecting elements satisfying condition Y, zeroing others]=],
   arguments=[[X←D; Y←B]],
   utf=[=[Y×X]=],
   iso=[=[Y�X]=]};
[729]={description=[=[Number and its negative ('plus minus')]=],
   arguments=[[X←D0]],
   utf=[=[1 ¯1×X]=],
   iso=[=[1 �1�X]=]};
[730]={description=[=[Changing an index origin dependent result to be as ⎕IO=0]=],
   arguments=[[X←I]],
   utf=[=[-⎕IO-X]=],
   iso=[=[-�IO-X]=]};
[731]={description=[=[Changing an index origin dependent argument to act as ⎕IO=1]=],
   arguments=[[X←I]],
   utf=[=[(⎕IO-1)+X]=],
   iso=[=[(�IO-1)+X]=]};
[732]={description=[=[Output of assigned numeric value]=],
   arguments=[[X←D]],
   utf=[=[+X←]=],
   iso=[=[+X�]=]};
[733]={description=[=[Changing an index origin dependent argument to act as ⎕IO=0]=],
   arguments=[[X←I]],
   utf=[=[⎕IO+X]=],
   iso=[=[�IO+X]=]};
[734]={description=[=[Selecting elements satisfying condition Y, others to one]=],
   arguments=[[X←D; Y←B]],
   utf=[=[X*Y]=],
   iso=[=[X*Y]=]};
[736]={description=[=[Setting a constant with hyphens]=],
   arguments=[[]],
   utf=[=[⎕LX←⍞]=],
   iso=[=[�LX��]=]};
[737]={description=[=[Output of assigned value]=],
   arguments=[[X←A]],
   utf=[=[⎕←X←]=],
   iso=[=[��X�]=]};
[738]={description=[=[Syntax error to stop execution]=],
   arguments=[[]],
   utf=[=[*]=],
   iso=[=[*]=]};
[888]={description=[=[Meaning of life]=],
   arguments=[[]],
   utf=[=[⍎⊖⍕⊃⊂|⌊-*+○⌈×÷!⌽⍉⌹~⍴⍋⍒,⍟?⍳0]=],
   iso=[=[�����|�-*+�ӫ�!���~���,�?�0]=]};
   maxn=888}
