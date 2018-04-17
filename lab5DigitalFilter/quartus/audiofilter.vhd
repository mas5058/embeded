library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Signal declarations
signal filterInOneChannel : signed(15 downto 0);
signal filterInResized : signed(35 downto 0);
signal filterSection_1in : signed(35 downto 0);
signal filterOutput : signed(35 downto 0);

signal s1Output : signed(35 downto 0);
signal b1input : signed(35 downto 0);
signal b1Output : signed(35 downto 0);
signal ab2Output : signed(35 downto 0);
signal b2Output : signed(35 downto 0);
signal a2Output : signed(35 downto 0);
signal sec1 : signed(35 downto 0);
signal sec2 : signed(35 downto 0);

--constant declarations
constant B(1)(1) : std_logic_signed := x"E45";
constant B(3)(1) : std_logic_signed := (others => '0');
constant B(1)(2) : std_logic_signed := x"15B"; --.0026446 to 347
constant B(2)(2) : std_logic_signed := x"2B7"; -- .00529893 to 695
constant B(3)(2) : std_logic_signed := x"15B"; --.0026446
constant a(2)(1) : std_logic_signed := x"1D1EC";-- - 91
constant a(3)(1) : std_logic_signed := (others => '0');
constant a(2)(2) : std_logic_signed := x"1D1EC"-- -1.9349
constant a(3)(2) : std_logic_signed := x"1E317"-- .94353 to 123671

-- Grab just one channel from input
filterInOneChannel <= i_audioSample(35 downto 0);

-- Simply resize the 16 bit input to 36 bits. There is an implied
-- divide by 4 involved in this, since we are going from 15 bits to
-- 17 bits after the implied decimal point. This will be canceled by
-- the multiply by 4 on the output.
filterInResized <= resize(filterInOneChannel, filterInResized'length);

-- Implement the divide by 16 which is multiplier s(1)
filterSection_1in <= shift_right(filterInResized, 4);

-- Grab the lowest 16 bits of your filter output and place them
-- into the output port. There is an implied multiply by 4 here
-- due to going from 15 bits to 17 bits after the decimal. This cancels
-- the previous divide by 4.
o_audioSampleFiltered <= filterOutput(15 downto 0) & filterOutput(15 downto 0);

entity audiofilter is
	port (
		clk : in std_logic;
		reset : in std_logic;
		audioSample : in signed(35 downto 0);
		dataReq : in std_logic;
		audioSampleFiltered : out signed(35 downto 0)
	);
end entity;

architecture arch of audiofilter is
	--circles are adders, triangles are multipliers

	component multi_inst is
	port (
			dataa	 : in std_logic_vector (35 downto 0);
			datab	 : in std_logic_vector (35 downto 0);
			result : out std_logic_vector  (71 downto 0)	 
		);
	end component;

	component Adder is
		port
		(
			nibble1, nibble2 : in unsigned(35 downto 0); 
			sum       : out unsigned(35 downto 0); 
			carry_out : out std_logic
		);
	end component;
	
	component flipflop is
	port ( d, clk, en : in std_logic;
	       q 		  : out std_logic
	);
	end component;

	begin
	-- s(1)multi : multi_inst port map(
		-- dataa => audioSample,
		-- datab => 
		-- result => s1Output);
		--done with filterSection_1in
		
	s(1)adder: Adder port map(
		nibble1 => filterSection_1in,
		nibble1 => a2Output,
		sum => b1input,
		carry_out=> null
	)
	
	b11multi: multi_inst port map(
		dataa => b1input,
		datab => B(1)(1),
		result => b1Output
	)
	
	badder: Adder port map(
		nibble1 => b1Output,
		nibble2 => b2Output,
		sum => sec1
		)
		
	sec1ff1: flipflop  port map(
		clk => clk,
		d => b1input,
		en => dataReq,
		q => ab2Output
	)
	b(2)(1)multi: multi_inst port map(
		dataa => ab2Output,
		datab => b2Output,
		result => b2Output
	)
	a(2)(1)multi: multi_inst port map(
		dataa => ab2Output,
		datab => b2Output,
		result => a2Output
	)
	
	
	if (rising_edge(clk)) then
		if (reset = ‘1’) then
			delayOutput <= (others => 0);
		elsif (dataReq = ‘1’) then
			delayOutput <= delayInput;
	end if;
end if;

end architecture arch;