library verilog;
use verilog.vl_types.all;
entity valider_vlg_sample_tst is
    port(
        byte            : in     vl_logic_vector(7 downto 0);
        en              : in     vl_logic;
        nreset          : in     vl_logic;
        rdclk           : in     vl_logic;
        ready           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end valider_vlg_sample_tst;
