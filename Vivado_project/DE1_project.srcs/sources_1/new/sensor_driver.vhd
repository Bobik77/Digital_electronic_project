----------------------------------------------------------------------------------
-- Company: 
-- Engineer: OK3PVL
-- 
-- Create Date: 07.04.2021 14:58:57
-- Design Name: sensor_driver.vhd
-- Module Name: sensor_driver - Behavioral
-- Project Name: DE1_project
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Driver for distance sensor HC-SR04,

-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;



entity sensor_driver is
    Port (
        clk     : in std_logic;  -- 100MHz
        rst     : in std_logic;
        trigger_o : out std_logic; --connect ECHO pin of sensor
        echo_i    : in std_logic; --connect ECHO pin of sensor 
        distance_o: out std_logic_vector(7 downto 0) -- distance in cm; 8bits
        );
end sensor_driver;

architecture Behavioral of sensor_driver is
    -- define FSM states
    type t_state is (idle,
                   trig,
                   tarry,
                   counting,
                   fault);
    signal s_state : t_state := idle; -- define actual state variable 
    signal s_counter : integer := 980000; --preset for shorten first interval
    signal s_distance : std_logic_vector(7 downto 0);
    
    -- Timing constants in ticks (clk tick = 10ns)
    constant c_idle_time : integer := 1000000;  --(10ms) delay between measurings
    constant c_trigger_time : integer := 10000;  --(100us) trigger time width
    constant c_fault_overtime : integer := 200000;  --(2ms)fault state, if echo sig. didnt rise to this time
    constant c_max_echo_time : integer := 19000000;  --(190ms) if is echo pulse longer than this >> too far obstacle
    
begin
    sensor_get_data : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                s_counter <= 0;
                s_state <= idle;
                trigger_o <= '0'; 
            end if; -- Reset
            -- increment counter every clk tick
            s_counter <= s_counter + 1;
            
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
                        trigger_o <= '0'; -- trigger = HIGH
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
                    end if;
               
               when counting =>
               -- wait for fall of echo pulse and count time
                    if (echo_i = '0') then
                        -- do one tick correctio
                        s_counter <= s_counter + 1;
                        -- todo translation to output 
                        distance_o <= "11111111";
                        s_counter <= 0;   -- reset counter
                        s_state <= idle;  -- change state
                    --  too far obstacle if not respond for 190ms
                    elsif (s_counter >= c_max_echo_time) then
                        s_state <= fault;
                    end if;
                    
               when fault =>
                    distance_o <= "00000000"; -- set output to disabled status
                    s_counter <= 0;   -- reset counter
                    s_state <= idle;  -- change state
                    -- in case of fault try again to send trigger
 
            end case;
                
        end if; -- Rising edge
    end process sensor_get_data;
end Behavioral;
