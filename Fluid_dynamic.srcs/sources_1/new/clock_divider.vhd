----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2025 05:28:24 PM
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
  generic(
        factor : integer := 2);
  Port (
        reset : in std_logic;
        clk_in : in std_logic;
        clk_out : out std_logic);
end clock_divider;

architecture Behavioral of clock_divider is
    signal count: integer := 1;
    signal tmp: std_logic;
begin
    process (clk_in, reset) 
    begin 
        if (reset = '1') then 
            tmp <= '0';
        elsif (rising_edge(clk_in)) then 
            count <= count + 1;
            if (count = factor) then  --Modifica valore a seconda delle necessità
                tmp <= not tmp;
                count <= '1';
            end if;
        end if;
        clk_out <= tmp;
    end process;
end Behavioral;
