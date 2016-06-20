module Main where

import Language.Drasil (DocType(SRS,LPM,Website,Code))
import Language.Drasil.Recipe (Recipe(..))
import Language.Drasil.Generate (gen)

import Example.Drasil.HGHC (srsBody,lpmBody,codeBody)
import Example.Drasil.PCM.Body (pcm_srs)

docs :: [Recipe]
docs = [Recipe (SRS "SRS")     srsBody, 
        Recipe (Website "SRS") srsBody,
--        Recipe SRS "PCM_SRS.tex" createSRS2,
        Recipe (LPM "LPM")     lpmBody,
        Recipe (Code "Code")   codeBody,
        Recipe (SRS "PCM_SRS") pcm_srs,
        Recipe (Website "PCM_SRS") pcm_srs
       ]

main :: IO ()            
main = do
  gen docs
