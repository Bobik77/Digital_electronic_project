
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 


entity tb_sound_player is
--  empty
end tb_sound_player;

architecture Behavioral of tb_sound_player is
    
    -- local constants
    constant c_clk_period : time := 10 ns;
    -- local signals
    signal s_clk    : std_logic;
    signal s_rst    : std_logic;
    signal s_data_out   : unsigned (7 downto 0); 
    
    
begin     
uut_sound_player: entity work.sound_player
    port map(
        clk => s_clk,
        rst => s_rst, 
        data_out => s_data_out);
    ----------------------------------------------------------------------------------
    -- Clock generation
    ----------------------------------------------------------------------------------
    p_clk_gen : process begin
        while now <  1000 ms loop   -- 1 sec of simulation
            s_clk <= '0';
            wait for c_clk_period / 2;
            -- wait half period
            s_clk <= '1';
            wait for c_clk_period / 2;
            -- wait half period
        end loop;
    end process p_clk_gen;
    ----------------------------------------------------------------------------------
    -- Reset impuls generation
    ----------------------------------------------------------------------------------
    p_rst_gen : process
    begin
        s_rst <= '0'; wait for 200 ns;
        -- Reset activated
        s_rst <= '1'; wait for 500 ns;
        -- Reset deactivated
        s_rst <= '0';
        wait;
    end process p_rst_gen;



end Behavioral;
