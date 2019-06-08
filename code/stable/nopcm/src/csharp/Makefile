ifeq "$(OS)" "Windows_NT"
    TARGET_EXTENSION=.exe
    CSC=csc
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S), Linux)
        TARGET_EXTENSION=
        CSC=mcs
    endif
    ifeq ($(UNAME_S), Darwin)
        TARGET_EXTENSION=
        CSC=mcs
    endif
endif

build: SWHS$(TARGET_EXTENSION)

SWHS$(TARGET_EXTENSION): Control.cs InputParameters.cs OutputFormat.cs Calculations.cs InputFormat.cs
	$(CSC) -out:SWHS$(TARGET_EXTENSION) Control.cs InputParameters.cs OutputFormat.cs Calculations.cs InputFormat.cs

run: build
	./SWHS$(TARGET_EXTENSION) $(RUNARGS)

.PHONY: build run