--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: UART_Tx.vhd
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
use ieee.numeric_std.all;
use work.all;

entity UART_Rx_DP is
port (
    -- Input digital signals
	clk         : IN std_logic;
    rst_n       : IN std_logic;

    Data_in     : IN std_logic;
    odd_even    : IN std_logic;
    T_init 	    : in std_logic;
    T_shift 	: in std_logic;
    T_db_sb     : in std_logic;
        
    -- Input digital data
    nData_bits  : IN  std_logic_vector(2 downto 0);
    nStop_bits  : IN  std_logic_vector(1 downto 0);
    T_OUT_MUX   : IN  std_logic_vector(1 downto 0);
    
    -- Output digital signals
    T_counter   : OUT std_logic; 

    -- Output digital data
    Data_out    : OUT std_logic_vector(8 downto 0)
);
end UART_Rx_DP;

architecture architecture_UART_Rx_DP of UART_Rx_DP is
   -- signal, component etc. declarations
	signal baud_ratex2      : std_logic;
    signal baud_rate        : std_logic;
    signal parity_val       : std_logic;
    signal parity_out       : std_logic;
	signal SR_out           : std_logic_vector(8 downto 0);
	signal Counter_out      : std_logic_vector(4 downto 0);
	signal Comp_in          : std_logic_vector(4 downto 0);
	signal NStop            : std_logic_vector(4 downto 0);
	signal NData            : std_logic_vector(4 downto 0);
	signal Comparator_out   : std_logic_vector(4 downto 0);

    component Freq_divider
    generic (
        DIV : positive :=  1
    );
    port (
        --<port_name> : <direction> <type>;
        clk_in      : IN  std_logic; 
        rstn        : IN  std_logic; 
        clk_out     : out std_logic
        --<other_ports>;
    );
    end component;

    component shift_reg
    generic(
        data_width : integer := 8
    );
    port(
        -- 	Bit Inputs
        en:	    in std_logic;
        clk:	in std_logic;
        rst:	in std_logic;
        serial:	in std_logic;
        shift:	in std_logic;

        -- 	Bit_Vector Inputs
        I:	in std_logic_vector(data_width-1 downto 0);

        --	Bit_Vector Outputs
        O:	out std_logic_vector(data_width-1 downto 0)
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

    component contador_ud_en is
    generic(
        data_width  : integer := 6;
        dir         : std_logic := '0'
    );
    port(	
        clk     : 	in std_logic;
        en      :   in std_logic;
        init    :	in std_logic;
        count   :	out std_logic_vector(data_width-1 downto 0)
    );
    end component;

    component UAL 
    generic(
        data_width : integer := 64
    );
    port(	
        A:	    in std_logic_vector(data_width-1 downto 0);
        B:	    in std_logic_vector(data_width-1 downto 0);
        Cin:	in std_logic;

        S:	    out std_logic_vector(data_width-1 downto 0);
        Cout:	out std_logic
    );
    end component;

    component Zero_detector    
    generic(
        data_width : integer := 6
    );
    port(	
        I:	in std_logic_vector(data_width-1 downto 0);
        O:	out std_logic
    );
    end component;

begin
   -- architecture body

    BAUD_DIVIDER_8 : Freq_divider generic map (DIV =>  8)
    port map (clk_in => clk, rstn => rst_n, clk_out => baud_ratex2);

    BAUD_DIVIDER_16 : Freq_divider generic map (DIV =>  16)
    port map (clk_in => clk, rstn => rst_n, clk_out => baud_rate);

    SR:  shift_reg generic map(data_width =>  9)
    port map(
            en      =>  T_init, 
            clk     =>  baud_rate, 
            rst     =>  rst_n, 
            serial  =>  '0', 
            shift   =>  T_shift, 
            I       =>  Data_in, 
            O       =>  SR_out
    );

    PARITY_TFF: TFF port map(
        Tin => SR_out(SR_out'low), 
        nrst => rst_n, 
        clk => baud_rate, 
        Q => parity_val
        );

    parity_out <=   parity_val when odd_even = '0' else 
                    not parity_val;

    Data_out <= '0' when T_OUT_MUX = "00" else
                '1' when T_OUT_MUX = "01" else
                SR_out(SR_out'low) when T_OUT_MUX = "10" else
                parity_out;

    CONTADOR: contador_ud_en generic map (data_width => 5, dir => '1')
        port map(
            clk     => baud_ratex2, 
            en      => '1',
            init    => T_init,
            count   => Counter_out
        );

    NData   <=  "01010" when nData_bits = "000" else
                "01100" when nData_bits = "001" else
                "01110" when nData_bits = "010" else
                "10000" when nData_bits = "011" else
                "10010" when nData_bits = "100" else
                "10000";

    NStop   <=  "00010" when nStop_bits = "00" else
                "00011" when nStop_bits = "01" else
                "00100" when nStop_bits = "10" else
                "00010";

    Comp_in <=  NData when T_db_sb = '0' else
                NStop;

    COMPARATOR: UAL generic map(data_width => 5)
    port map(
        A => Counter_out,
        B => Comp_in,
        Cin => '0',
        S => Comparator_out,
        Cout => open
    );

    COUNTER_END: Zero_detector generic map (data_width => 5)
    port map(
            I => Comparator_out,
            O => T_counter
    );
            
end architecture_UART_Rx_DP;