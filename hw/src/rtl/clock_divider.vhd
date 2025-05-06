----------------------------------------------------------------------------------
-- Team: LedMatrixGroup
-- Engineer: 
-- 
-- Create Date: 03/13/2025 04:43:41 PM
-- Module Name: display_driver - Behavioral
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
  generic(
        factor : integer := 1);
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
                count <= 1;
            end if;
        end if;
        clk_out <= tmp;
    end process;
end Behavioral;
