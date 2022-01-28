library IEEE;
use IEEE.std_logic_1164.all;

entity Das_Sign_Ext is

	port ( Das_Bits_IN : in std_logic_vector (15 downto 0);
			 Das_Bits_OUT : out std_logic_vector (31 downto 0)
		  );
			 
end Das_Sign_Ext;

architecture behav of Das_Sign_Ext is 

begin

Das_Bits_OUT <= x"0000"  & Das_Bits_IN when Das_Bits_IN(15) = '0' else
					 x"FFFF"  & Das_Bits_IN;
	
end behav;