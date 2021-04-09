----------------------------------------------------------------------------------
-- Company: 
-- Engineer: OK3PVL
-- 
-- Create Date: 07.04.2021 14:58:57
-- Design Name: sensor_driver.vhd
-- Module Name: sensor_driver - Behavioral
-- Project Name: DE1_project
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Driver for distance sensor HC-SR04,

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

entity sensor_driver is
    Port (
        clk     : in std_logic;
        rst     : in std_logic;
        trigger : out std_logic; --connect ECHO pin of sensor
        echo    : in std_logic; --connect ECHO pin of sensor 
        distance: out std_logic_vector -- distance in cm
        );
end sensor_driver;

architecture Behavioral of sensor_driver is
    -- define FSM states
    type STATE is (idle,
                   trig,
                   tarry,
                   counting,
                   fault);
begin

end Behavioral;
