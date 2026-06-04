----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2026 11:40:45 AM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

-- mono-pulse generator
entity MPG is
    Port ( CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
    signal en_reg: std_logic_vector(15 downto 0) := x"0000";

    signal en_reg1: std_logic := '0';
    signal en_reg2: std_logic := '0';
    signal en_reg3: std_logic := '0';
begin
    -- counter
    process(CLK)
    begin
        if(rising_edge(CLK)) 
            then en_reg <= std_logic_vector(unsigned (en_reg) + 1);
        end if;
    end process;

    -- register
    process(CLK, en_reg, BTN)
    begin
        if(rising_edge(CLK)) then
            if(en_reg = x"FFFF") then
                en_reg1 <= BTN;      
            end if;
            
            en_reg2 <= en_reg1;
            en_reg3 <= en_reg2;
        end if;
    end process;
    
    -- output
    ENABLE <= en_reg2 and not en_reg3;


end Behavioral;
