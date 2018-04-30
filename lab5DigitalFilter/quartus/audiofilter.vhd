library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity audiofilter is
	port (
		clk : in std_logic;
		reset : in std_logic;
		audioSample : in signed(31 downto 0);
		dataReq : in std_logic;
		audioSampleFiltered : out signed(31 downto 0)
	);
end entity;

architecture arch of audiofilter is
-- Signal declarations
	signal filterInOneChannel : signed(15 downto 0) := (others => '0');
	signal filterInResized : signed(35 downto 0) := (others => '0');
	signal filterSection_1in : signed(35 downto 0) := (others => '0');
	signal filterOutput : signed(35 downto 0) := (others => '0');

	signal s1Output : signed(35 downto 0) := (others => '0');
	signal b1input : signed(35 downto 0) := (others => '0');
	signal b12input : signed(35 downto 0):= (others => '0');
	signal b1Output : signed(35 downto 0):= (others => '0');
	signal ab2Output : signed(35 downto 0):= (others => '0');

	signal ff21output : signed(35 downto 0):= (others => '0');
	signal ff22output : signed(35 downto 0):= (others => '0');

	signal ff31output : signed(35 downto 0):= (others => '0');
	signal ff32output : signed(35 downto 0):= (others => '0');

	signal s2adder1Output : signed(35 downto 0):= (others => '0');
	signal s2adder2Output : signed(35 downto 0):= (others => '0');
	signal s2adder3Output : signed(35 downto 0):= (others => '0');

	signal badder2output : signed(35 downto 0):= (others => '0');
	
	signal b2Output : signed(35 downto 0):= (others => '0');
	signal b11Output : signed(35 downto 0):= (others => '0');
	signal b12Output : signed(35 downto 0):= (others => '0');
	signal b13Output : signed(35 downto 0):= (others => '0');
	signal b21Output : signed(35 downto 0):= (others => '0');
	signal b22Output : signed(35 downto 0):= (others => '0');
	signal b23Output : signed(35 downto 0):= (others => '0');
	signal b32Output : signed(35 downto 0):= (others => '0');
	signal b33Output : signed(35 downto 0):= (others => '0');
	
	signal  b2OutputFull : signed(71 downto 0):= (others => '0');
	signal b11OutputFull : signed(71 downto 0):= (others => '0');
	signal b12OutputFull : signed(71 downto 0):= (others => '0');
	signal b13OutputFull : signed(71 downto 0):= (others => '0');
	signal b21OutputFull : signed(71 downto 0):= (others => '0');
	signal b22OutputFull : signed(71 downto 0):= (others => '0');
	signal b23OutputFull : signed(71 downto 0):= (others => '0');
	signal b32OutputFull : signed(71 downto 0):= (others => '0');
	signal b33OutputFull : signed(71 downto 0):= (others => '0');

	signal a2Output : signed(35 downto 0):= (others => '0');
	signal a22Output : signed(35 downto 0):= (others => '0');
	signal a23Output : signed(35 downto 0):= (others => '0');
	signal a32Output : signed(35 downto 0):= (others => '0');
	signal a33Output : signed(35 downto 0):= (others => '0');
	
	signal s24sum : signed(35 downto 0):= (others => '0');
	
	signal a2OutputFull :  signed(71 downto 0):= (others => '0');
	signal a22OutputFull : signed(71 downto 0):= (others => '0');
	signal a23OutputFull : signed(71 downto 0):= (others => '0');
	signal a32OutputFull : signed(71 downto 0):= (others => '0');
	signal a33OutputFull : signed(71 downto 0):= (others => '0');

	signal sec1Output : signed(35 downto 0):= (others => '0');
	signal sec1       : signed(35 downto 0):= (others => '0');
	signal sec2       : signed(35 downto 0):= (others => '0');


	--constant declarations
	--constant B11 : signed(35 downto 0) := x"000000E45";
	constant B11 : signed(35 downto 0) := x"0000001B7"; --.0033507
	constant B21 : signed(35 downto 0) := x"0000001B7"; -- .0033507
	constant A21 : signed(35 downto 0) := x"FFFFE2E14";-- -.91 C
	constant B31 : signed(35 downto 0) := (others => '0');
	--constant A21 : signed(35 downto 0) := x"0000E2E14";-- -.91 C
	
	constant A31 : signed(35 downto 0) := (others => '0');
	
	
	constant B12 : signed(35 downto 0) := x"00000015B"; --.0026446 to 347
	constant B22 : signed(35 downto 0) := x"0000002B5"; -- .00529893 to 693
	constant B32 : signed(35 downto 0) := x"00000015B"; --.0026446
	constant A22 : signed(35 downto 0) := x"FFFFC2155";-- -1.9349
	constant A32 : signed(35 downto 0) := x"00001E316";-- .94353 to 123671
	
	constant B13 : signed(35 downto 0) := x"00000800A"; --.25008
	constant B23 : signed(35 downto 0) := x"000010014"; -- .50015 to 65555
	constant B33 : signed(35 downto 0) := x"00000800A"; --.25008 to 327793 C
    constant A23 : signed(35 downto 0) := x"FFFFC4C98";-- -1.8504 to 242536
	constant A33 : signed(35 downto 0) := x"00001B79C";-- .85861 TO 1122540

	
	--circles are adders, triangles are multipliers

	component filter_mult is
	port (
			dataa	 : in signed (35 downto 0);
			datab	 : in signed (35 downto 0);
			result : out signed  (71 downto 0)	 
		);
	end component;

	component adder is
		port
		(
			nibble1, nibble2 : in signed(35 downto 0); 
			aOrS 			 : in std_logic;
			sum       		 : out signed(35 downto 0)
		);
	end component;
	
	component flipflop is
	port ( d      : in signed(35 downto 0);
		 clk,en, reset : in std_logic;
	   q 		  : out signed(35 downto 0)
);
	end component;

	begin
	-- s(1)multi : filter_mult port map(
		-- dataa => audioSample,
		-- datab => 
		-- result => s1Output);
		--done with filterSection_1in
	
        
    --sec1
    
	s1adder: adder port map(
		nibble1 => filterSection_1in,
		nibble2 => a2Output,
		aOrS => '1',
		sum => b1input
		--carry_out=> null
	);
	
	b11multi: filter_mult port map(
		dataa => b1input,
		datab => B11,
		result => b11OutputFull
	);
	
	badder: adder port map(
		nibble1 => b1Output,
		nibble2 => b21Output,
		aOrS => '0',
		sum => sec1
		);
		
	sec1ff1: flipflop  port map(
		clk => clk,
		d => b1input,
		en => dataReq,
		reset => reset,
		q => ab2Output
	);
	b21multi: filter_mult port map(
		dataa => ab2Output,
		datab => B21,
		result => b21OutputFull
	);
	a21multi: filter_mult port map(
		dataa => ab2Output,
		datab => A21,
		result => a2OutputFull
	);
    
    --sec1.5
    
    s15adder: adder port map(
        nibble1 => sec1,
        nibble2 => a22Output,
		aOrS => '1',
        sum => sec1Output
    );
    
    s12adder: adder port map(
        nibble1 => sec1Output,
        nibble2 => a32Output,
		aOrS => '1',
        sum     => b12input
    );
    
    b12multi: filter_mult port map(
    	dataa => b12input,
		datab => B12,
		result => b12OutputFull
    );
    
    badder2: adder port map(
        nibble1 => b12Output,
        nibble2 => b22Output,
		aOrS => '0',
        sum     => badder2output
    );
    
    badder3: adder port map(
        nibble1 => badder2output,
        nibble2 => b32Output,
		aOrS => '0',
        sum     => sec2
    );
    
    b22multi: filter_mult port map(
    	dataa => ff21output,
		datab => B22,
		result => b22OutputFull
    );
    
    a22multi: filter_mult port map(
    	dataa => ff21output,
		datab => A22,
		result => a22OutputFull
    );
    
    a32multi: filter_mult port map(
    	dataa => ff22output,
		datab => A32,
		result => a32OutputFull
    );
    
    b32multi: filter_mult port map(
    	dataa => ff22output,
		datab => B32,
		result => b32OutputFull
    );
    
    s1ff1 :flipflop port map(
        d => b12input,
        clk => clk,
        en => dataReq,
		  reset => reset,
        q => ff21output
    );

    s1ff2 :flipflop port map(
        d => ff21output,
        clk => clk,
		 reset => reset,
        en => dataReq,
        q => ff22output
    );
    
    --section 2
    
    s2adder1: adder port map(
        nibble1 => sec2,
        nibble2 => a23Output,
		aOrS => '1',
        sum     => s2adder1Output
    );
    
    s2adder2: adder port map(
        nibble1 => s2adder1Output,
        nibble2 => a33Output,
		aOrS => '1',
        sum     => s2adder2Output
    );
    
    b13multi: filter_mult port map(
        dataa => s2adder2Output,
        datab => B13,
        result => b13OutputFull
    );
    
    s2adder3:adder port map(
        nibble1 => b13Output,
        nibble2 => b23Output,
		aOrS => '0',
        sum     => s2adder3Output
    );
    
    s2ff1: flipflop port map(
        d => s2adder2Output,
        clk => clk,
        en => dataReq,
		  reset => reset,
        q=> ff31output
    );
    
    s2ff2: flipflop port map(
        d => ff31output,
        clk => clk,
		  reset => reset,
        en => dataReq,
        q=> ff32output
    );
    
    a23multi: filter_mult port map(
        dataa => ff31output,
        datab => A23,
        result => a23OutputFull
    );
    
    b23multi: filter_mult port map(
        dataa => ff31output,
        datab => B23,
        result => b23OutputFull
    );
    
    a33multi: filter_mult port map(
        dataa => ff32output,
        datab => A33,
        result => a33OutputFull
    );
    
    b33multi: filter_mult port map(
        dataa => ff32output,
        datab => B33,
        result => b33OutputFull
    );
    
    s2adder4:adder port map(
        nibble1 => s2adder3Output,
        nibble2 => b33Output,
		aOrS => '0',
        sum     => s24sum
    );
