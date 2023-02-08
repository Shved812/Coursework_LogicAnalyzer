library verilog;
use verilog.vl_types.all;
entity ARCHIVATOR_vlg_sample_tst is
    port(
        bit_in          : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        en              : in     vl_logic;
        nreset          : in     vl_logic;
        rdclk           : in     vl_logic;
        read            : in     vl_logic;
        readclk         : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end ARCHIVATOR_vlg_sample_tst;
