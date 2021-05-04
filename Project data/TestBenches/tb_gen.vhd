----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2021 01:11:59 PM
-- Design Name: 
-- Module Name: tb_gen - Behavioral
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
use IEEE.std_logic_signed.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_gen is
    --Port ( );
    
end tb_gen;

architecture Behavioral of tb_gen is
        
        -- Local constants
        constant c_audio_freq       : natural := 400;       -- not used right now
        --integer temp :
        constant c_clk_period       : time := 2.22 ns;      -- not used right now
        constant c_MAX              : natural := 511364;    -- this makes the frequency 440Hz
        
        -- local signals
        signal s_clk                : std_logic;
        signal s_reset              : std_logic;
        signal s_pulse              : std_logic;
        
begin
    uut_gen : entity work.gen
        generic map(
            g_MAX => c_MAX
            )
        port map(
            clk     => s_clk,
            reset   => s_reset,
            pulse   => s_pulse  
        );

-- Clock generation
        ----------------------------------------------------------------------------------
        p_clk_gen : process
        begin
            while now < 1000 ms loop   -- 1 sec of simulation
                s_clk <= '0';
                wait for c_clk_period / 2;
                s_clk <= '1';
                wait for c_clk_period / 2;
            end loop;
            wait;
        end process p_clk_gen;
        ----------------------------------------------------------------------------------
        -- Reset impuls generation
        ----------------------------------------------------------------------------------
        p_rst_gen : process
        begin
            s_reset <= '0'; wait for 10 ns;
            -- Reset activated
            s_reset <= '1'; wait for 10 ns;
            -- Reset deactivated
            s_reset <= '0';
            wait;
        end process p_rst_gen;
        
end Behavioral;
