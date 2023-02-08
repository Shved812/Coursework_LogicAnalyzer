library verilog;
use verilog.vl_types.all;
entity ARCHIVATOR_vlg_check_tst is
    port(
        byte_out        : in     vl_logic_vector(7 downto 0);
        CBUF_overflow   : in     vl_logic;
        FIFO_EMPTY      : in     vl_logic;
        FIFO_FULL       : in     vl_logic;
        pin_name1       : in     vl_logic;
        pin_name2       : in     vl_logic;
        ready           : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end ARCHIVATOR_vlg_check_tst;
