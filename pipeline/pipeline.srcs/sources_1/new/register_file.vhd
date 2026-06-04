----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2026 11:14:46 AM
-- Design Name: 
-- Module Name: register_file - Behavioral
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

entity register_file is
    Port ( CLK : in STD_LOGIC;
           RegWr: in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 :  in STD_LOGIC_VECTOR (2 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0)
           );
end register_file;

architecture Behavioral of register_file is

type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file: reg_array 
:= (0 => x"0001", 1 => x"0002", 2 => x"0003", 3 => x"0004", 
    4 => x"0005", 5 => x"0006", 6 => x"0000", 7 => x"0008");

begin

process(CLK)
begin
    if(RegWr = '1') then
        if(rising_edge(CLK)) then
            reg_file((conv_integer(WA))) <= WD;
        end if;
    end if;
end process;

RD1 <= reg_file(conv_integer (RA1));
RD2 <= reg_file(conv_integer (RA2));

end Behavioral;

