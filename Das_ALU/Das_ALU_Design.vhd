
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Das_ALU_Design is
	
	generic (N: INTEGER:= 32);
	port( Das_Clk        : in STD_LOGIC  := '1';
	      Das_OP_Code    : in std_logic_vector  (3 downto 0);
	      Das_RS, Das_RT : in std_logic_vector  (N-1 downto 0);
	      Das_shamt      : in integer;
	      Das_16_bit_IMM : in std_logic_vector  (15 downto 0);
	      Das_RD         : out std_logic_vector (N-1 downto 0);
	      Das_AS_RD      : out std_logic_vector (N-1 downto 0);
	      Das_AS_RD_16   : out std_logic_vector (N-1 downto 0); 
	      Das_Cout, Das_Overflow_Flag, Das_Zero_Flag, Das_Negative_Flag: out std_logic;
	      Das_Cout2, Das_Overflow_Flag2, Das_Zero_Flag2, Das_Negative_Flag2: out std_logic);

end Das_ALU_Design;

architecture arch of Das_ALU_Design is

component Das_N_bit_Add_Sub is 
	port( 	AddSub : in std_logic;
		x, y   : in std_logic_vector (N-1 downto 0);
		Sum    : out std_logic_vector (N-1 downto 0);
		Cout, Overflow_Flag, Zero_Flag, Negative_Flag: out std_logic);

end component;

component Das_N_bit_Register is
	generic (N: integer := 32);
	port ( 	Das_Clock : in std_logic;
		Das_Wren : in std_logic;
		Das_Rden : in std_logic;
		Das_Chen : in std_logic;
		Das_D	 : in std_logic_vector (N-1 downto 0);
		Das_Q	 : out std_logic_vector (N-1 downto 0) 
		);
end component;

component Das_16_bit_Register is
	generic (N: integer := 16);
	port ( 	Das_Clock : in std_logic;
		Das_Wren : in std_logic;
		Das_Rden : in std_logic;
		Das_Chen : in std_logic;
		Das_D	 : in std_logic_vector (N-1 downto 0);
		Das_Q	 : out std_logic_vector (N-1 downto 0) 
		);
end component;

component Das_4_bit_OP_Code is
	generic (N: INTEGER:= 32);
	port( 	Das_OP_Code    : in std_logic_vector (3 downto 0);
		Das_x, Das_y   : in std_logic_vector (N-1 downto 0);
		Das_shamt       : in integer;
		Das_extension : in std_logic_vector (N-1 downto 0);
		Das_Result     : out std_logic_vector (N-1 downto 0));
end component;

component Das_Sign_Ext is
	port ( Das_Bits_IN  : in std_logic_vector (15 downto 0);
	       Das_Bits_OUT : out std_logic_vector (31 downto 0)
	     );
end component;

signal Das_Add_Sub	: STD_LOGIC;
signal Das_wren		: STD_LOGIC;
signal Das_chen		: STD_LOGIC;
signal Das_rden		: STD_LOGIC;
signal Das_Extension    : std_logic_vector (N-1 downto 0);
signal Das_RS_Out	: std_logic_vector (N-1 downto 0); 
signal Das_RT_Out       : std_logic_vector (N-1 downto 0);
signal Das_IMM_Out      : std_logic_vector (15 downto 0);
signal Das_RD_Second_2  : std_logic_vector (N-1 downto 0);
signal Das_RD_Second_3  : std_logic_vector (N-1 downto 0);
signal Das_RD_Second_4  : std_logic_vector (N-1 downto 0);

begin

process(Das_OP_Code)
begin
	if (Das_OP_Code = "0000") then --add
		Das_Add_Sub <= '0';
	elsif (Das_OP_Code = "0001") then --addi
		Das_Add_Sub <= '0';
	elsif (Das_OP_Code = "0100") then
		Das_Add_Sub <= '1';
	end if;
end process;

Sign_Ext: Das_Sign_Ext port map (Das_16_Bit_IMM, Das_Extension);

AddSub: Das_N_bit_Add_Sub port map (AddSub => Das_Add_Sub, x => Das_RS_Out, 
				    y => Das_RT_Out, Cout => Das_Cout, 
				    Overflow_Flag => Das_Overflow_Flag, 
				    Zero_Flag => Das_Zero_Flag, Negative_Flag => Das_Negative_Flag,
				    Sum => Das_RD_Second_2);

												
AddSub_2: Das_N_bit_Add_Sub port map (AddSub => Das_Add_Sub, x => Das_RS_Out, 
				      y => Das_Extension, Cout => Das_Cout2, 
				      Overflow_Flag => Das_Overflow_Flag2, 
				      Zero_Flag => Das_Zero_Flag2, Negative_Flag => Das_Negative_Flag2,
				      Sum => Das_RD_Second_4);
												
Registers_In1: Das_N_bit_Register port map (Das_Clock => Das_Clk, Das_Wren => Das_wren, 
					    Das_Rden => Das_rden, Das_Chen => Das_chen,
					    Das_D => Das_RS, Das_Q => Das_RS_Out);
														
Register_Out1: Das_N_bit_Register port map (Das_Clock => Das_Clk, Das_Wren => Das_wren, 
					    Das_Rden => Das_rden, Das_Chen => Das_chen,
					    Das_D => Das_RD_Second_2, Das_Q => Das_AS_RD);
																				 
Registers_In2: Das_N_bit_Register port map (Das_Clock => Das_Clk, Das_Wren => Das_wren, 
				     	    Das_Rden => Das_rden, Das_Chen => Das_chen,
					    Das_D => Das_RT, Das_Q => Das_RT_Out);
														
Register_3: Das_16_Bit_Register port map (Das_Clock => Das_Clk, Das_Wren => Das_wren, 
					  Das_Rden => Das_rden, Das_Chen => Das_chen,
					  Das_D => Das_16_Bit_IMM, Das_Q => Das_IMM_Out);
														
Register_Out3: Das_N_bit_Register port map (Das_Clock => Das_Clk, Das_Wren => Das_wren, 
					    Das_Rden => Das_rden, Das_Chen => Das_chen,
					    Das_D => Das_RD_Second_4, Das_Q => Das_AS_RD_16);
																				
Logical_OP: Das_4_bit_OP_Code port map (Das_OP_Code => Das_OP_Code, Das_x => Das_RS_Out, Das_y => Das_RT_Out, 
					Das_shamt => Das_shamt, Das_extension => Das_Extension, 
					Das_Result => Das_RD_Second_3);

Register_Out2: Das_N_bit_Register port map (Das_Clock => Das_Clk, Das_Wren => Das_wren, 
					    Das_Rden => Das_rden, Das_Chen => Das_chen,
					    Das_D => Das_RD_Second_3, Das_Q => Das_RD);



end arch;
	
