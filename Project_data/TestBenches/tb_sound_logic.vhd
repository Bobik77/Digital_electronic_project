----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Turák Samuel
-- 
-- Create Date: 04/19/2021 08:53:10 PM
-- Design Name: sound_logic.vhd
-- Module Name: tb_sound_logic - Behavioral
-- Project Name: DE1
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      testbench for sound_logic
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


entity tb_sound_logic is
--  Port ( );
end tb_sound_logic;

architecture Behavioral of tb_sound_logic is

        constant c_clk_period       : time := 10 ns; -- 100 MHz
        signal s_clk                : std_logic;
        signal s_state              : std_logic_vector(3 - 1 downto 0); -- the nearness representation
        signal s_sound_in           : std_logic; -- input for this simulation
        signal s_sound_out          : std_logic; -- output
begin
    uut_sound_logic : entity work.sound_logic
    
        port map(
            clk       => s_clk,  
            state     => s_state,
            sound_in  => s_sound_in,
            sound_out => s_sound_out
            );
            
            
    -- clock generation
    p_clk_gen : process
        begin
        while now < 400 ms loop   
            s_clk <= '0';
            wait for c_clk_period / 2;
            s_clk <= '1';
            wait for c_clk_period / 2;
        end loop;
        wait;
    end process p_clk_gen; 

    -- logical input
    p_state_gen : process  
       begin
           s_state <= "000"; wait for 1 ms;
                       
           s_state <= "001"; wait for 1 ms;
                        
           s_state <= "010"; wait for 1 ms;
                                    
           s_state <= "011"; wait for 1 ms;
                        
           s_state <= "100"; wait for 1 ms;
                          
           s_state <= "101"; wait for 1 ms;
           
           s_state <= "111"; wait for 1 ms;
           
    end process p_state_gen;
    
    -- input recreation
    p_in_gen : process  
       begin
           s_sound_in <= '1'; 
           wait;
           
           wait;
    end process p_in_gen;
    
end Behavioral;
