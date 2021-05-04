----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Turák Samuel
-- 
-- Create Date: 04/19/2021 02:23:53 PM
-- Design Name: 
-- Module Name: tb_pwn_gen - Behavioral
-- Project Name: DE1 Project
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      testbench for pwm module
-- Dependencies: 
-- 
-- Revision:
-- Revision 1.0 - Fine
-- Additional Comments:
--      Ideal simulation time for these settings is 30 microseconds
----------------------------------------------------------------------------------


library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_pwm is
    
--  port ( );
      
end tb_pwm;

architecture Behavioral of tb_pwm is

        
        constant c_clk_period       : time := 10 ns; -- period of pwm signal
        signal s_clk                : std_logic;
        signal s_duty               : unsigned(8 - 1 downto 0);
        signal s_output             : std_logic;

        
begin
     uut_pwm : entity work.pwm
     
     port map(
        clk         => s_clk,  
        duty        => s_duty,
        output      => s_output
        );
        
        -- clock signal generation
     p_clk_gen : process
        begin
        while now < 10 ms loop   -- 10 milisec of simulation
            s_clk <= '0';
            wait for c_clk_period / 2;
            s_clk <= '1';
            wait for c_clk_period / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
    p_duty : process  -- recreation of the input signal
       begin
           s_duty <= "00000011"; wait for 2550 ns;  -- the original freq is dependent on the sampling freq...
                                                
           s_duty <= "00001001"; wait for 2550 ns;  -- ... here we use this freq for clarity of the signal
                                                
           s_duty <= "00111111"; wait for 2550 ns;
           
           s_duty <= "01111111"; wait for 2550 ns;
                                                
           s_duty <= "10011111"; wait for 2550 ns;
                                                
           s_duty <= "11000001"; wait for 2550 ns;
                                                
           s_duty <= "10111111"; wait for 2550 ns;
                                                
           s_duty <= "11111111"; wait for 2550 ns;

    end process p_duty;
      
end Behavioral;
