----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Pavel Vanek
-- 
-- Create Date: 07.04.2021 14:58:57
-- Design Name: sensor_driver.vhd
-- Module Name: sensor_driver - Behavioral
-- Project Name: DE1_project
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Driver for ultrasound distance sensor  HC-SR04.
--      Uses trigger pin to control the sensor. 
--      At the echo pin sensor gives a responce depending on the measured distance.
--      Output is 8bit unsigned decimal, evulating distance in cm

-- Dependencies: 
-- 
-- Revision:
-- Revision 1.0 - Final
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;



entity sensor_driver is
    Port (
        clk          : in std_logic;  -- 100MHz
        rst          : in std_logic;
        trigger_o    : out std_logic; --connect ECHO pin of sensor
        echo_i       : in std_logic; --connect ECHO pin of sensor 
        distance_o   : out std_logic_vector(7 downto 0) -- distance in cm; 8bits
        );
end sensor_driver;

architecture Behavioral of sensor_driver is
    -- define FSM states
    type t_state is (idle,
                     trig,
                     tarry,
                     counting,
                     fault);
    -- preseted signals are used in manner of simulation
    signal s_state              : t_state := idle; -- define actual state variable 
    signal s_counter            : integer := 980000; --preset for shorten first interval
    signal s_distance           : natural := 0; -- int for calculating distance
    
    -- Timing constants in ticks (clk tick = 10ns)
    constant c_idle_time        : integer := 1000000;  --(10ms) delay between measurings
    constant c_trigger_time     : integer := 10000;  --(100us) trigger time width
    constant c_fault_overtime   : integer := 200000;  --(2ms)fault state, if echo sig. didnt rise to this time
    constant c_max_echo_time    : integer := 19000000;  --(190ms) if is echo pulse longer than this >> too far obstacle
   
    
begin
    sensor_get_data : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                s_counter <= 0; --reset counter
                s_state <= idle; --set first FSM state
                trigger_o <= '0'; 
            end if; -- Reset
            
            -- Every clk tick rutines:
            -- increment counter every clk tick
            s_counter <= s_counter + 1;
            -- output actualise 
            distance_o <= std_logic_vector(to_unsigned(s_distance, 8));
            
            case s_state is
               when idle =>
               -- wait between measurements
                    -- count 20uS than move to next state
                    if (s_counter >= c_idle_time) then
                        s_counter <= 0;   -- reset counter
                        trigger_o <= '1'; -- trigger = HIGH
                        s_state <= trig;  -- change state
                    end if;  -- counter done
                    
               when trig =>
               -- set triger
                    if (s_counter > c_trigger_time) then
                        s_counter <= 0;   -- reset counter
                        trigger_o <= '0'; -- trigger = LOW
                        s_state <= tarry;  -- change state
                    end if;  -- trigger done
                    
               when tarry =>   
               -- wait for rise of echo pulse
                    if (echo_i = '1') then
                        s_counter <= 0;   -- reset counter
                        s_state <= counting;  -- change state
                    -- fault detection (disconnected sensor) if not respond
                    elsif (s_counter >= c_fault_overtime) then
                        s_state <= fault;
                        s_counter <= 0;   -- reset counter
                    end if;
               
               when counting =>
               -- wait for fall of echo pulse and count time
                    if (echo_i = '0') then
                        -- compute distance (in cm)
                        s_distance <= (s_counter+1)/5800;  
                        s_counter <= 0;   -- reset counter
                        s_state <= idle;  -- change state
                        -- output assigment
                        distance_o <= std_logic_vector(to_unsigned(s_distance, 8));
                    --  too far obstacle if echo pulse is too long
                    elsif (s_counter >= c_max_echo_time) then
                         s_state <= fault;
                         s_counter <= 0;   -- reset counter
                    end if;
                    
               when others =>  --in case of fault
               -- do this case in the case of too long echo pulse,
               -- or if echo pulse will not appear
               -- could be used for generating fault signal if needed
                   if (s_counter >= 2000) then
                        s_counter <= 0;   -- reset counter
                        s_state <= idle;  -- change state
                        -- in case of fault try again to send trigger
                   end if;
            end case; -- s_state
        end if; -- rising_edge(clk)
    end process sensor_get_data;
end Behavioral;