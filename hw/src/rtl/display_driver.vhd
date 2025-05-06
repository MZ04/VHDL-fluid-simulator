----------------------------------------------------------------------------------
-- Team: LedMatrixGroup
-- Engineer: 
-- 
-- Create Date: 03/13/2025 04:43:41 PM
-- Module Name: display_driver - Behavioral
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This is the display driver for the LED matrix. It takes a processed frame of 512 bits and sends it to the display matrix.
-- The processed frame is a 2D array of pixels, where each pixel is represented by 2 bits (red and green).
-- This module takes care of the timing and the data transfer to the display matrix.

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
    signal frame_buffer: std_logic_vector (511 downto 0) := (others => '0');
    signal buffer_drawn : std_logic := '1';
    type state is (
        idle,
        tbrf_tsesu,
        first_led,
        fill_row,
        end_row,
        tbrb,
        tcke,
        end_matrix
        );
    signal current_state : state := idle;
    signal pixel_index : integer := 0;
    signal row_index : integer := 0; 
    signal debug_count : integer := 0;
    begin
        
    -- Select is set as high since we are feeding the display with data
    select_out <= '1';
    
    -- New frame is displayed in the matrix
    process (clk_in, reset_in, frame_ready)
    begin
        -- Signals which are set by default
        clk_out <= '0'; 
        bright <= '0';
        reset_display <= '0';
        copy_done <= '0';

        if (frame_ready = '1' and buffer_drawn = '1') then 
            frame_buffer <= processed_frame;
            buffer_drawn <= '0';
            copy_done <= '1'; -- When the processed frame is copied in the buffer, the system that calculates the next frame is notified via copy_done
        end if;

        -- reset_in: needs to be asynchronous
        if (reset_in = '1') then
            current_state <= idle;
            buffer_drawn <= '1';
        end if;

        if (rising_edge(clk_in)) then
            case current_state is 

            -- idle: Initial state, waits for `buffer_drawn` to be '0' (meaning that it needs to be drawn)
            when idle => 
                debug_count <= 0;
                reset_display <= '1';
                if (buffer_drawn = '0') then
                    current_state <= tbrf_tsesu;
                end if; 

            -- Timing: Waits for Tbrf and Tsesu. Since Tbrf > Tsesu (by a lot) and they overlap, we only wait for Tbrf.
            when tbrf_tsesu => 
                debug_count <= debug_count + 1;
                if (debug_count = 140) then
                    current_state <= first_led;
                    debug_count <= 0;
                end if;

            -- first_led: Get the first pixel data of the current row to start the cycle
            when first_led => 
                    red_data <= frame_buffer((row_index * 32) + pixel_index);
                    green_data <= frame_buffer((row_index * 32) + pixel_index + 1);
                    pixel_index <= pixel_index + 2;
                    current_state <= fill_row;

            --- fill_row: Sends out the clock to the display matrix in order to make it read the current pixel data
            --- & on falling edge of the clock the next pixel data is fetched from the buffer
            when fill_row => 
                clk_out <= '1';
                if (pixel_index >= 32) then 
                    current_state <= end_row;
                    pixel_index <= 0;
                    row_index <= row_index + 1;
                end if; 

            -- end_row: at the end of each row it starts the timer Tbrb, and if the last row has been sent, it goes to end_matrix
            when end_row =>
                clk_out <= '1';
                if (row_index = 16) then 
                    current_state <= end_matrix;
                else 
                    current_state <= tbrb;
                end if; 

            -- Timing: Waits for Tbrb
            when tbrb => 
                debug_count <= debug_count + 1;
                if (debug_count = 88) then 
                    debug_count <= 0;
                    current_state <= tcke;
                end if;
            
            -- Timing: Waits for Tcke
            when tcke =>
                bright <= '1';
                debug_count <= debug_count + 1;
                if (debug_count = 99) then -- TODO: Insert value based on an estimation
                    debug_count <= 0;
                    current_state <= first_led;
                end if;

            -- end_matrix: set buffer drawn to '1', resets the row index and current state goes back to idle
            when end_matrix =>
                -- clk_out <= '1'; 
                current_state <= idle;
                buffer_drawn <= '1';
                row_index <= 0;
            end case;
        else 
            -- if in fill_row state, fetch the next pixel data and update the pixel index
            if (current_state = fill_row) then 
                    red_data <= frame_buffer((row_index * 32) + pixel_index);
                    green_data <= frame_buffer((row_index * 32) + pixel_index + 1);
                    pixel_index <= pixel_index + 2;
            end if;
        end if;
    end process;
    
end Behavioral;
