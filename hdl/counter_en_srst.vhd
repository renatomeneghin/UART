--------------------------------------------------------------
-- Contador sincrono com reset		
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.all;

--------------------------------------------------------------

entity contador_srst is
generic(
	data_width : integer := 6
);
port(	
    clk     : 	in std_logic;
	en      :	in std_logic;
    nrst    :   in std_logic;
    srst    :   in std_logic;
	count   :	out std_logic_vector(data_width-1 downto 0)
);
end contador_srst;

--------------------------------------------------------------

architecture behavioral of contador_srst is

signal EA, PE: std_logic_vector(data_width-1 downto 0);

begin
 	process(clk, nrst, srst, en, PE) is
	begin
		if nrst = '0' then
			EA <= (others => '0');
		elsif clk'event and clk = '1' then
            if en = '1' then
                if srst = '1' then
                    EA <= (others => '0');
                else
                    EA <= PE;
                end if;
            end if;
		end if;
	end process;
	PE <= unsigned(EA) + 1;
	count <= EA;
end behavioral;