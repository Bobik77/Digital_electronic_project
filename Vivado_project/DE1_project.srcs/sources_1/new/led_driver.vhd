----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2021 09:44:03
-- Design Name: 
-- Module Name: led_driver - Behavioral
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

entity led_driver is
    Port ( 
        clk     : in std_logic;
        state_L : in std_logic_vector(3 - 1 downto 0);  -- state of left sensor, 3 bits
        state_M : in std_logic_vector(3 - 1 downto 0);  -- state of middle sensor, 3 bits
        state_R : in std_logic_vector(3 - 1 downto 0);  -- state of right sensor, 3 bits
        
        LED_L0_o : out std_logic_vector(3 - 1 downto 0); -- output color (RGB) of left leds
        LED_L1_o : out std_logic_vector(3 - 1 downto 0);
        LED_L2_o : out std_logic_vector(3 - 1 downto 0);
        LED_L3_o : out std_logic_vector(3 - 1 downto 0);
        
        LED_M0_o : out std_logic_vector(3 - 1 downto 0); -- output color (RGB) of middle leds
        LED_M1_o : out std_logic_vector(3 - 1 downto 0);
        LED_M2_o : out std_logic_vector(3 - 1 downto 0);
        LED_M3_o : out std_logic_vector(3 - 1 downto 0);
        
        LED_R0_o : out std_logic_vector(3 - 1 downto 0); -- output color (RGB) of right leds
        LED_R1_o : out std_logic_vector(3 - 1 downto 0);
        LED_R2_o : out std_logic_vector(3 - 1 downto 0);
        LED_R3_o : out std_logic_vector(3 - 1 downto 0)
        
    );
end led_driver;

architecture Behavioral of led_driver is
    type t_stateL is (L_LOW0, L_LOW1, L_LOW2, L_MED, L_HIGH1, L_HIGH2); -- 6 possibilities of lightning leds
    type t_stateM is (M_LOW0, M_LOW1, M_LOW2, M_MED, M_HIGH1, M_HIGH2);
    type t_stateR is (R_LOW0, R_LOW1, R_LOW2, R_MED, R_HIGH1, R_HIGH2);
    
    signal s_stateL : t_stateL;
    signal s_stateM : t_stateM;
    signal s_stateR : t_stateR;

    begin
    
    p_L_led : process(state_L)  -- assignment of 5 levels due to input signals
    begin
        case state_L is
            when "000" =>
                s_stateL <= L_LOW0;
            when "001" =>
                s_stateL <= L_LOW1;
            when "010" =>
                s_stateL <= L_LOW1;
            when "011" =>
                s_stateL <= L_LOW2;
            when "100" =>
                s_stateL <= L_MED;
            when "101" =>
                s_stateL <= L_MED;
            when "110" =>
                s_stateL <= L_HIGH1;
            when "111" =>
                s_stateL <= L_HIGH2;
        end case;                               
    end process p_L_led;
    
    p_output_L : process(s_stateL)
    begin
        case s_stateL is
            when L_LOW1 =>          -- no led shines
                LED_L0_o <= "010";
                LED_L1_o <= "000";
                LED_L2_o <= "000";
                LED_L3_o <= "000";
                        
            when L_LOW1 =>          -- first led green
                LED_L0_o <= "010";
                LED_L1_o <= "000";
                LED_L2_o <= "000";
                LED_L3_o <= "000";
                
            when L_LOW2 =>          -- first and second led green
                LED_L0_o <= "010";
                LED_L1_o <= "010";
                LED_L2_o <= "000";
                LED_L3_o <= "000";
                
            when L_MED =>           -- first, second led green, third led yellow
                LED_L0_o <= "010";
                LED_L1_o <= "010";
                LED_L2_o <= "110";
                LED_L3_o <= "000";
                
            when L_HIGH1 =>          -- green, green, yellow, red
                LED_L0_o <= "010";
                LED_L1_o <= "010";
                LED_L2_o <= "110";
                LED_L3_o <= "100";
                          
            when others =>          -- red diode flashes - TO DO
                LED_L0_o <= "010";
                LED_L1_o <= "010";
                LED_L2_o <= "110";
                LED_L3_o <= "100";                                                                
        end case;
    end process p_output_L;

end Behavioral;