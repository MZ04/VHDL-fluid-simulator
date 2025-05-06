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

entity display_driver_testbench is   
--  Port ( );
end display_driver_testbench;

architecture Structural of display_driver_testbench is
    signal clk_in, reset_in, frame_ready, copy_done: std_logic;
    signal red_data, green_data, select_out, reset_display, bright, clk_out : std_logic;
    signal processed_frame : std_logic_vector (511 downto 0);
begin
    dd: entity xil_defaultlib.display_driver port map (
        clk_in => clk_in,
        reset_in => reset_in,
        processed_frame => processed_frame,
        frame_ready => frame_ready,
        copy_done => copy_done,
        red_data => red_data,
        green_data => green_data,
        select_out => select_out,
        reset_display => reset_display,
        bright => bright,
        clk_out => clk_out
    );

    clock_process : process 
    begin 
        clk_in <= '1';
        wait for 25 ns;
        clk_in <= '0';
        wait for 25 ns;
    end process;

    reset_process : process
    begin 
        reset_in <= '1';
        wait for 100 ns;
        reset_in <= '0';
        wait;
    end process;

    set_processed_frame : process
        variable temp : std_logic_vector (511 downto 0);
    begin 
        for i in 0 to 255 loop
            temp(2*i) := '1';
            temp(2*i+1) := '0';
        end loop;
        
        processed_frame <= temp;
        wait;
    end process;

    set_frame_ready : process
    begin 
        frame_ready <= '0';
        wait for 100 ns;
        frame_ready <= '1';
        wait;
    end process;

end Structural;
