
library ieee;
use ieee.std_logic_1164.all;

entity Das_N_bit_Add_Sub is
	generic (N: INTEGER:= 32);
	port( AddSub : in std_logic;
			x, y   : in std_logic_vector (N-1 downto 0);
			Sum    : out std_logic_vector (N-1 downto 0);
			Cout, Overflow_Flag, Zero_Flag, Negative_Flag: out std_logic);

end Das_N_bit_Add_Sub;

architecture Das_N_bit_AddSub of Das_N_Bit_Add_Sub is

component Das_Full_Adder is 
	port (x, y, Zin: in std_logic;
			sum, Cout : out std_logic);
end component;

signal Temp_Cout: std_logic_vector (N downto 0);
signal Temp: std_logic_vector (N-1 downto 0);
signal Or_Temp: std_logic_vector (N-1 downto 0);
signal Temp_Sum :  std_logic_vector (N-1 downto 0);
signal Temp_Zero_Flag :  std_logic_vector (N downto 0) := (others => '0');

begin

Temp_Cout(0) <= AddSub; 
Cout <= Temp_Cout(N);
Overflow_Flag <= Temp_Cout(N) xor Temp_Cout(N-1);
Negative_Flag <= Temp_Sum(N-1);
--Temp_Zero_Flag(0) <= '1';

Sum <= Temp_Sum;

Loop2:for i in 0 to N-1 generate
			Temp(i) <= y(i) xor AddSub;
		--	Temp_Zero_Flag(i + 1) <= Temp_Sum(i) xor Temp_Zero_Flag(i);
			add_sub : Das_Full_Adder port map (Zin=>Temp_Cout(i), x=>x(i),y=>Temp(i), sum=>Temp_Sum(i), Cout=>Temp_Cout(i+1));
	end generate;

--Zero_Flag <= Temp_Zero_Flag(N);

process (Temp_Sum)
begin
	if (Temp_Sum = x"00000000") then
		Zero_Flag <= '1';
	else 
		Zero_Flag <= '0';
	end if;
end process;
	
	
	

--	if (Temp_Cout(N) <='1') then
--		Negative_Flag <= '1';
--		else 
--		Negative_Flag <= '0';
--		end if;
--		end process;

end Das_N_bit_AddSub;
