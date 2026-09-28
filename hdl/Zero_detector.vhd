--------------------------------------------------------------
-- Zero Detector		
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------

entity Zero_detector is
generic(
	data_width : integer := 6
);
port(	I:	in std_logic_vector(data_width-1 downto 0);
	O:	out std_logic
);
end Zero_detector;

--------------------------------------------------------------
architecture arq_Zero_detector of Zero_detector is
	signal zeros : std_logic_vector(data_width-1 downto 0);
begin

	process(I) is
	begin
		if I = zeros then
			O <= '1';
		else
			O <= '0';
		end if;
	end process;

	zeros <= (others => '0');	

end arq_Zero_detector;

--------------------------------------------------------------
