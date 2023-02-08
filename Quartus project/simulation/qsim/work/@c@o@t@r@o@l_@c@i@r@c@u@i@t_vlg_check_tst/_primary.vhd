library verilog;
use verilog.vl_types.all;
entity COTROL_CIRCUIT_vlg_check_tst is
    port(
        en              : in     vl_logic;
        Led_0           : in     vl_logic;
        Led_1           : in     vl_logic;
        Led_2           : in     vl_logic;
        Led_3           : in     vl_logic;
        nreset          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end COTROL_CIRCUIT_vlg_check_tst;
