library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity audiofilter_tb is
end entity audiofilter_tb;

ARCHITECTURE test OF audiofilter_tb IS

component audiofilter is
	port (
		clk : in std_logic;
		reset : in std_logic;
		audioSample : in signed(35 downto 0);
		dataReq : in std_logic;
		audioSampleFiltered : out signed(35 downto 0)
	);
end component;

	signal clk_tb 				  : std_logic;
	signal reset_tb 			  : std_logic;
	signal dataReq_tb			  : std_logic;
	signal audioSample_tb 		  : signed(35 downto 0);
	signal audioSampleFiltered_tb : signed(35 downto 0);
	
	signal period : time := 20 ns;
    
   signal audioSample_w : signed  (71 downto 0);
	
	type audArray is array (39 downto 0) of signed(35 downto 0);
	
	signal audioSampleArray : audArray;
	
	begin
	
	uut: audiofilter
		port map(
			clk => clk_tb,
			reset => reset_tb,
			dataReq => dataReq_tb,
			audioSample => audioSample_tb,
			audioSampleFiltered => audioSampleFiltered_tb
			);
	
	clk_tb <= '0';
	clk_tb <= not clk_tb after period/2;
    audioSample_w <= (audioSample_tb & audioSample_tb);
    
	stimulus : process is
		file read_file : text open read_mode is "./src/verification_src/one_cycle_integer.csv";
		file results_file : text open write_mode is "./src/verification_src/output_waveform.csv";
		variable lineIn : line;
		variable lineOut : line;
		variable readValue : integer;
		variable writeValue : integer;
		begin
		
		wait for 100 ns;
		reset_tb <= '0';
		-- Read data from file into an array
        for i in 0 to 39 loop
            readline(read_file, lineIn);
            read(lineIn, readValue);
            audioSampleArray(i) <= to_signed(readValue, 16);
            wait for 50 ns;
        end loop;
        file_close(read_file);
		-- Apply the test data and put the result into an output file
		for i in 1 to 100 loop
			for j in 0 to 39 loop
                wait for 20000 ns;
                audioSample_tb <= audioSampleArray(i);
                audioSampleFiltered_tb <= audioSample_w (35 downto 0);
                audioSampleArray(i) <= to_signed(readValue, 16);
                wait for 50 ns;
                dataReq_tb <= '1';
                wait for 20 ns;
                dataReq_tb <= '0';
				-- Your code here...
				-- Write filter output to file
				writeValue := to_integer(audioSampleFiltered_tb);
				write(lineOut, writeValue);
				writeline(results_file, lineOut);
				-- Your code here...
			end loop;
		end loop;
		file_close(results_file);
		-- end simulation
	--	sim_done <= true;
		wait for 100 ns;
		-- last wait statement needs to be here to prevent the process
		-- sequence from re starting at the beginning
		wait;
	end process stimulus;

end architecture;
	
	