module Drasil.GlassBR.ModuleDefs (implVars, allMods) where

import Language.Drasil hiding (a_)

import Drasil.GlassBR.Unitals (plate_len, plate_width, nom_thick,
  glass_type, char_weight, tNT, sdx, sdy, sdz, pb_tol)

allMods :: [Mod]
allMods = [readTableMod, inputMod, interpMod]

-- It's a bit odd that this has to be explicitly built here...
implVars :: [VarChunk]
implVars = [v, x_z_1, y_z_1, x_z_2, y_z_2, mat, col,
  i, j, k, z, z_vector, y_array, x_array, y, arr, filename,
  y_2, y_1, x_2, x_1, x]

--from TSD.txt:

read_table :: Func
read_table = funcData "read_table" $
  [ singleLine (repeated [junk, listEntry [WithPattern] z_vector]) ',',
    multiLine (repeated [listEntry [WithLine, WithPattern] x_array, 
                         listEntry [WithLine, WithPattern] y_array]) ','
  ]
  
readTableMod :: Mod
readTableMod = packmod "ReadTable" [read_table]

-----

--from defaultInput.txt:

glassInputData :: Func
glassInputData = funcData "get_input" $
  [ junkLine,
    singleton plate_len, singleton plate_width, singleton nom_thick,
    junkLine,
    singleton glass_type, 
    junkLine,
    singleton char_weight, 
    junkLine, 
    singleton tNT, 
    junkLine,
    singleton sdx, singleton sdy, singleton sdz,
    junkLine,
    singleton pb_tol
  ]

inputMod :: Mod
inputMod = packmod "InputFormat" [glassInputData]

-----
  
one, two :: Symbol
one = Atomic "1"
two = Atomic "2"  

y_2, y_1, x_2, x_1, x :: VarChunk
y_1  = implVar "v_y_1"    (nounPhraseSP "y1")   (sub lY one) Real
y_2  = implVar "v_y_2"    (nounPhraseSP "y2")   (sub lY two) Real
x_1  = implVar "v_x_1"    (nounPhraseSP "x1")   (sub lX one) Real
x_2  = implVar "v_x_2"    (nounPhraseSP "x2")   (sub lX two) Real
x    = implVar "v_x"      (nounPhraseSP "x")    lX           Real -- = params.wtnt from mainFun.py

v, x_z_1, y_z_1, x_z_2, y_z_2, mat, col,
  i, j, k, z, z_vector, y_array, x_array, y, arr, filename :: VarChunk
v       = implVar "v_v"          (nounPhraseSP "v")       lV  Real
i       = implVar "v_i"          (nounPhraseSP "i")       lI  Natural
j       = implVar "v_j"          (nounPhraseSP "j")       lJ  Natural
k       = implVar "v_k"          (nounPhraseSP "k")       (sub lK two) Natural -- k breaks things until we start using ids
                                                                          -- in codegen (after refactor end of August)
z       = implVar "v_z"       (nounPhraseSP "z")       lZ  Real
z_vector = implVar "v_z_vector" (nounPhraseSP "z_vector") (sub lZ (Atomic "vector")) (Vect Real)
y_array = implVar "v_y_array" (nounPhraseSP "y_array") (sub lY (Atomic "array")) (Vect $ Vect Real)
x_array = implVar "v_x_array" (nounPhraseSP "x_array") (sub lX (Atomic "array")) (Vect $ Vect Real)
y       = implVar "v_y"       (nounPhraseSP "y")       lY Real
arr     = implVar "v_arr"     (nounPhraseSP "arr")     (Atomic "arr") (Vect Real)--FIXME: temporary variable for indInSeq?
x_z_1   = implVar "v_x_z_1"   (nounPhraseSP "x_z_1")     (sub lX (sub lZ one)) (Vect Real)
y_z_1   = implVar "v_y_z_1"   (nounPhraseSP "y_z_1")     (sub lY (sub lZ one)) (Vect Real)
x_z_2   = implVar "v_x_z_2"   (nounPhraseSP "x_z_2")     (sub lX (sub lZ two)) (Vect Real)
y_z_2   = implVar "v_y_z_2"   (nounPhraseSP "y_z_2")     (sub lY (sub lZ two)) (Vect Real)
mat     = implVar "v_mat"     (nounPhraseSP "mat")       (Atomic "mat") (Vect $ Vect Real)
col     = implVar "v_col"     (nounPhraseSP "col")       (Atomic "col") (Vect Real)
filename= implVar "v_filename" (nounPhraseSP "filename") (Atomic "filename") String

------------------------------------------------------------------------------------------
--
-- Some semantic functions

-- Given two points (x1,y1) and (x2,y2), and an x ordinate, return
-- interpolated y on the straight line in between
interp :: (Num a, Fractional a) => (a, a) -> (a, a) -> a -> a
interp (x1,y1) (x2,y2) x_ = ((y2 - y1) / (x2 - x1)) * (x_ - x1) + y1

------------------------------------------------------------------------------------------
-- Code Template functions

vLook :: (HasSymbol a, HasSymbol i, Chunk a, Chunk i) => a -> i -> Expr -> Expr

vLook a i_ p = idx (sy a) (sy i_ + p)

