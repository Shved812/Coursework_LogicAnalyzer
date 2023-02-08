library verilog;
use verilog.vl_types.all;
entity EDGE_CODER_vlg_sample_tst is
    port(
        bit_in          : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        en              : in     vl_logic;
        nreset          : in     vl_logic;
        rdclk           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end EDGE_CODER_vlg_sample_tst;