--	begin
	 filterInOneChannel <= audioSample(15 downto 0);
        
       --Simply resize the 16 bit input to 36 bits. There is an implied
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
        audioSampleFiltered <= (filterOutput(15 downto 0) & filterOutput(15 downto 0));
    
    -- process (clk, reset) is
    -- begin
    -- if (reset = '1') then
        -- --audioSampleFiltered <= (others => '0');
        -- b2Output            <= (others => '0');
        -- b11Output           <= (others => '0');
        -- b12Output           <= (others => '0');
        -- b13Output           <= (others => '0');
        -- b21Output           <= (others => '0');
        -- b22Output           <= (others => '0');
        -- b23Output           <= (others => '0');
        -- b32Output           <= (others => '0');
        -- b33Output           <= (others => '0');
                               
         -- a2Output           <= (others => '0');
        -- a22Output           <= (others => '0');
        -- a23Output           <= (others => '0');
        -- a32Output           <= (others => '0');
        -- a33Output           <= (others => '0');
        
        -- --filterInOneChannel <= (others => '0');
        -- --filterInResized <= (others => '0');
        -- --filterSection_1in <= (others => '0');
        -- --audioSampleFiltered<= (others => '0');
    -- END IF;
    
        filterOutput <= s24sum (35 downto 0);
        --b2Output <= b2OutputFull(52 downto 17);
        b11Output <= b11OutputFull(52 downto 17);
        b12Output <= b12OutputFull(52 downto 17);
        b13Output <= b13OutputFull(52 downto 17);
        b21Output <= b21OutputFull(52 downto 17);
        b22Output <= b22OutputFull(52 downto 17);
        b23Output <= b23OutputFull(52 downto 17);
        b32Output <= b32OutputFull(52 downto 17);
        b33Output <= b33OutputFull(52 downto 17);
        
         a2Output <= a2OutputFull(52 downto 17);
        a22Output <= a22OutputFull(52 downto 17);
        a23Output <= a23OutputFull(52 downto 17);
        a32Output <= a32OutputFull(52 downto 17);
        a33Output <= a33OutputFull(52 downto 17);
        
       
	
    --end if;
    --end process;
	

	
	
	
end architecture arch;