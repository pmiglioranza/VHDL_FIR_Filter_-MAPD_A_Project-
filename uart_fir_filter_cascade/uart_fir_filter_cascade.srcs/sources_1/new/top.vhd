library IEEE;
use IEEE.std_logic_1164.all;

entity top is
	port(
 		CLK100MHZ    : in  std_logic;
 		rst          : in  std_logic;
 		sel_1        : in  std_logic;
 		sel_2        : in  std_logic;
 		sel_3        : in  std_logic;
        uart_txd_in  : in  std_logic;
        busy         : out std_logic;
        uart_rxd_out : out std_logic
        );
end entity top;

architecture rtl of top is

    signal clk            : std_logic;
    
    signal data_to_send   : std_logic_vector(7 downto 0);
    signal data_1	  	  : std_logic_vector(7 downto 0);
    signal data_2	  	  : std_logic_vector(7 downto 0);
    signal data_3	  	  : std_logic_vector(7 downto 0);
    signal filtered_data  : std_logic_vector(7 downto 0);
    
    signal data_valid_in  : std_logic;
    signal valid_1  	  : std_logic;
    signal valid_2  	  : std_logic;
    signal valid_3        : std_logic;
    signal data_valid_out : std_logic;
    
    signal uart_tx        : std_logic;
  
	component uart_receiver is
		port(
			clk           : in  std_logic;
			uart_rx       : in  std_logic;
			valid         : out std_logic;
			received_data : out std_logic_vector(7 downto 0)
			); 
    end component uart_receiver;
    
    component fir_filter is
        port(
            clk       : in  std_logic;
            rst       : in  std_logic;
            valid_in  : in  std_logic;
            data_in   : in  std_logic_vector(7 downto 0);
            valid_out : out  std_logic;
            data_out  : out std_logic_vector(7 downto 0)
            ); 
    end component fir_filter;

    component uart_transmitter is
		port(
			clk          : in  std_logic;
			data_to_send : in  std_logic_vector(7 downto 0);
			valid 		 : in  std_logic;
			busy         : out std_logic;
			uart_tx      : out std_logic
			); 
    end component uart_transmitter;

begin -- architecture rtl

    uart_receiver_1 : uart_receiver
        port map(
            clk           => CLK100MHZ,
            uart_rx       => uart_txd_in,
            valid         => data_valid_in,
            received_data => data_to_send
            );
            
    fir_filter_0 : fir_filter
        port map(
            clk       => CLK100MHZ,
            rst       => rst,
            valid_in  => data_valid_in,
            data_in   => data_to_send,
            valid_out => valid_1,
            data_out  => data_1
            );
            
    fir_filter_1 : fir_filter
        port map(
            clk       => CLK100MHZ,
            rst       => sel_1,
            valid_in  => valid_1,
            data_in   => data_1,
            valid_out => valid_2,
            data_out  => data_2
            );
    
    fir_filter_2 : fir_filter
        port map(
            clk       => CLK100MHZ,
            rst       => sel_2,
            valid_in  => valid_2,
            data_in   => data_2,
            valid_out => valid_3,
            data_out  => data_3
            );
            
    fir_filter_3 : fir_filter
        port map(
            clk       => CLK100MHZ,
            rst       => sel_3,
            valid_in  => valid_3,
            data_in   => data_3,
            valid_out => data_valid_out,
            data_out  => filtered_data
            );
      
    uart_transmitter_1 : uart_transmitter
        port map(
		    clk          => CLK100MHZ,
		    data_to_send => filtered_data,
		    valid        => data_valid_out,
			busy         => busy,
		    uart_tx      => uart_rxd_out
		    );

end architecture rtl;