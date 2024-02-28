library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sample_generator is
    port(
        clk			 : in  std_logic;
		uart_rx 	 : in  std_logic;
		baudrate_out : out std_logic
		);
end entity sample_generator;

architecture rtl of sample_generator is 

    type state_t is (idle, start);
    signal state : state_t := idle;   	 

    signal counter               : unsigned(9 downto 0) := (others => '0');
    signal delay_counter         : unsigned(9 downto 0) := (others => '0');
    signal state_machine_counter : unsigned(9 downto 0) := (others => '0');
    
    signal pulse_out      : std_logic;
    signal enable_counter : std_logic := '0';
    signal enable_delay   : std_logic := '0';

begin -- architecture rtl
	
    pulse_generator : process(clk) is
    begin
        if rising_edge(clk) then
            if enable_counter = '1' then
                counter <= counter + 1;
            if counter = 867 then
                pulse_out <= '1';
                counter <= (others => '0');
            else
                pulse_out <= '0';
            end if;
            else
                counter <= (others => '0');
                pulse_out <= '0';
            end if; -- enable counter
        end if; -- rising edge
    end process pulse_generator;

	delay_line : process(clk) is
	begin
        if rising_edge(clk) then   
            if pulse_out = '1' then
                enable_delay <= '1'; -- start count
            end if;
            if enable_delay = '1' then
                delay_counter <= delay_counter + 1;
            else
                delay_counter <= (others => '0');
            end if;    
            if delay_counter = 433 then
                baudrate_out <= '1';
                enable_delay <= '0'; -- end count
            else
                baudrate_out <= '0';
            end if;     
        end if; -- rising edge
	end process delay_line;

	state_machine : process(clk) is
	begin
		if rising_edge(clk) then
			case state is
                when idle =>
				    enable_counter <= '0';
				    if uart_rx = '0' then
				        state <= start;
				        state_machine_counter <= (others => '0');
				    else
				        null;
				    end if;
				when start =>
				    enable_counter <= '1';
				    if pulse_out = '1' then
				        state_machine_counter <= state_machine_counter + 1;
				        if state_machine_counter = 8 then -- 9 then
							state <= idle;
				            state_machine_counter <= (others => '0');
				        end if;
				    else
						null;
				    end if;
            end case;
		end if; -- rising edge
	end process state_machine;

end architecture rtl;