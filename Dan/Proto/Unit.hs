{-# OPTIONS -Wall #-} 
module Unit where

import ASTInternal using (Expr(..))

data Unit c = Fundamental --Fundamental unit type (e.g. "m" for length)
          | Derived (Expr c)--Derived unit type (e.g. "J" for power, from
                                --the expression kg m^2 / s^2
