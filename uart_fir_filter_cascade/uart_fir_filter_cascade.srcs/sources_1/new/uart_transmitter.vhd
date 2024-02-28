library IEEE;
use IEEE.std_logic_1164.all;

entity uart_transmitter is
    port(
        clk          : in  std_logic;
        data_to_send : in  std_logic_vector(7 downto 0);
        valid 	     : in  std_logic;
		busy         : out std_logic;
        uart_tx      : out std_logic
        );   
end entity uart_transmitter;

architecture rtl of uart_transmitter is

    type state_t is (idle, data_valid, start,
                     bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7,
                     stop); -- state machine signals
	signal state : state_t := idle;   	 
	signal baudrate : std_logic;
       
	component baudrate_generator is
        port(    
            clk          : in  std_logic;
            baudrate_out : out std_logic
            );
	end component baudrate_generator;
    
begin -- architecture rtl

	baudrate_generator_1 : baudrate_generator
        port map(
            clk 		 => clk,
            baudrate_out => baudrate
            );

	main_state_machine : process(clk) is
	begin
        if rising_edge(clk) then
            case state is
                when idle =>
					busy    <= '0';
                    uart_tx <= '1';
                    if valid = '1' then
                        state <= data_valid;
                    else
                        null;
                    end if;
                when data_valid =>
                	busy <= '1';
                    uart_tx <= '1';
                    if baudrate = '1' then
                        state <= start;
                    else
                        null;
                    end if;
                when start =>
                    uart_tx <= '0';
                    if baudrate = '1' then
                        state <= bit0;
                    else
                        null;
                    end if;
                when bit0 =>
                    uart_tx <= data_to_send(0);
                    if baudrate = '1' then
                        state <= bit1;
                    else
                        null;
                    end if;
                when bit1 =>
                    uart_tx <= data_to_send(1);
                    if baudrate = '1' then
                        state <= bit2;
                    else
                        null;
                    end if;
                when bit2 =>
                    uart_tx <= data_to_send(2);
                    if baudrate = '1' then
                        state <= bit3;
                    else
                        null;
                    end if;
                when bit3 =>
                    uart_tx <= data_to_send(3);
                    if baudrate = '1' then
                        state <= bit4;
                    else
                        null;
                    end if;
                when bit4 =>
                    uart_tx <= data_to_send(4);
                    if baudrate = '1' then
                        state <= bit5;
                    else
                        null;
                    end if;
                when bit5 =>
                    uart_tx <= data_to_send(5);
                    if baudrate = '1' then
                        state <= bit6;
                    else
                        null;
                    end if;
                when bit6 =>
                    uart_tx <= data_to_send(6);
                    if baudrate = '1' then
                        state <= bit7;
                    else
                        null;
                    end if;
                when bit7 =>
                    uart_tx <= data_to_send(7);
                    if baudrate = '1' then
                        state <= stop;
                    else
                        null;
                    end if;
                when stop =>
                    uart_tx <= '1';
                    if baudrate = '1' then
                        state <= idle;
                    else
                        null;
                    end if;                        
            end case;
        end if; -- rising edge
	end process main_state_machine;
    
end architecture rtl;