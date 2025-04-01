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
  Port (clk_in : in std_logic;
        reset_in : in std_logic;
        processed_frame : in std_logic_vector (511 downto 0);
        frame_ready : in std_logic;
        copy_done : out std_logic;
        red_data, green_data, select_out, reset_display, bright, clk_out : out std_logic
        );
end display_driver;

architecture Behavioral of display_driver is
    signal frame_buffer: std_logic_vector (511 downto 0);
    signal buffer_drawn : std_logic;
    type state is (
        idle,
        tbrf_tsesu,
        first_led,
        fill_row,
        add_clock,
        tbrb,
        tcke,
        add_clock_2
    );
    begin
        
    -- Select is set as high since we are feeding the display with data    
    select_out <= '1';

    -- New frame is loaded in the buffer
    process (frame_ready, buffer_drawn)
    begin
        if (frame_ready = '1' and buffer_drawn = '0') then 
            frame_buffer <= processed_frame;
            buffer_drawn <= '1';
            copy_done <= '1'; -- When the processed frame is copied in the buffer the system that calculates the following frame is notified
        end if;
    end process;
    
    --New frame is displayed in the matrix
    process (clk_in, reset_in)
        variable debug_count : integer := 0;
        variable pixel_count : integer := 0;
        variable row_count : integer := 0; 
        variable current_state : state := idle;
    begin
        --Signals which are set by default
        clk_out <= '0'; 
        bright <= '0';
        reset_display <= '0';

        --reset_in needs to be asynchronous
        if (reset_in = '1') then
            current_state := idle;
            buffer_drawn <= '0';
        end if;


        if (rising_edge(clk_in)) then
            case current_state is 
            when idle => --Initial state
                debug_count := 0;
                reset_display <= '1';
                if (buffer_drawn = '1') then
                    current_state := tbrf_tsesu;
                end if; 

            when tbrf_tsesu => --Defined for   
                debug_count := debug_count + 1;
                if (debug_count = 140) then
                    current_state := first_led;
                    debug_count := 0;
                end if;

            when first_led =>
                red_data <= frame_buffer((row_count * 32) + pixel_count);
                green_data <= frame_buffer((row_count * 32) + pixel_count + 1);
                pixel_count := pixel_count + 2;
                current_state := fill_row;

            when fill_row => 
                clk_out <= '1';
                if (pixel_count > 28) then 
                    current_state := add_clock;
                    pixel_count := 0;
                end if; 

            when add_clock =>
                clk_out <= '1';
                row_count := row_count + 1;
                if (row_count = 16) then 
                    current_state := add_clock_2;
                else 
                    current_state := tbrb;
                end if; 

            when tbrb => 
                debug_count := debug_count + 1;
                if (debug_count = 88) then 
                    debug_count := 0;
                    current_state := tcke;
                end if;

            when tcke =>
                bright <= '1';
                debug_count := debug_count + 1;
                if (debug_count = 99) then -- TODO: Insert value based on an estimation
                    debug_count := 0;
                    current_state := idle;
                end if;

            when add_clock_2 =>
                clk_out <= '1';
                current_state := idle;
            end case;
        else 
            if (current_state = fill_row) then 
                red_data <= frame_buffer((row_count * 16) + pixel_count);
                green_data <= frame_buffer((row_count * 16) + pixel_count + 1);
                pixel_count := pixel_count + 2;
            end if;
        end if;    
    end process;
    
end Behavioral;
