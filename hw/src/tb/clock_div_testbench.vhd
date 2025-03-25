----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2025 05:41:43 PM
-- Design Name: 
-- Module Name: clock_div_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
library xil_defaultlib;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
