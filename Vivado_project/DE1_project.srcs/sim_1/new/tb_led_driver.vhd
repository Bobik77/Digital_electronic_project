----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.04.2021 08:28:24
-- Design Name: 
-- Module Name: tb_led_driver - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_led_driver is
--  Port ( );
end tb_led_driver;

architecture Behavioral of tb_led_driver is

        -- Local constans
        constant c_CLK_100MHZ_PERIOD : time := 10ns;
        
        -- Local signals
        signal s_clk      : std_logic;
        signal s_reset    : std_logic;
        signal s_state_L  : std_logic_vector(3 - 1 downto 0);
        signal s_state_M  : std_logic_vector(3 - 1 downto 0);
        signal s_state_R  : std_logic_vector(3 - 1 downto 0);
        
        signal s_LED_L0   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_L1   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_L2   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_L3   : std_logic_vector(3 - 1 downto 0);
        
        signal s_LED_M0   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_M1   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_M2   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_M3   : std_logic_vector(3 - 1 downto 0);
        
        signal s_LED_R0   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_R1   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_R2   : std_logic_vector(3 - 1 downto 0);
        signal s_LED_R3   : std_logic_vector(3 - 1 downto 0);

begin
    -- Connecting testbench signals with led_driver entity (Unit Under Test)
    uut_led_driver : entity work.led_driver
        port map(
            clk         => s_clk,
            reset       => s_reset,
            state_L     => s_state_L,
            state_M     => s_state_M,
            state_R     => s_state_R,
                    
            LED_L0_o    => s_LED_L0,
            LED_L1_o    => s_LED_L1,
            LED_L2_o    => s_LED_L2,
            LED_L3_o    => s_LED_L1,
                    
            LED_M0_o    => s_LED_M0,
            LED_M1_o    => s_LED_M1,
            LED_M2_o    => s_LED_M2,
            LED_M3_o    => s_LED_M3,
                    
            LED_R0_o    => s_LED_R0,
            LED_R1_o    => s_LED_R1,
            LED_R2_o    => s_LED_R2,
            LED_R3_o    => s_LED_R3
        );
    
    -- Clock generation process
    p_clk_gen : process
    begin
        while now < 10000 ns loop   -- 10 usec of simulation
            s_clk <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
    -- Reset generation process
    p_reset_gen : process
    begin
        s_reset <= '0'; wait for 10 ns;
        -- Reset activated
        s_reset <= '1'; wait for 10 ns;
        -- Reset deactivated
        s_reset <= '0'; wait for 800 ns;
        -- Reset activated
        s_reset <= '1'; wait for 100 ns;
        -- Reset deactivated
        s_reset <= '0';
        wait;
    end process p_reset_gen;
    
    -- Data generation process    
    p_stimulus : process
    begin
        -- Report a note at the begining of stimulus process
        report "Stimulus process started" severity note;
        
        s_state_L <= "000"; s_state_M <= "000"; s_state_R <= "000"; 
        wait for 100ns;
        
        s_state_L <= "000";wait for 20ns;
        s_state_L <= "001";wait for 20ns;
        s_state_L <= "010";wait for 20ns;
        s_state_L <= "011";wait for 20ns;
        s_state_L <= "100";wait for 20ns;
        s_state_L <= "101";wait for 20ns;
        s_state_L <= "110";wait for 20ns;
        s_state_L <= "111";wait for 80ns;
        
        s_state_L <= "000"; s_state_M <= "000"; s_state_R <= "000"; 
        wait for 100ns;
        s_state_L <= "001"; s_state_M <= "001"; s_state_R <= "001"; 
        wait for 100ns;
        s_state_L <= "100"; s_state_M <= "010"; s_state_R <= "011"; 
        wait for 100ns;
        s_state_L <= "110"; s_state_M <= "011"; s_state_R <= "010"; 
        wait for 100ns;
        
        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end Behavioral;