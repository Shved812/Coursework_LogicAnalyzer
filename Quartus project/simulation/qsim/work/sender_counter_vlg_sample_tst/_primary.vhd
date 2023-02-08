library verilog;
use verilog.vl_types.all;
entity sender_counter_vlg_sample_tst is
    port(
        en              : in     vl_logic;
        nreset          : in     vl_logic;
        rdclk           : in     vl_logic;
        ready_in        : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end sender_counter_vlg_sample_tst;
