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
        reset_in : in std_logic;
        processed_frame : in std_logic_vector (511 downto 0);
        frame_ready : in std_logic;
        copy_done : out std_logic;
        red_data, green_data, select_out, reset_display, bright : out std_logic
        );
end display_driver;

architecture Behavioral of display_driver is
    signal frame_buffer: std_logic_vector (511 downto 0);
    signal buffer_available : std_logic;
begin
    -- The code is designed to ignore the select signal
    select_out <= '0';
    
    -- Reset is handled by the external system 
    reset_display <= reset_in;
    
    -- New frame is loaded in the buffer
    process (frame_ready, buffer_available)
    begin
        if (frame_ready = '1' and buffer_available = '1') then 
            frame_buffer <= processed_frame;
            buffer_available <= '0';
            copy_done <= '1'; -- When the processed frame is copied in the buffer the system that calculates the following frame is notified
        end if;
    end process;
    
    --New frame is displayed in the matrix
    process (buffer_available, clk)
        variable count : integer := 0;
    begin
        if (buffer_available = '0') then 
            if (rising_edge(clk)) then 
                if (count < 512) then 
                    red_data <= frame_buffer (count);
                    green_data <= frame_buffer (count + 1);
                    count := count + 2;
                else 
                    count := 0;
                    buffer_available <= '1';
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
