library ieee;

use ieee.std_logic_1164.all;

entity Das_Half_Adder is
	
	port (X, y: in std_logic;
			s_ha, c_ha : out std_logic);

end Das_Half_Adder;

architecture Das_HA of Das_Half_Adder is

begin

P1: process (x, y)
		begin 
			s_ha  <= x xor y;
		end process;
		
P2: process (x, y)
		begin
			c_ha <= x and y;
		end process;
	
end Das_HA;