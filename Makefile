# ==========================================
# Usage:
#   make DESIGN=b01         # run RTL + GL
#   make rtl DESIGN=b01     # run RTL only
#   make gl DESIGN=b01      # run GL only
#   make clean
# ==========================================

DESIGN ?= b01

WRAP   = $(DESIGN)_wrap.v
TB     = tb_$(DESIGN).v
GL_NET = $(DESIGN)_gl.v

RTL_VVP = sim_$(DESIGN)_rtl.vvp
GL_VVP  = sim_$(DESIGN)_gl.vvp

PDK_ROOT ?= /home/mbrown4/.volare

.PHONY: all rtl gl clean check_pdk

# ==========================================
# Default target
# ==========================================
all: rtl gl

# ==========================================
# Check PDK files exist
# ==========================================
check_pdk:
	@test -f "$(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v" || \
		(echo "ERROR: primitives.v not found. Check PDK_ROOT=$(PDK_ROOT)"; exit 1)
	@test -f "$(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v" || \
		(echo "ERROR: sky130_fd_sc_hd.v not found. Check PDK_ROOT=$(PDK_ROOT)"; exit 1)

# ==========================================
# RTL Simulation
# ==========================================
rtl: $(RTL_VVP)
	vvp $(RTL_VVP)

$(RTL_VVP): FI_DFF.v $(WRAP) $(TB)
	iverilog -g2012 -Wall -DRTL -o $(RTL_VVP) FI_DFF.v $(WRAP) $(TB)

# ==========================================
# Gate-Level Simulation
# ==========================================
gl: check_pdk $(GL_VVP)
	vvp $(GL_VVP)

$(GL_VVP): FI_DFF.v $(GL_NET) $(TB)
	iverilog -g2012 -Wall -DGL -o $(GL_VVP) \
		$(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
		$(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
		FI_DFF.v $(GL_NET) $(TB)

# ==========================================
# Cleanup
# ==========================================
clean:
	rm -f *.vvp *.vcd