module Drasil.SSP.Body where

import Control.Lens ((^.))
import Prelude hiding (id, sin, cos, tan)

import Language.Drasil
import Data.Drasil.SI_Units
import Data.Drasil.Authors

import Drasil.SSP.Defs
import Drasil.SSP.Unitals
import Drasil.SSP.Modules
import Drasil.SSP.Changes
import Drasil.SSP.Reqs
import Drasil.SSP.TMods
import Drasil.SSP.GenDefs
import Drasil.SSP.DataDefs
import Drasil.SSP.IMods
import qualified Drasil.SRS as SRS

import Drasil.Sections.ReferenceMaterial
import Drasil.DocumentLanguage
import Drasil.Sections.SpecificSystemDescription
import Drasil.Sections.Requirements
import Drasil.Sections.GeneralSystDesc
import Drasil.Sections.AuxiliaryConstants

import Data.Drasil.Concepts.Documentation
import Data.Drasil.Concepts.Physics
import Data.Drasil.Concepts.PhysicalProperties
import Data.Drasil.Concepts.Software
import Data.Drasil.Concepts.Computation
import Data.Drasil.Concepts.Math hiding (constraint)
import Data.Drasil.Concepts.SolidMechanics (normForce, shearForce)
import Data.Drasil.Software.Products

import Data.Drasil.Utils
import Data.Drasil.SentenceStructures

import Drasil.Template.MG
import Drasil.Template.DD

--type declarations for sections--
s3, s4, s5, s6, s7, s8 :: Section

s1_2_intro :: [TSIntro]

s4_1, s4_1_1, s4_1_2,
  s4_1_3, s4_2, s5_1, s5_2 :: Section

s4_1_1_list, s4_1_2_p1, s4_1_2_bullets,
  s4_1_2_p2, s4_1_2_fig1, s4_1_2_fig2,
  s4_1_3_list, s4_2_1_list,
  s4_2_5_p2, s4_2_5_p3, s5_1_list, s5_1_table,
  s8_list :: Contents

s4_2_2_tmods, s4_2_3_genDefs, s4_2_4_dataDefs, s4_2_5_IMods :: [Contents]

--Document Setup--
this_si :: [UnitDefn]
this_si = map UU [metre, degree] ++ map UU [newton, pascal]

ssp_si :: SystemInformation
ssp_si = SI ssa srs [henryFrankis]
  this_si sspSymbols (sspSymbols) acronyms sspDataDefs (map qs sspInputs) (map qs sspOutputs)
  [Parallel (head sspDataDefs) (tail sspDataDefs)] sspConstrained

mkSRS :: DocDesc
mkSRS = RefSec (RefProg intro
  [TUnits, tsymb'' s1_2_intro TAD, TAandA]) :
  IntroSec (IntroProg startIntro kSent
    [IPurpose prpsOfDoc_p1, IScope scpIncl scpEnd
    , IChar (S "solid mechanics") (S "undergraduate level 4" +:+ phrase physics)
        EmptyS
    , IOrgSec orgSecStart inModel (SRS.inModel SRS.missingP []) orgSecEnd]) :
    --FIXME: SRS.inModel should be removed and the instance model section
    --should be looked up from "inModel" by the interpreter while generating.
  map Verbatim [s3, s4, s5, s6, s7, s8]

ssp_srs, ssp_mg :: Document
ssp_srs = mkDoc mkSRS ssp_si
ssp_mg = mgDoc ssa (name henryFrankis) mgBod

mgBod :: [Section]
(mgBod, _) = makeDD likelyChanges unlikelyChanges reqs modules

-- SYMBOL MAP HELPERS --
sspSymMap :: SymbolMap
sspSymMap = symbolMap sspSymbols

sspSymMapT :: RelationConcept -> Contents
sspSymMapT = symbolMapFun sspSymMap Theory

sspSymMapD :: QDefinition -> Contents
sspSymMapD = symbolMapFun sspSymMap Data

-- SECTION 1 --
--automatically generated in mkSRS -

-- SECTION 1.1 --
--automatically generated in mkSRS

-- SECTION 1.2 --
--automatically generated in mkSRS using the intro below

s1_2_intro = [TSPurpose, TypogConvention [Verb $
  plural value +:+ S "with a subscript" +:+ getS index +:+
  S "implies that the" +:+ phrase value +:+
  S "will be taken at and analyzed at a" +:+
  phrase slice `sOr` phrase slice +:+
  S "interface composing the total slip" +:+ phrase mass]]

-- SECTION 1.3 --
--automatically generated in mkSRS

-- SECTION 2 --
startIntro, kSent :: Sentence
startIntro = foldlSent [S "A", phrase slope, S "of geological",
  phrase mass `sC` S "composed of", phrase soil, S "and rock, is subject", 
  S "to the influence of gravity on the" +:+. phrase mass, S "For an unstable",
  phrase slope +:+. S "this can cause instability in the form of soil/rock movement",
  S "The effects of soil/rock movement can range from inconvenient to seriously",
  S "hazardous, resulting in signifcant life and economic loses.", at_start slope,
  S "stability is of", phrase interest, S "both when analyzing natural", plural slope `sC`
  S "and when designing an excavated" +:+. phrase slope, at_start ssa, S "is",
  S "assessment" `ofThe` S "safety of a", phrase slope `sC` S "identifying the",
  phrase surface, S "most likely to", S "experience slip and an index of", 
  S "its relative stability known as the", phrase fs_rc]
kSent = keySent ssa

keySent :: (NamedIdea a) => a -> Sentence
keySent pname = S "a" +:+ phrase pname +:+. phrase problem +:+ S "The developed"
  +:+ phrase program +:+ S "will be referred to as the" +:+ introduceAbb pname +:+
  phrase program
  
-- SECTION 2.1 --
-- Purpose of Document automatically generated in introductionF
prpsOfDoc_p1 :: Sentence
prpsOfDoc_p1 = foldlSent [S "The", short ssa, phrase program,
  S "determines the", phrase crtSlpSrf `sC` S "and its respective",
  phrase fs_rc, S "as a", phrase method_,
  S "of assessing the stability of a", phrase slope +:+. phrase design,
  S "The", phrase program,
  S "is intended to be used as an educational tool for",
  S "introducing", phrase slope, S "stability issues, and will facilitate the",
  phrase analysis, S "and", phrase design, S "of a safe", phrase slope]

