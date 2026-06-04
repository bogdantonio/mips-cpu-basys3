----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2026 11:42:00 AM
-- Design Name: 
-- Module Name: ROM - Behavioral
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

entity ROM is
    Port (  A : in STD_LOGIC_VECTOR (15 downto 0);
           DO : out STD_LOGIC_VECTOR (15 downto 0));
end ROM;

architecture Behavioral of ROM is

type rom_type is array(0 to 65535) of std_logic_vector(15 downto 0);
signal romrom: rom_type := (
    -- R-Type Instructions: opcode | src | target | dest | sa | function
    0 => x"0DF0", -- add: 000/0 11/01 1/111 /0/000 | add $7 $3 $3
    1 => x"1171", -- sub: 000/1 00/01 0/111 /0/001 | sub $7 $4 $2
    2 => x"023A", -- sll: 000/0 00/10 0/011 /1/010 | sll $3 $4
    3 => x"013B", -- srl: 000/0 00/01 0/011 /1/011 | srl $3 $2
    4 => x"1E14", -- and: 000/1 11/10 0/001 /0/100 | and $1 $7 $4
    5 => x"0A15", -- or:  000/0 10/10 0/001 /0/101 | or $1 $2 $4
    6 => x"0A16", -- xor: 000/0 10/10 0/001 /0/110 | xor $1 $2 $4
    7 => x"0507", -- slt: 000/0 01/01 0/000 /0/111 | $1 < $2 ? $0 <- 1 : $0 <- 0 // if done w/ cond jmps in assembly
     -- I-Type Instructions opcode | src | target | immediate
    8 => x"3085",  -- lw: 001/1 00/00 1/000 0101 | $1 <- MEM[$4 + 5] // ADD then MOV
    9 => x"5106",  -- sw: 010/1 00/01 0/000 0110 | MEM[$4 + 6] <- $2 // ADD then MOV

    10 => x"3086", -- lw: 001/1 00/00 1/000 0110 | $1 <- MEM[$4 + 6]
    11 => x"3386", -- lw: 001/1 00/11 1/000 0110
    12 => x"7CC0", -- beq: 011/1 11/00 1/100 0000 | CMP $7 $1 JE 64 -- THIS IMMEDIATE WILL GET SIGN EXTENDED END WILL END UP AS xFFC0
    
    13 => x"308E", -- lw: 001/1 00/00 1/000 E
    14 => x"338F", -- lw: 001/1 00/11 1/000 F
    15 => x"9CA0", -- ble: 100/1 11/00 1/010 0000 | CMP $7 $1 JLE 32
    
    16 => x"308F", -- 001/1 00/00 1/000 F
    17 => x"338F", -- 001/1 00/11 1/000 F
    18 => x"BC90", -- bge: 101/1 11/00 1/001 0000 | CMP $7 $1 JGE 16
    
    19 => x"C588", -- slti: 110/0 01/01 1/000 1000 | $1 < 8 ? $3 <- 1 : $3 <- 0 // if done w/ cond jmps in assembly
     -- J-Type Instructions opcode | jump adress
    20 => x"E038", -- jmp: 111/0 0000 0011 1000 | JMP 56
    
    65485 => x"0A16", -- xor that the beq will jump to
    65486 => x"E00D", -- jump back to ble
    48 => x"0A15", -- or that ble will jump to
    49 => x"E010", -- jump back to bge
    35 => x"1E14", -- and that bge will jump to
    36 => x"E013", -- jump back to slti
    56 => x"0DF0", -- add that jmp will jump to
    57 => x"E000", -- jump back to program beginning
    
    others => x"0000"
);

begin

DO <= romrom(conv_integer(A));

end Behavioral;
