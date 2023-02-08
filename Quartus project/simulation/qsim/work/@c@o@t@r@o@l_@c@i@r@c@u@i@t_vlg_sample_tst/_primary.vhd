library verilog;
use verilog.vl_types.all;
entity COTROL_CIRCUIT_vlg_sample_tst is
    port(
        data_rx         : in     vl_logic_vector(7 downto 0);
        FIFO_EMPTY      : in     vl_logic;
        FIFO_FULL       : in     vl_logic;
        idle_tx         : in     vl_logic;
        nreset_button   : in     vl_logic;
        rdclk           : in     vl_logic;
        ready_rx        : in     vl_logic;
        start_button    : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end COTROL_CIRCUIT_vlg_sample_tst;
