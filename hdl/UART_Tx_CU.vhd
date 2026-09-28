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

entity UART_Tx_CU is
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
end UART_Tx_CU;
architecture architecture_UART_Tx_CU of UART_Tx_CU is
    -- signal, component etc. declarations
    type STATES is (E0,E1,E2,E3);
    signal EA, PE: STATES;

begin
    -- architecture body
    P1:	process(clk, rst_n, PE)
	begin
		if rst_n = '0' then
			EA <= E0;
		elsif clk'event and clk = '1' then
			EA <= PE;
		end if;	
	end process;

    P2:    process(EA, go, T_counter)
    begin
        case EA is
            when E0 =>
                T_shift 	<= 	'0';
                T_db_sb     <= 	'0';
                if go = '1' then
                    PE      <= E1;
                    idle    <= '0';
                    T_init  <= '1';
                    OUT_MUX <= "00";
                else
                    PE      <= E0;
                    idle    <= '1';
                    T_init  <= '0';
                    OUT_MUX <= "01";
                end if;
            when E1 =>
                T_init 	    <= 	'0';
                T_shift 	<= 	'1';
                T_db_sb     <= 	'0';
                idle        <= 	'0';
                OUT_MUX     <= "10";
                if T_counter = '1' then
                    if parity_en = '1' then
                        PE  <= E2;
                    else
                        PE  <= E3;
                    end if;
                else
                    PE      <= E1;
                end if;
            when E2 =>
                T_init 	    <= 	'1';
                T_shift 	<= 	'0';
                T_db_sb     <= 	'1';
                idle        <= 	'0';
                OUT_MUX     <= "11";
                PE          <= E3;
            when E3 =>
                T_init 	    <= 	'0';
                T_shift 	<= 	'0';
                T_db_sb     <= 	'1';
                idle        <= 	'0';
                OUT_MUX     <= "01";
                if T_counter = '1' then
                    PE      <= E0;
                else
                    PE      <= E3;
                end if;                
        end case;
    end process;
            
end architecture_UART_Tx_CU;