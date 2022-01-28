library ieee;

use ieee.std_logic_1164.all;

entity Das_Full_Adder is
	
	port (x, y, Zin: in std_logic;
			sum, Cout : out std_logic);

end Das_Full_Adder;

architecture Das_FA of Das_Full_Adder is
	signal int_1, int_2, int_3: std_logic;
	component Das_Half_Adder is 
	port (x, y : in std_logic;
			s_ha, c_ha : out std_logic);
	end component; 
begin
	FA1 : Das_Half_Adder port map (x => x, y => y, s_ha => int_1, c_ha => int_3);
	FA2 : Das_Half_Adder port map (x => int_1, y => Zin, s_ha => sum, c_ha => int_2);
	cout <= int_2 or int_3;
	
end Das_FA;