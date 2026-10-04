--------------------------------------------------------------
-- Multiplicador		
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------

entity TMR_Voter is
generic(

	data_width : integer := 64
);
port(
	-- 	Bit Inputs
	A:	in std_logic_vector(data_width-1 downto 0);
	B:	in std_logic_vector(data_width-1 downto 0);
	C:	in std_logic_vector(data_width-1 downto 0);

	--	Bit_Vector Outputs
	O:	out std_logic_vector(data_width-1 downto 0)
);
end TMR_Voter;

--------------------------------------------------------------
architecture arq_TMR_Voter of TMR_Voter is
begin

	O <= (A and B) or (B and C) or (A and C);

end arq_TMR_Voter;

--------------------------------------------------------------
