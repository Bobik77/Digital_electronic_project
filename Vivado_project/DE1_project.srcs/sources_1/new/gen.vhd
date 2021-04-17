----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2021 11:25:52 AM
-- Design Name: 
-- Module Name: gen - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gen is
    generic(
        
        g_MAX : natural := 563063
        
        );
        
      Port (
        clk     : in std_logic;
        reset   : in std_logic;
        pulse   : out std_logic
       );
end gen;

architecture Behavioral of gen is
    
    signal s_cnt_local : natural;
    signal s_pulse : std_logic;
    --constant audio_frequency : integer := 100000000;

begin
    generate_signal : process (clk)
    begin
    
        if rising_edge(clk) then        -- Synchronous process

            if (reset = '1') then       -- High active reset
                s_cnt_local <= 0;       -- Clear local counter
                s_pulse     <= '0';     -- Set output to low

            -- Test number of clock periods
            elsif (s_cnt_local >= (g_MAX - 1)) then
                s_cnt_local <= 0;               -- Clear local counter
                s_pulse     <= not s_pulse;     -- Generate clock enable pulse
                
            else
                s_cnt_local <= s_cnt_local + 1;
            end if;
        end if;
        
    pulse <= s_pulse;
        
        
    end process generate_signal;
end Behavioral;
