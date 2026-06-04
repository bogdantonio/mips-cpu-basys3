----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2026 02:51:57 PM
-- Design Name: 
-- Module Name: main_control - Behavioral
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

entity main_control is
    Port ( OPCODE : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst: out std_logic;
           ExtOp: out std_logic;
           ALUSrc: out std_logic;
           Branch: out std_logic;
           Jump: out std_logic;
           ALUOp: out std_logic_vector(2 downto 0);
           MemWrite: out std_logic;
           MemToReg: out std_logic;
           RegWrite: out std_logic;
           SetImm: out std_logic
    );
end main_control;

architecture Behavioral of main_control is

begin

process(OPCODE)
begin
    case OPCODE is
        when "000" => -- R-Type Instructions
            RegDst <= '1';
            RegWrite <= '1';
            ALUSrc <= '0';
            MemWrite <= '0';
            MemToReg <= '0';
            ExtOp <= '0';
            ALUOp <= "000";
            Jump <= '0';
            Branch <= '0';
            SetImm <= '0';
        when "001" => -- lw
            RegDst <= '0';
            RegWrite <= '1';
            ALUSrc <= '1';
            MemWrite <= '0';
            MemToReg <= '1';
            ExtOp <= '1';
            ALUOp <= "101";
            Jump <= '0';
            Branch <= '0';
            SetImm <= '0';    
        when "010" => -- sw
            RegDst <= '0';
            RegWrite <= '0';
            ALUSrc <= '1';
            MemWrite <= '1';
            MemToReg <= '0';
            ExtOp <= '1';
            ALUOp <= "101";
            Jump <= '0';
            Branch <= '0';
            SetImm <= '0';  
        when "011" => -- beq
            RegDst <= '0';
            RegWrite <= '0';
            ALUSrc <= '0';
            MemWrite <= '0';
            MemToReg <= '0';
            ExtOp <= '1';
            ALUOp <= "001";
            Jump <= '0';
            Branch <= '1';
            SetImm <= '0';      
        when "100" => -- ble
            RegDst <= '0';
            RegWrite <= '0';
            ALUSrc <= '0';
            MemWrite <= '0';
            MemToReg <= '0';
            ExtOp <= '1';
            ALUOp <= "010";
            Jump <= '0';
            Branch <= '1';
            SetImm <= '0';  
        when "101" => -- bge
            RegDst <= '0';
            RegWrite <= '0';
            ALUSrc <= '0';
            MemWrite <= '0';
            MemToReg <= '0';
            ExtOp <= '1';
            ALUOp <= "011";
            Jump <= '0';
            Branch <= '1';
            SetImm <= '0';  
        when "110" => -- slti
            RegDst <= '0';
            RegWrite <= '1';
            ALUSrc <= '1';
            MemWrite <= '0';
            MemToReg <= '0';
            ExtOp <= '1';
            ALUOp <= "100";
            Jump <= '0';
            Branch <= '0';
            SetImm <= '1';
        when "111" => -- jmp
            RegDst <= '0';
            RegWrite <= '0';
            ALUSrc <= '0';
            MemWrite <= '0';
            MemToReg <= '0';
            ExtOp <= '0';
            ALUOp <= "111";
            Jump <= '1';
            Branch <= '0';
            SetImm <= '0';      
    end case; 
end process;

end Behavioral;
