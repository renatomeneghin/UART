--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: BaudRate_Generator.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::PolarFireSoC> <Die::MPFS025TL> <Package::FCVG484>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity BaudRate_Generator is
generic (
    FREQ : positive := 1 -- 1 => 100 MHz; 2 => 125 MHz; 3 => 160 MHz; 
);
port (
    --<port_name> : <direction> <type>;
	clk_in      : IN  std_logic; 
    rstn        : IN  std_logic; 
    BAUD_SEL    : IN  std_logic_vector(1 downto 0); 
    baud_clk    : out std_logic
    --<other_ports>;
);
end BaudRate_Generator;
architecture architecture_BaudRate_Generator of BaudRate_Generator is
   -- signal, component etc. declarations
	signal TR  : std_logic;
	signal freq_div     : std_logic_vector(15 downto 0); -- example
    signal counter_out  : std_logic_vector(15 downto 0);

    component contador_srst
        generic(
            data_width : integer := 6
        );
        port( 
            -- Inputs
            clk : in std_logic;
            en : in std_logic;
            nrst : in std_logic;
            srst : in std_logic;
            -- Outputs
            count : out std_logic_vector(data_width-1 downto 0)
        );
    end component;
    
    component TFF is
    port (
        Tin     :	in std_logic;
        nrst    :	in std_logic;
        clk     :	in std_logic;
        Q       :	out std_logic
    );
    end component;
    
begin
    -- architecture body
    Assert freq > 0 and freq < 4
        report "Invalid frequency configuration"
        severity error;
    
    U1: contador_srst 
                generic map (16)
                port map(
                    clk => clk_in, 
                    en => '1',
                    nrst => rstn,
                    srst => TR,
                    count => counter_out
                    );
                    
    U2: TFF port map(Tin => TR, nrst => rstn, clk => clk_in, Q => baud_clk);
    
    TR <= and(not(counter_out xor freq_div));
    
    -----------------------------------------------------------------
    -- BAUD RATE LUT (Blocos de Geração Estática baseados no Generic)
    -----------------------------------------------------------------
    BAUD_RATE_LUT_1: if FREQ = 1 generate
        freq_div <= x"0145" when baud_sel = "00" else
                    x"00A2" when baud_sel = "01" else
                    x"0036" when baud_sel = "10" else
                    x"001B";
    end generate BAUD_RATE_LUT_1;

    BAUD_RATE_LUT_2: if FREQ = 2 generate
        freq_div <= x"0196" when baud_sel = "00" else
                    x"00CB" when baud_sel = "01" else
                    x"0043" when baud_sel = "10" else
                    x"0021";
    end generate BAUD_RATE_LUT_2;

    BAUD_RATE_LUT_3: if FREQ = 3 generate
        freq_div <= x"0208" when baud_sel = "00" else
                    x"0104" when baud_sel = "01" else
                    x"0056" when baud_sel = "10" else
                    x"002B";
    end generate BAUD_RATE_LUT_3;

end architecture_BaudRate_Generator;
