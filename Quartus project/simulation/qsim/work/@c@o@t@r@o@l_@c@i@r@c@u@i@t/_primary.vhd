library verilog;
use verilog.vl_types.all;
entity COTROL_CIRCUIT is
    port(
        nreset          : out    vl_logic;
        nreset_button   : in     vl_logic;
        rdclk           : in     vl_logic;
        ready_rx        : in     vl_logic;
        data_rx         : in     vl_logic_vector(7 downto 0);
        start_button    : in     vl_logic;
        en              : out    vl_logic;
        Led_3           : out    vl_logic;
        FIFO_FULL       : in     vl_logic;
        Led_2           : out    vl_logic;
        Led_1           : out    vl_logic;
        FIFO_EMPTY      : in     vl_logic;
        Led_0           : out    vl_logic;
        idle_tx         : in     vl_logic
    );
end COTROL_CIRCUIT;
