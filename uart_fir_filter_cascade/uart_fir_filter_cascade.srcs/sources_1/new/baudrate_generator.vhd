library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity baudrate_generator is
    port(    
        clk          : in  std_logic;
        baudrate_out : out std_logic
        );    
end entity baudrate_generator;

architecture rtl of baudrate_generator is 

    signal counter : unsigned(9 downto 0) := (others => '0');

begin -- architecture rtl

    main : process(clk) is
    begin -- process main	
        if rising_edge(clk) then
            counter <= counter + 1;
            if counter =  867 then
                baudrate_out <= '1';
                counter <= (others => '0');
            else 
                baudrate_out <= '0';
            end if;
        end if; -- rising edge
    end process main;

end architecture rtl;