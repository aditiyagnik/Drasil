build: GlassBR/Control.class

GlassBR/Control.class: GlassBR/Control.java GlassBR/InputParameters.java GlassBR/InputFormat.java GlassBR/DerivedValues.java GlassBR/InputConstraints.java GlassBR/Calculations.java GlassBR/OutputFormat.java GlassBR/ReadTable.java GlassBR/Interpolation.java
	javac GlassBR/Control.java

run: build
	java GlassBR.Control $(RUNARGS)

doc: doxConfig GlassBR/Control.java GlassBR/InputParameters.java GlassBR/InputFormat.java GlassBR/DerivedValues.java GlassBR/InputConstraints.java GlassBR/Calculations.java GlassBR/OutputFormat.java GlassBR/ReadTable.java GlassBR/Interpolation.java
	doxygen doxConfig

.PHONY: build run doc
