LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Das_Final_Lab_CPU IS
	generic (N: integer := 32);
	PORT
	(
		Das_clock		    : IN STD_LOGIC  := '1';
		Das_Register_Clock : IN STD_LOGIC;
		Das_Wren		       : IN STD_LOGIC  := '0';
		Das_Chen           : IN std_logic;
		Das_rden	          : IN STD_LOGIC;
		Das_IR_I_Register  : IN std_logic_vector (31 downto 0);
		Das_data		       : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		Das_RS	          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Das_RT	          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Das_q		          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Das_AS_RD          : out std_logic_vector (N-1 downto 0);
		Das_AS_RD_16       : out std_logic_vector (N-1 downto 0); 
		Das_Cout, Das_Overflow_Flag, Das_Zero_Flag, Das_Negative_Flag     : out std_logic;
		Das_Cout2, Das_Overflow_Flag2, Das_Zero_Flag2, Das_Negative_Flag2 : out std_logic
		
	);
END Das_Final_Lab_CPU;


ARCHITECTURE SYN OF Das_Final_Lab_CPU IS

SIGNAL Das_sub_wire0	      : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Das_sub_wire1	      : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal Das_q_signal		   : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal Das_rdaddress_a		: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal Das_rdaddress_b		: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal Das_wraddress		   : STD_LOGIC_VECTOR (4 DOWNTO 0);
signal Das_Result	         : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal Das_d_signal	      : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal Das_OP_Code         : STD_LOGIC_VECTOR (3 downto 0);
signal Das_16_bit_IMM      : std_logic_vector (15 downto 0);
signal Das_RD              : std_logic_vector (N-1 downto 0);
signal Das_Add_Sub		   : STD_LOGIC;
signal Das_shamt           : integer; 
signal Das_MemWr : std_logic;
signal Das_MemRd :std_logic; 

component Das_N_BIT_Register is
	generic (N: integer := 32);
	port ( Das_Clock : in std_logic;
			 Das_Wren : in std_logic;
			 Das_Rden : in std_logic;
			 Das_Chen : in std_logic;
			 Das_D	 : in std_logic_vector (N-1 downto 0);
			 Das_Q	 : out std_logic_vector (N-1 downto 0) 
			 );
end component;

component Das_N_Bit_Add_Sub is 
	generic (N: integer := 32);
	port( AddSub : in std_logic;
			x, y : in std_logic_vector (N-1 downto 0);
			Sum : out std_logic_vector (N-1 downto 0);
			Cout, Overflow_Flag, Zero_Flag, Negative_Flag: out std_logic);
end component;

component Das_ALU_Design is 
	generic (N: INTEGER:= 32);
	port( Das_Clk        : in STD_LOGIC  := '1';
			Das_Wren			: in STD_LOGIC;
			Das_chen			: in STD_LOGIC;
			Das_rden			: in STD_LOGIC;
			Das_OP_Code    : in std_logic_vector  (3 downto 0);
			Das_RS, Das_RT : in std_logic_vector  (N-1 downto 0);
			Das_shamt      : integer;
			Das_16_bit_IMM : in std_logic_vector  (15 downto 0);
			Das_RD         : out std_logic_vector (N-1 downto 0);
			Das_AS_RD      : out std_logic_vector (N-1 downto 0);
			Das_AS_RD_16   : out std_logic_vector (N-1 downto 0); 
			Das_Cout, Das_Overflow_Flag, Das_Zero_Flag, Das_Negative_Flag: out std_logic;
			Das_Cout2, Das_Overflow_Flag2, Das_Zero_Flag2, Das_Negative_Flag2: out std_logic);
end component;
	
BEGIN

	Das_q <= Das_q_signal;
	Das_d_signal <= Das_IR_I_Register;
	
	
portMap_For_N_Bit_Registers: Das_N_BIT_Register port map (Das_Clock => Das_Register_Clock, Das_Wren => Das_wren, 
																				 Das_Rden => Das_rden, Das_Chen => Das_chen,
																				 Das_D => Das_d_signal, Das_Q => Das_q_signal);
	Das_OP_Code <= Das_q_signal(31 downto 28);
	Das_wraddress <= Das_q_signal(25 downto 21);
	Das_rdaddress_a <= Das_q_signal(20 downto 16); 
	Das_rdaddress_b <= Das_q_signal(15 downto 11);
	Das_16_bit_IMM <= Das_q_signal(15 downto 0);

	altsyncram_component_1 : altsyncram
	GENERIC MAP (
		address_aclr_b => "NONE",
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_b => "BYPASS",
		init_file => "Das_Final_Lab_CPU_Mif.mif",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 32,
		numwords_b => 32,
		operation_mode => "DUAL_PORT",
		outdata_aclr_b => "NONE",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		ram_block_type => "M10K",
		read_during_write_mode_mixed_ports => "DONT_CARE",
		widthad_a => 5,
		widthad_b => 5,
		width_a => 32,
		width_b => 32,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => Das_wraddress,
		address_b => Das_rdaddress_a,
		clock0 => Das_clock,
		data_a => Das_data,
		wren_a => Das_wren,
		q_b => Das_sub_wire0
	);
	
	altsyncram_component_2 : altsyncram
	GENERIC MAP (
		address_aclr_b => "NONE",
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_b => "BYPASS",
		init_file => "Das_Final_Lab_CPU_Mif.mif",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 32,
		numwords_b => 32,
		operation_mode => "DUAL_PORT",
		outdata_aclr_b => "NONE",
		outdata_reg_b => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		ram_block_type => "M10K",
		read_during_write_mode_mixed_ports => "DONT_CARE",
		widthad_a => 5,
		widthad_b => 5,
		width_a => 32,
		width_b => 32,
		width_byteena_a => 1
	)

	PORT MAP (
		address_a => Das_wraddress,
		address_b => Das_rdaddress_b,
		clock0 => Das_clock,
		data_a => Das_data,
		wren_a => Das_wren,
		q_b => Das_sub_wire1
	);
	
	process(Das_q_signal)
	begin
		if (Das_q_signal(26) = '0') then
			Das_Add_Sub <= '0';
		else
			Das_Add_Sub <= '1';
		end if;
	end process;
	
	process(Das_OP_Code) --LW/SW
	begin
	if (Das_OP_Code = "0010") then 
		Das_RS    <= Das_sub_wire0(31 DOWNTO 0);
		Das_RT    <= Das_sub_wire1(31 DOWNTO 0);
		Das_AS_RD <= Das_Result;
	end if;
	end process;


portMap_for_ALU: Das_ALU_Design port map (Das_Clk =>  Das_Clock, 
														Das_Wren => Das_Wren, Das_Chen => Das_Chen, Das_rden => Das_rden,
														Das_OP_Code => Das_OP_Code,
														Das_RS => Das_sub_wire0, Das_RT => Das_sub_wire1,
														Das_shamt => Das_shamt,
														Das_16_bit_IMM => Das_16_bit_IMM,
														Das_RD => Das_RD,
														Das_AS_RD => DAs_Result,
														Das_AS_RD_16 => Das_AS_RD_16,
														Das_Cout => Das_Cout, 
														Das_Overflow_Flag => Das_Overflow_Flag, 
														Das_Zero_Flag => Das_Zero_Flag, 
														Das_Negative_Flag => Das_Negative_Flag,
													   Das_Cout2 => Das_Cout2, 
														Das_Overflow_Flag2 => Das_Overflow_Flag2, 
														Das_Zero_Flag2 => Das_zero_Flag2, 
														Das_Negative_Flag2 => Das_Negative_Flag2
														);

END SYN;