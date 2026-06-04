----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2026 11:40:45 AM
-- Design Name: 
-- Module Name: RAM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is -- Data Memory
    port ( CLK : in std_logic; 
           WE : in std_logic; -- MemWrite
           ADDR : in std_logic_vector(15 downto 0); -- ALURes
           DI : in std_logic_vector(15 downto 0); -- RD2
           DO : out std_logic_vector(15 downto 0) -- MemData
           ); 
end RAM;

architecture Behavioral of RAM is

-- actually the RAM should be (0 to 2^16-1), but that is too much for the hardware at hand: Basys3
-- curently it is (0 to 2^13-1)
type ram_type is array (0 to 8191) of std_logic_vector (15 downto 0); 
signal ramram: ram_type := (
    10 => x"0005", -- value to load when pc is 8
    11 => x"0F0F", -- here will store
    -- values used to load for ble and bge to ensure their jump condition
    19 => x"0FF0", 
    20 => x"00FF",
    others => x"0000"
); 

begin

process (CLK) 
    begin 
        if WE = '1' then 
            if(rising_edge (CLK)) then
                ramram(conv_integer(ADDR)) <= DI; 
            end if;
        else 
            DO <= ramram(conv_integer(ADDR)); 
        end if; 
end process;

end Behavioral;
