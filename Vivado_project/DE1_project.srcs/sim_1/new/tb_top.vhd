----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2021 04:57:43 PM
-- Design Name: 
-- Module Name: tb_top - Behavioral
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

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is
        
        constant c_clk_period       : time := 10 ns;
        signal s_clk                : std_logic;
        signal s_rst                : std_logic;
        signal s_trigger_L_o        : std_logic;
        signal s_trigger_M_o        : std_logic;
        signal s_trigger_R_o        : std_logic;
        signal s_echo_L_i           : std_logic;
        signal s_echo_M_i           : std_logic;
        signal s_echo_R_i           : std_logic;
        
        signal s_speaker_o          : std_logic; 
        
        signal s_LED_L0_o           : std_logic_vector(1 downto 0); 
        signal s_LED_L1_o           : std_logic_vector(1 downto 0); 
        signal s_LED_L2_o           : std_logic_vector(1 downto 0); 
        signal s_LED_L3_o           : std_logic_vector(1 downto 0); 
        signal s_LED_M0_o           : std_logic_vector(1 downto 0); 
        signal s_LED_M1_o           : std_logic_vector(1 downto 0); 
        signal s_LED_M2_o           : std_logic_vector(1 downto 0); 
        signal s_LED_M3_o           : std_logic_vector(1 downto 0); 
        signal s_LED_R0_o           : std_logic_vector(1 downto 0); 
        signal s_LED_R1_o           : std_logic_vector(1 downto 0); 
        signal s_LED_R2_o           : std_logic_vector(1 downto 0); 
        signal s_LED_R3_o           : std_logic_vector(1 downto 0);
    
begin
    uut_top: entity work.top
    
        port map(
            clk              => s_clk,  
            RST              => s_rst,
            
            trigger_L_o      => s_trigger_L_o,
            trigger_M_o      => s_trigger_M_o,
            trigger_R_o      => s_trigger_R_o,
            echo_L_i         => s_echo_L_i,
            echo_M_i         => s_echo_M_i,
            echo_R_i         => s_echo_R_i,
            
            speaker_o        => s_speaker_o,
          
            LED_L0_o         => s_LED_L0_o,
            LED_L1_o         => s_LED_L1_o,
            LED_L2_o         => s_LED_L2_o,
            LED_L3_o         => s_LED_L3_o,
            LED_M0_o         => s_LED_M0_o,
            LED_M1_o         => s_LED_M1_o,
            LED_M2_o         => s_LED_M2_o,
            LED_M3_o         => s_LED_M3_o,
            LED_R0_o         => s_LED_R0_o,
            LED_R1_o         => s_LED_R1_o,
            LED_R2_o         => s_LED_R2_o,
            LED_R3_o         => s_LED_R3_o
            );
            
            
    p_clk_gen : process
        begin
        while now < 400 ms loop   -- clock length time
            s_clk <= '0';
            wait for c_clk_period / 2;
            s_clk <= '1';
            wait for c_clk_period / 2;
        end loop;
        wait;
    end process p_clk_gen; 
    
    p_rst_gen : process
        begin
            s_rst <= '0'; wait for 200 ns;
            -- Reset activated
            s_rst <= '1'; wait for 500 ns;
            -- Reset deactivated
            s_rst <= '0';
            wait;
        end process p_rst_gen;
        
    p_sensor_simulation_L : process
        begin
            s_echo_L_i <= '0';
            -- normal distance 26.8cm
                wait until rising_edge(s_trigger_L_o); -- rise of trigger
                wait until falling_edge(s_trigger_L_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_L_i <= '1';
                wait for 1560 us; -- echo pulse width
                s_echo_L_i <= '0';  
                
            -- theoretical distance 1 cm
                wait until rising_edge(s_trigger_L_o); -- rise of trigger
                wait until falling_edge(s_trigger_L_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_L_i <= '1';
                wait for 58 us; -- echo pulse width 58
                s_echo_L_i <= '0';
             
              -- Max distance 255 cm   
                wait until rising_edge(s_trigger_L_o); -- rise of trigger
                wait until falling_edge(s_trigger_L_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_L_i <= '1';
                wait for 190790 us; -- echo pulse width
                s_echo_L_i <= '0';
                
              -- Fault not responding 
                wait until rising_edge(s_trigger_L_o); -- rise of trigger
                wait until falling_edge(s_trigger_L_o);-- fall of trigger

                
              -- Fault too long echo pulse    
                wait until rising_edge(s_trigger_L_o); -- rise of trigger
                wait until falling_edge(s_trigger_L_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_L_i <= '1';
                wait for 15000 us; -- echo pulse width
                s_echo_L_i <= '0';
                
 
        end process p_sensor_simulation_L;
        
    
    p_sensor_simulation_M : process
        begin
            s_echo_M_i <= '0';
            -- normal distance 26.8cm
                wait until rising_edge(s_trigger_M_o); -- rise of trigger
                wait until falling_edge(s_trigger_M_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_M_i <= '1';
                wait for 1560 us; -- echo pulse width
                s_echo_M_i <= '0';  
                
            -- theoretical distance 1 cm
                wait until rising_edge(s_trigger_M_o); -- rise of trigger
                wait until falling_edge(s_trigger_M_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_M_i <= '1';
                wait for 58 us; -- echo pulse width 58
                s_echo_M_i <= '0';
             
              -- Max distance 255 cm   
                wait until rising_edge(s_trigger_M_o); -- rise of trigger
                wait until falling_edge(s_trigger_M_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_M_i <= '1';
                wait for 190790 us; -- echo pulse width
                s_echo_M_i <= '0';
                
              -- Fault not responding 
                wait until rising_edge(s_trigger_M_o); -- rise of trigger
                wait until falling_edge(s_trigger_M_o);-- fall of trigger

                
              -- Fault too long echo pulse    
                wait until rising_edge(s_trigger_M_o); -- rise of trigger
                wait until falling_edge(s_trigger_M_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_M_i <= '1';
                wait for 15000 us; -- echo pulse width
                s_echo_M_i <= '0';
                
 
        end process p_sensor_simulation_M;
        
    
    p_sensor_simulation_R : process
        begin
            s_echo_R_i <= '0';
            -- normal distance 26.8cm
                wait until rising_edge(s_trigger_R_o); -- rise of trigger
                wait until falling_edge(s_trigger_R_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_R_i <= '1';
                wait for 1560 us; -- echo pulse width
                s_echo_R_i <= '0';  
                
            -- theoretical distance 1 cm
                wait until rising_edge(s_trigger_R_o); -- rise of trigger
                wait until falling_edge(s_trigger_R_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_R_i <= '1';
                wait for 58 us; -- echo pulse width 58
                s_echo_R_i <= '0';
             
              -- Max distance 255 cm   
                wait until rising_edge(s_trigger_R_o); -- rise of trigger
                wait until falling_edge(s_trigger_R_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_R_i <= '1';
                wait for 190790 us; -- echo pulse width
                s_echo_R_i <= '0';
                
              -- Fault not responding 
                wait until rising_edge(s_trigger_R_o); -- rise of trigger
                wait until falling_edge(s_trigger_R_o);-- fall of trigger

                
              -- Fault too long echo pulse    
                wait until rising_edge(s_trigger_R_o); -- rise of trigger
                wait until falling_edge(s_trigger_R_o);-- fall of trigger
                wait for 800 us; --tarry
                s_echo_R_i <= '1';
                wait for 15000 us; -- echo pulse width
                s_echo_R_i <= '0';
                
        end process p_sensor_simulation_R;
        
                 
end Behavioral;