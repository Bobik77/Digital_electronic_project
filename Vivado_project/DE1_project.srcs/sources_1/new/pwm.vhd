----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2021 09:06:13 PM
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
    port (
  
    clk           : in std_logic;
    duty          : in unsigned(8 - 1 downto 0);
    output        : inout std_logic
      
  );
end pwm;

architecture Behavioral of pwm is
    signal s_cnt_local : natural;
    
begin
    
    pwm : process(clk)
        begin
            if rising_edge(clk) then
                
                if (s_cnt_local >= duty) then
                    output <= '0';
                else
                    output <= '1';
                end if;
                
                s_cnt_local <= s_cnt_local +1;
                
                if (s_cnt_local = 255) then
                    s_cnt_local <= 0;
                    output <= '1';
                end if;
            end if;
        
        end process pwm;    
        
                  
end Behavioral;
