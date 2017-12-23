library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity count_down is
	generic(tcount : natural :=0 ;
			N_bits : natural := 4);
	port(clk,en,srst,timeup,timedown: in std_logic;
		 sel : in std_logic_vector(1 downto 0);
		 tc : out std_logic;
		 green,red : out std_logic_vector(5 downto 0);
		 display0,display1,display2:out  std_logic_vector( 6 downto 0) ;
		 output,output2,output3 : out std_logic_vector(N_bits-1 downto 0);
		 slower_clk0,slower_clk1,slower_clk2  : BUFFER STD_LOGIC);
end count_down;

architecture arch of count_down is 
	signal count_out0,count_out1,count_out2 : std_logic_vector(N_bits-1 downto 0) := (others => '0');
	signal disp0: std_logic_vector( 6 downto 0) := "1100111";
	signal disp1: std_logic_vector( 6 downto 0) := "1100111";
	signal disp2: std_logic_vector( 6 downto 0) := "1100111";
	signal not_reset : std_logic := '1';
	signal temp,temp1: std_logic := '1';
	SIGNAL freq_ctr : INTEGER RANGE 0 TO 2**27-1 := 0;
	--signal temp_tc1,temp_tc2 : std_logic := '0';
  CONSTANT period_in_cycles: INTEGER RANGE 0 TO 2**27-1 := 50000000;
begin
output <= count_out0;
output2 <= count_out1;
output3 <= count_out2;
display0 <= not disp0;
display1 <= not disp1;
display2 <= not disp2;
--not_reset <= not srst;
process(clk,disp0,disp1,disp2,timeup,timedown,temp)
begin
	if rising_edge(clk) then
		
		tc <= '0';
		if freq_ctr = period_in_cycles - 1 then
			freq_ctr <= 0;
			if slower_clk0 = '0' then
				slower_clk0 <= '1';
			else
				slower_clk0 <= '0';
			end if;
			
			if  not srst ='1' then 
			count_out0 <= (others => '0');
			temp <= '1';
		
--		elsif count_out2 = "0000" then
--				if count_out1="0000" then
--					if count_out0 = "0000"  then
--					temp <= '0';
--				end if;
--			end if;
	
		elsif en='0' then
				if sel = "11" then
				if timeup = '0' then
					count_out0 <= count_out0 + '1';
				end if;
				if timedown = '0' then
					count_out0 <= count_out0 - '1';
				end if;
				end if;
			
		elsif en='1' then
			if count_out2 = "0000" then
				if count_out1 = "0000" then
					if temp = '1' then
						count_out0 <= count_out0 - '1';
						if count_out0 = "0000" then
							count_out0 <= "0000";
							temp <= '0';
						end if;
					end if;
				end if;
		end if;
		end if;
		else
			freq_ctr <= freq_ctr + 1;
		end if;
	
	end if;	
----------------------------------
-----end of counter1
-------------------------------
---start of counter 2
---------------------------------------
	
	if rising_edge(clk) then
	--temp<= '1';	
		tc <= '0';
		if freq_ctr = period_in_cycles - 1 then
			freq_ctr <= 0;
			if slower_clk1 = '0' then
				slower_clk1 <= '1';
			else
				slower_clk1 <= '0';
			end if;
			
			if  not srst ='1' then 
			count_out1 <= (others => '0');
			temp <='1';
		elsif count_out1 = "0000" then 
			if count_out2 = "0000" then
				if temp = '1' then
					count_out1 <= 	 "0101";
					tc <='1';
				end if;
			end if;
		elsif en='0' then
				if sel = "10" then 
				if timeup = '0' then
					count_out1 <= count_out1 + '1';
				end if;
				if timedown = '0' then
					count_out1 <= count_out1 - '1';
					
						
				end if;
				end if;
	
		elsif en='1' then
			if count_out2 = "0000" then -- working of middle ssd 
				if temp = '1' then
					count_out1 <= count_out1 - '1';
					if count_out1= "0000" then
						if count_out0 = "0000" then
							count_out1 <= "0000";
							temp <= '0';
						end if;
					end if;
				end if;
			end if;
		end if;
		else
			freq_ctr <= freq_ctr + 1;
		end if;
	
	end if;
------------------------------------
--end of counter 2
--start of counter 2
---------------------------
if rising_edge(clk) then
		--temp <= '1';
		tc <= '0';
		if freq_ctr = period_in_cycles - 1 then
			freq_ctr <= 0;
			if slower_clk2 = '0' then
				slower_clk2 <= '1';
			else
				slower_clk2 <= '0';
			end if;
		
			if  not srst ='1' then 
			count_out2 <= (others => '0');	
			elsif count_out2 = tcount then 
				if temp = '1' then
				count_out2 <= 	 "1001";
				tc <='1';	
				end if;
			elsif en='0' then
				if sel = "01" then 
				if timeup = '0' then
					count_out2 <= count_out2 + '1';
				end if;
				if timedown = '0' then
					count_out2 <= count_out2 - '1';
				end if;
				end if;
			elsif en= '1' then
				
				count_out2 <= count_out2 - '1';
				if count_out2 = "0000" then
						count_out2 <= "0000";
						--temp <= '0';
				end if;
			end if;
			else
			freq_ctr <= freq_ctr + 1;
		end if;
		
	end if;


end process;
Process(count_out0,count_out1,count_out2)
begin
if count_out0="0000" then
			if count_out1="0000" then
				if count_out2="0000" then
					red <="111111";
					green <="000000";
				else
					red <="000000";
					green   <="111111";
				end if;
			end if;
end if;	
if count_out0="0000" then
			if count_out1="0101" then
				--if count_out2="0000" then
					red <="111111";
					green <="000000";
				else
					red <="000000";
					green   <="111111";
				--end if;
			end if;
end if;	
end process;

BCD1: entity work.ssd_1
	port map (bcd =>  count_out0,
			seg_out => disp0);
BCD2: entity work.ssd_1
	port map (bcd =>  count_out1,
			seg_out1 => disp1);
BCD3: entity work.ssd_1
	port map (bcd =>  count_out2,
			seg_out => disp2);
end arch;