----------------------------------------------------------------------------------
-- Company: University of Louisville
-- Engineer: Nathan Hodges
-- 
-- Create Date: 12/05/2019 04:09:43 PM
-- Design Name: 
-- Module Name: alu_design - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_design is
    Port ( increment : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pre : in STD_LOGIC;
           count_dir : in STD_LOGIC;
           pre_val : in STD_LOGIC_VECTOR (9 downto 0);
           count_out : out STD_LOGIC_VECTOR (9 downto 0));
end counter_design;

architecture Behavioral of counter_design is

signal count : std_logic_vector (9 downto 0);               --INTERNAL COUNTING SIGNAL
signal lastButtonState : std_logic := '0';


begin

    process(increment, clk, rst, pre, count_dir)                   --DEBOUNCED COUNTER PROCESS
    begin

        if (rst = '1') then                                 --CHECK IF RESET IS ACTIVE
            
            count <= (others => '0');
            
        else
            if (clk'event and clk = '1') then
            
                if (increment = '0') then
                    lastButtonState <= increment; --Last Button State resets to 0 when button is unpressed.
                end if;
            
            
                if (increment = '1') then                      --BEGIN SYN COUNTING PROCESSES
                    if (lastButtonState = '0') then
                    
                        lastButtonState <= increment; --Goes to 1 and will stay 1 for multiple cycles
                
                        if (pre = '1') then                         --PRESET VALLUE IF PRE IS ACTIVE
                    
                            if (pre_val <= "1111101000") then       --ONLY PRESET TO A MAXIMUM OF 1,000
                            
                                count <= pre_val;
                            
                            else
                        
                                count <= "1111101000";
                            
                            end if;
                            
                        else                                        --NORMAL SEQUENCE W/O RST/PRE ACTIVE
                        
                            if (count_dir = '0') then               --COUNT UP SEQUENCE
                            
                                if (count = "1111101000") then
                                
                                    count <= (others => '0');       --RESTART COUNT AT 0 WHEN HITTING MAX
                                
                                else
                                
                                    count <= count + 1;             --COUNT UP BY 1
                                    
                                
                                end if;
                            
                            else                                    --COUNT DOWN SEQUENCE
                            
                                if (count = "0000000000") then   --RESTART COUNT AT 1000 WHEN HITTING MIN
                                
                                    count <= "1111101000";
                                
                                else
                                
                                    count <= count - 1;             --COUNT DOWN BY 1
                                                            
                                end if;
                            
                            end if;
                            
                        end if;
                            
                    else
                    
                        null;                                       --NO CLOCK, DO NOTHING
                    
                    end if; --SYN IF
                    
               end if; --END master clock if
                
            end if; --ASYN IF
            
        end if;
        
        count_out <= count;
                
    end process;

end Behavioral;
