module Drasil.SRS
 (doc, doc', intro, prpsOfDoc, scpOfReq, charOfIR, orgOfDoc, stakeholder, theCustomer, theClient, 
  genSysDec, sysCont, userChar, sysCon, scpOfTheProj, prodUCTable, indPRCase, specSysDec,
  probDesc, termAndDefn, termogy, physSyst, goalStmt, solCharSpec, assump, thModel,
  genDefn, inModel, dataDefn, datCon, require, nonfuncReq, funcReq, likeChg, traceyMandG,
  appendix, reference, propCorSol) where
--Temporary file for keeping the "srs" document constructor until I figure out
-- a better place for it. Maybe Data.Drasil or Language.Drasil.Template?

--May want to combine SRS-specific functions into this file as well (ie. OrganizationOfSRS) to make it more Recipe-like.

import Language.Drasil

import qualified Data.Drasil.Concepts.Documentation as Doc

-- Local function to keep things looking clean, not exported.
forTT' :: (NamedIdea c, NamedIdea d) => c -> d -> Sentence
forTT' = for'' titleize titleize'

doc, doc' :: NamedIdea c => c -> Sentence -> [Section] -> Document
doc sys authors secs = Document (Doc.srs `for` sys) authors secs
doc' sys authors secs = Document (Doc.srs `forTT'` sys) authors secs

intro, prpsOfDoc, scpOfReq, charOfIR, orgOfDoc, stakeholder, theCustomer, theClient, 
  genSysDec, sysCont, userChar, sysCon, scpOfTheProj, prodUCTable, indPRCase, specSysDec,
  probDesc, termAndDefn, termogy, physSyst, goalStmt, solCharSpec, assump, thModel,
  genDefn, inModel, dataDefn, datCon, require, nonfuncReq, funcReq, likeChg, traceyMandG,
  appendix, reference :: [Contents] -> [Section] -> Section

intro       = section (titleize Doc.introduction)
prpsOfDoc   = section (titleize Doc.prpsOfDoc)
scpOfReq    = section (titleize Doc.scpOfReq)
charOfIR    = section (titleize' Doc.charOfIR)
orgOfDoc    = section (titleize Doc.orgOfDoc)

stakeholder = section (titleize' Doc.stakeholder)
theCustomer = section (titleize $ the Doc.customer)
theClient   = section (titleize $ the Doc.client)

genSysDec   = section (titleize Doc.generalSystemDescription)
sysCont     = section (titleize Doc.sysCont)
userChar    = section (titleize' Doc.userCharacteristic)
sysCon      = section (titleize' Doc.systemConstraint)

scpOfTheProj= section (titleize Doc.scpOfTheProj)
prodUCTable = section (titleize Doc.prodUCTable)
indPRCase   = section (titleize' Doc.indPRCase)

specSysDec  = section (titleize Doc.specificsystemdescription)
probDesc    = section (titleize Doc.problemDescription)
termAndDefn = section (titleize' Doc.termAndDef)
termogy     = section (titleize Doc.terminology)
physSyst    = section (titleize Doc.physSyst)
goalStmt    = section (titleize' Doc.goalStmt)
solCharSpec = section (titleize' Doc.solutionCharSpec)
assump      = section (titleize' Doc.assumption)
thModel     = section (titleize' Doc.thModel)
genDefn     = section (titleize' Doc.genDefn)
inModel     = section (titleize' Doc.inModel)
dataDefn    = section (titleize' Doc.dataDefn)
datCon      = section (titleize' Doc.datumConstraint)

propCorSol  = section (Doc.propOfCorSol)

require     = section (titleize' Doc.requirement)
nonfuncReq  = section (titleize' Doc.nonfunctionalRequirement)
funcReq     = section (titleize' Doc.functionalRequirement)

likeChg     = section (titleize' Doc.likelyChg)

traceyMandG = section (titleize' Doc.traceyMandG)

appendix    = section (titleize Doc.appendix)

reference   = section (titleize' Doc.reference)
