library verilog;
use verilog.vl_types.all;
entity ARCHIVATOR_testbench is
    port(
        FIFO_FULL       : out    vl_logic;
        en              : in     vl_logic;
        nreset          : in     vl_logic;
        rdclk           : in     vl_logic;
        read            : in     vl_logic;
        readclk         : in     vl_logic;
        FIFO_EMPTY      : out    vl_logic;
        ready           : out    vl_logic;
        CBUF_OVERFLOW   : out    vl_logic;
        cbuf_full       : out    vl_logic;
        full2           : out    vl_logic;
        wrreq1          : in     vl_logic;
        rdreq2          : in     vl_logic;
        clock2          : in     vl_logic;
        sclr2           : in     vl_logic;
        data2           : in     vl_logic_vector(7 downto 0);
        empty2          : out    vl_logic;
        byte_out        : out    vl_logic_vector(7 downto 0);
        q2              : out    vl_logic_vector(7 downto 0);
        usedw2          : out    vl_logic_vector(2 downto 0);
        clk             : in     vl_logic;
        bit_in          : in     vl_logic_vector(15 downto 0)
    );
end ARCHIVATOR_testbench;
