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

entity UART_Tx is
port (
    -- Input digital signals
	go          : IN std_logic;
    clk         : IN std_logic;
    rst_n       : IN std_logic;
    parity_en   : IN std_logic;
    odd_even    : IN std_logic;

    -- Input digital data
    Data_in     : IN  std_logic_vector(8 downto 0);
    nData_bits  : IN  std_logic_vector(2 downto 0);
    nStop_bits  : IN  std_logic_vector(1 downto 0);

    -- Output digital signals
    idle        : OUT std_logic; 

    -- Output digital data
    Data_out    : OUT std_logic
);
end UART_Tx;

architecture architecture_UART_Tx of UART_Tx is
   -- signal, component etc. declarations
	signal T_counter    : std_logic;
	signal T_init       : std_logic;
	signal T_shift      : std_logic;
	signal T_db_sb      : std_logic;
	signal T_OUT_MUX    : std_logic_vector(1 downto 0);

    component UART_Tx_CU is
    port (
        -- Input digital signals
        clk         : IN    std_logic;
        rst_n       : IN    std_logic;
        go          : IN    std_logic;
        
        T_counter   : IN    std_logic;

        parity_en   : IN    std_logic;

        T_init 	    : OUT   std_logic;
        T_shift 	: OUT   std_logic;
        T_db_sb     : OUT   std_logic;
        T_OUT_MUX   : OUT   std_logic_vector(1 downto 0);

        -- Output digital signals 
        idle        : OUT   std_logic 

    );
    end component;

    component UART_Tx_DP is
    port (
        -- Input digital signals
        clk         : IN std_logic;
        rst_n       : IN std_logic;

        odd_even    : IN std_logic;
        T_init 	    : in std_logic;
        T_shift 	: in std_logic;
        T_db_sb     : in std_logic;
            
        -- Input digital data
        Data_in     : IN  std_logic_vector(8 downto 0);
        nData_bits  : IN  std_logic_vector(2 downto 0);
        nStop_bits  : IN  std_logic_vector(1 downto 0);
        T_OUT_MUX   : IN  std_logic_vector(1 downto 0);

        -- Output digital signals
        T_counter   : OUT std_logic; 

        -- Output digital data
        Data_out    : OUT std_logic
    );
end component;

begin
    -- architecture body
    DP: UART_Tx_DP port map (
        clk         => clk,
        rst_n       => rst_n,
        odd_even    => odd_even,
        T_init 	    => T_init,
        T_shift 	=> T_shift,
        T_db_sb     => T_db_sb,
        Data_in     => Data_in,
        nData_bits  => nData_bits,
        nStop_bits  => nStop_bits,
        T_OUT_MUX   => T_OUT_MUX,
        T_counter   => T_counter,
        Data_out    => Data_out        
    );

    CU: UART_Tx_CU port map (
        clk         => clk,
        rst_n       => rst_n,
        go          => go,
        T_counter   => T_counter,
        parity_en   => clk,
        T_init 	    => T_init,
        T_shift 	=> T_shift,
        T_db_sb     => T_db_sb,
        T_OUT_MUX   => T_OUT_MUX, 
        idle        => idle
    ); 
end architecture_UART_Tx;
