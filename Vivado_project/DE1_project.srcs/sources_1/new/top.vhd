----------------------------------------------------------------------------------
-- Company: 
-- Engineer: PVL
-- 
-- Create Date: 30.04.2021 11:44:58
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision: 1
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity top is
  Port (-- Board signals
        CLK:       in std_logic;   -- internal clock
        RST:             in std_logic;   -- reset button
        
        -- SENSORs Wiring
        trigger_L_o:     out std_logic;  -- left sensor trigger pin
        trigger_M_o:     out std_logic;  -- mid  sensor trigger pin
        trigger_R_o:     out std_logic;  -- right sensor trigger pin
        echo_L_i:        in  std_logic;  -- left sensor echo pin
        echo_M_i:        in  std_logic;  -- left sensor echo pin
        echo_R_i:        in  std_logic;  -- left sensor echo pin
        
        -- SPEAKER Wiring
        speaker_o:       out std_logic;  -- speaker pwm output
        
        -- LEDs Wiring (RED; GREEN)
        LED_L0_o:        out std_logic_vector(1 downto 0);  -- left side LEDs
        LED_L1_o:        out std_logic_vector(1 downto 0);  
        LED_L2_o:        out std_logic_vector(1 downto 0);
        LED_L3_o:        out std_logic_vector(1 downto 0);
        LED_M0_o:        out std_logic_vector(1 downto 0);  -- middle LEDs
        LED_M1_o:        out std_logic_vector(1 downto 0);  
        LED_M2_o:        out std_logic_vector(1 downto 0);
        LED_M3_o:        out std_logic_vector(1 downto 0);
        LED_R0_o:        out std_logic_vector(1 downto 0);  -- right side LEDs
        LED_R1_o:        out std_logic_vector(1 downto 0);
        LED_R2_o:        out std_logic_vector(1 downto 0);
        LED_R3_o:        out std_logic_vector(1 downto 0));
end top;

architecture Behavioral of top is
    -- measured distances from each sensor
    signal s_distance_L : std_logic_vector(7 downto 0);
    signal s_distance_M : std_logic_vector(7 downto 0);
    signal s_distance_R : std_logic_vector(7 downto 0);
    -- computed states for leds and sound actuator
    signal s_led_L_state: std_logic_vector(2 downto 0);
    signal s_led_M_state: std_logic_vector(2 downto 0);
    signal s_led_R_state: std_logic_vector(2 downto 0);
    signal s_sound_state: std_logic_vector(2 downto 0);
    -- readed sound wav
    signal s_sound_data:  unsigned(7 downto 0);
    -- pwm modulated sound (continuous)
    signal s_sound_PWM:   std_logic;
    -- signal for unused bits of led output vector (we dont use blue color)
    signal s_unused:      std_logic_vector(11 downto 0);
    
begin
    ----------------------------------------------------------------------------------
    -- SENSORS
    ----------------------------------------------------------------------------------
    -- Instance of sensor driver for LEFT side
    sensor_driver_0: entity work.sensor_driver
        port map(-- control signals
                 clk    => CLK,
                 rst    => RST,
                 -- sensor connection
                 echo_i       => echo_L_i,
                 trigger_o    => trigger_L_o,
                 -- data out
                 distance_o   => s_distance_L);
                 
                 
    -- Instance of sensor driver for MIDDLE segment
    sensor_driver_1: entity work.sensor_driver
        port map(-- control signals
                 clk    => CLK,
                 rst    => RST,
                 -- sensor connection
                 echo_i       => echo_M_i,
                 trigger_o    => trigger_M_o,
                 -- data out
                 distance_o   => s_distance_M);
                 
                 
    -- Instance of sensor driver for RIGHT side
    sensor_driver_2: entity work.sensor_driver
        port map(-- control signals
                 clk    => CLK,
                 rst    => RST,
                 -- sensor connection
                 echo_i       => echo_R_i,
                 trigger_o    => trigger_R_o,
                 -- data out
                 distance_o   => s_distance_R);
                 
    ----------------------------------------------------------------------------------
    -- CONTROL LOGIC
    ----------------------------------------------------------------------------------
    -- Instance of control unit
    control_unit_0: entity work.control_unit
        port map( -- control signals
                 clk    => CLK,
                 -- sensors connections
                 left_i      =>  s_distance_L, -- left  side
                 mid_i       =>  s_distance_M, -- middle
                 right_i     =>  s_distance_R, -- right side
                 -- actuators connections
                 led_L_o     =>  s_led_L_state, --state vector for left  side
                 led_M_o     =>  s_led_M_state, --state vector for mid   side
                 led_R_o     =>  s_led_R_state, --state vector for right side
                 sound_o     =>  s_sound_state);
    
    ----------------------------------------------------------------------------------
    -- LED ACTUATORS
    ----------------------------------------------------------------------------------
    -- Instance of led driver
    led_driver_0: entity work.led_driver
        port map(-- control signals
                 clk    => CLK,
                 reset    => RST,
                 -- state inputs
                 state_L_i => s_led_L_state, -- left  side
                 state_M_i => s_led_M_state, -- middle
                 state_R_i => s_led_R_state, -- right side
                 -- LED outputs
                 LED_L0_o => LED_L0_o, -- left side LEDs
                 LED_L1_o => LED_L1_o,
                 LED_L2_o => LED_L2_o,
                 LED_L3_o => LED_L3_o,
                 LED_M0_o => LED_M0_o, -- middle     LEDs
                 LED_M1_o => LED_M1_o,
                 LED_M2_o => LED_M2_o,
                 LED_M3_o => LED_M3_o,
                 LED_R0_o => LED_R0_o, -- right side LEDs
                 LED_R1_o => LED_R1_o,
                 LED_R2_o => LED_R2_o,
                 LED_R3_o => LED_R3_o);
                                
    ----------------------------------------------------------------------------------
    -- SOUND ACTUATOR
    ----------------------------------------------------------------------------------
    -- Instance of sound player with memory
    sound_player_0 : entity work.sound_player
        generic map(-- global constants
                    g_TICKS_PER_SAMPLE => 10,  --sample duration in ticks; original value = 1042
                    g_VOLUME           => 2)   --volume adjust
        port map(-- control signals
                 clk      => CLK,
                 rst      => RST,
                 -- data output
                 data_out => s_sound_data);
                 
    -- Instance of PWM D/A convertor
    pwm_0: entity work.pwm
        port map(-- control signals
                 clk      => CLK,
                 -- duty control
                 duty     => s_sound_data,
                 -- PWM output
                 output   => s_sound_PWM);
                 
    -- Instance of sound logic (beep switching)
    sound_logic: entity work.sound_logic
        port map(-- control signals
                 clk      => CLK,
                 -- inputs
                 state    => s_sound_state, --state vector
                 sound_in => s_sound_pwm,   -- PWM signal
                 -- output
                 sound_out => speaker_o);   -- switched beep in PWM
end Behavioral;
