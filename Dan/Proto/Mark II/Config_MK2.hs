{-# OPTIONS -Wall #-} 
module Config_MK2 where
import ASTInternal_MK2

output :: OutFormat  
output = TeX

outLang :: OutLang
outLang = CLang

-- precision :: Precision
-- precision = Double

expandSymbols :: Bool
expandSymbols = True

srsTeXParams :: [DocParams]
srsTeXParams = defaultSRSparams

tableWidth :: Double --in cm
tableWidth = 10.5

--TeX Document Parameter Defaults (can be modified to affect all documents OR
  -- you can create your own parameter function and replace the one above.
defaultSRSparams :: [DocParams]
defaultSRSparams = [
  DocClass  [] "article",
  UsePackages ["booktabs","longtable"]
  ]

  
datadefnFields :: [Field]
datadefnFields = [Symbol, SIU, Equation, Description]

  --column width for data definitions (fraction of textwidth)
colAwidth, colBwidth :: Double
colAwidth = 0.2
colBwidth = 0.73