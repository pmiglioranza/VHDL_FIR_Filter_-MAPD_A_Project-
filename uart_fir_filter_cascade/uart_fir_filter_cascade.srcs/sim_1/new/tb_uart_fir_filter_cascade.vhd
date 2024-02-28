library IEEE;
use IEEE.std_logic_1164.all;

entity tb_uart_fir_filter_cascade is
end entity tb_uart_fir_filter_cascade;

architecture test of tb_uart_fir_filter_cascade is

    component top is
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
    end component top;

    signal clk   : std_logic := '1';
    signal rst   : std_logic := '0';
    signal sel_1 : std_logic := '0';
    signal sel_2 : std_logic := '0';
    signal sel_3 : std_logic := '0';
    signal y_in  : std_logic := '1';
    signal y_out : std_logic := '1';
    signal busy  : std_logic := '0';
    
    -- constant t : integer := 5;
    
    type t_inputs is array (0 to 7) of std_logic_vector(7  downto 0);
    signal inputs : t_inputs := (
        "00000100",
        "00000101",
        "00000110",
        "00000111",
        "00001000",
        "00001001",
        "00001010",
        "00001011"
        );
    
begin -- architecture test

    uut : top
		port map (
		    CLK100MHZ => clk,
		    rst => rst,
		    sel_1 => sel_1,
		    sel_2 => sel_2,
		    sel_3 => sel_3,
		    uart_txd_in => y_in,
		    busy => busy,
		    uart_rxd_out => y_out
		    );
               
    p_clk : process
    begin
        clk <= '1'; wait for 5 ns;
        clk <= '0'; wait for 5 ns;
    end process p_clk;
    
    p_rst : process
    begin
        -- bypass filter
        -- rst   <= '0';
        -- sel_1 <= '0';
        -- sel_2 <= '0';
        -- sel_3 <= '0';
        -- wait;
        rst   <= '0';
        sel_1 <= '0';
        sel_2 <= '0';
        sel_3 <= '0';
        wait for 8680 ns;        
        rst   <= '1';
        sel_1 <= '1';
        sel_2 <= '1';
        sel_3 <= '1';
        wait;
    end process p_rst;
    
    data : process
    begin
        for k in 0 to 2 loop
            for i in 0 to 7 loop
                y_in <= '1'; wait for 43400 ns; -- idle
                y_in <= '0'; wait for 8680 ns; -- start
                for j in 0 to 7 loop
                    y_in <= inputs(i)(j); wait for 8680 ns; -- bit j-th
                end loop;  
            end loop; 
        end loop;      
        y_in <= '1'; wait;              
    end process data;
        
end architecture test; 