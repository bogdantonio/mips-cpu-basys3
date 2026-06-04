----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2026 11:32:57 AM
-- Design Name: 
-- Module Name: instruction_fetch - Behavioral
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

entity instruction_fetch is
    Port ( RST: in std_logic;
           
           CLK : in STD_LOGIC;
           JMP: in std_logic;
           PCSrc: in std_logic;
           BR_ADDR : in STD_LOGIC_VECTOR (15 downto 0);
           
           NEXT_ADDR : out STD_LOGIC_VECTOR (15 downto 0);
           INSTR : out STD_LOGIC_VECTOR (15 downto 0));
end instruction_fetch;

architecture Behavioral of instruction_fetch is

component ROM is
    Port (  A : in STD_LOGIC_VECTOR (15 downto 0);
           DO : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal pc: std_logic_vector(15 downto 0) := x"0000";
signal next_instruction: std_logic_vector(15 downto 0);
signal crnt_instruction: std_logic_vector(15 downto 0);

begin

ROM1: ROM port map (A => pc, DO => crnt_instruction);

INSTR <= crnt_instruction;

program_counter: process(CLK, RST)
begin
    if(RST = '1') then
        pc <= x"0000";
    elsif (rising_edge (CLK)) then
        pc <= next_instruction;
    end if;
end process;

NEXT_ADDR <= std_logic_vector(unsigned(pc) + 1);
next_instruction_address: process(CLK)
begin
    if(JMP = '1') then
        next_instruction <= "000" & crnt_instruction(12 downto 0);
    else
        if(PCSrc = '1') then
            next_instruction <= BR_ADDR;
        else
            next_instruction <= std_logic_vector(unsigned(pc) + 1);
        end if;
    end if;
end process;  

end Behavioral;
