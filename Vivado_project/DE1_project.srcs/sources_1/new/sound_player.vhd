----------------------------------------------------------------------------------
-- Engineer: Pavel Vanek
-- 
-- Create Date: 26.04.2021 19:04:04
-- Design Name: sound_player.vhd
-- Module Name: sound_player
-- Project Name:  DE1 Project
-- Target Devices: Arty A7
-- Description: 
--      generation 8bit wide audio stream (wav) for ADC.
--      Cloud be used global parameter for setting
-- 
-- Dependencies: 
--      sound_memory.vhd
-- Revision:
-- Revision 2.01 
-- Additional Comments:
--      Global parameters:
--          g_VOLUME            -- volume preset (1 is loudest)        
--          g_TICKS_PER_SAMPLES -- length of one sample in clk ticks
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity sound_player is
    generic(
            g_VOLUME : natural := 4;
            g_TICKS_PER_SAMPLE : natural := 1042); -- 1042 clk ticks for 1 sample
    
    Port ( 
           clk :        in STD_LOGIC;
           rst :        in STD_LOGIC;
           data_out :   out unsigned (7 downto 0));
end sound_player;

architecture Behavioral of sound_player is
    -- Local constants
    constant c_sample_period :       natural := g_TICKS_PER_SAMPLE; -- length of sample in clk ticks, 
    constant c_n_samples :           natural := 2303-1;   -- total numer of samples in memory, original val. 2303-1
    constant c_volume :              natural := g_VOLUME; --volume regulation 0 to cca 12,, higher means lower vol. 
    -- Local signals 
    signal s_address :              unsigned(11 downto 0); -- addres signal for memory
    signal s_sample_clk :           std_logic; --internal slowed clk   
    signal s_clk_tick_counter :     unsigned (11 downto 0); -- counter for clock divider
    signal s_data_in :              unsigned (7 downto 0); -- internal signal, memorz input
begin
    -- Sound Memory implemeentation
    e_sound_memoy: entity work.sound_memory
    port map(
        clk => clk,
        address => s_address,
        data_out => s_data_in);
    
    -- INTERNAL CLOCK GENERATION (clk divider)
    p_internal_clk: process(clk) begin  
        if rising_edge(clk) then
            -- reset
            if (rst = '1') then
                s_clk_tick_counter <= (others => '0');
                s_sample_clk <= '0';
            else -- do increment
                s_clk_tick_counter <=  s_clk_tick_counter + 1;
                    if (s_clk_tick_counter >= c_sample_period / 2) then
                           s_clk_tick_counter <= (others => '0');
                           s_sample_clk <= not s_sample_clk;
                    end if;
            end if; --rst='1'
        end if; -- rising_edge(clk)
    end process p_internal_clk;
    
    -- ADRESS OUTPUT ACTUALISE
    -- cyclicaly set addres 0 to c_n_samples
    p_samples_loading: process(clk, s_sample_clk) begin
        if(rising_edge(clk) and (rst = '1')) then
            s_address <= (others => '0'); 
        else
            if rising_edge(s_sample_clk) then
                s_address <= s_address + 1; -- set next address
                -- addres counter overflow
                if (s_address >= c_n_samples) then 
                    s_address <= (others => '0');
                end if; 
            end if;       
        end if;
    end process p_samples_loading;
    
    -- OUTPUT ACTUALISE, volume regulation
    p_volume_regulation: process(s_data_in) begin
        data_out <= s_data_in/(c_volume);
    end process p_volume_regulation;
end Behavioral;
