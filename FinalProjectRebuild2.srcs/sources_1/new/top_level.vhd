----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2019 10:12:24 AM
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( clock100MHz : in STD_LOGIC;
           presetValue : in STD_LOGIC_VECTOR (9 downto 0);
           demuxSelect : in STD_LOGIC;
           microblazeOperation : in STD_LOGIC_VECTOR (1 downto 0);
           uart_rtl_rxd : in STD_LOGIC;
           countButton : in STD_LOGIC;
           resetButton : in STD_LOGIC;
           presetButton : in STD_LOGIC;
           countDirection : in STD_LOGIC;
           GPIO_out : out STD_LOGIC_VECTOR (15 downto 0);
           uart_rtl_txd : out STD_LOGIC;
           ssdValue : out STD_LOGIC_VECTOR (6 downto 0);
           ssdSelect : out STD_LOGIC_VECTOR (3 downto 0)
           );
end top_level;

architecture Behavioral of top_level is

component demux_2_1
Port (
        input_1 : in STD_LOGIC_VECTOR(9 downto 0);
        sel : in STD_LOGIC;
        clk : in STD_LOGIC;
        output1 : out STD_LOGIC_VECTOR(9 downto 0);
        output2 : out STD_LOGIC_VECTOR(9 downto 0)
     );
end component;

component counter_design
Port (
       increment : in STD_LOGIC;
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       pre : in STD_LOGIC;
       count_dir : in STD_LOGIC;
       pre_val : in STD_LOGIC_VECTOR (9 downto 0);
       count_out : out STD_LOGIC_VECTOR (9 downto 0)
     );
end component;

component TenBit_to_SixteenBit
Port (
        ten_bit_input : in STD_LOGIC_VECTOR(9 downto 0);
        sixteen_bit_output : out STD_LOGIC_VECTOR (15 downto 0)
     );
end component;
 
component bin2bcd
Port (
       input : in STD_LOGIC_VECTOR (15 downto 0);
       ones : out STD_LOGIC_VECTOR (3 downto 0);
       tens : out STD_LOGIC_VECTOR (3 downto 0);
       hundreds : out STD_LOGIC_VECTOR (3 downto 0);
       thousands : out STD_LOGIC_VECTOR (3 downto 0)
     );
end component;
 
component sev_seg
Port (
       ones_input : in STD_LOGIC_VECTOR (3 downto 0);
       tens_input : in STD_LOGIC_VECTOR (3 downto 0);
       hundreds_input : in STD_LOGIC_VECTOR (3 downto 0);
       thousands_input : in STD_LOGIC_VECTOR (3 downto 0);
       clk : in STD_LOGIC;
       seg_sel : out STD_LOGIC_VECTOR (3 downto 0);
       seg_out : out STD_LOGIC_VECTOR (6 downto 0)
     );
end component;

component debouncer
Port (
        inc_in : in STD_LOGIC;
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        deb_out: out STD_LOGIC
     );
end component;

component design_1_wrapper
Port (
        clk_100MHz : in STD_LOGIC;
        gpio_rtl_0_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
        gpio_rtl_1_tri_i : in STD_LOGIC_VECTOR ( 21 downto 0 );
        reset_rtl : in STD_LOGIC;
        uart_rtl_0_rxd : in STD_LOGIC;
        uart_rtl_0_txd : out STD_LOGIC
     );
end component;

signal M72 : STD_LOGIC;
signal M12 : STD_LOGIC_VECTOR (9 downto 0);
signal M13 : STD_LOGIC_VECTOR (9 downto 0);
signal M23 : STD_LOGIC_VECTOR (9 downto 0);
signal M24 : STD_LOGIC_VECTOR (9 downto 0);
signal M45 : STD_LOGIC_VECTOR (15 downto 0);
signal M56_ones : STD_LOGIC_VECTOR (3 downto 0);
signal M56_tens : STD_LOGIC_VECTOR (3 downto 0);
signal M56_hundreds : STD_LOGIC_VECTOR (3 downto 0);
signal M56_thousands : STD_LOGIC_VECTOR (3 downto 0);

begin

M1: demux_2_1 port map(
        input_1 => presetValue,
        sel => demuxSelect,
        clk => clock100MHz,
        output1 => M12,
        output2 => M13
    );

M2 : counter_design port map(
        increment => M72,
        clk => clock100MHz,
        rst => resetButton,
        pre => presetButton,
        count_dir => countDirection,
        pre_val => M12,
        count_out => M24
    );
 
 M3: design_1_wrapper port map(
        clk_100MHz => clock100MHz,
        gpio_rtl_0_tri_o => GPIO_out,
        reset_rtl => resetButton,
        gpio_rtl_1_tri_i(1 downto 0) => microblazeOperation,
        gpio_rtl_1_tri_i(11 downto 2) => M13,
        gpio_rtl_1_tri_i(21 downto 12) => M24,
        uart_rtl_0_rxd => uart_rtl_rxd,
        uart_rtl_0_txd => uart_rtl_txd
    );
    
    
    

M4 : TenBit_to_SixteenBit port map(
        ten_bit_input => M24,
        sixteen_bit_output => M45
    );

M5: bin2bcd port map(
        input => M45,
        ones => M56_ones,
        tens => M56_tens,
        hundreds => M56_hundreds,
        thousands => M56_thousands
    );

M6: sev_seg port map(
        ones_input => M56_ones,
        tens_input => M56_tens,
        hundreds_input => M56_hundreds,
        thousands_input => M56_thousands,
        clk => clock100MHz,
        seg_sel => ssdSelect,
        seg_out => ssdValue
    );

M7: debouncer port map(
        inc_in => countButton,
        rst => resetButton,
        clk => clock100MHz,
        deb_out => M72
    );

end Behavioral;