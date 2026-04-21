# Usage:
#   make DESIGN=b02

# Output:
#   sim_b02.vvp + b02_compare.vcd

DESIGN ?= b01

WRAP   = $(DESIGN)_wrap.v
TB     = tb_$(DESIGN).v
VVP    = sim_$(DESIGN).vvp

all: $(VVP)
	@vvp $(VVP)

$(VVP): FI_DFF.v $(WRAP) $(TB)
	iverilog -g2012 -Wall -o $(VVP) $^

clean:
	rm -f *.vvp *.vcd
