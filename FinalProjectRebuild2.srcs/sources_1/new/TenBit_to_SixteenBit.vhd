----------------------------------------------------------------------------------
-- Company: University of Louisville
-- Engineer: Kaleb Byrum
-- 
-- Create Date: 12/06/2019 09:13:49 PM
-- Design Name: 
-- Module Name: TenBit_to_SixteenBit - Behavioral
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

entity TenBit_to_SixteenBit is
    Port ( ten_bit_input : in STD_LOGIC_VECTOR (9 downto 0);
           sixteen_bit_output : out STD_LOGIC_VECTOR (15 downto 0));
end TenBit_to_SixteenBit;

architecture Behavioral of TenBit_to_SixteenBit is

begin

sixteen_bit_output <= "000000" & ten_bit_input;

end Behavioral;
