----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Turák Samuel
-- 
-- Create Date: 04/10/2021 02:56:28 PM
-- Design Name: sound_logic.vhd
-- Module Name: sound_logic - Behavioral
-- Project Name: DE1 Project
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      This module cuts the input from pwm.vhd by a logic,
--      that has it's 3b input ftom the control unit. 
--      It provides the peeping in the sound driver

-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity sound_logic is
    Port (
        clk       : in std_logic; -- clock signal
        state     : in std_logic_vector(3 - 1 downto 0); -- 3 bit input that describes the nearness of a object
        sound_in  : in std_logic; -- input sound, pwm in the project
        sound_out : out std_logic -- output will be a cut version of the input
       );
       
end sound_logic;

architecture Behavioral of sound_logic is
        signal s_cnt_local : natural;
        signal on_state : std_logic; -- 
        
    begin
    
        -- this process cuts the input signal 
        logic: process (clk)
        begin
            if rising_edge(clk) then
                s_cnt_local <= s_cnt_local +1;
                
                case state is
                    when "000" =>                         -- nearest state
                        on_state <= '0';                  -- does not peep
                    when "001" => 
                        if (s_cnt_local > 50000000) then    -- peeps 500 ms and stays quiet 500 ms
                            s_cnt_local <= 0;
                            on_state <= not on_state;           -- the switch
                        end if;
                    when "010" =>
                        if (s_cnt_local > 30000000) then        -- peeps 300 ms and stays quiet 300 ms
                            s_cnt_local <= 0;
                            on_state <= not on_state;
                        end if;
                    when "011" =>
                        if (s_cnt_local > 30000000) then         -- peeps 300 ms and stays quiet 300 ms
                            s_cnt_local <= 0;
                            on_state <= not on_state;
                        end if;
                    when "100" =>
                        if (s_cnt_local > 20000000) then         -- peeps 200 ms and stays quiet 200 ms
                            s_cnt_local <= 0;
                            on_state <= not on_state;
                        end if;
                    when "101" =>
                        if (s_cnt_local > 20000000) then         -- peeps 200 ms and stays quiet 200 ms
                            s_cnt_local <= 0;
                            on_state <= not on_state;
                        end if;
                    when "110" =>
                        if (s_cnt_local > 10000000) then         -- peeps 100 ms and stays quiet 100 ms
                            s_cnt_local <= 0;
                            on_state <= not on_state;
                        end if;
                    when others =>                          -- farthest state
                    on_state <= '1';                        -- peeps all the time
                            
                end case;
            end if;
        end process logic;
    
        -- we assign our output depending the on_state variable in this process
        define: process (clk) 
        begin
            if (on_state = '1') then
                sound_out <= sound_in;
            else
                sound_out <= '0';
            end if;
        end process define;
    
end Behavioral;
