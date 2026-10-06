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

entity UART_Tx_DP is
port (
    -- Input digital signals
	clk         : IN    std_logic;
    rst_n       : IN    std_logic;
    
    T_counter   : IN    std_logic;
    T_start_bit : IN    std_logic;

    parity_en   : IN    std_logic;

    T_init 	        : OUT   std_logic;
    T_shift 	    : OUT   std_logic;
    T_db_sb         : OUT   std_logic;
    T_parity_acc    : OUT std_logic;
    T_parity_check  : OUT std_logic;
    
    -- Output digital signals 
    idle        : OUT   std_logic 
);
end UART_Tx_DP;

architecture architecture_UART_Tx_DP of UART_Tx_DP is
    -- signal, component etc. declarations
    type STATES is (E0,E1,E2,E3,E4);
    signal EA, PE: STATES;

begin
    -- architecture body
    P1:	process(clk, rst_n, PE)
	begin
		if rst_n = '0' then
			EA <= E0;
		elsif rising_edge(clk) then
			EA <= PE;
		end if;	
	end process;

    P2:    process(EA, go, T_counter, T_start_bit)
    begin
        case EA is
            when E0 => -- IDLE
                T_shift 	    <= 	'0';
                T_db_sb         <= 	'0';
                T_parity_acc    <=  '0';
                T_parity_check  <=  '0';
                if T_start_bit = '0' then
                    PE          <= E1;
                    idle        <= '0';
                    T_init      <= '0';
                else
                    PE          <= E0;
                    idle        <= '1';
                    T_init      <= '1';
                end if;
            when E1 => -- START BIT?
                T_shift 	    <= 	'0';
                T_db_sb         <= 	'0';
                T_parity_acc    <=  '0';
                T_parity_check  <=  '0';
                idle            <= 	'0';
                if T_counter = '1' then
                    T_init 	    <= '1';
                    if T_start_bit = '0' then
                        PE      <= E2;
                    else
                        PE      <= E0;
                    end if;
                else
                    PE      <= E1;
                    T_init 	<= '0';
                end if;
            when E2 => -- DATA BITS
                T_init 	        <= 	'0';
                T_shift 	    <= 	'1';
                T_db_sb         <= 	'0';
                T_parity_acc    <=  '1';
                T_parity_check  <=  '0';
                idle            <= 	'0';
                if T_counter = '1' then
                    if parity_en = '1' then
                        PE  <= E3;
                    else
                        PE  <= E4;
                    end if;
                else
                    PE      <= E2;
                end if;
            when E3 =>
                T_init 	        <= 	'1';
                T_shift 	    <= 	'0';
                T_db_sb         <= 	'1';
                T_parity_acc    <=  '0';
                T_parity_check  <=  '0';
                idle            <= 	'0';
                PE              <= E4;
            when E4 =>
                T_init 	        <= 	'0';
                T_shift 	    <= 	'0';
                T_db_sb         <= 	'1';
                T_parity_acc    <=  '0';
                T_parity_check  <=  '0';
                idle            <= 	'0';
                if T_counter = '1' then
                    PE      <= E0;
                else
                    PE      <= E4;
                end if;                
        end case;
    end process;
            
end architecture_UART_Tx_DP;