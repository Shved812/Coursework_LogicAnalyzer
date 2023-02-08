library verilog;
use verilog.vl_types.all;
entity valider is
    port(
        nreset          : in     vl_logic;
        en              : in     vl_logic;
        rdclk           : in     vl_logic;
        byte            : in     vl_logic_vector(7 downto 0);
        ready           : in     vl_logic;
        switch          : out    vl_logic
    );
end valider;
