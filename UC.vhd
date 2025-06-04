library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port( 
        clk        : in std_logic; -- clock
        instr      : in unsigned(15 downto 0); -- Instrução de 16 bits
        rst        : in std_logic; --reset geral
        data_in    : in unsigned(6 downto 0); -- endereço do PC
        estado     : in unsigned(1 downto 0); -- Estado de 2 bits
        data_out   : out unsigned(6 downto 0); -- endereço do PC atualizado
        sourceB    : out unsigned(1 downto 0); --fonte do segundo operando da ULA
        wr_enBanco : out std_logic; -- write enable do banco de regs
        wr_enA     : out std_logic; -- write enable do acumulador
        wr_enIR    : out std_logic; -- write enable do registrador da instrução
        OP_ULA     : out unsigned(1 downto 0); -- código de operação da ULA
        banco_rcv  : out unsigned(2 downto 0); -- fonte que o banco recebe (imediato ou do mov)
        A_rcv      : out unsigned(2 downto 0); -- fonte que o acumulador recebe (imediato, do mov ou da ULA)
        wr_enPC    : out std_logic; --habilita escrita no PC
        constante  : out unsigned(15 downto 0) -- constante a ser usada
    );
end entity;

architecture a_UC of UC is


    signal opcode: unsigned(15 downto 12);
    signal func3 : unsigned(2 downto 0);

    signal prox_estado : std_logic;
    signal prox_pc : unsigned(6 downto 0);

    
    signal add_en  : std_logic;
    signal sub_en  : std_logic;
    signal mov_en  : std_logic;
    signal cmpi_en : std_logic;
    signal ld_en   : std_logic;
    signal subi_en : std_logic;
    signal jump_en : std_logic;
    signal nop_en  : std_logic;

    signal

    is_add  <= '1' when opcode = "0101" and instr(2 downto 0) = "111" else '0';
    is_sub  <= '1' when opcode = "0101" and instr(2 downto 0) = "000" else '0';
    is_subi <= '1' when opcode = "0110" else '0';
    is_cmpi <= '1' when opcode = "1001" else '0';
    is_ld   <= '1' when opcode = "0010" else '0';
    is_mov  <= '1' when opcode = "0100" else '0';
    is_jump <= '1' when opcode = "1111" else '0';
    is_nop  <= '1' when opcode = "0000" else '0';
    is_memo_wr <= '1' when opcode = "0011" else '0'; -- Write Memory

begin

    --habilita ou não a escrita no IR
    wr_enIR <= '1' when (estado = "00") else '0'; -- Só carrega coisa em IR se é fetch

            -- habilita ou não a escrita no PC
    wr_enPC <= '1' when (is_jump = '1') or estado = "10" else '0'; --Só habilita escrita no PC no execute de JUMP

    -- Decodifica o opcode
    OP_ULA <= "00" when is_add = '1' else
              "01" when is_sub = '1' or is_cmpi = '1' or is_subi = '1' else
              "00";

    --PC só muda no execute de JUMP, senão incrementa normalmente
    data_out <= instr(6 downto 0) when (estado = "10" and is_jump = '1') else
                data_in + 1       when (estado = "10" and is_jump = '0') else
                data_in;           -- fetch ou decode: mantém

    -- constante para LD, SUBI ou CMPI
    constante <= (15 downto 6 => instr(5)) & instr(5 downto 0) when is_subi = '1' else
                 (15 downto 9 => instr(8)) & instr(8 downto 0) when is_cmpi = '1' or is_ld = '1';

    -- Fonte do segundo operando da ULA
    sourceB <= "01" when (is_subi = '1' or is_cmpi = '1') else
               "00"; -- Se for SUBI ou CMPI, pega o imediato, senão pega do banco de regs

    -- Fonte que o banco recebe
    banco_rcv <= "00" when (is_mov='1' and instr(8 downto 6)="000") else
                 "01" when (is_ld = '1' and instr(11 downto 9)/="000") else
                 "10" when (is_mov='1' and instr(11 downto 9)/="000") else
                 "11" when (is_memo_wr='1' and instr(11 downto 9) /= "000") else
                 "XX"; 

    -- Fonte que o acumulador recebe
    A_rcv <= "11" when is_memo_wr='1' and instr(11 downto 9) = "000" else
             "10" when is_mov = '1' and instr(11 downto 9) = "000" else
             "01" when is_ld = '1' and instr(11 downto 9) = "000" else
             "00"; 

    wr_enBanco <= '1' when  estado="10" 
                        and (is_mov = '1'  or 
                        is_ld = '1'
                        ) else '0';

    wr_enA <= '1' when estado="10" and  (
                        is_add = '1' or 
                        is_sub = '1'  or
                        is_subi = '1' or
                        is_cmpi = '1' or
                        is_mov = '1'
                        ) else '0';

end architecture;