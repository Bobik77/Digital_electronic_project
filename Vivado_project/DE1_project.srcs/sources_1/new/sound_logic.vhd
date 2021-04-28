----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2021 02:56:28 PM
-- Design Name: 
-- Module Name: sound_logic - Behavioral
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

entity sound_logic is
    Port (
        clk       : in std_logic;
        state     : in std_logic_vector(3 - 1 downto 0);
        on_state  : inout std_logic;
        sound_in  : in std_logic;
        sound_out : out std_logic
        
       );
end sound_logic;

architecture Behavioral of sound_logic is
        signal s_cnt_local : natural;

    begin
    
        logic: process (clk)
        begin
            if rising_edge(clk) then
                s_cnt_local <= s_cnt_local +1;
                
                case state is
                    when "000" =>
                        on_state <= '0';
                    when "001" => 
                        if (s_cnt_local > 500) then
                            s_cnt_local <= 0;
                            on_state <= not on_state;
                        end if;
                    when "010" =>
                        if (s_cnt_local > 300) then
                            s_cnt_local <= 0;
                            if (on_state = '1') then
                                s_cnt_local <= 0;
                            end if;
                            on_state <= not on_state;
                        end if;
                    when "011" =>
                        if (s_cnt_local > 300) then
                            s_cnt_local <= 0;
                            if (on_state = '1') then
                                s_cnt_local <= 0;
                            end if;
                            on_state <= not on_state;
                        end if;
                    when "100" =>
                        if (s_cnt_local > 200) then
                            s_cnt_local <= 0;
                            if (on_state = '1') then
                                s_cnt_local <= 0;
                            end if;
                            on_state <= not on_state;
                        end if;
                    when "101" =>
                        if (s_cnt_local > 200) then
                            s_cnt_local <= 0;
                            if (on_state = '1') then
                                s_cnt_local <= 0;
                            end if;
                            on_state <= not on_state;
                        end if;
                    when "110" =>
                        if (s_cnt_local > 100) then
                            s_cnt_local <= 0;
                            if (on_state = '1') then
                                s_cnt_local <= 0;
                            end if;
                            on_state <= not on_state;
                        end if;
                    when others =>
                    on_state <= '1';
                            
                end case;
            end if;
        end process logic;
    
    
        define: process (clk) 
        begin
            if (on_state = '1') then
                sound_out <= sound_in;
            else
                sound_out <= '0';
            end if;
        end process define;
    
end Behavioral;
