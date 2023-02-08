library verilog;
use verilog.vl_types.all;
entity sender_counter_vlg_check_tst is
    port(
        ready           : in     vl_logic;
        word_out        : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end sender_counter_vlg_check_tst;
