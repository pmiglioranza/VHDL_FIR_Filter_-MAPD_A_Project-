
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fir_filter is
	port(
		clk       : in  std_logic;
		rst       : in  std_logic;
		valid_in  : in  std_logic;
		data_in   : in  std_logic_vector(7 downto 0);
		valid_out : out std_logic;
		data_out  : out std_logic_vector(7 downto 0) 
		);
end fir_filter;

architecture behavioural of fir_filter is

    constant n_taps  : integer := 4;
 
	type type_byte_array is array (0 to n_taps-1) of signed(7  downto 0);
	signal data_sequence : type_byte_array;
	
	signal data_sum      : signed(9 downto 0); 
	signal data_norm     : signed(9 downto 0);    

	
    type state_t is (idle, sum, norm, output);
	signal state : state_t := idle;

begin
	
	state_machine : process(clk) is
	begin
		if rst = '0' then
			data_sequence <= (others => (others => '0'));
		    data_sum <= (others => '0');
		    data_norm <= (others => '0');
			valid_out <= '0';
			-- bypass filter
			if valid_in = '1' then
                data_out <= data_in;
                valid_out <= '1';
            end if;        
        elsif rising_edge(clk) then
            case state is
                when idle =>
                	valid_out <= '0';
                    if valid_in = '1' then
                        state <= sum;
                    else
                        null;
                    end if;
                when sum =>
                    data_sum <= resize(signed(data_in), 10)
                    			- resize(data_sequence(n_taps-1), 10)
                    			+ resize(data_sum, 10);
                   	data_sequence <= signed(data_in) & data_sequence(0 to n_taps-2);
                    state <= norm;
                when norm =>            
                    data_norm <= data_sum/to_signed(n_taps, 10);
                    --data_norm <= data_sum srl 2;
                    state <= output;
                when output =>
                   	data_out <= std_logic_vector(data_norm(7 downto 0));
                   	valid_out <= '1';
                    state <= idle;
            end case;
        end if; -- rising edge
	end process state_machine;

end behavioural;