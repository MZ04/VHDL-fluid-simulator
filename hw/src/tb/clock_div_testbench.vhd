----------------------------------------------------------------------------------
-- Team: LedMatrixGroup
-- Engineer: 
-- 
-- Create Date: 03/13/2025 04:43:41 PM
-- Module Name: display_driver - Behavioral
----------------------------------------------------------------------------------


library IEEE;
library xil_defaultlib;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_div_testbench is   
--  Port ( );
end clock_div_testbench;

architecture Behavioral of clock_div_testbench is
    signal clk_in : std_logic;
    signal clk_out : std_logic;
    signal reset : std_logic;
begin
     cd: entity xil_defaultlib.clock_divider port map (
        reset => reset,
        clk_in => clk_in,
        clk_out => clk_out
     );

    process
    begin
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        wait for 5 ns;
    
        while true loop
            clk_in <= '0';
            wait for 25 ns;
            clk_in <= '1';
            wait for 25 ns;
        end loop;
    end process;
end Behavioral;
