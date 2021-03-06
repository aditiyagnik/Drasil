module Data.Drasil.IdeaDicts where

import Language.Drasil.Chunk.NamedIdea (IdeaDict, mkIdea)
import Language.Drasil.Chunk.CommonIdea (CI, commonIdeaWithDict)
import Language.Drasil.NounPhrase (cn')

compScience, softEng, mathematics, progLanguage, idglass, physics, civilEng
  , materialEng, documentc, knowledgemng :: IdeaDict
-------------------------------------------------------------------------------
--  IdeaDict     |   |      id       |       term                    |  abbreviation
-------------------------------------------------------------------------------
compScience  = mkIdea  "compScience"    (cn' "Computer Science")      (Just "CS")
softEng      = mkIdea  "softEng"        (cn' "Software Engineering")  (Just "SE")
mathematics  = mkIdea  "mathematics"    (cn' "Mathematics")           Nothing
progLanguage = mkIdea  "progLanguage"   (cn' "Programming Language")  Nothing
idglass      = mkIdea  "glass"          (cn' "Glass")                 Nothing
physics      = mkIdea  "physics"        (cn' "Physics")               Nothing
civilEng     = mkIdea  "civilEng"       (cn' "Civil Engineering")     Nothing
materialEng  = mkIdea  "materialEng"    (cn' "Material Engineering")  Nothing
documentc    = mkIdea  "documentc"      (cn' "Document")              (Just "Doc")
knowledgemng = mkIdea  "knowledgemng"   (cn' "Knowledge Management")  Nothing

dataDefn, genDefn, inModel, thModel :: CI

dataDefn = commonIdeaWithDict "dataDefn" (cn' "data definition")    "DD"  [softEng]
genDefn  = commonIdeaWithDict "genDefn"  (cn' "general definition") "GD"  [softEng]
inModel  = commonIdeaWithDict "inModel"  (cn' "instance model")     "IM"  [softEng]
thModel  = commonIdeaWithDict "thModel"  (cn' "theoretical model")  "TM"  [softEng]
