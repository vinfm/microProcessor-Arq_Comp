library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port( 
        clk             : in std_logic; --clock
        rst             : in std_logic --reset geral
   );
end entity;

architecture a_processador of processador is
    component PCMaisUCMaisROM 
    port( 
        clk        : in std_logic; --clock
        rst        : in std_logic; --reset geral
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
    end component;

    component regsMaisULA 
    port(
         clk      : in std_logic; --clock
         rst      : in std_logic; --reset geral
         B_wen    : in std_logic; --habilita escrita no banco de registradores
         ula_op   : in unsigned(1 downto 0); --código de operação da ULA
         data_wr  : in unsigned(15 downto 0); --dado a escrever no banco de registradores
         const    : in unsigned(15 downto 0); --constante
         reg_wr   : in unsigned(2 downto 0); --registrador a escrever o dado no banco de registradores
         reg_r1   : in unsigned(2 downto 0); --registrador a ler do banco de registradores
         sel_ULA_optr : in unsigned(1 downto 0); --seleciona o segundo operador da ULA
         data_wr_bRegs_sel :in unsigned(1 downto 0); --seleciona fonte de dados para o banco de registradores
         A_wr_sel : in unsigned(1 downto 0); --seleciona fonte do dado a escrever no A
         A_wen    : in std_logic;  --habilita escrita no acumulador
         overflow : out std_logic; --flag de overflow da ULA
         negativo : out std_logic; --flag de negativo da ULA
         zero     : out std_logic  --flag de zero da ULA
        );
    end component; 

    signal wr_enBanco_s, wr_enA_s, negativo, overflow, zero: std_logic; -- Sinais de controle
    signal sourceB_s: unsigned(1 downto 0); -- Fonte do segundo operando da ULA
    signal banco_rcv_s, A_rcv_s: unsigned(1 downto 0);
    signal const_s: unsigned(15 downto 0); -- Constante a ser usada

    signal op_ULA_s: unsigned(1 downto 0); -- Código de operação da ULA
    signal reg_src_s, rd_s: unsigned(2 downto 0); -- Registradores fonte e destino
    signal mem_data_read: unsigned(15 downto 0); -- Dado lido da memória (simulação não usa memória)
    
begin

    PC_UC_ROM: PCMaisUCMaisROM
        port map(
            clk        => clk,
            rst        => rst,
            sourceB    => sourceB_s, -- Fonte do segundo operando da ULA
            OP_ULA     => op_ULA_s, -- Código de operação da ULA
            reg_src    => reg_src_s, -- Registrador fonte 
            rd         => rd_s, -- Registrador destino 
            banco_rcv  => banco_rcv_s, -- Fonte que o banco recebe 
            A_rcv      => A_rcv_s, -- Fonte que o acumulador recebe 
            constante  => const_s, -- Constante a ser usada
            wr_enBanco => wr_enBanco_s, -- Habilita escrita no banco de registradores
            wr_enA     => wr_enA_s -- Habilita escrita no acumulador
        );

    ULA_regs: regsMaisULA
        port map(
            clk              => clk,
            rst              => rst,
            B_wen            => wr_enBanco_s, -- Habilita escrita no banco de registradores
            ula_op           => op_ULA_s, -- Código de operação da ULA
            data_wr          => mem_data_read, -- Dado a escrever no banco de registradores
            const            => const_s, -- Constante 
            reg_wr           => rd_s, -- Registrador a escrever 
            reg_r1           => reg_src_s, -- Registrador a ler 
            sel_ULA_optr     => sourceB_s, -- Seleciona o segundo operador da ULA
            data_wr_bRegs_sel=> banco_rcv_s, -- Seleciona fonte de dados para o banco de registradores
            A_wr_sel         => A_rcv_s, -- Seleciona fonte do dado a escrever no A
            A_wen            => wr_enA_s, -- Habilita escrita no acumulador
            overflow         => overflow, -- Flag de overflow da ULA 
            negativo         => negativo, -- Flag de negativo da ULA 
            zero             => zero  -- Flag de zero da ULA 
        );

end architecture;