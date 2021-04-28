----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 02:23:53 PM
-- Design Name: 
-- Module Name: tb_pwn_gen - Behavioral
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

entity tb_pwm is
    
--  port ( );
      
end tb_pwm;

architecture Behavioral of tb_pwm is

        
        constant c_clk_period       : time := 10 ns;
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
        
     p_clk_gen : process
        begin
        while now < 10 ms loop   -- 1 sec of simulation
            s_clk <= '0';
            wait for c_clk_period / 2;
            s_clk <= '1';
            wait for c_clk_period / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
    p_duty : process  -- LUT signal recreation
       begin
           s_duty <= "00000011"; wait for 2550 ns;
                                                
           s_duty <= "00001001"; wait for 2550 ns;
                                                
           s_duty <= "00111111"; wait for 2550 ns;
                                                
           s_duty <= "01111111"; wait for 2550 ns;
                                                
           s_duty <= "10011111"; wait for 2550 ns;
                                                
           s_duty <= "11000001"; wait for 2550 ns;
                                                
           s_duty <= "10111111"; wait for 2550 ns;
                                                
           s_duty <= "11111111"; wait for 2550 ns;

    end process p_duty;
      
end Behavioral;
