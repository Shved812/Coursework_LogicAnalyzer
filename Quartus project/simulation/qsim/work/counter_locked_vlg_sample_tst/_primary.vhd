library verilog;
use verilog.vl_types.all;
entity counter_locked_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        en              : in     vl_logic;
        nreset          : in     vl_logic;
        rdclk           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end counter_locked_vlg_sample_tst;
