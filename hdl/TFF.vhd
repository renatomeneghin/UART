--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: TFF.vhd
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
use ieee.std_logic_arith.all;
use work.all;

entity TFF is
port (
    Tin     :	in std_logic;
    nrst    :	in std_logic;
    clk     :	in std_logic;
    Q       :	out std_logic
);
end TFF;
architecture architecture_TFF of TFF is
   -- signal, component etc. declarations
	signal ffin, ffout : std_logic; -- example
	
    component Flip_Flop_D is
    port(	
        D   :	in std_logic;
        rst :	in std_logic;
        clk :	in std_logic;
        Q   :	out std_logic
    );
    end component;

begin
    -- Instantiation of the main flip-flop
    U1: Flip_Flop_D port map (D => ffin, rst => nrst, clk => clk, Q => ffout);
    
    -- signal control for the TFF
    ffin    <= Tin xor ffout;
    Q       <= ffout;
end architecture_TFF;