-- SECTION 2.2 --
-- Scope of Requirements automatically generated in introductionF
scpIncl, scpEnd :: Sentence
scpIncl = S "stability analysis of a 2 dimensional" +:+ phrase slope `sC`
  S "composed of homogeneous" +:+ plural soilLyr
scpEnd  = S "identify the most likely failure" +:+
  phrase surface +:+ S "within the possible" +:+ phrase input_ +:+ S "range" `sC`
  S "and find the" +:+ phrase fs_rc +:+ S "for the" +:+
  phrase slope +:+ S "as well as displacement of" +:+ phrase soil +:+
  S "that will occur on the" +:+ phrase slope

-- SECTION 2.3 --
-- Characteristics of the Intended Reader automatically generated in introductionF

-- SECTION 2.4 --
-- Organization automatically generated in introductionF
orgSecStart, orgSecEnd :: Sentence
orgSecStart = foldlSent [S "The", phrase organization, S "of this",
  phrase document, S "follows the", phrase template, S "for an",
  short srs, S "for", phrase sciCompS,
  S "proposed by Koothoor as well as Smith and Lai"]
orgSecEnd   = S "The" +:+ plural inModel +:+ S "provide the set of" +:+
  S "algebraic" +:+ plural equation +:+ S "that must be solved iteratively to perform a" +:+
  titleize morPrice +:+ titleize analysis

-- SECTION 3 --
s3 = genSysF [] userCharIntro [] []

-- SECTION 3.1 --
-- User Characteristics automatically generated in genSysF with the userContraints intro below
userCharIntro :: Contents
userCharIntro = foldlSP [S "The", phrase endUser, S "of",
  short ssa,
  S "should have an understanding of undergraduate Level 1 Calculus and",
  titleize physics `sC` S "and be familiar with", phrase soil,
  S "and", plural mtrlPrpty]

-- SECTION 3.2 --
-- System Constraints automatically generated in genSysF

-- SECTION 4 --
s4 = specSysDesF end [s4_1, s4_2]
  where end = plural definition +:+ S "and finally the" +:+
              plural inModel +:+ S "that" +:+ phrase model +:+
              S "the" +:+ phrase slope

-- SECTION 4.1 --
s4_1 = probDescF EmptyS ssa ending [s4_1_1, s4_1_2, s4_1_3]
  where ending = S "evaluate the" +:+ phrase fs_rc +:+ S "of a" +:+
                 phrase slope :+: S "'s" +:+ --FIXME apostrophe on "slope's"
                 phrase slpSrf +:+ S "and to calculate the displacement"
                 +:+ S "that the" +:+ phrase slope +:+ S "will experience"

-- SECTION 4.1.1 --
s4_1_1 = termDefnF EmptyS [s4_1_1_list]

