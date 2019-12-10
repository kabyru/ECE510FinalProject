----------------------------------------------------------------------------------
-- Company: University of Louisville
-- Engineer: Kaleb Byrum
-- 
-- Create Date: 12/06/2019 08:05:41 PM
-- Design Name: 
-- Module Name: demux_2_1 - Behavioral
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

entity demux_2_1 is
    Port ( 
           input_1   : in STD_LOGIC_VECTOR(9 downto 0);
           sel       : in STD_LOGIC;
           output1   : out STD_LOGIC_VECTOR(9 downto 0);
           output2   : out STD_LOGIC_VECTOR(9 downto 0);
           clk       : in STD_LOGIC
           );
end demux_2_1;

architecture Behavioral of demux_2_1 is
begin

process(clk)
begin
if (clk'event and clk = '1') then
    if (sel = '0') then
        output1 <= input_1;
        --output2 <= "0000000000";
    else
        output2 <= input_1;
        --output1 <= "0000000008";
    end if;
end if;
end process;
    
end Behavioral;
