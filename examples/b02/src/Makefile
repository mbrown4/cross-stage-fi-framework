# ==========================================
# Usage:
#   make DESIGN=b02          # run RTL + GL
#   make rtl DESIGN=b02      # run RTL only
#   make gl DESIGN=b02       # run GL only
#   make clean
# ==========================================

DESIGN ?= b02

# Fault location (symbolic name)
INJECT_MASK ?= FI_STATO_0

RTL_SRC = $(DESIGN).v
TB      = tb_$(DESIGN)_fi.v
GL_NET  = $(DESIGN)_gl_faulty.v
FI_DFF  = FI_DFF.v

RTL_VVP = sim_$(DESIGN)_rtl.vvp
GL_VVP  = sim_$(DESIGN)_gl.vvp

TB_TOP  = tb_$(DESIGN)_fi

PDK_ROOT ?= /home/mbrown4/.volare

SKY130_PRIMS = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
SKY130_LIB   = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

.PHONY: all rtl gl clean check_pdk FORCE

###########################################################
# Default
###########################################################

all: rtl gl

###########################################################
# Check PDK
###########################################################

check_pdk:
	@test -f "$(SKY130_PRIMS)" || \
		(echo "ERROR: primitives.v not found. Check PDK_ROOT=$(PDK_ROOT)"; exit 1)
	@test -f "$(SKY130_LIB)" || \
		(echo "ERROR: sky130_fd_sc_hd.v not found. Check PDK_ROOT=$(PDK_ROOT)"; exit 1)

###########################################################
# RTL
###########################################################
fORCE:

rtl: $(RTL_VVP) FORCE $(RTL_SRC) $(TB)
	vvp $(RTL_VVP)

$(RTL_VVP): $(RTL_SRC) $(TB)
	iverilog -g2012 -Wall \
		-DRTL \
		-DINJECT_MASK=$(INJECT_MASK) \
		-s $(TB_TOP) \
		-o $(RTL_VVP) \
		$(RTL_SRC) \
		$(TB)

###########################################################
# Gate-Level
###########################################################

gl: check_pdk $(GL_VVP)
	vvp $(GL_VVP)

$(GL_VVP): FORCE $(FI_DFF) $(GL_NET) $(TB)
	iverilog -g2012 -Wall \
		-DGL \
		-DINJECT_MASK=$(INJECT_MASK) \
		-s $(TB_TOP) \
		-o $(RTL_VVP) \
		$(FI_DFF) \
		$(SKY130_PRIMS) \
		$(SKY130_LIB) \
		$(GL_NET) \
		$(TB)

###########################################################
# Clean
###########################################################

clean:
	rm -f *.vvp *.vcd
