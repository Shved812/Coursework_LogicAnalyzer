library verilog;
use verilog.vl_types.all;
entity ARCHIVATOR is
    port(
        FIFO_FULL       : out    vl_logic;
        nreset          : in     vl_logic;
        en              : in     vl_logic;
        rdclk           : in     vl_logic;
        clk             : in     vl_logic;
        bit_in          : in     vl_logic_vector(15 downto 0);
        readclk         : in     vl_logic;
        FIFO_EMPTY      : out    vl_logic;
        ready           : out    vl_logic;
        CBUF_overflow   : out    vl_logic;
        pin_name1       : out    vl_logic;
        pin_name2       : out    vl_logic;
        byte_out        : out    vl_logic_vector(7 downto 0);
        read            : in     vl_logic
    );
end ARCHIVATOR;
