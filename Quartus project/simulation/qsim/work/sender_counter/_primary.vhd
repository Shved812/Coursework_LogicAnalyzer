library verilog;
use verilog.vl_types.all;
entity sender_counter is
    port(
        nreset          : in     vl_logic;
        en              : in     vl_logic;
        rdclk           : in     vl_logic;
        ready_in        : in     vl_logic;
        word_out        : out    vl_logic_vector(15 downto 0);
        ready           : out    vl_logic
    );
end sender_counter;
