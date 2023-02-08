library verilog;
use verilog.vl_types.all;
entity modulator is
    port(
        nreset          : in     vl_logic;
        en              : in     vl_logic;
        clk             : in     vl_logic;
        \out\           : out    vl_logic
    );
end modulator;
