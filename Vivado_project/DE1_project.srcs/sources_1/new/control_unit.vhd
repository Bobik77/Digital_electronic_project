----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
----------------------------------------------------------------------------------

library ieee;               -- Standard library
use ieee.std_logic_1164.all;-- Package for data types and logic operations
use ieee.numeric_std.all;   -- Package for arithmetic operations

------------------------------------------------------------------------
-- Entity declaration
------------------------------------------------------------------------
entity control_unit is
    
    --  Port map
    port (
    -- Clock
    clk     : in std_logic;   -- no used 

    -- Inputs
    left_i    : in  std_logic_vector(8-1 downto 0); -- senzor_driver input 1 
    mid_i     : in  std_logic_vector(8-1 downto 0); -- senzor_driver input 2
    right_i   : in  std_logic_vector(8-1 downto 0); -- senzor_driver input 3

    --Outputs
    led_L_o    : out std_logic_vector(3-1 downto 0);  -- LED diode output
    led_M_o    : out std_logic_vector(3-1 downto 0);  -- LED diode output
    led_R_o    : out std_logic_vector(3-1 downto 0);  -- LED diode output
    sound_o    : out std_logic_vector(3-1 downto 0)   -- Sound output

    );
end control_unit;

------------------------------------------------------------------------
-- Architecture declaration
------------------------------------------------------------------------
architecture Behavioral of control_unit is
    
    -- Internal signals
    signal inter_sound  : std_logic_vector(8-1 downto 0); -- The lowest value
    
begin  
    -- Select the lowest (nearest) value 
    p_select_input : process (left_i, mid_i, right_i)
    begin
        if (left_i < mid_i) and (left_i < right_i)  then 
            inter_sound <= left_i;
        elsif
           (mid_i < left_i) and (mid_i < right_i)   then 
            inter_sound <= mid_i; 
        elsif
           (right_i < left_i) and (right_i < mid_i) then 
            inter_sound <= right_i; 
        elsif
            (left_i = mid_i) or (left_i = right_i)  then
            inter_sound <= left_i;
        elsif
            (mid_i = right_i) then
            inter_sound <= mid_i; 
        end if;            
    end process p_select_input;
    
    -- Sound code  
     p_sound : process(inter_sound)
     begin
        if (inter_sound >= b"0000_0001")    and (inter_sound <= b"0001_1101") then -- Option 1 (1-29cm)
            sound_o <= "111";
        elsif (inter_sound >= b"0001_1110") and (inter_sound <= b"0011_1011") then -- Option 2 (30-59cm)
            sound_o <= "100";--010
        elsif (inter_sound >= b"0011_1100") and (inter_sound <= b"0101_1001") then -- Option 3 (60-89cm)
            sound_o <= "101";
        elsif (inter_sound >= b"0101_1010") and (inter_sound <= b"0111_0111") then -- Option 4 (90-119cm)
            sound_o <= "100";
        elsif (inter_sound >= b"0111_1000") and (inter_sound <= b"1001_0101") then -- Option 5 (120-149cm)
            sound_o <= "011";
        elsif (inter_sound >= b"1001_0110") and (inter_sound <= b"1011_0011") then -- Option 6 (150-179cm)
            sound_o <= "010";
        elsif (inter_sound >= b"1011_0100") and (inter_sound <= b"1100_1000") then -- Option 7 (180-200cm)
            sound_o <= "001";
        elsif (inter_sound = b"0000_0000") or  (inter_sound = b"1111_1111") then -- Option 8 (Disabled)
            sound_o <= "000";       
        end if;
     end process p_sound; 
    
    
     -- Code for led_L_o  
     p_led_L : process(left_i)
     begin   
        if (left_i >= b"0000_0001")    and (left_i <= b"0001_1101") then -- Option 1 (1-29cm)
            led_L_o <= "111";
        elsif (left_i >= b"0001_1110") and (left_i <= b"0011_1011") then -- Option 2 (30-59cm)
            led_L_o <= "110";
        elsif (left_i >= b"0011_1100") and (left_i <= b"0101_1001") then -- Option 3 (60-89cm)
            led_L_o <= "101";
        elsif (left_i >= b"0101_1010") and (left_i <= b"0111_0111") then -- Option 4 (90-119cm)
            led_L_o <= "100";
        elsif (left_i >=  b"0111_1000") and (left_i <= b"1001_0101") then -- Option 5 (120-149cm)
            led_L_o <= "011";
        elsif (left_i >= b"1001_0110") and (left_i <= b"1011_0011") then -- Option 6 (150-179cm)
            led_L_o <= "010";
        elsif (left_i >= b"1011_0100") and (left_i <= b"1100_1000") then -- Option 7 (180-200cm)
            led_L_o <= "001";
        elsif (left_i = b"0000_0000") or  (left_i = b"1111_1111") then -- Option 8 (Disabled)
            led_L_o <= "000";       
        end if;
 end process p_led_L;
    
     -- Code for led_M_o    
     p_led_M : process(mid_i)
     begin   
        if (mid_i >= b"0000_0001")    and (mid_i <= b"0001_1101") then -- Option 1 (1-29cm)
            led_M_o <= "111";
        elsif (mid_i >= b"0001_1110") and (mid_i <= b"0011_1011") then -- Option 2 (30-59cm)
            led_M_o <= "110";
        elsif (mid_i >= b"0011_1100") and (mid_i <= b"0101_1001") then -- Option 3 (60-89cm)
            led_M_o <= "101";
        elsif (mid_i >= b"0101_1010") and (mid_i <= b"0111_0111") then -- Option 4 (90-119cm)
            led_M_o <= "100";
        elsif (mid_i >= b"0111_1000") and (mid_i <= b"1001_0101") then -- Option 5 (120-149cm)
            led_M_o <= "011";
        elsif (mid_i >= b"1001_0110") and (mid_i <= b"1011_0011") then -- Option 6 (150-179cm)
            led_M_o <= "010";
        elsif (mid_i >= b"1011_0100") and (mid_i <= b"1100_1000") then -- Option 7 (180-200cm)
            led_M_o <= "001";
        elsif (mid_i = b"0000_0000") or  (mid_i = b"1111_1111") then -- Option 8 (Disabled)
            led_M_o <= "000";       
        end if;
     end process p_led_M;
     
     -- Code for led_R_o  
     p_led_R : process(right_i)
     begin   
        if (right_i >= b"0000_0001")    and (right_i <= b"0001_1101") then -- Option 1 (1-29cm)
            led_R_o <= "111";
        elsif (right_i >= b"0001_1110") and (right_i <= b"0011_1011") then -- Option 2 (30-59cm)
            led_R_o <= "110";
        elsif (right_i >= b"0011_1100") and (right_i <= b"0101_1001") then -- Option 3 (60-89cm)
            led_R_o <= "101";
        elsif (right_i >= b"0101_1010") and (right_i <= b"0111_0111") then -- Option 4 (90-119cm)
            led_R_o <= "100";
        elsif (right_i >= b"0111_1000") and (right_i <= b"1001_0101") then -- Option 5 (120-149cm)
            led_R_o <= "011";
        elsif (right_i >= b"1001_0110") and (right_i <= b"1011_0011") then -- Option 6 (150-179cm)
            led_R_o <= "010";
        elsif (right_i >= b"1011_0100") and (right_i <= b"1100_1000") then -- Option 7 (180-200cm)
            led_R_o <= "001";
        elsif (right_i = b"0000_0000") or  (right_i = b"1111_1111") then -- Option 8 (Disabled)
            led_R_o <= "000";       
        end if;
     end process p_led_R;
end Behavioral;


