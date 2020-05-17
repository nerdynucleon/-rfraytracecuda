########################################################################
####################### Makefile Template ##############################
########################################################################

CUDA_PATH ?= /usr/local/cuda

# Compiler settings - Can be customized.	
HOST_COMPILER ?= g++
NVCC          := $(CUDA_PATH)/bin/nvcc -ccbin $(HOST_COMPILER)
CC := $(HOST_COMPILER)
CXXFLAGS = -std=c++11 -Wall

LDFLAGS = -L/usr/local/cuda/lib64 -lcudart
HOST_ARCH   := $(shell uname -m)
CUFLAGS = 

# Makefile settings - Can be customized.
APPNAME = rfraytrace
EXT = .cpp
CU_EXT = .cu
SRCDIR = src
OBJDIR = obj

############## Do not change anything from here downwards! #############
SRC = $(wildcard $(SRCDIR)/*$(EXT))
CU_SRC  = $(wildcard $(SRCDIR)/*$(CU_EXT))
OBJ = $(SRC:$(SRCDIR)/%$(EXT)=$(OBJDIR)/%.o)
CU_OBJ = $(CU_SRC:$(SRCDIR)/%$(CU_EXT)=$(OBJDIR)/%.cuo)
DEP = $(OBJ:$(OBJDIR)/%.o=%.d)

# UNIX-based OS variables & settings
RM = rm
DELOBJ = $(OBJ)
DEL_CU_OBJ = $(CU_OBJ)
# Windows OS variables & settings
DEL = del
EXE = .exe
WDELOBJ = $(SRC:$(SRCDIR)/%$(EXT)=$(OBJDIR)\\%.o)

########################################################################
####################### Targets beginning here #########################
########################################################################

all: $(APPNAME)

# Builds the app
$(APPNAME): $(OBJ) $(CU_OBJ)
	$(CC) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

# # Build CUDA components
$(OBJDIR)/%.cuo: $(SRCDIR)/%$(CU_EXT)
	$(NVCC) $(CUFLAGS) -o $@ -c $< 

# Creates the dependecy rules
%.d: $(SRCDIR)/%$(EXT)
	@$(CPP) $(CFLAGS) $< -MM -MT $(@:%.d=$(OBJDIR)/%.o) >$@

# Includes all .h files
-include $(DEP)

# Building rule for .o files and its .c/.cpp in combination with all .h
$(OBJDIR)/%.o: $(SRCDIR)/%$(EXT)
	$(CC) $(CXXFLAGS) -o $@ -c $<

################### Cleaning rules for Unix-based OS ###################
# Cleans complete project
.PHONY: clean
clean:
	$(RM) $(DELOBJ) $(DEP) $(APPNAME) $(DEL_CU_OBJ)

# Cleans only all files with the extension .d
.PHONY: cleandep
cleandep:
	$(RM) $(DEP)

#################### Cleaning rules for Windows OS #####################
# Cleans complete project
.PHONY: cleanw
cleanw:
	$(DEL) $(WDELOBJ) $(DEP) $(APPNAME)$(EXE)

# Cleans only all files with the extension .d
.PHONY: cleandepw
cleandepw:
	$(DEL) $(DEP)