s4_1_1_list = Enumeration $ Simple $ --FIXME: combine this definition below? But fs_rc already has a definition
--  ([(titleize $ fs_rc, Flat $ S "Stability metric. How likely a" +:+
--    (phrase slpSrf) +:+. S "is to experience failure through slipping")] ++
  map (\x -> (titleize $ x, Flat $ x ^. defn))
      ([cw fs] ++ map cw [crtSlpSrf, stress, strain, normForce, shearForce, tension, compression, plnStrn])
      -- most of these are in concepts (physics or solidMechanics) except for crtSlpSrf & plnStrn which is in defs.hs

-- SECTION 4.1.2 --
s4_1_2 = SRS.physSyst [s4_1_2_p1, s4_1_2_bullets, s4_1_2_p2, s4_1_2_fig1, s4_1_2_fig2] []

s4_1_2_p1 = foldlSP [at_start analysis, S "of the", phrase slope,
  S "is performed by looking at", plural property, S "of the",
  phrase slope, S "as a series of", phrase slice +:+. plural element,
  S "Some", plural property, S "are", plural itslPrpty `sC`
  S "and some are", phrase slice, S "or", phrase slice,
  S "base" +:+. plural property, S "The index convention for referencing which",
  phrase intrslce, S "or", phrase slice, S "is being used is shown in",
  makeRef fig_indexconv]

s4_1_2_bullets = enumBullet [
  (at_start' itslPrpty +:+ S "convention is noted by j. The end" +:+
    plural itslPrpty +:+ S "are usually not of" +:+ phrase interest `sC`
    S "therefore use the" +:+ plural itslPrpty +:+ S "from" +:+ 
    (E $ Int 1 :<= C index :<= (C numbSlices) :- Int 1)),
  (at_start slice +:+ plural property +:+. S "convention is noted by" +:+ getS index)
  ]

s4_1_2_p2 = foldlSP [S "A", phrase fbd, S "of the", plural force,
  S "acting on the", phrase slice, S "is displayed in", makeRef fig_forceacting]

s4_1_2_fig1 = fig_indexconv

fig_indexconv :: Contents
fig_indexconv = Figure (S "Index convention for numbering" +:+
  phrase slice +:+ S "and" +:+ phrase intrslce +:+
  phrase force +:+ plural variable) "IndexConvention.png"

s4_1_2_fig2 = fig_forceacting

fig_forceacting :: Contents
fig_forceacting = Figure (at_start' force +:+ S "acting on a" +:+ (phrase slice))
  "ForceDiagram.png"

-- SECTION 4.1.3 --
s4_1_3 = goalStmtF (map (\(x, y) -> x `ofThe` y) [(S "geometry",
         S "water" +:+ phrase table_),
         (S "geometry", S "layers composing the plane of a" +:+ phrase slope),
         (plural mtrlPrpty, S "layers")]) [s4_1_3_list]

s4_1_3_list = enumSimple 1 (short goalStmt) [
  (S "Evaluate local and global" +:+ plural fs_rc +:+
      S "along a given" +:+. phrase slpSrf),
  (S "Identify the" +:+ phrase crtSlpSrf +:+ S "for the" +:+ phrase slope `sC`
      S "with the lowest" +:+. phrase fs_rc),
  (S "Determine" +:+. (S "displacement" `ofThe` phrase slope))
  ]

-- SECTION 4.2 --
s4_2 = solChSpecF ssa (s4_1, s6) ddEnding (EmptyS, dataConstraintUncertainty, EmptyS)
  ([s4_2_1_list], s4_2_2_tmods, s4_2_3_genDefs, s4_2_4_dataDefs, 
  s4_2_5_p2:s4_2_5_p3:s4_2_5_IMods, [s4_2_6Table2, s4_2_6Table3]) []
  where ddEnding = foldlSent [at_start' definition, acroDD 1, S "to", acroDD 8, S "are the",
          phrase force, plural variable, S "that can be solved by direct",
          S "analysis of given" +:+. plural input_, S "The", phrase intrslce, 
          S "forces", acroDD 9, S "are", phrase force, plural variable, 
          S "that must be written in terms of", acroDD 1, S "to", acroDD 8 +:+. S "to solve"]
 --       tbRef = makeRef s4_2_6Table2 +:+ S "and" +:+ makeRef s4_2_6Table3 +:+ S "show"

-- SECTION 4.2.1 --
-- Assumptions is automatically generated in solChSpecF using the list below

s4_2_1_list = enumSimple 1 (short assumption) [
  (S "The" +:+ phrase slpSrf +:+ S "is concave with respect to" +:+
    S "the" +:+. phrase slopeSrf +:+ ((getS coords +:+
    S "coordinates") `ofThe'` S "failure") +:+ phrase surface +:+.
    S "follow a monotonic function"),
  (S "geometry" `ofThe'` phrase slope `sC` S "and" +:+
    (plural mtrlPrpty `ofThe` plural soilLyr) +:+.
    S "are given as inputs"),
  (S "different layers" `ofThe'` phrase soil +:+ S "are homogeneous" `sC`
    S "with consistent" +:+ plural soilPrpty +:+ S "throughout" `sC`
    S "and independent of dry or saturated" +:+ plural condition `sC`
    S "with the exception of" +:+ phrase unit_ +:+. S "weight"),
  (at_start' soilLyr +:+ S "are treated as if they have" +:+.
    S "isotropic properties"),
  (at_start intrslce +:+ S "normal and" +:+ plural shearForce +:+ S "have a" +:+
    S "linear relationship, proportional to a constant" +:+
    sParen (getS normToShear) +:+ S "and an" +:+
    phrase intrslce +:+ phrase force +:+ S "function" +:+ sParen (getS scalFunc) +:+.
    S "depending on x position"),
  (at_start slice +:+ S "to base normal and" +:+ plural shearForce +:+ S "have" +:+
    S "a linear relationship, dependent on the" +:+
    phrase fs_rc +:+ sParen (getS fs) `sC`
    S "and the Coulomb sliding law."),
  (S "The" +:+ phrase stress :+: S "-" :+: phrase strain +:+ S "curve for" +:+ --FIXME: add hypens to drasil language
    phrase intrslce +:+ S "relationships is linear with a constant" +:+.
    phrase slope),
  (S "The" +:+ phrase slope +:+ S "and" +:+ phrase slpSrf +:+.
    S "extends far into and out of the geometry (z coordinate)" +:+
    S "This implies plane" +:+ phrase strain +:+ plural condition `sC`
    S "making 2D analysis appropriate."),
  (S "The effective normal" +:+ phrase stress +:+ S "is large enough" +:+
    S "that the resistive shear to effective normal" +:+
    phrase stress +:+ S "relationship can be approximated as a" +:+.
    S "linear relationship"),
  (S "The" +:+ phrase surface +:+ S "and base of a" +:+
    phrase slice +:+ S "between" +:+ phrase intrslce +:+.
    S "nodes are approximated as straight lines")
  ]

-- SECTION 4.2.2 --
-- TModels is automatically generated in solChSpecF using the tmods below

s4_2_2_tmods = map sspSymMapT sspTMods --FIX fs_rc to use lowercase

-- SECTION 4.2.3 --
-- General Definitions is automatically generated in solChSpecF
s4_2_3_genDefs = map sspSymMapT sspGenDefs

-- SECTION 4.2.4 --
-- Data Definitions is automatically generated in solChSpecF
s4_2_4_dataDefs = (map sspSymMapD (take 10 sspDataDefs)) ++ resShrDerivation ++
  [sspSymMapD (sspDataDefs !! 10)] ++ mobShrDerivation ++ [sspSymMapD (sspDataDefs !! 11)] ++
  stfMtrxDerivation ++ (map sspSymMapD (drop 12 sspDataDefs)) --FIXME: is there a better way of shoving these derivations in the middle of the Data Defs?

resShrDerivation :: [Contents]
resShrDerivation = [foldlSP [S "The", phrase shrResI, S "of a slice is defined as", 
  getS shrResI, S "in" +:+. acroGD 3, S "The", phrase nrmFSubWat, S "in the equation for", getS shrResI,
  S "of the soil is defined in the perpendicular force equilibrium of a slice from", 
  acroGD 2 `sC` S "using the", getTandS nrmFSubWat, S "of", acroT 4, 
  S "shown in", eqN 1],
  
  EqnBlock $
  (C nrmFSubWat) := (((C slcWght) - (C intShrForce) + (C intShrForce) :+ 
  (C surfHydroForce) :* (cos (C surfAngle)) :+ --FIXME: add indexing
  (C surfLoad) :* (cos (C impLoadAngle))) :* (cos (C baseAngle)) :+
  (Neg (C earthqkLoadFctr) :* (C slcWght) :- (C intNormForce) :+ (C intNormForce) :- 
  (C watrForce) :+ (C watrForce) :+ (C surfHydroForce) :* sin (C surfAngle) :+ 
  (C surfLoad) :* (sin (C impLoadAngle))) :* (sin (C baseAngle)) :- (C baseHydroForce)),
  
  foldlSP [S "The values of the interslice forces", getS intNormForce, S "and",
  getS intShrForce, S "in the equation are unknown, while the other values",
  S "are found from the physical force definitions of", acroDD 1, S "to" +:+. acroDD 9,
  S "Consider a force equilibrium without the affect of interslice forces,",
  S "to obtain a solvable value as done for", getS nrmFNoIntsl, S "in", eqN 2],

  EqnBlock $
  (C nrmFNoIntsl) := (((C slcWght) :+ (C surfHydroForce) :* (cos (C surfAngle)) :+ 
  (C surfLoad) :* (cos (C impLoadAngle))) :* (cos (C baseAngle)) :+
  (Neg (C earthqkLoadFctr) :* (C slcWght) - (C watrForce) + (C watrForce) :+
  (C surfHydroForce) :* sin (C surfAngle) :+
  (C surfLoad) :* (sin (C impLoadAngle))) :* (sin (C baseAngle)) :- (C baseHydroForce)),
  
  foldlSP [S "Using", getS nrmFNoIntsl `sC` S "a", phrase shearRNoIntsl,
  shearRNoIntsl ^. defn, S "can be solved for in terms of all known",
  S "values as done in", eqN 3],
  
  EqnBlock $
  C shearRNoIntsl := (C nrmFNoIntsl) * tan (C fricAngle) +
  (C cohesion) * (C baseWthX) * sec (C baseAngle),
  
  EqnBlock $
  C shearRNoIntsl := (((C slcWght) :+ (C surfHydroForce) :* (cos (C surfAngle)) :+ 
  (C surfLoad) :* (cos (C impLoadAngle))) :* (cos (C baseAngle)) :+
  (Neg (C earthqkLoadFctr) :* (C slcWght) :- (C watrForceDif) :+ (C surfHydroForce)
  :* sin (C surfAngle) :+ (C surfLoad) :* (sin (C impLoadAngle))) :* (sin (C baseAngle))
  :- (C baseHydroForce)) :*
  tan (C fricAngle) :+ (C cohesion) :* (C baseWthX) :* sec (C baseAngle)
  
  ]

mobShrDerivation :: [Contents]
mobShrDerivation = [foldlSP [S "The", phrase mobShrI, S "acting on a slice is",
  S "defined as", getS mobShrI, S "from the force equilibrium in", acroGD 2 `sC`
  S "also shown in", eqN 4],
  
  EqnBlock $
  (C nrmFSubWat) := (((C slcWght) - (C intShrForce) + (C intShrForce) :+
  (C surfHydroForce) :* (cos (C surfAngle)) :+ --FIXME: add indexing
  (C surfLoad) :* (cos (C impLoadAngle))) :* (sin (C baseAngle)) :-
  (Neg (C earthqkLoadFctr) :* (C slcWght) - (C intNormForce) + (C intNormForce)
  - (C watrForce) + (C watrForce) :+ (C surfHydroForce)
  :* sin (C surfAngle) :+ (C surfLoad) :* (sin (C impLoadAngle))) :* (cos (C baseAngle))),
  
  foldlSP [S "The equation is unsolvable, containing the unknown", getTandS intNormForce,
  S "and" +:+. getTandS intShrForce, S "Consider a force equilibrium", S wiif `sC`
  S "to obtain the", getTandS shearFNoIntsl `sC` S "as done in", eqN 5], --FIXME: use wiif from shearFNoIntsl's definition but removed index
  
  EqnBlock $
  C shearFNoIntsl := ((C slcWght) :+ (C surfHydroForce) :* (cos (C surfAngle)) :+ 
  (C surfLoad) :* (cos (C impLoadAngle))) :* (sin (C baseAngle)) :- 
  (Neg (C earthqkLoadFctr) :* (C slcWght) :- (C watrForceDif) :+ (C surfHydroForce)
  :* sin (C surfAngle) :+ (C surfLoad) :* (sin (C impLoadAngle))) :* (cos (C baseAngle)),
  
  foldlSP [S "The values of", getS shearRNoIntsl, S "and", getS shearFNoIntsl,
  S "are now defined completely in terms of the known force property values of",
  acroDD 1, S "to", acroDD 9]
  ]

stfMtrxDerivation :: [Contents]
stfMtrxDerivation = [foldlSP [S "Using the force-displacement relationship of", acroGD 8,
  S "to define stiffness matrix", getS shrStiffIntsl `sC` S "as seen in", eqN 6], --FIXME: index

  foldlSP [S "For interslice surfaces the stiffness constants and displacements",
  S "refer to an unrotated coordinate system" `sC` getS genDisplace, S "of" +:+. acroGD 9,
  S "The interslice elements are left in their standard coordinate system, and",
  S "therefore are described by the same equation from" +:+. acroGD 8,
  S "Seen as", getS shrStiffIntsl, S "in" +:+. acroDD 12, isElMx shrStiffIntsl "shear" `sC` --FIXME: Index
  S "and", isElMx nrmStiffIntsl "normal" `sC` S "calculated as in", acroDD 14],
  
  foldlSP [S "For basal surfaces the stiffness constants and displacements refer",
  S "to a system rotated for the base angle alpha" +:+. sParen (acroDD 5),
  S "To analyze the effect of force-displacement relationships occurring on both basal",
  S "and interslice surfaces of an element", getS index, S "they must reference the same coordinate",
  S "system. The basal stiffness matrix must be rotated counter clockwise to align",
  S "with the angle of the basal surface. The base stiffness counter clockwise rotation",
  S "is applied in", eqN 7, S "to the new matrix", getS nrmFNoIntsl],
  
  foldlSP [S "The Hooke's law force displacement relationship of", acroGD 8,
  S "applied to the base also references a displacement vector", getS rotatedDispl,
  S "of", acroGD 9, S "rotated for the base angle of the slice", getS baseAngle +:+.
  S "The basal displacement vector", getS genDisplace, S "is rotated clockwise",
  S "to align with the interslice displacement vector", getS genDisplace `sC`
  S "applying the definition of", getS rotatedDispl, S "in terms of", getS genDisplace,
  S "as seen in" +:+. acroGD 9, S "Using this with base stiffness matrix", getS shrStiffBase --FIXME: index, should be K*i"
  `sC` S "a basal force displacement relationship in the same coordinate system",
  S "as the interslice relationship can be derived as done in", eqN 8],
  
  foldlSP [S "The new effective base stiffness matrix", getS shrStiffBase, --FIXME: index
  S "as derived in", eqN 7, S "is defined in" +:+. eqN 9, S "This is seen as matrix",
  getS shrStiffBase, S "in" +:+. acroGD 12, isElMx shrStiffBase "shear" `sC` S "and",
  isElMx nrmStiffBase "normal" `sC` S "calculated as in" +:+. acroDD 14,
  S "The notation is simplified by the introduction of the constants",
  getS shrStiffBase `sAnd` getS shrStiffBase `sC` S "defined in", eqN 10 `sAnd`--FIXME: index should be KbA,i and KbB,i
  eqN 11, S "respectively"],
  
  EqnBlock $
  (C shrStiffBase) := (C shrStiffBase) * (cos (C baseAngle)) :^ (Int 2) :+ --FIXME: the first symbol should be K_(bA,i), waiting on indexing
  (C nrmStiffBase) * (sin (C baseAngle)) :^ (Int 2),
  
  EqnBlock $
  (C shrStiffBase) := ((C shrStiffBase)-(C nrmStiffBase)) * --FIXME: the first symbol should be K_(bB,i), waiting on indexing
  (sin (C baseAngle)) * (cos (C baseAngle)),
  
  foldlSP [S "A force-displacement relationship for an element", getS index, S "can be written",
  S "in terms of displacements occurring in the unrotated coordinate system",
  getS genDisplace `sOf` acroGD 9, S "using the matrix", getS shrStiffBase `sC` --FIXME: index
  S "and", getS shrStiffBase, S "as seen in", acroDD 12]
  ]

isElMx :: (SymbolForm a) => a -> String -> Sentence
isElMx sym kword = getS sym `isThe` S kword +:+ S "element in the matrix"

-- SECTION 4.2.5 --
-- Instance Models is automatically generated in solChSpecF using the paragraphs below

s4_2_5_p2 = foldlSP [S "The", titleize morPrice,
  phrase method_, S "is a vertical", phrase slice `sC` S "limit equilibrium",
  phrase ssa +:+. phrase method_, at_start analysis, S "is performed by",
  S "breaking the", S "assumed failure", phrase surface, S "into a series of vertical",
  plural slice, S "of" +:+. phrase mass, S "Static equilibrium",
  S "analysis using two", phrase force, S "equilibrium, and one moment",
  phrase equation, S "as in" +:+. acroT 2, S "The", phrase problem,
  S "is statically indeterminate with only these 3", plural equation, S "and one", --FIXME: T2, T3, GD5, DD1, DD9, DD10, DD11 should be references
  S "constitutive", phrase equation, sParen $ S "the Mohr Coulomb shear strength of" +:+ acroT 3,
  S "so the", phrase assumption, S "of", acroGD 5, S "is used. Solving for",
  phrase force, S "equilibrium allows", plural definition, S "of all", plural force,
  S "in terms of the", plural physicalProperty, S "of", acroDD 1, S "to",
  acroDD 9 `sC` S "as done in", acroDD 10 `sC` acroDD 11]

s4_2_5_p3 = foldlSP [plural value `ofThe'` (phrase intrslce +:+ phrase normForce),
  getS intNormForce, S "the", getTandS normToShear `sC`
  S "and the", titleize fs_rc, (sParen $ getS fs) `sC` S "are unknown.",
  at_start' equation, S "for the unknowns are written in terms of only the",
  plural value, S "in", acroDD 1, S "to", acroDD 9 `sC` S "the", plural value, S "of", getS shearRNoIntsl `sC`
  S "and", getS shearFNoIntsl, S "in", acroDD 10, S "and", acroDD 11 `sC`
  S "and each", --FIXME: DD10, DD11 should be references
  S "other. The relationships between the unknowns are non linear" `sC`
  S "and therefore explicit", plural equation, S "cannot be derived and an",
  S "iterative", plural solution, S "method is required"]

s4_2_5_IMods = concat $ weave [map (\x -> [sspSymMapT x]) sspIMods, --FIXME: ? is there a better way of doing this?
  [fctSftyDerivation, nrmShrDerivation, intrSlcDerivation,
  rigDisDerivation, rigFoSDerivation]]

fctSftyDerivation, nrmShrDerivation, intrSlcDerivation,
  rigDisDerivation, rigFoSDerivation :: [Contents]

fctSftyDerivation = [foldlSP [S "Using", eqN 21, S "from", acroIM 3 `sC`
  S "rearranging, and", boundaryCon `sC` S "an equation for the", phrase fs_rc,
  S "is found as", eqN 12 `sC` S "also seen in", acroIM 1],
  
  EqnBlock fcSfty_rel,
  
  fUnknowns]

boundaryCon :: Sentence
boundaryCon = foldlSent_ [S "applying the boundary condition that", --FIXME: Index
  getS intNormForce `sAnd` getS intNormForce,  S "are equal to", E $ Int 0]

fUnknowns :: Contents
fUnknowns = foldlSP [S "The constants", getS mobShrC `sAnd` getS shrResC, S "described in",
  eqN 20 `sAnd` eqN 19, S "are functions of the unknowns: the",
  getTandS normToShear, sParen (acroIM 2) `andThe` getTandS fs, sParen (acroIM 1)]

nrmShrDerivation = [foldlSP [S "Taking the last static equation of", acroT 2,
  S "with the", phrase momentEql `sOf` acroGD 6, S "about the midpoint of the base",
  S "and the assumption of", acroGD 5, S "results in", eqN 13],
  
  EqnBlock momEql_rel, --FIXME: this is not *exactly* the equation but very similar
  --Need more simbols (z) to finish
  
  foldlSP [S "The equation in terms of", getS normToShear, S "leads to", eqN 14],
  
  EqnBlock $
  C normToShear := momEql_rel / ((C baseWthX / Int 2) * --FIXME: remove Int 0 from momEql_rel
  (C intNormForce * C scalFunc + C intNormForce * C scalFunc)), 
  
  foldlSP [S "Taking a summation of each slice, and", boundaryCon `sC`
  S "a general equation for the constant", getS normToShear, S "is developed in",
  eqN 15 `sC` S "also found in", acroIM 2], --NOTE: "Taking this with that and the assumption of _ to get equation #" pattern
  
  EqnBlock $
  C normToShear := summation (Just (lI, Low $ Int 1, High $ C numbSlices))
  (C baseWthX * (C intNormForce + C intNormForce + C watrForce + C watrForce) * tan(C baseAngle) +
  C midpntHght * (C earthqkLoadFctr * C slcWght - Int 2 * C surfHydroForce * sin(C surfAngle) -
  Int 2 * C surfLoad * sin(C impLoadAngle))) / 
  summation (Just (lI, Low $ Int 1, High $ C numbSlices))
  (C baseWthX * (C intNormForce * C scalFunc + C intNormForce * C scalFunc)),
  
  foldlSP [eqN 15, S "for", getS normToShear `sC` S "is a function of the unknown",
  getTandS intNormForce, acroIM 3]
  ]

intrSlcDerivation = [foldlSP [S "Taking the", phrase normForcEq `sOf` acroGD 1,
  S "with the", phrase effStress, S "definition from", acroT 4, --NOTE: "Taking this with that and the assumption of _ to get equation #" pattern
  S "that", E (C totNrmForce := C nrmFSubWat - C baseHydroForce) `sC`
  S "and the assumption of", acroGD 5, S "the equilibrium equation can be rewritten as",
  eqN 16],
  
  EqnBlock $
  C nrmFSubWat := ((C slcWght :- C normToShear :* C scalFunc :* C intNormForce :+ 
  C normToShear :* C scalFunc :* C intNormForce :+ 
  C baseHydroForce :* cos (C surfAngle) :+ C surfLoad :* 
  cos (C impLoadAngle)) :* cos (C baseAngle)
  :+ (Neg (C earthqkLoadFctr) :* C slcWght :- 
  C intNormForce :+ C intNormForce :- C watrForce :+ 
  C watrForce :+ C surfHydroForce :* sin (C surfAngle) :+ 
  C surfLoad :* sin (C impLoadAngle)) :* sin (C baseAngle)) - (C baseHydroForce),
  
  foldlSP [S "Taking the", phrase bsShrFEq `sOf` acroGD 2, S "with the definition of",
  phrase mobShr, S "from", acroGD 4, S "and", S "the assumption of", acroGD 5 `sC`
  S "the equilibrium equation can be rewritten as", eqN 17], --NOTE: "Taking this with that and the assumption of _ to get equation #" pattern
  
  EqnBlock $
  ((C totNrmForce) * tan (C fricAngle) + (C cohesion) * (C baseWthX) * sec (C baseAngle)) / (C fs) := --FIXME: pull the left side of this from GD4
  (C slcWght :- C normToShear :* C scalFunc :* C intNormForce :+ 
  C normToShear :* C scalFunc :* C intNormForce :+ 
  C baseHydroForce :* cos (C surfAngle) :+ C surfLoad :* 
  cos (C impLoadAngle)) :* sin (C baseAngle)
  :+ (Neg (C earthqkLoadFctr) :* C slcWght :- 
  C intNormForce :+ C intNormForce :- C watrForce :+ 
  C watrForce :+ C surfHydroForce :* sin (C surfAngle) :+ 
  C surfLoad :* sin (C impLoadAngle)) :* cos (C baseAngle),
  
  foldlSP [S "Substituting the equation for", getS nrmFSubWat, S "from",
  eqN 16, S "into", eqN 17, S "and rearranging results in", eqN 18],

  EqnBlock $
  (C intNormForce) * (((C normToShear)*(C scalFunc) * cos (C baseAngle) - sin (C baseAngle)) * tan (C fricAngle) -
  ((C normToShear)*(C scalFunc) * sin (C baseAngle) - cos (C baseAngle)) * (C fs)) := 
  (C intNormForce) * (((C normToShear)*(C scalFunc) * cos (C baseAngle) - sin (C baseAngle)) * tan (C fricAngle) -
  ((C normToShear)*(C scalFunc) * sin (C baseAngle) - cos (C baseAngle)) * (C fs)) +
  (C fs) * (C shearFNoIntsl) - (C shearRNoIntsl),
  
  foldlSP [S "Where", getS shearRNoIntsl `sAnd` getS shearFNoIntsl, S "are the",
  S "resistive and mobile shear of the slice" `sC` S wiif, getS intNormForce
  `sAnd` getS intShrForce `sC` S "as defined in", acroDD 10 `sAnd` acroDD 11,
  S "Making use of the constants, and with full equations found below in",
  eqN 19 `sAnd` eqN 20, S "respectively, then", eqN 18, S "can be simplified",
  S "to", eqN 21 `sC` S "also seen in", acroIM 3],
  
  EqnBlock $
  (C shrResC) := ((C normToShear)*(C scalFunc) * cos (C baseAngle) - sin (C baseAngle)) * tan (C fricAngle) -
  ((C normToShear)*(C scalFunc) * sin (C baseAngle) - cos (C baseAngle)) * (C fs),
  --FIXME: index everything here and add "Where i is the local slice of mass for 1 :<= i :<= n-1"
  EqnBlock $
  (C mobShrC) := ((C normToShear)*(C scalFunc) * cos (C baseAngle) - sin (C baseAngle)) * tan (C fricAngle) -
  ((C normToShear)*(C scalFunc) * sin (C baseAngle) - cos (C baseAngle)) * (C fs),
  
  EqnBlock $
  (C intNormForce) := ((C mobShrC)*(C intNormForce) + (C fs)*(C shearFNoIntsl)
  - (C shearRNoIntsl)) / (C shrResC),
  
  fUnknowns]

rigDisDerivation = [foldlSP [S "Using the net force-displacement equilibrium equation of a slice",
  S "from", acroDD 13, S "with the definitions of the", S "stiffness matrices",
  S "from", acroDD 12, S "and the force definitions",
  S "from", acroGD 7 , S "a broken down force displacement equilibrium equation" +:+. S "can be derived",
  eqN 22, S "gives the broken down equation in the x direction" `sC` S "and", eqN 23,
  S "gives the broken down equation in the y direction"],

  EqnBlock fDisEq_rel, --FIXME: Original equations need indexing
  
  foldlSP [S "Using the known input assumption of", acroA 2 `sC` S "the force",
  S "variable definitions of", acroDD 1, S "to", acroDD 8, S "on the left",
  S "side of the equations can be solved for. The only unknown in the variables",
  S "to solve for the stiffness values from", acroDD 14 +:+. S "is the displacements",
  S "Therefore taking the equation from each slice a set of", E $ (Int 2) * (C numbSlices),
  S "equations, with", E $ (Int 2) * (C numbSlices), S "unknown displacements in the",
  S "x and y directions of each slice can be derived. Solutions for the displacements",
  S "of each slice can then be found. The use of displacement in the definition of the",
  S "stiffness values makes the equation implicit, which means an iterative solution",
  S "method, with an initial guess for the displacements in the stiffness values is required"]
  ]

rigFoSDerivation = [foldlSP [S "RFEM analysis can also be used to calculate the",
  phrase fs, S "for the slope. For a slice element", getS index, S "the displacements",
  getS dx_i, S "and", getS dy_i `sC` S "are solved from the system of equations in" +:+.
  acroIM 4, S "The definition of", getS rotatedDispl, S "as the rotation of the",
  S "displacement vector", getS genDisplace, S "is seen in" +:+. acroGD 9, S "This is", --FIXME: index i
  S "used to find the displacements of the slice parallel to the base of the slice",
  getS shrDispl `sIn` eqN 24, S "and normal to the base of the slice", getS nrmDispl,
  S "in", eqN 25],
  
  EqnBlock $
  C shrDispl := cos(C baseAngle) * C dx_i + sin(C baseAngle) * C dy_i,
  EqnBlock $
  C nrmDispl := Neg (sin(C baseAngle)) * C dx_i + sin(C baseAngle) * C dy_i,
  
  foldlSP [S "With the definition of normal stiffness from", acroDD 14, --FIXME: grab nrmStiffBase's term name?
  S "to find the normal stiffness of the base", getS nrmStiffBase,
  S "and the now known base displacement perpendicular to the surface",
  getS nrmDispl, S "from", eqN 25, S "the", S "normal base stress",
  S "can be calculated from the force-displacement relationship of" +:+. acroT 5,
  S "Stress", getS normStress `sIs` S "used in place of force", getS genForce, --FIXME: use getTandS
  S "as the stiffness hasn't been normalized for the length of the base. Results" --FIXME: grammar
  `sIn` eqN 26],

  EqnBlock $
  C normStress := C nrmStiffBase * C nrmDispl, --FIXME: index
  
  foldlSP [S "The resistive shear to calculate the", getTandS fs,
  S "is found from the Mohr Coulomb resistive strength of soil in", acroT 3,
  S "Using the", getTandS normStress, S "from", eqN 26, S "as the stress, the resistive",
  S "shear of the slice can be calculated from", eqN 27],
  
  EqnBlock $
  C mobShrI := C cohesion - C normStress * tan(C fricAngle), --FIXME: index and prime
  
  foldlSP [S "Previously the value of the", getTandS shrStiffBase,
  S "as seen in", eqN 28, S "was unsolvable because the", getTandS normStress,
  S "was unknown. With the definition of", getS normStress, S "from", eqN 26,
  S "and the definition of displacement shear to the base", getS shrDispl,
  S "from", eqN 25 `sC` S "the value of", getS shrStiffBase, S "becomes solvable"],
  
  EqnBlock $
  C shrStiffBase := C intNormForce / (Int 2 * (Int 1 + C poissnsRatio)) * (Dbl 0.1 / C baseWthX) +
  (C cohesion - C normStress * tan(C fricAngle)) / (abs (C shrDispl) + V "a"),
  
  foldlSP [S "With", getTandS shrStiffBase, S "calculated in", eqN 28,
  S "and shear displacement", getS shrDispl, S "calculated in", eqN 24, --FIXME: grab term too once we have a displacement modifier
  S "values now known the", phrase shrStress, shrStress ^. defn, getS shrStress,
  S "can be calculated using", acroT 5 `sC` S "as done in" +:+. eqN 29,
  S "Again, stress", getS shrStress, S "is used in place of force", getS genForce, --FIXME: grab term
  S "as the stiffness has not been normalized for the length of the base"],
  
  EqnBlock $
  C shrStress := C shrStiffBase * C shrDispl,
  
  foldlSP [S "The", phrase shrStress, shrStress ^. defn, getS shrStress, --FIXME: ISSUE #348
  S "acts as the mobile shear acting on the base. Using the definition",
  titleize fs, S "equation from", acroT 1 `sC` S "with the definitions of",
  S "resistive shear strength of a slice", getS mobShrI,
  S "from equation (27) and shear stress on a slice", getS shrStress, S "from",
  eqN 29, S "the", getTandS fsloc, S "can be found from as seen in", eqN 30 `sAnd` acroIM 5],
  
  EqnBlock $
  C fsloc := C mobShrI / C shrStress :=
  (C cohesion - C nrmStiffBase * C nrmDispl * tan(C fricAngle)) /
  (C shrStiffBase * C shrDispl), --FIXME: pull parts of this equation from other equations such as IM5
  
  foldlSP [S "The global", titleize fs, S "is then the ratio of the summation",
  S "of the resistive and mobile shears for each slice, with a weighting for the",
  S "length of the slices base. Shown in", eqN 31 `sAnd` acroIM 5],
  
  EqnBlock $ --FIXME: pull from other equations in derivation
  (C fs) := summation (Just (lI, Low $ Int 1, High $ C numbSlices))
  (C baseLngth * C mobShrI) /
  summation (Just (lI, Low $ Int 1, High $ C numbSlices))
  (C baseLngth * C shrStress) :=
  summation (Just (lI, Low $ Int 1, High $ C numbSlices))
  (C baseLngth * (C cohesion - C nrmStiffBase * C nrmDispl * tan(C fricAngle))) /
  summation (Just (lI, Low $ Int 1, High $ C numbSlices))
  (C baseLngth * (C shrStiffBase * C shrDispl)) --FIXME: Grouping with brackets
  ]

-- SECTION 4.2.6 --
-- Data Constraints is automatically generated in solChSpecF using the tables below
{-
{-input data-}
noTypicalVal, vertConvention :: Sentence
noTypicalVal   = short notApp
vertConvention = S "Consecutive vertexes have increasing x" +:+. plural value +:+
  S "The start and end vertices of all layers go to the same x" +:+. plural value --Monotonicly increasing?

verticesConst :: Sentence -> [Sentence]
verticesConst vertexType = [vertVar vertexType, vertConvention, noTypicalVal, noTypicalVal, noTypicalVal]

waterVert, slipVert, slopeVert :: [Sentence]
waterVert = verticesConst $ S "water" +:+ phrase table_
slipVert  = verticesConst $ phrase slip
slopeVert = verticesConst $ phrase slope

dataConstIn :: [[Sentence]]
dataConstIn = [waterVert, slipVert, slopeVert] ++ map fmtInConstr sspInputs
-}
{-input and output tables-}
s4_2_6Table2, s4_2_6Table3 :: Contents
s4_2_6Table2 = inDataConstTbl sspInputs --FIXME: needs more inputs but cannot express them yet
s4_2_6Table3 = outDataConstTbl sspOutputs --FIXME: monotonic may need work

-- SECTION 5 --
s5 = reqF [s5_1, s5_2]

-- SECTION 5.1 --
s5_1 = SRS.funcReq
  [s5_1_list, s5_1_table] []

s5_1_list = enumSimple 1 (short requirement) [
  (S "Read the" +:+ phrase input_ +:+ S "file, and store the" +:+. plural datum +:+
    S "Necessary" +:+ plural inDatum +:+ S "summarized in" +:+.
    makeRef s5_1_table),
  (S "Generate potential" +:+ phrase crtSlpSrf :+:
    S "'s for the" +:+ phrase input_ +:+. phrase slope),
  (S "Test the" +:+ plural slpSrf +:+ S "to determine" +:+
    S "if they are physically realizable based" +:+.
    S "on a set of pass or fail criteria"),
  (S "Prepare the" +:+ plural slpSrf +:+ S "for a" +:+ phrase method_ +:+
    S "of" +:+ plural slice +:+. S "or limit equilibrium analysis"),
  (S "Calculate" +:+. (plural fs_rc `ofThe` plural slpSrf)),
  (S "Rank and weight the" +:+ plural slope +:+ S "based on their" +:+
    phrase fs_rc `sC` S "such that a" +:+ phrase slpSrf +:+
    S "with a smaller" +:+ phrase fs_rc +:+.
    S "has a larger weighting"),
  (S "Generate new potential" +:+ plural crtSlpSrf +:+
    S "based on previously analysed" +:+ plural slpSrf +:+
    S "with low" +:+. plural fs_rc),
  (S "Repeat" +:+ plural requirement +:+ acroR 3 +:+ S "to" +:+
    acroR 7 +:+ S "until the" +:+
    S "minimum" +:+ phrase fs_rc +:+ S "remains approximately" +:+
    S "the same over a predetermined number of" +:+
    S "repetitions. Identify the" +:+ (phrase slpSrf) +:+
    S "that generates the minimum" +:+ phrase fs_rc +:+
    S "as the" +:+. phrase crtSlpSrf),
  (S "Prepare the" +:+ phrase crtSlpSrf +:+ S "for" +:+ phrase method_ +:+
    S "of" +:+ plural slice +:+. S "or limit equilibrium analysis"),
  (S "Calculate" +:+ (phrase fs_rc `ofThe` phrase crtSlpSrf) +:+
    S "using the" +:+ titleize morPrice +:+. phrase method_),
  (S "Display the" +:+ phrase crtSlpSrf +:+ S "and the" +:+
    phrase slice +:+ phrase element +:+.
    S "displacements graphically" +:+ S "Give" +:+
    (plural value `ofThe` plural fs_rc) +:+ S "calculated" +:+
    S "by the" +:+ titleize morPrice +:+. phrase method_)
  ]

s5_1_table = mkInputDatTb ([cqs coords] ++ --this has to be seperate since coords is a different type
  map cqs [elasticMod, cohesion, poissnsRatio, fricAngle, dryWeight, satWeight, waterWeight])

-- SECTION 5.2 --
s5_2 = nonFuncReqF [accuracy, performanceSpd]
  [correctness, understandability, reusability, maintainability] r EmptyS
  where r = (short ssa) +:+ S "is intended to be an educational tool"

-- SECTION 6 --
s6 = SRS.likeChg [] []

-- SECTION 7 --
s7 = valsOfAuxConstantsF ssa []

-- References --
s8 = SRS.reference [s8_list] []

s8_list = mkRefsList 1 [ --FIXME: names should be in italics
  S "Q.H. Qian D.Y. Zhu, C.F. Lee and G.R. Chen. A concise algorithm for computing" +:+
            S "the factor of safety using the morgensternprice method. Can. Geotech. J.," +:+.
            S "(42):272-278, 19 February 2005",
  S "D.G. Fredlund and J.Krahn. Comparison of slope stability methods of" +:+.
            phrase analysis +:+. S "Can. Geotech. J., (14):429-439, 4 April 1977",
  S "Nirmitha Koothoor. A document drive approach to certifying" +:+.
            phrase sciCompS +:+ S "Master's thesis, McMaster University," +:+.
            S "Hamilton, Ontario, Canada, 2013",
  S "David L. Parnas and P.C. Clements. A rational design process: How" +:+
            S "and why to fake it. IEEE Transactions on Software Engineering," +:+.
            S "12(2):251-257, February 1986",
  S "W. Spencer Smith and Lei Lai. A new requirements template for" +:+
            S "scientific computing. In J. Ralyt" :+: (F Acute 'e') `sC` S "P. Agerfalk, and N. Kraiem" `sC`
            S "editors, Proceedings of the First International Workshopon" +:+
            S "Situational Requirements Engineering Processes - Methods," +:+
            S "Techniques and Tools to Support Situation-Specific Requirements" +:+
            S "Engineering Processes, SREP'05, pages 107-121, Paris, France" `sC`
            S "2005. In conjunction with 13th IEEE International Requirements" +:+.
            S "Engineering Conference",
  S "Dieter Stolle and Peijun Guo. Limit equilibrum" +:+ phrase ssa +:+.
            S "using rigid finite elements. Can. Geotech. J., (45):653-662, 20 May 2008",
  S "Tony L.T Zhan Dao-Sheng Ling Yu-Chao Li, Yun-Min Chen and" +:+
            S "Peter John Cleall. An efficient approach for locating the" +:+
            phrase crtSlpSrf +:+ S "in" +:+ plural ssa +:+ S "using a" +:+
            S "real-coded genetic algorithm. Can. Geotech. J., (47):806-820," +:+.
            S "25 June 2010"]