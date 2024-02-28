library IEEE;
use IEEE.std_logic_1164.all;

entity uart_receiver is
	port(
        clk           : in  std_logic;
		uart_rx       : in  std_logic;
		valid 		  : out std_logic;
		received_data : out std_logic_vector(7 downto 0)
		); 
end entity uart_receiver;

architecture rtl of uart_receiver is

	type state_t is (idle, start,
                     bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7); -- ,
                     -- stop); -- state machine signals
	signal state : state_t := idle;    
	signal baudrate : std_logic;
	signal received_data_s : std_logic_vector(7 downto 0);
        
	component sample_generator is
		port(
			clk          : in  std_logic;
			uart_rx      : in  std_logic;
			baudrate_out : out std_logic
			);
	end component sample_generator;
    
begin -- architecture rtl

	sampler_generator_1 : sample_generator
		port map(
		clk          => clk,
		uart_rx 	 => uart_rx,
		baudrate_out => baudrate
		);

    main : process(clk) is
	begin
        if rising_edge(clk) then
            case state is
                when idle =>
                    received_data_s <= (others => '0');
                    valid <= '0';
                    if uart_rx = '0' then
                        state <= start;
                    else
                        null;
                    end if;
                when start =>
                    if baudrate = '1' then
                        received_data_s(0) <= uart_rx;
                        state <= bit0;
                    else
                        null;
                    end if;
                when bit0 => 
                    if baudrate = '1' then
                        received_data_s(1) <= uart_rx;
                        state <= bit1;
                    else
                        null;
                    end if;
                when bit1 =>
                    if baudrate = '1' then
                        received_data_s(2) <= uart_rx;
                        state <= bit2;
                    else
                        null;
                    end if;
                when bit2 =>
                    if baudrate = '1' then
                        received_data_s(3) <= uart_rx;
                        state <= bit3;
                    else
                        null;
                    end if;
                when bit3 =>
                    if baudrate = '1' then
                        received_data_s(4) <= uart_rx;
                        state <= bit4;
                    else
                        null;
                    end if;
                when bit4 =>
                    if baudrate = '1' then
                        received_data_s(5) <= uart_rx;
                        state <= bit5;
                    else
                        null;
                    end if;
                when bit5 =>
                    if baudrate = '1' then
                        received_data_s(6) <= uart_rx;
                        state <= bit6;
                    else
                        null;
                    end if;
                when bit6 =>
                    if baudrate = '1' then
                        received_data_s(7) <= uart_rx;
                        state <= bit7;
                    else
                        null;
                    end if;
                when bit7 =>
                    if baudrate = '1' then
                        valid <= '1'; 
                        received_data <= received_data_s;
                        state <= idle; --stop;
                    else
                        null;
                    end if;
                -- when stop =>
                    -- if baudrate = '1' then
                        -- state <= idle;
                    -- else
                        -- null;
                    -- end if;                        
            end case;
        end if; -- rising edge
	end process main;
    
end architecture rtl;