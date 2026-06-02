# ==========================================
# Usage:
#   make DESIGN=b01          # run RTL + GL
#   make rtl DESIGN=b01      # run RTL only
#   make gl DESIGN=b01       # run GL only
#   make clean
# ==========================================

DESIGN ?= b01

RTL_SRC = $(DESIGN).v
TB      = tb_$(DESIGN)_fi.v
GL_NET  = $(DESIGN)_gl_faulty.v
FI_DFF  = FI_DFF.v

RTL_VVP = sim_$(DESIGN)_rtl.vvp
GL_VVP  = sim_$(DESIGN)_gl.vvp

# Your current testbench top module is tb_b01_fi
TB_TOP ?= tb_$(DESIGN)_fi

PDK_ROOT ?= /home/mbrown4/.volare

SKY130_PRIMS = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
SKY130_LIB   = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

.PHONY: all rtl gl clean check_pdk

all: rtl gl

check_pdk:
	@test -f "$(SKY130_PRIMS)" || \
		(echo "ERROR: primitives.v not found. Check PDK_ROOT=$(PDK_ROOT)"; exit 1)
	@test -f "$(SKY130_LIB)" || \
		(echo "ERROR: sky130_fd_sc_hd.v not found. Check PDK_ROOT=$(PDK_ROOT)"; exit 1)

rtl: $(RTL_VVP)
	vvp $(RTL_VVP)

$(RTL_VVP): $(RTL_SRC) $(TB)
	iverilog -g2012 -Wall -DRTL -s $(TB_TOP) -o $(RTL_VVP) \
		$(RTL_SRC) \
		$(TB)

gl: check_pdk $(GL_VVP)
	vvp $(GL_VVP)

$(GL_VVP): $(FI_DFF) $(GL_NET) $(TB)
	iverilog -g2012 -Wall -DGL -s $(TB_TOP) -o $(GL_VVP) \
		$(FI_DFF) \
		$(SKY130_PRIMS) \
		$(SKY130_LIB) \
		$(GL_NET) \
		$(TB)

clean:
	rm -f *.vvp *.vcd
