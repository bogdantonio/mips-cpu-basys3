----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2026 11:01:46 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( CLK : in STD_LOGIC;
           RST: in STD_LOGIC;
           EN : in STD_LOGIC;
           SW: in std_logic_vector(7 downto 0);
           BIT_CTRL: out std_logic_vector(8 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           
           si: out std_logic;
           sr: out std_logic;
           s: out std_logic 
           );
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end component;

component SSD is
    Port ( CLK: in std_logic;
           DIGITS : in STD_LOGIC_VECTOR (15 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component instruction_fetch is
    Port (RST: in std_logic;
           
           CLK : in STD_LOGIC;
           JMP: in std_logic;
           PCSrc: in std_logic;
           BR_ADDR : in STD_LOGIC_VECTOR (15 downto 0);
           JMP_ADDR : in std_logic_vector (15 downto 0);
           
           NEXT_ADDR : out STD_LOGIC_VECTOR (15 downto 0);
           INSTR : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component instruction_decode is
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
           sa : out STD_LOGIC;
           
           write_address_out: out std_logic_vector(2 downto 0);
           write_address_in: in std_logic_vector(2 downto 0)
           );
end component;

component main_control is
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
end component;

component ALU is
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
end component;

component RAM is -- Data Memory
    port ( CLK : in std_logic; 
           WE : in std_logic; -- MemWrite
           ADDR : in std_logic_vector(15 downto 0); -- ALURes
           DI : in std_logic_vector(15 downto 0); -- RD2
           DO : out std_logic_vector(15 downto 0) -- MemData
           ); 
end component;

-- miscellaneous signals
signal mpg_enable_1: std_logic := '0';
signal mpg_reset_1: std_logic := '0';
signal display: std_logic_vector(15 downto 0); -- SSD input
signal mpg_regwr: std_logic;

-- instruction fetch signals
signal instruction: std_logic_vector(15 downto 0);
signal nxt_adr: std_logic_vector(15 downto 0);
signal PCSrc: std_logic;
signal jmp_addr: std_logic_vector(15 downto 0);

-- instruction decode signals
signal RD1: std_logic_vector(15 downto 0);
signal RD2: std_logic_vector(15 downto 0);
signal ExtImm: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal wa_out: std_logic_vector(2 downto 0);

-- control unit signals
signal RegWr: std_logic;
signal RegDst: std_logic;
signal MemWr: std_logic;
signal MemToReg: std_logic;
signal ExtOp: std_logic;
signal SetImm: std_logic;
signal jump: std_logic;
signal branch: std_logic;
signal ALUSrc: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);

-- ALU signals
signal branch_en: std_logic; -- output from the the ALU that will enable the branch instructions
signal branch_addr: std_logic_vector(15 downto 0);
signal Set: std_logic;
signal SetReg: std_logic;
signal ALURes: std_logic_vector(15 downto 0);

-- Data Memory signals
signal MemData: std_logic_vector(15 downto 0);

-- Write Back signals
signal wd: std_logic_vector(15 downto 0) := x"0000";

-- pipeline registers
signal if_id: std_logic_vector(31 downto 0);
signal id_ex: std_logic_vector(79 downto 0);
signal ex_mem: std_logic_vector(56 downto 0);
signal mem_wb: std_logic_vector(19 downto 0);

begin

MPG1: MPG port map (CLK => CLK, BTN => EN, ENABLE => mpg_enable_1);
MPG2: MPG port map (CLK => CLK, BTN => RST, ENABLE => mpg_reset_1);

IF1: instruction_fetch port map(RST => mpg_reset_1, CLK => mpg_enable_1, 
                            JMP => jump, PCSrc => PCSrc, JMP_ADDR => jmp_addr,
                            BR_ADDR => branch_addr, NEXT_ADDR => nxt_adr, 
                            INSTR => instruction);

mpg_regwr <= mem_wb(16) AND mpg_enable_1;

if_id_stage:process(mpg_enable_1)
begin
    if (rising_edge(mpg_enable_1)) then
        if_id (15 downto 0) <= nxt_adr;
        if_id (31 downto 16) <= instruction;
        
        jmp_addr <= "000" & instruction (12 downto 0);         
    end if;
end process;

ID: instruction_decode port map(CLK => mpg_regwr, 
    INSTR => if_id (31 downto 16), WD => mem_wb (15 downto 0), 
    RegWrite => mem_wb(16), RegDst => RegDst, 
    ExtOp => ExtOp,
    RD1 => RD1, RD2 => RD2, 
    ExtImm => ExtImm,
    func => func, sa => sa, 
    write_address_out => wa_out, write_address_in => mem_wb (19 downto 17));

MC: main_control port map(OPCODE => if_id(31 downto 29 ), 
        RegDst => RegDst, RegWrite => RegWr, 
        ALUSrc => ALUSrc, ALUOp => ALUOp,
        Branch => branch, Jump=> jump, 
        MemWrite => MemWr, MemToReg => MemToReg, 
        ExtOp => ExtOp, SetImm => SetImm);        

id_ex_stage:process(mpg_enable_1)
begin
    if(rising_edge (mpg_enable_1)) then
        id_ex (2 downto 0) <= func;
        id_ex (3) <= sa;
        id_ex (19 downto 4) <= ExtImm;
        id_ex (35 downto 20) <= RD2;
        id_ex (51 downto 36) <= RD1;
        id_ex (54 downto 52) <= wa_out;
        id_ex (70 downto 55) <= if_id (15 downto 0); -- the previous nxt_adr 
        id_ex (71) <= ALUSrc;
        id_ex (74 downto 72) <= ALUOp;
        id_ex (75) <= SetImm;
        id_ex (76) <= branch;
        id_ex (77) <= MemWr;
        id_ex (78) <= RegWr;
        id_ex (79) <= MemToReg;
    end if;
end process;

ALU1: ALU port map (NEXT_ADDRESS => id_ex (70 downto 55), 
            ExtImm => id_ex (19 downto 4), RD1 => id_ex (51 downto 36), RD2 => id_ex (35 downto 20), ALUSrc => id_ex(71), 
            sa => id_ex(3), func => id_ex (2 downto 0), ALUOp => id_ex (74 downto 72), 
            branch_en => branch_en, branch_address => branch_addr, 
            ALURes => ALURes, Set => Set, SetReg => SetReg);  
            
PCSrc <= id_ex (76) AND branch_en;

ex_mem_stage:process(mpg_enable_1)
begin
    if(rising_edge (mpg_enable_1)) then
        ex_mem (15 downto 0) <= id_ex (51 downto 36); -- RD1
        ex_mem (31 downto 16) <= id_ex (35 downto 20); -- RD2
        ex_mem (47 downto 32) <= ALURes;
        ex_mem (48) <= SetReg; -- internally generated in EX stage
        ex_mem (49) <= id_ex (75); -- SetImm
        ex_mem (50) <= Set;
        ex_mem (51) <= id_ex (77); -- MemWr
        ex_mem (52) <= id_ex (78); -- RegWr
        ex_mem (53) <= id_ex (79); -- MemToReg
        ex_mem (56 downto 54) <= id_ex (54 downto 52); -- wa_out
    end if;
end process;

sr <= ex_mem(48);
si <= ex_mem(49);
s <= ex_mem(50);

RAM1: RAM port map (CLK => CLK, WE => ex_mem (51), 
                    ADDR => ex_mem (47 downto 32), DI => ex_mem (31 downto 16), DO => MemData);

write_back_setup:process(ex_mem(53), ex_mem (50), ex_mem (48), ex_mem (49), ex_mem (47 downto 32))
begin
    if(ex_mem (53) = '1') then
        WD <= MemData;
    else
        slt_slti_logic: 
        if(ex_mem (48) = '1' or ex_mem (49) = '1') then
            if(ex_mem (50) = '1') then
                WD <= x"0001";
            else
                WD <= x"0000";
            end if;
        else
            WD <= ex_mem (47 downto 32);    
        end if;
    end if;
end process;

mem_wb_stage:process(mpg_enable_1)
begin
    if(rising_edge (mpg_enable_1)) then
        mem_wb (15 downto 0) <= WD;
        mem_wb (16) <= ex_mem (52); -- RegWr
        mem_wb (19 downto 17) <= ex_mem (56 downto 54); -- wa_out
    end if;
end process;

control_signals:process(sw(0))
begin
    if(sw(0) = '0') then
        BIT_CTRL <= ALUSrc & branch & jump & SetImm & ExtOp & MemToReg & MemWr & RegDst & RegWr;
    else
        BIT_CTRL <= "000000" & ALUOp;
    end if;
end process;  
  
display_control:process(SW)
begin
    case SW(7 downto 5) is
       when "000" => display <= instruction;
       when "001" => display <= nxt_adr;
       when "010" => display <= RD1;
       when "011" => display <= RD2;
       when "100" => display <= ExtImm;
       when "101" => display <= ALURes;
       when "110" => display <= MemData; 
       when "111" => display <= wd;
   end case;
end process;

SSD1: SSD port map (CLK => CLK, DIGITS => display, CAT => CAT, AN => AN);

end Behavioral;
