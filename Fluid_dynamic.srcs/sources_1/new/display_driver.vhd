----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2025 04:43:41 PM
-- Design Name: 
-- Module Name: display_driver - Behavioral
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

entity display_driver is
  Port (clk : in std_logic;
        frame : in std_logic_vector (511 downto 0);
        frame_ready : in std_logic;
        red_data : out std_logic;
        green_data : out std_logic;
        select_out : out std_logic;
        bright : out std_logic;
        reset_display : out std_logic
        );
end display_driver;

architecture Behavioral of display_driver is
    signal swapped : std_logic_vector (511 downto 0);
    signal display_ready : std_logic;
begin
                     
end Behavioral;
