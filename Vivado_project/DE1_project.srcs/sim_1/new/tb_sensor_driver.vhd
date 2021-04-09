----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2021 20:58:10
-- Design Name: 
-- Module Name: tb_sensor_driver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      testbench of sensor_driver.vhd
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


entity tb_sensor_driver is
-- empty
end tb_sensor_driver;

architecture Behavioral of tb_sensor_driver is
    
    -- local constants
    constant c_clk_period : time := 10 ns;
    -- local signals
    signal s_clk    : std_logic;
    signal s_rst    : std_logic;
    signal s_trigger: std_logic;
    signal s_echo   : std_logic;
    signal s_distance : std_logic_vector(7 downto 0);
    
begin
    uut_sensor_driver : entity work.sensor_driver
        port map(
            clk         =>  s_clk,
            rst         =>  s_rst,
            trigger_o   =>  s_trigger,
            echo_i      =>  s_echo,
            distance_o  =>  s_distance
         );
        ----------------------------------------------------------------------------------
        -- Clock generation
        ----------------------------------------------------------------------------------
        p_clk_gen : process
        begin
            while now <  1000 ms loop   -- 1 sec of simulation
                s_clk <= '0';
                wait for c_clk_period / 2;
                -- wait half period
                s_clk <= '1';
                wait for c_clk_period / 2;
                -- wait half period
            end loop;
        end process p_clk_gen;
        ----------------------------------------------------------------------------------
        -- Reset impuls generation
        ----------------------------------------------------------------------------------
        p_rst_gen : process
        begin
            s_rst <= '0'; wait for 200 ns;
            -- Reset activated
            s_rst <= '1'; wait for 500 ns;
            -- Reset deactivated
            s_rst <= '0';
            wait;
        end process p_rst_gen;
        ----------------------------------------------------------------------------------
        -- Sensor simulation
        ----------------------------------------------------------------------------------
        p_sensor_simulation : process
        begin
            s_echo <= '0';
            while now < 1000 ms loop -- 1 sec of simulation
                wait until rising_edge(s_trigger); -- rise of trigger
                wait until falling_edge(s_trigger);-- fall of trigger
                wait for 800 us; --tarry
                s_echo <= '1';
                wait for 1561 us; -- echo pulse width
                s_echo <= '0';  
            end loop;
        end process p_sensor_simulation;
        
end Behavioral;
