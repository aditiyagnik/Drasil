{-# Language Rank2Types #-}
module Drasil.DocumentLanguage.RefHelpers
  ( refR, refChng, cite
  , refRByNum, refChngByNum, citeByNum
  , ModelDB, tmRefDB, gdRefDB, ddRefDB, imRefDB
  , mdb, modelsFromDB
  ) where

import Language.Drasil

import Control.Lens ((^.), Simple, Lens)
import Data.List (sortBy)
import Data.Function (on)
import qualified Data.Map as Map (elems, lookup)

modelsFromDB :: RefMap a -> [a]
modelsFromDB db = dropNums $ sortBy (compare `on` snd) elemPairs
  where elemPairs = Map.elems db
        dropNums = map fst

-- Trying not to add to RefDB since these are recipe-specific content-types for
-- the SmithEtAl Template recipe.
data ModelDB = MDB
             { tmRefDB :: RefMap TheoryModel
             , gdRefDB :: RefMap GenDefn
             , ddRefDB :: RefMap QDefinition
             , imRefDB :: RefMap InstanceModel
             }

mdb :: [TheoryModel] -> [GenDefn] -> [QDefinition] -> [InstanceModel] -> ModelDB
mdb tms gds dds ims = MDB
  (simpleMap tms) (simpleMap gds) (simpleMap dds) (simpleMap ims)

modelLookup :: HasUID a => a -> RefMap a -> (a, Int)
modelLookup c db = getS $ Map.lookup (c ^. uid) db
  where getS (Just x) = x
        getS Nothing  = error $ "Could not find model id: " ++ c ^. uid ++
                       " in model database"

-- | Internal lookup function for the number associated with an assumption,
-- requirement, etc. and returns it as a Sentence.
-- Takes a reference database, a lens to the appropriate table, a lookup function,
-- and a chunk of the appropriate type to look up.
-- For example, looking up an assumption number would require:
-- a reference database, the assumpRefTable lens, the assumpLookup function, and
-- the assumption chunk being looked up.
numLookup :: HasUID c => ReferenceDB -> Simple Lens ReferenceDB t ->
  (c -> t -> (ct, Int)) -> c -> String
numLookup db tableLens lookupFun chunk =
  show $ snd $ lookupFun chunk (db ^. tableLens)

-- | Verifies that a chunk exists within our referencing database before we
-- attempt to make a reference to it.
chunkLookup :: HasUID c => ReferenceDB -> Simple Lens ReferenceDB t ->
  (c -> t -> (ct, Int)) -> c -> ct
chunkLookup db tableLens lookupFun chunk =
  fst $ lookupFun chunk (db ^. tableLens)

-- | Smart constructors for requirement referencing by name or by number.
refR, refRByNum :: ReferenceDB -> ReqChunk -> Sentence
refR rfdb = refRCustom rfdb ByName
refRByNum rfdb = refRCustom rfdb ByNum

-- | Reference Requirements by Name or by Number where applicable
refRCustom :: ReferenceDB -> RefBy -> ReqChunk -> Sentence
refRCustom rfdb ByNum  r = customRef r (shortname' $ show (reqType r) ++
  numLookup rfdb reqRefTable reqLookup r)
refRCustom rfdb ByName r = makeRef (chunkLookup rfdb reqRefTable reqLookup r)

-- | Smart constructors for likely/unlikely change referencing by name or by number.
refChng, refChngByNum :: ReferenceDB -> Change -> Sentence
refChng rfdb = refChngCustom rfdb ByName
refChngByNum rfdb = refChngCustom rfdb ByNum

-- | Reference Changes by Name or by Number where applicable
refChngCustom :: ReferenceDB -> RefBy -> Change -> Sentence
refChngCustom chdb ByNum  c = customRef c (shortname' $ show (chngType c) ++
  numLookup chdb changeRefTable changeLookup c)
refChngCustom chdb ByName c =
  makeRef (chunkLookup chdb changeRefTable changeLookup c)

-- | Smart constructors for citation referencing by name or by number.
cite, citeByNum :: ReferenceDB -> Citation -> Sentence
cite rfdb = citeCustom rfdb ByName
citeByNum rfdb = citeCustom rfdb ByNum

-- | Reference Changes by Name or by Number where applicable
citeCustom :: ReferenceDB -> RefBy -> Citation -> Sentence
citeCustom rfdb ByNum  c = customRef c
  (shortname' $ "[" ++ numLookup rfdb citationRefTable citeLookup c ++ "]")
citeCustom rfdb ByName c =
  makeRef (chunkLookup rfdb citationRefTable citeLookup c)