aLook :: (HasSymbol a, HasSymbol i, HasSymbol j, Chunk a, Chunk i, Chunk j) => 
  a -> i -> j -> Expr
aLook a i_ j_ = idx (idx (sy a) (sy i_)) (sy j_)

getCol, getColp1 :: (HasSymbol a, HasSymbol i, Chunk a, Chunk i) => a -> i -> Expr
getCol   a_ i_ = apply (asExpr extractColumn) [sy a_, sy i_]
getColp1 a_ i_ = apply (asExpr extractColumn) [sy a_, sy i_ + 1]

------------------------------------------------------------------------------------------
-- Instantiating

linInterp :: Func
linInterp = funcDef "lin_interp" [x_1, y_1, x_2, y_2, x] Real 
  [ FRet $ interp (sy x_1, sy y_1) (sy x_2, sy y_2) (sy x) ]

------------------------------------------------------------------------------------------
-- More straightforward "code generation"

indInSeq :: Func
indInSeq = funcDef "indInSeq" [arr, v] Natural 
  [
    ffor i (sy i $< (dim (sy arr) - 1))
      [ FCond ((vLook arr i 0 $<= (sy v)) $&& ((sy v) $<= vLook arr i 1))
        [ FRet $ sy i ] [] ],
    FThrow "Bound error"      
  ]

extractColumn :: Func
extractColumn = funcDef "extractColumn" [mat, j] (Vect Real) 
  [
    fdec col,
    --
    ffor i (sy i $< dim (sy mat)) 
      [ FAppend (sy col) (aLook mat i j) ],
    FRet (sy col)
  ]

interpY :: Func
interpY = funcDef "interpY" [{-x_array, y_array, z_vector,-} filename, x, z] Real
  [
    -- hack
  fdec x_array,
  fdec y_array,
  fdec z_vector,
  --
  FProcCall read_table [sy filename, sy z_vector, sy x_array, sy y_array],
  -- endhack
    i     $:= (apply (asExpr indInSeq)      [sy z_vector, sy z]),
    x_z_1 $:= getCol   x_array i,
    y_z_1 $:= getCol   y_array i,
    x_z_2 $:= getColp1 x_array i,
    y_z_2 $:= getColp1 y_array i,
    FTry 
      [ j $:= (apply2 (asVC indInSeq) x_z_1 x),
        k $:= (apply2 (asVC indInSeq) x_z_2 x) ]
      [ FThrow "Interpolation of y failed" ],
    y_1 $:= (apply (asExpr linInterp) [ vLook x_z_1 j 0,
                                        vLook y_z_1 j 0,
                                        vLook x_z_1 j 1,
                                        vLook y_z_1 j 1,
                                        sy x ]),
    y_2 $:= (apply (asExpr linInterp) [ vLook x_z_2 k 0,
                                        vLook y_z_2 k 0,
                                        vLook x_z_2 k 1,
                                        vLook y_z_2 k 1,
                                        sy x ]),
    FRet (apply (asExpr linInterp) [ vLook z_vector i 0,
                                     sy y_1,
                                     vLook z_vector i 1,
                                     sy y_2,
                                     sy z ] )                                  
  ]  
  
interpZ :: Func
interpZ = funcDef "interpZ" [{-x_array, y_array, z_vector,-} filename, x, y] Real
  [
    -- hack
  fdec x_array,
  fdec y_array,
  fdec z_vector,
  --
  FProcCall read_table [sy filename, sy z_vector, sy x_array, sy y_array],
  -- endhack
    ffor i (sy i $< (dim (sy z_vector) - 1)) 
      [
        x_z_1 $:= (apply (asExpr extractColumn) [sy x_array, sy i]),
        y_z_1 $:= (apply (asExpr extractColumn) [sy y_array, sy i]),
        x_z_2 $:= (apply (asExpr extractColumn) [sy x_array, (sy i) + 1]),
        y_z_2 $:= (apply (asExpr extractColumn) [sy y_array, (sy i) + 1]),
        FTry 
          [ j $:= (apply2 (asVC indInSeq) x_z_1 x),
            k $:= (apply2 (asVC indInSeq) x_z_2 x) ]
          [ FContinue ],
        y_1 $:= (apply (asExpr linInterp) [ vLook x_z_1 j 0,
                                            vLook y_z_1 j 0,
                                            vLook x_z_1 j 1,
                                            vLook y_z_1 j 1,
                                            sy x ]),
        y_2 $:= (apply (asExpr linInterp) [ vLook x_z_2 k 0,
                                            vLook y_z_2 k 0,
                                            vLook x_z_2 k 1,
                                            vLook y_z_2 k 1,
                                            sy x ]),
        FCond ((sy y_1 $<= sy y) $&& (sy y $<= sy y_2))
          [ FRet (apply (asExpr linInterp) [ sy y_1,
                                             idx (sy z_vector) (sy i),
                                             sy y_2,
                                             idx (sy z_vector) ((sy i) + 1),
                                             sy y ] )  
          ] []                                             
      ],
    FThrow "Interpolation of z failed"      
  ]


interpMod :: Mod
interpMod = packmod "Interpolation" [linInterp, indInSeq, extractColumn, interpY, interpZ]
