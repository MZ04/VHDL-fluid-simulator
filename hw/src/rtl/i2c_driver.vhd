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

entity i2c_driver is
  Port (read : in std_logic;                  --Flags to impose the read / write action
        write : in std_logic;
        clk_in : in std_logic;                --Set to 400kHz, which is the frequency of the i2c communication
        slave_address_in : in std_logic(7 downto 0);            
        slave_address_out : out std_logic_vector(7 downto 0);  --Address of the device, regardless the type
        register_address_in : in std_logic(7 downto 0);
        register_address_out : out std_logic(7 downto 0);      --Register where the data is contained
        result : out signed; 
        
);
end i2c_driver;

architecture Behavioral of i2c_driver is
begin
end Behavioral;
