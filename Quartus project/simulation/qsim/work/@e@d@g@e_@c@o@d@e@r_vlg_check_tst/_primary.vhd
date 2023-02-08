library verilog;
use verilog.vl_types.all;
entity EDGE_CODER_vlg_check_tst is
    port(
        bit_out         : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end EDGE_CODER_vlg_check_tst;
