library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
    Port (  A : in STD_LOGIC_VECTOR (15 downto 0);
           DO : out STD_LOGIC_VECTOR (15 downto 0));
end ROM;

architecture Behavioral of ROM is

type rom_type is array(0 to 65535) of std_logic_vector(15 downto 0);
signal romrom: rom_type := (
    -- NOP: x"1B60", -- add: 000/1 10/11 0/110 /0/000 | add $6 $6 $6

    -- R-Type Instructions: opcode | src | target | dest | sa | function
    0 => x"0DF0", -- add: 000/0 11/01 1/111 /0/000 | add $7 $3 $3
    1 => x"1171", -- sub: 000/1 00/01 0/111 /0/001 | sub $7 $4 $2
    2 => x"023A", -- sll: 000/0 00/10 0/011 /1/010 | sll $3 $4
    3 => x"013B", -- srl: 000/0 00/01 0/011 /1/011 | srl $3 $2
    4 => x"1E14", -- and: 000/1 11/10 0/001 /0/100 | and $1 $7 $4
    5 => x"0A15", -- or:  000/0 10/10 0/001 /0/101 | or $1 $2 $4
    6 => x"0A16", -- xor: 000/0 10/10 0/001 /0/110 | xor $1 $2 $4
    7 => x"1B60",
    8 => x"1B60",
    9 => x"1B60",
    10 => x"1B60",
    11 => x"0507", -- slt: 000/0 01/01 0/000 /0/111 | $1 < $2 ? $0 <- 1 : $0 <- 0 // if done w/ cond jmps in assembly
     -- I-Type Instructions opcode | src | target | immediate
    12 => x"3085",  -- lw: 001/1 00/00 1/000 0101 | $1 <- MEM[$4 + 5] // ADD then MOV
    
    13 => x"5106",  -- sw: 010/1 00/01 0/000 0110 | MEM[$4 + 6] <- $2 // ADD then MOV
    14 => x"1B60",
    15 => x"1B60",
    16 => x"1B60",
    17 => x"1B60",
    18 => x"3086", -- lw: 001/1 00/00 1/000 0110 | $1 <- MEM[$4 + 6]
    19 => x"3386", -- lw: 001/1 00/11 1/000 0110
    20 => x"1B60",
    21 => x"1B60",
    22 => x"1B60",
    23 => x"1B60",
    24 => x"7CC0", -- beq: 011/1 11/00 1/100 0000 | CMP $7 $1 JE 64 -- THIS IMMEDIATE WILL GET SIGN EXTENDED TO xFFC0: 65472  
    25 => x"1B60",
    26 => x"1B60", 
    
    65497 => x"308E", -- lw: 001/1 00/00 1/000 E
    65498 => x"338F", -- lw: 001/1 00/11 1/000 F
    65499 => x"1B60",
    65500 => x"1B60",
    65501 => x"1B60",
    65502 => x"1B60",
    65503 => x"E01B", -- jump 27
    65504 => x"1B60",
    
    27 => x"9CA0", -- ble: 100/1 11/00 1/010 0000 | CMP $7 $1 JLE 32
    28 => x"1B60",
    29 => x"1B60",
    
    60 => x"308F", -- 001/1 00/00 1/000 F
    61 => x"338F", -- 001/1 00/11 1/000 F
    62 => x"1B60",
    63 => x"1B60",
    64 => x"1B60",
    65 => x"1B60",
    66 => x"BC90", -- bge: 101/1 11/00 1/001 0000 | CMP $7 $1 JGE 16
    67 => x"1B60",
    68 => x"1B60",
    
    83 => x"C5C8", -- slti: 110/0 01/01 1/100 1000 | $1 < 65484 ? $3 <- 1 : $3 <- 0 // if done w/ cond jmps in assembly
    -- J-Type Instructions opcode | jump adress
    84 => x"E000", -- jmp: 111/0 0000 0011 1000 | JMP 0
    85 => x"1B60",

    others => x"0000"
);

begin

DO <= romrom(conv_integer(A));

end Behavioral;
