----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2026 02:11:30 PM
-- Design Name: 
-- Module Name: instruction_decode - Behavioral
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

entity instruction_decode is
    Port ( CLK : in STD_LOGIC;
           INSTR : in STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end instruction_decode;

architecture Behavioral of instruction_decode is

component register_file is
    Port ( CLK : in STD_LOGIC;
           RegWr: in STD_LOGIC; 
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 :  in STD_LOGIC_VECTOR (2 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0)
           );
end component;

signal write_adress: std_logic_vector(2 downto 0);

begin

RF: register_file port map (CLK => CLK, RegWr => RegWrite, WD => WD, WA => write_adress, 
                        RA1 => INSTR(12 downto 10), RA2 => INSTR(9 downto 7), 
                        RD1 => RD1, RD2 => RD2);

process(INSTR)
begin
    if(RegDst = '0') then
        write_adress <= INSTR(9 downto 7);
    else
        write_adress <= INSTR(6 downto 4);
    end if;
    
    if(ExtOp = '0') then
        ExtImm <= "000000000" & INSTR(6 downto 0);
    else
        ExtImm <=  INSTR(6) & INSTR(6) & INSTR(6) & INSTR(6) & INSTR(6) & INSTR(6) & INSTR(6) & INSTR(6) & INSTR(6)
                    & INSTR(6 downto 0);
    end if;
end process;

func <= INSTR(2 downto 0);
sa <= INSTR(3);

end Behavioral;
