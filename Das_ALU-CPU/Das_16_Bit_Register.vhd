
library IEEE;
use IEEE.std_logic_1164.all;


entity Das_16_BIT_Register is
	generic (N: integer := 16);
	port ( Das_Clock : in std_logic;
			 Das_Wren : in std_logic;
			 Das_Rden : in std_logic;
			 Das_Chen : in std_logic;
			 Das_D	 : in std_logic_vector (N-1 downto 0);
			 Das_Q	 : out std_logic_vector (N-1 downto 0) );
end Das_16_BIT_Register;

architecture arch of Das_16_BIT_Register is 
	
	signal Das_Storage : std_logic_vector (N-1 downto 0);
	
begin 
	process (Das_Clock)
	begin
		if (rising_edge(Das_Clock) and Das_Wren = '1') then 
			Das_Storage <= Das_D;
		end if;
	end process;
	
	process (Das_Rden, Das_Chen, Das_Storage)
	begin
		if (Das_Rden = '1' and Das_Chen = '1') then 
			Das_Q <= Das_Storage;
		elsif (Das_Chen = '0') then
			Das_Q <= (others => 'Z');
		end if;
	end process;
end arch; 