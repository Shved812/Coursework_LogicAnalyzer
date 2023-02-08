library verilog;
use verilog.vl_types.all;
entity parallelizer_vlg_check_tst is
    port(
        \out\           : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end parallelizer_vlg_check_tst;
