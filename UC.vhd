library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port( 
        clk        : in std_logic; -- clock
        rst        : in std_logic; --reset geral
        data_in    : in unsigned(6 downto 0); -- endereço do PC
        estado     : in unsigned(1 downto 0); -- Estado de 2 bits
        data_out   : out unsigned(6 downto 0); -- endereço do PC atualizado
        wr_enPC    : out std_logic; --habilita escrita no PC
        instr      : in unsigned(15 downto 0); -- Instrução de 16 bits
        wr_enIR    : out std_logic; -- write enable do registrador da instrução
        sourceB    : out unsigned(1 downto 0); --fonte do segundo operando da ULA
        OP_ULA     : out unsigned(1 downto 0); -- código de operação da ULA
        reg_src    : out unsigned(2 downto 0); --registrador fonte, se houver
        rd         : out unsigned(2 downto 0); --registrador destino, se houver
        banco_rcv  : out unsigned(1 downto 0); -- fonte que o banco recebe (imediato ou do mov)
        A_rcv      : out unsigned(1 downto 0); -- fonte que o acumulador recebe (imediato, do mov ou da ULA)
        constante  : out unsigned(15 downto 0); -- constante a ser usada
        wr_enBanco : out std_logic; -- write enable do banco de regs
        wr_enA     : out std_logic -- write enable do acumulador
    );
end entity;

architecture a_UC of UC is

    signal prox_estado : std_logic;
    signal prox_pc : unsigned(6 downto 0);

    
    signal is_add  : std_logic;
    signal is_sub  : std_logic;
    signal is_mov  : std_logic;
    signal is_cmpi : std_logic;
    signal is_ld   : std_logic;
    signal is_subi : std_logic;
    signal is_jump : std_logic;
    signal is_nop  : std_logic;
    signal is_memo_read : std_logic; -- Write Memory

begin

    is_add  <= '1' when instr(15 downto 12) = "0101" and instr(2 downto 0) = "111" else '0';
    is_sub  <= '1' when instr(15 downto 12) = "0101" and instr(2 downto 0) = "000" else '0';
    is_subi <= '1' when instr(15 downto 12) = "0110" else '0';
    is_cmpi <= '1' when instr(15 downto 12) = "1001" else '0';
    is_ld   <= '1' when instr(15 downto 12) = "0010" else '0';
    is_mov  <= '1' when instr(15 downto 12) = "0100" else '0';
    is_jump <= '1' when instr(15 downto 12) = "1111" else '0';
    is_nop  <= '1' when instr(15 downto 12) = "0000" else '0';
    is_memo_read <= '1' when instr(15 downto 12) = "0011" else '0'; -- Write Memory


    --habilita ou não a escrita no IR
    wr_enIR <= '1' when (estado = "00" and not (is_jump = '1' and estado = "10")) else
               '0';
            -- habilita ou não a escrita no PC
    wr_enPC <= '1' when estado = "01" else '0'; --Só habilita escrita no PC no execute de JUMP

    --PC só muda no execute de JUMP, senão incrementa normalmente
    data_out <= instr(6 downto 0) when (is_jump = '1') else
                data_in + 1       when (is_jump = '0') else
                data_in;           -- fetch ou decode: mantém

    -- Decodifica o a op da ULA
    OP_ULA <= "00" when is_add = '1' else
              "01" when is_sub = '1' or is_cmpi = '1' or is_subi = '1' else
              "00";

    -- Registrador fonte, se houver
    reg_src <= instr(8 downto 6) when (is_add = '1' or is_sub = '1' or is_ld = '1' or is_mov='1') else
             "101"; -- Se não for nenhuma dessas, não tem fonte
    -- Registrador destino, se houver
    rd <= instr(11 downto 9) when (is_ld = '1' or is_mov = '1') else -- aqui muda só em operações ld, mov e escrita de memória, provavelmente
         "111"; -- Se não for nenhuma dessas, não tem destino além do acumulador

    -- constante para LD, SUBI ou CMPI
    constante <= (15 downto 6 => instr(5)) & instr(5 downto 0) when is_subi = '1' else
                 (15 downto 9 => instr(8)) & instr(8 downto 0) when is_cmpi = '1' or is_ld = '1';

    -- Fonte do segundo operando da ULA
    sourceB <= "01" when (is_subi = '1' or is_cmpi = '1') else
               "00"; -- Se for SUBI ou CMPI, pega o imediato, senão pega do banco de regs

    -- Fonte que o banco recebe
    banco_rcv <= "00" when (is_mov='1' and instr(8 downto 6)="111" and instr(11 downto 9)/="110") else
                 "01" when (is_ld = '1' and instr(11 downto 9)/="111" and instr(11 downto 9)/="110") else
                 "10" when (is_mov='1' and instr(11 downto 9)/="111" and instr(11 downto 9)/="110") else
                 "11" when (is_memo_read='1' and instr(11 downto 9) /= "111" and instr(11 downto 9)/="110") else
                 "XX"; 

    -- Fonte que o acumulador recebe
    A_rcv <= "11" when is_memo_read='1' and instr(11 downto 9) = "111" else
             "10" when is_mov = '1' and instr(11 downto 9) = "111" else
             "01" when is_ld = '1' and instr(11 downto 9) = "111" else
             "00"; 

    wr_enBanco <= '1' when  estado="10" 
                        and (is_mov = '1' or 
                        is_ld = '1'  
                        )   else '0';

    wr_enA <= '1' when estado="10" and  (
                        is_add = '1' or 
                        is_sub = '1'  or
                        is_subi = '1' or
                        (instr(11 downto 9)="111" and (is_mov = '1' or is_ld = '1'))
                        )   else '0';

end architecture;