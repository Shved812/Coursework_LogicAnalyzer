library verilog;
use verilog.vl_types.all;
entity ARCHIVATOR_testbench_vlg_check_tst is
    port(
        byte_out        : in     vl_logic_vector(7 downto 0);
        cbuf_full       : in     vl_logic;
        CBUF_OVERFLOW   : in     vl_logic;
        empty2          : in     vl_logic;
        FIFO_EMPTY      : in     vl_logic;
        FIFO_FULL       : in     vl_logic;
        full2           : in     vl_logic;
        q2              : in     vl_logic_vector(7 downto 0);
        ready           : in     vl_logic;
        usedw2          : in     vl_logic_vector(2 downto 0);
        sampler_rx      : in     vl_logic
    );
end ARCHIVATOR_testbench_vlg_check_tst;
