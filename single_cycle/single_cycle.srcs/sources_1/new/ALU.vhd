----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2026 11:40:45 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( NEXT_ADDRESS: in std_logic_vector(15 downto 0);
           ExtImm: in std_logic_vector (15 downto 0);
           RD2: in std_logic_vector(15 downto 0);
           RD1: in std_logic_vector(15 downto 0);
           ALUSrc: in std_logic;
           sa: in std_logic;
           func: in std_logic_vector(2 downto 0);
           ALUOp: in std_logic_vector(2 downto 0);
           branch_en: out std_logic;
           branch_address: out std_logic_vector(15 downto 0);
           ALURes: out std_logic_vector(15 downto 0);
           Set: out std_logic; -- whether to set or not
           SetReg: out std_logic -- control to tell whether the slt instruction want to set
           );
end ALU;

architecture Behavioral of ALU is

signal operation: std_logic_vector(3 downto 0);
signal op1: std_logic_vector(15 downto 0);
signal op2: std_logic_vector(15 downto 0);

begin

op1 <= RD1;
op2 <= RD2 when ALUSrc = '0' else ExtImm;

ALU: process(operation)
begin
    DEFAULT_OUTPUT:
    Set <= '0';
    branch_en <= '0';
    branch_address <= x"0000";

    OPERATIONS:
    case operation is
        when x"0" => -- add: add
            ALURes <= op1 + op2;
        when x"1" => -- sub
            ALURes <= op1 - op2;
        when x"2" => -- sll
            ALURes <= op2(14 downto 0) & '0';
        when x"3" => -- srl
            ALURes <= '0' & op2(15 downto 1);
        when x"4" => -- and
            ALURes <= op1 and op2;
        when x"5" => -- or
            ALURes <= op1 or op2;
        when x"6" => -- xor
            ALURes <= op1 xor op2;
        when x"7" => -- compare strictly less for slt and slti
            if (op1 < op2) then
                Set <= '1';
            end if;       
        when x"8" => -- compare equal for beq
            if(op1 = op2) then
                branch_en <= '1';
                branch_address <= ExtImm + NEXT_ADDRESS;
            end if;
        when x"9" => -- compare less or equal for ble
            if(op1 <= op2) then
                branch_en <= '1';
                branch_address <= ExtImm + NEXT_ADDRESS;
            end if; 
        when x"A" => -- compare greater or equal for bge
            if(op1 >= op2) then
                branch_en <= '1';
                branch_address <= ExtImm + NEXT_ADDRESS;
            end if;
        when others => 
            ALURes <= x"FFFF";
    end case;
end process;

ALU_CONTROL:process(ALUOp, func)
begin
    SetReg <= '0';

    case ALUOp is
        when "000" =>
            case func is
                when "000" => operation <= "0000"; -- add
                when "001" => operation <= "0001"; -- sub
                when "010" => operation <= "0010"; -- sll
                when "011" => operation <= "0011"; -- srl
                when "100" => operation <= "0100"; -- and
                when "101" => operation <= "0101"; -- or
                when "110" => operation <= "0110"; -- xor
                when "111" => -- slt
                    operation <= "0111"; 
                    SetReg <= '1';
            end case;    
        when "001" => operation <= "1000"; -- beq 
        when "010" => operation <= "1001"; -- ble 
        when "011" => operation <= "1010"; -- bge
        -- for slti, have the same operation = "0111" since is the same type of comparison
        when "100" => operation <= "0111"; -- slti
        when "101" => operation <= "0000"; -- lw/sw: both use add
        when others => operation <= "1111";
    end case;
end process;
    
end Behavioral;
