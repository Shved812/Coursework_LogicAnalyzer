library verilog;
use verilog.vl_types.all;
entity EDGE_CODER is
    port(
        nreset          : in     vl_logic;
        en              : in     vl_logic;
        clk             : in     vl_logic;
        rdclk           : in     vl_logic;
        bit_in          : in     vl_logic_vector(15 downto 0);
        bit_out         : out    vl_logic_vector(15 downto 0)
    );
end EDGE_CODER;
