library verilog;
use verilog.vl_types.all;
entity parallelizer_vlg_sample_tst is
    port(
        \in\            : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end parallelizer_vlg_sample_tst;
