module Language.Drasil.Template.DD(makeMG) where

import Language.Drasil.Document
import Language.Drasil.Chunk
import Language.Drasil.Chunk.Module
import Language.Drasil.Spec
import Language.Drasil.Printing.Helpers
import Language.Drasil.Reference

import Control.Lens ((^.))
import Data.List (nub, (\\))
import Data.Maybe (fromJust, isNothing)

type MPair = (ModuleChunk, Maybe Contents)

getChunks :: [MPair] -> [ModuleChunk]
getChunks [] = []
getChunks ((mc,_):mps) = mc:getChunks mps

getMods :: [MPair] -> [Contents]
getMods [] = []
getMods ((_,Nothing):mps) = getMods mps
getMods ((_,Just m):mps)  = m:getMods mps

makeMG :: [ModuleChunk] -> [Section]
makeMG mcs = let mhier  = buildMH $ splitLevels mcs
                 mpairs = map createMPair (getMHOrder mhier)
                 hierTable = mgHierarchy $ formatMH mhier
  in [ mgModuleHierarchy mpairs hierTable,
       mgModuleDecomp mpairs ]

createMPair :: ModuleChunk -> MPair
createMPair mc = if   (imp mc == Nothing)
                 then (mc, Nothing)
                 else (mc, Just $ Module mc)

mgModuleHierarchy :: [MPair] -> Contents -> Section
mgModuleHierarchy mpairs hierTable =
  Section 0 (S "Module Hierarchy") (
    [ Con $ mgModuleHierarchyIntro hierTable ]
    ++ (map Con $ getMods mpairs)
    ++ [Con hierTable]
  )

mgModuleHierarchyIntro :: Contents -> Contents
mgModuleHierarchyIntro t@(Table _ _ _ _) = Paragraph $
  S "This section provides an overview of the module design. Modules are " :+:
  S "summarized in a hierarchy decomposed by secrets in " :+:
  makeRef t :+:
  S ". The modules listed below, which are leaves in the hierarchy tree, " :+:
  S "are the modules that will actually be implemented."


mgHierarchy :: [[Sentence]] -> Contents
mgHierarchy mh = let cnt = length $ head mh
                     hdr = map (\x -> S $ "Level " ++ show x) $ take cnt [1..]
                 in  Table hdr mh (S "Module Hierarchy") True

buildMH :: [[ModuleChunk]] -> [[Maybe ModuleChunk]]
buildMH mcl = map (padBack (length mcl)) $ buildMH' Nothing mcl
  where buildMH' _ []                 = []
        buildMH' _ ([]:_)             = []
        buildMH' mLast ((mc:mcs):mcl) =
          let nextCol = buildMH' (Just mc) mcl
              padCnt = length nextCol - 1
          in  if (hier mc == mLast)
              then ((Just mc):replicate padCnt (Nothing)) `jCols` nextCol
                ++ buildMH' mLast (mcs:mcl)
              else buildMH' mLast (mcs:mcl)
          where jCols [] [] = []
                jCols x []  = [x]
                jCols (x:xs) (y:ys) = [x:y] ++ jCols xs ys
        padBack n s = s ++ replicate (n - length s) (Nothing)

formatMH :: [[Maybe ModuleChunk]] -> [[Sentence]]
formatMH = map (map (\x -> if   isNothing x
                           then (S "")
                           else (S $ formatName $ fromJust x)))

getMHOrder :: [[Maybe ModuleChunk]] -> [ModuleChunk]
getMHOrder = concat . map removeNothing
  where removeNothing []       = []
        removeNothing (mc:mcs) = if isNothing mc
                                 then removeNothing mcs
                                 else (fromJust mc):removeNothing mcs

splitLevels :: [ModuleChunk] -> [[ModuleChunk]]
splitLevels mcs = splitLevels' mcs []
  where splitLevels' [] sl  = sl
        splitLevels' mcs [] = let level = splitLevelsInit mcs
                      in  splitLevels' (mcs \\ level) [level]
          where splitLevelsInit []         = []
                splitLevelsInit (mc:mcs)   = if   (hier mc == Nothing)
                                             then mc:splitLevelsInit mcs
                                             else splitLevelsInit mcs
        splitLevels' mcs sl = let level = splitLevels'' (last sl) mcs
                              in  splitLevels' (mcs \\ level) (sl ++ [level])
          where splitLevels'' _ []          = []
                splitLevels'' prev (mc:mcs) = let current = fromJust $ hier mc
                                              in  if   current `elem` prev
                                                  then mc:splitLevels'' prev mcs
                                                  else splitLevels'' prev mcs

getLevel :: ModuleChunk -> [[ModuleChunk]] -> Int
getLevel mc ls = getLevel' mc ls 0
  where getLevel' _ [] _      = error "Module not found"
        getLevel' mc (l:ls) n = if   (mc `elem` l)
                                then min n 1
                                else getLevel' mc ls (n+1)

mgModuleDecomp :: [MPair] -> Section
mgModuleDecomp mpairs = let levels = splitLevels $ getChunks mpairs
  in Section 0 (S "Module Decomposition") (
       [Con $ mgModuleDecompIntro $ getChunks mpairs]
       ++ map (\x -> Sub (mgModuleInfo x levels)) mpairs
     )

mgModuleDecompIntro :: [ModuleChunk] -> Contents
mgModuleDecompIntro mcs =
  let impl ccs = foldl1 (:+:) $ map (\x -> (S $ "If the entry is " ++
       (x ^. name) ++ ", this means that the module is provided by the ")
       :+: (x ^. descr) :+: S ". ") ccs
  in Paragraph $
    S "Modules are decomposed according to the principle of \"information " :+:
    S "hiding\" proposed by Parnas. The Secrets field in a module " :+:
    S "decomposition is a brief statement of the design decision hidden by " :+:
    S "the module. The Services field specifies what the module will do " :+:
    S "without documenting how to do it. For each module, a suggestion for " :+:
    S "the implementing software is given under the Implemented By title. " :+:
    impl (nub $ getImps mcs) :+:
    S "Only the leaf modules in the hierarchy have to be implemented. If a " :+:
    S "dash (--) is shown, this means that the module is not a leaf and " :+:
    S "will not have to be implemented. Whether or not this module is " :+:
    S "implemented depends on the programming language selected."
      where
        getImps []     = []
        getImps (m:ms) = if imp m == Nothing
                         then getImps ms
                         else (fromJust $ imp m):getImps ms

mgModuleInfo :: MPair -> [[ModuleChunk]] -> Section
mgModuleInfo (mc, m) ls = let title = if   isNothing m
                                   then S (formatName mc)
                                   else S (formatName mc) :+: S " (" :+:
                                          (makeRef $ fromJust m) :+: S ")"
                              level = getLevel mc ls
  in Section (1 + level)
    title
    [ Con $ Enumeration $ Desc
      [(S "Secrets", Flat (secret mc)),
       (S "Services", Flat (mc ^. descr)),
       (S "Implemented By", Flat (getImp $ imp mc))
      ]
    ]
    where
      getImp (Just x) = S (x ^. name)
      getImp _        = S "--"