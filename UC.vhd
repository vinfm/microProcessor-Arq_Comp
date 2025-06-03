library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port( 
        clk        : in std_logic;
        instr      : in unsigned(15 downto 0); -- Instrução de 16 bits
        rst        : in std_logic;
        data_in    : in unsigned(6 downto 0);
        estado     : in unsigned(1 downto 0); -- Estado de 2 bits
        data_out   : out unsigned(6 downto 0);
        sourceB    : out std_logic;
        wr_enBanco : out std_logic;
        wr_enA     : out std_logic;
        wr_enIR    : out std_logic;
        OP_ULA     : out unsigned(1 downto 0);
        banco_rcv  : out unsigned(2 downto 0);
        A_rcv      : out unsigned(2 downto 0);
        wr_enPC    : out std_logic
        
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

    is_add  <= '1' when opcode = "0101" and instr(2 downto 0) = "111" else '0';
    is_sub  <= '1' when opcode = "0101" and instr(2 downto 0) = "000" else '0';
    is_subi <= '1' when opcode = "0110" else '0';
    is_cmpi <= '1' when opcode = "1001" else '0';
    is_ld   <= '1' when opcode = "0010" else '0';
    is_mov  <= '1' when opcode = "0100" else '0';
    is_jump <= '1' when opcode = "1111" else '0';
    is_nop  <= '1' when opcode = "0000" else '0';

begin

     wr_enBanco <= '1' when (
                            estado = "10" and 
                            (is_mov = '1'  or 
                            is_ld = '1')
                            ) else '0';

    wr_enA <= '1' when (
                        estado = "10" and 
                        (is_add = '1' or 
                        is_sub = '1'  or
                        is_subi = '1' or
                        is_cmpi = '1' or
                        is_mov = '1')
                        ) else '0';

    wr_enPC <= '1' when (estado = "10" and is_jump = '1') else '0'; --Só habilita escrita no PC no execute de JUMP

    wr_enIR <= '1' when (estado = "00") else '0'; -- Só carrega coisa em IR se é fetch

   jump_en <=  '1' when opcode="1111" else '0'; 
   nop_en  <=  '1' when opcode="0000" else '0';

   OP_ULA <=  "00" when is_add = '1' else
              "01" when is_sub = '1' or is_cmpi = '1' or is_subi = '1' else
              "00";


    --PC só muda no execute de JUMP, senão incrementa normalmente
    data_out <= instr(6 downto 0) when (estado = "10" and is_jump = '1') else
                data_in + 1       when (estado = "10") else
                data_in;           -- fetch ou decode: mantém


    -- Instancia o registrador de 1 bit
    
end architecture;