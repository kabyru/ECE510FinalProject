----------------------------------------------------------------------------------
-- Company: University of louisville
-- Engineer: Kaleb Byrum
-- 
-- Create Date: 12/08/2019 02:49:51 PM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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

entity debouncer is
    Port ( inc_in : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           deb_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

signal Q1, Q2, Q3, Q4, Q5, Q_OUT : std_logic;

begin

process(clk)
begin
    if (clk'event and clk = '1') then
        if (rst = '1') then
            Q1 <= '0';
            Q2 <= '0';
            Q3 <= '0';
            Q4 <= '0';
            Q5 <= '0';

        else
            Q1 <= inc_in;
            Q2 <= Q1;
            Q3 <= Q2;
            Q4 <= Q3;
            Q5 <= Q4;
            
        end if;
    end if;
end process;
deb_out <= Q1 and Q2 and Q3 and Q4 and (not Q5);

end Behavioral;
