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
signal b12input : signed(35 downto 0);
signal b1Output : signed(35 downto 0);
signal ab2Output : signed(35 downto 0);

signal ff21output : signed(35 downto 0);
signal ff22output : signed(35 downto 0);

signal ff31output : signed(35 downto 0);
signal ff32output : signed(35 downto 0);

signal s2adder1Output : signed(35 downto 0);
signal s2adder2Output : signed(35 downto 0);
signal s2adder3Output : signed(35 downto 0);

signal badder2output : signed(35 downto 0);
signal b2Output : signed(35 downto 0);
signal b12Output : signed(35 downto 0);
signal b13Output : signed(35 downto 0);
signal b22Output : signed(35 downto 0);
signal b23Output : signed(35 downto 0);
signal b32Output : signed(35 downto 0);
signal b33Output : signed(35 downto 0);

signal a2Output : signed(35 downto 0);
signal a22Output : signed(35 downto 0);
signal a23Output : signed(35 downto 0);
signal a32Output : signed(35 downto 0);
signal a33Output : signed(35 downto 0);

signal sec1Output : signed(35 downto 0);
signal sec1       : signed(35 downto 0);
signal sec2       : signed(35 downto 0);

--constant declarations
constant B(1)(1) : std_logic_signed(35 downto 0) := x"E45";
constant B(3)(1) : std_logic_signed(35 downto 0) := (others => '0');
constant B(1)(2) : std_logic_signed(35 downto 0) := x"15B"; --.0026446 to 347
constant B(2)(2) : std_logic_signed(35 downto 0) := x"2B7"; -- .00529893 to 695
constant B(3)(2) : std_logic_signed(35 downto 0) := x"800B"; --.0026446
constant B(3)(3) : std_logic_signed(35 downto 0) := x"15B"; --.25008 to 327793

constant a(2)(1) : std_logic_signed(35 downto 0) := x"1D1EC";-- - 91
constant a(3)(1) : std_logic_signed(35 downto 0) := (others => '0');
constant a(2)(2) : std_logic_signed(35 downto 0) := x"1D1EC"-- -1.9349
constant a(3)(2) : std_logic_signed(35 downto 0) := x"1E317"-- .94353 to 123671
constant a(3)(3) : std_logic_signed(35 downto 0) := x"1B79C"-- .85861 TO 1122540

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

	component adder is
		port
		(
			nibble1, nibble2 : in unsigned(35 downto 0); 
			sum       : out unsigned(35 downto 0); 
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
		
        
    --sec1
    
	s(1)adder: adder port map(
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
	
	badder: adder port map(
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
		datab => B(2)(1),
		result => b2Output
	)
	a(2)(1)multi: multi_inst port map(
		dataa => ab2Output,
		datab => a(2)(1),
		result => a2Output
	)
    
    --sec1.5
    
    s1adder: adder port map(
        nibble1 => sec1,
        nibble2 => a22Output,
        sum => sec1Output
    )
    
    s12adder: adder port map(
        nibble1 => sec1Output,
        nibble2 => a22Output,
        sum     => b12input
    )
    
    b12multi: multi_inst port map(
    	dataa => b12input,
		datab => b(2)(1),
		result => b12Output
    )
    
    badder2: adder port map(
        nibble1 => b12Output,
        nibble2 => b22Output,
        sum     => badder2output,
    )
    
    badder3: adder port map(
        nibble1 => badder2output,
        nibble2 => b32Output,
        sum     => sec2,
    )
    
    b22multi: multi_inst port map(
    	dataa => ff21output,
		datab => b(2)(2),
		result => b22Output
    )
    
    a22multi: multi_inst port map(
    	dataa => ff21output,
		datab => a(2)(2),
		result => a22Output
    )
    
    a32multi: multi_inst port map(
    	dataa => ff22output,
		datab => a(3)(2),
		result => a32Output
    )
    
    b32multi: multi_inst port map(
    	dataa => ff22output,
		datab => b(3)(2),
		result => b22Output
    )
    
    s1ff1 :flipflop port map(
        d => b12input,
        clk => clk,
        en => dataReq,
        q => ff21output
    )

    s1ff2 :flipflop port map(
        d => ff21output,
        clk => clk,
        en => dataReq,
        q => ff22output
    )
    
    --section 2
    
    s2adder1: adder port map(
        nibble1 => sec2,
        nibble2 => a23Output,
        sum     => s2adder1Output
    )
    
    s2adder2: adder port map(
        nibble1 => s2adder1Output,
        nibble2 => a33Output,
        sum     => s2adder2Output
    )
    
    b13multi: multi_inst port map(
        dataa => s2adder2Output,
        datab => B(1)(3),
        result => b13Output
    )
    
    s2adder3:adder port map(
        nibble1 => b13Output,
        nibble2 => b23Output,
        sum     => s2adder3Output
    )
    
    s2ff1: flipflop port map(
        d => s2adder2Output,
        clk => clk,
        en => dataReq,
        q=> ff31output
    )
    
    s2ff2: flipflop port map(
        d => ff31output,
        clk => clk,
        en => dataReq,
        q=> ff32output
    )
    
    a23multi: multi_inst port map(
        dataa => ff31output,
        datab => a(2)(3),
        result => a23Output
    )
    
    b23multi: multi_inst port map(
        dataa => ff31output,
        datab => B(2)(3),
        result => b23Output
    )
    
    a33multi: multi_inst port map(
        dataa => ff32output,
        datab => a(3)(3),
        result => a33Output
    )
    
    b33multi: multi_inst port map(
        dataa => ff32output,
        datab => B(3)(3),
        result => b33Output
    )
    
    s2adder4:adder port map(
        nibble1 => s2adder3Output,
        nibble2 => b33Output,
        sum     => audioSampleFiltered
    )
    
    
    
	
	if (rising_edge(clk)) then
		if (reset = ‘1’) then
			delayOutput <= (others => 0);
		elsif (dataReq = ‘1’) then
			delayOutput <= delayInput;
	end if;
end if;

end architecture arch;