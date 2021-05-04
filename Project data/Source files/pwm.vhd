----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Turák Samuel
-- 
-- Create Date: 04/26/2021 09:06:13 PM
-- Design Name: pwm.vhd
-- Module Name: pwm - Behavioral
-- Project Name: DE1 Project
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Pulse Width Modulation for output signal
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--      Input is a sampled 8b analog signal
--      Output is a rectangular signal with changing duty cycle
----------------------------------------------------------------------------------


library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pwm is
    port (
    clk           : in std_logic; -- clock signal 100MHz
    duty          : in unsigned(8 - 1 downto 0); -- 8b vector
    output        : out std_logic -- pwm signal
  );
  
end pwm;

architecture Behavioral of pwm is
    signal s_cnt_local : natural;   
    
begin

    -- Pulse width generation process
    pwm : process(clk)
        begin
            if rising_edge(clk) then
                
                if (s_cnt_local >= duty) then -- when the signal reaches the gicen duty cycle...
                    output <= '0'; -- ... only then it gets low, ...
                else
                    output <= '1'; -- ... before it is up
                end if;
                
                s_cnt_local <= s_cnt_local +1; -- incrementing the counter
                
                if (s_cnt_local = 255) then -- we let the counter reach the whole period...
                    s_cnt_local <= 0; -- ... then it gets low and the process repeats
                    output <= '1'; -- setting the output back to 1
                end if;
            end if;
        
        end process pwm;    
             
end Behavioral;
