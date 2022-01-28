library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;


entity Das_4_bit_OP_Code is
	
	generic (N: INTEGER:= 32);
	port( Das_OP_Code    : in std_logic_vector (3 downto 0);
			Das_x, Das_y   : in std_logic_vector (N-1 downto 0);
			Das_shamt       : in integer;
			Das_extension : in std_logic_vector (N-1 downto 0);
			Das_Result         : out std_logic_vector (N-1 downto 0));

end Das_4_bit_OP_Code;

architecture arch of Das_4_bit_OP_Code is

begin

process (Das_OP_code, Das_x, Das_y)
begin
	case Das_OP_Code is
	
		when "0110" => Das_Result <= Das_x and Das_y; --and
		when "0111" => Das_Result <= Das_x and Das_extension; --andi
		when "1000" => Das_Result <= Das_x nor Das_y; --nor
		when "1010" => Das_Result <= Das_x or Das_y; --or
		when "1011" => Das_Result <= Das_x or Das_extension; --ori
		when "1100" => Das_Result <= to_stdlogicvector(to_bitvector(Das_y) sll Das_shamt); --shift left
		when "1101" => Das_Result <= to_stdlogicvector(to_bitvector(Das_y) srl Das_shamt); --shift right
		when "1110" => Das_Result <= to_stdlogicvector(to_bitvector(Das_y) sra Das_shamt); --shift right arithmatic
		when others => Das_Result <= x"00000000";
		
	end case;
end process;

end arch;
 

