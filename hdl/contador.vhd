--------------------------------------------------------------
-- Contador sincrono com reset		
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

--------------------------------------------------------------

entity contador is
generic(
	data_width : integer := 6
);
port(	
    clk: 	in std_logic;
	init:	in std_logic;
	count:	out std_logic_vector(data_width-1 downto 0)
);
end contador;

--------------------------------------------------------------

architecture arq_contador of contador is

signal EA, PE: std_logic_vector(data_width-1 downto 0);

component UAL 
generic(
	data_width : integer := 64
);
port(	
	A:	in std_logic_vector(data_width-1 downto 0);
	B:	in std_logic_vector(data_width-1 downto 0);
	Cin:	in std_logic;

	S:	out std_logic_vector(data_width-1 downto 0);
	Cout:	out std_logic
);
end component;


begin
 	process(clk, init, PE) is
	begin
		if init = '1' then
			EA <= (others => '0');
		elsif clk'event and clk= '1' then
			EA <= PE;
		end if;
	end process;

	U1: UAL
		generic map(
			data_width => data_width
		)
		port map(
			A => EA,
			B => (others => '1'),
			Cin => '0',
			S => PE,
			Cout => open
		);

	count 	<= EA;
end arq_contador;


--------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity contador_ud_en is
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
end contador_ud_en;

--------------------------------------------------------------

architecture arq_contador_ud_en of contador_ud_en is

signal EA, PE, inc: std_logic_vector(data_width-1 downto 0);

component UAL 
generic(
	data_width : integer := 64
);
port(	
	A:	in std_logic_vector(data_width-1 downto 0);
	B:	in std_logic_vector(data_width-1 downto 0);
	Cin:	in std_logic;

	S:	out std_logic_vector(data_width-1 downto 0);
	Cout:	out std_logic
);
end component;

begin
 	process(clk, init, PE) is
	begin
		if init = '1' then
			EA <= (others => dir);
		elsif clk'event and clk= '1' then
            if en = '1' then
                EA <= PE;
            end if;
		end if;
	end process;
    
	U1: UAL
		generic map(
			data_width => data_width
		)
		port map(
			A => EA,
			B => inc,
			Cin => '0',
			S => PE,
			Cout => open
		);
		        
    inc(inc'high downto inc'low+1) <= (others => dir);
    inc(inc'low) <= '1';
	
    count <= EA;
end arq_contador_ud_en;
