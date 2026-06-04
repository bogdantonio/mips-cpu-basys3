----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2026 11:40:45 AM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

-- seven segment display
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( CLK: in std_logic;
           DIGITS : in STD_LOGIC_VECTOR (15 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal counter_state: std_logic_vector(15 downto 0) := x"FFFF";
signal sel: std_logic_vector(1 downto 0);
signal digit_out: std_logic_vector (3 downto 0);

begin
    -- counter
    process(CLK)
    begin
        if(rising_edge(CLK)) then
            counter_state <= std_logic_vector(unsigned(counter_state) + 1);
        end if;
    end process;
    
    -- multiplexors selection signal
    sel <= counter_state(15) & counter_state(14);
    
    -- multiplexors
    process(counter_state)
    begin
        case sel is 
            when "00" => 
                digit_out <= DIGITS(3 downto 0);
                AN <= "1110"; 
            when "01" => 
                digit_out <= DIGITS(7 downto 4);
                AN <= "1101";
            when "10" => 
                digit_out <= DIGITS(11 downto 8);
                AN <= "1011";
            when others => 
                digit_out <= DIGITS(15 downto 12);
                AN <= "0111";
        end case;
    end process;
    
    -- hex to seven segment decoder
    process(digit_out)
    begin
        case digit_out is
            when "0000" => CAT <= "1000000";
            when "0001" => CAT <= "1111001";
            when "0010" => CAT <= "0100100";
            when "0011" => CAT <= "0110000";
            when "0100" => CAT <= "0011001";
            when "0101" => CAT <= "0010010";
            when "0110" => CAT <= "0000010";
            when "0111" => CAT <= "1111000";
            when "1000" => CAT <= "0000000";
            when "1001" => CAT <= "0010000";
            
            when "1010" => CAT <= "0001000";
            when "1011" => CAT <= "0000011";
            when "1100" => CAT <= "1000110";
            when "1101" => CAT <= "0100001";
            when "1110" => CAT <= "0000110";
            when "1111" => CAT <= "0001110";
            
            when others => CAT <= "1111111"; -- digit off
        end case;
    end process;

end Behavioral;
