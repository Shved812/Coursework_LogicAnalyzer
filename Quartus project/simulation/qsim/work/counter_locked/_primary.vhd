library verilog;
use verilog.vl_types.all;
entity counter_locked is
    port(
        rdclk           : in     vl_logic;
        nreset          : in     vl_logic;
        en              : in     vl_logic;
        clk             : in     vl_logic;
        clk_out         : out    vl_logic
    );
end counter_locked;
