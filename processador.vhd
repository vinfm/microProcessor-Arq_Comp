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
-- PC + UC + maquina de estados + ROM --
    component maq_estados
    port(
        clk    : in std_logic;
        rst    : in std_logic;
        estado : out unsigned(1 downto 0) 
    );
    end component;

    component reg7bits --para o PC
    port( 
        clk      : in std_logic; --clock
        rst      : in std_logic; --reset
        wr_en    : in std_logic; 
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    );
    end component;

    component rom
    port(
        clk         : in std_logic; 
        endereco    : in unsigned(6 downto 0);
        dado        : out unsigned(15 downto 0)
    );
    end component;

    component UC
    port(
        clk        : in std_logic; -- clock
        rst        : in std_logic; --reset geral
        data_in    : in unsigned(6 downto 0); -- endereço do PC
        estado     : in unsigned(1 downto 0); -- Estado de 2 bits
        instr      : in unsigned(15 downto 0); -- Instrução de 16 bits
        flag_zero : in std_logic; -- Flag de zero, usada para comparações
        flag_neg  : in std_logic; -- Flag de negativo, usada para comparações
        flag_overflow : in std_logic; -- Flag de overflow, usada para comparações
        data_out   : out unsigned(6 downto 0); -- endereço do PC atualizado
        wr_enPC    : out std_logic; --habilita escrita no PC
        wr_enIR    : out std_logic; -- write enable do registrador da instrução
        sourceB    : out unsigned(1 downto 0); --fonte do segundo operando da ULA
        OP_ULA     : out unsigned(1 downto 0); -- código de operação da ULA
        reg_src    : out unsigned(2 downto 0); --registrador fonte, se houver
        rd         : out unsigned(2 downto 0); --registrador destino, se houver
        banco_rcv  : out unsigned(1 downto 0); -- fonte que o banco recebe (imediato ou do mov)
        A_rcv      : out unsigned(1 downto 0); -- fonte que o acumulador recebe (imediato, do mov ou da ULA)
        constante  : out unsigned(15 downto 0); -- constante a ser usada
        wr_enBanco : out std_logic; -- write enable do banco de regs
        wr_enA     : out std_logic; -- write enable do acumulador
        wr_en_f    : out std_logic -- write enable do registrador de flags
    );
    end component;

    signal UCout, PCout: unsigned(6 downto 0); -- Endereço do PC atual e próximo
    signal instr_in, instr_out: unsigned(15 downto 0); -- Instrução de 16 bits
    signal estado_uc : unsigned(1 downto 0); -- Estado de 2 bits
    signal wr_enPC_s, wr_enIR_s : std_logic; -- Sinais de controle para escrita no PC e IR
-- termina PC + UC + maquina de estados + ROM --

    component reg16bits 
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

-- Banco de Registradores + ULA + Acumulador --
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
-- Fim Banco de Registradores + ULA + Acumulador --

-- Sinais de controle e fontes de dados --
    signal wr_enBanco_s, wr_enA_s, wr_en_f_s: std_logic; -- sinais de write enable
    signal ff_z_i, ff_z_o, ff_n_i, ff_n_o, ff_v_i, ff_v_o: std_logic; -- Sinais de entrada e saídas dos flip flops de flags
    signal sourceB_s: unsigned(1 downto 0); -- Fonte do segundo operando da ULA
    signal banco_rcv_s, A_rcv_s: unsigned(1 downto 0);
    signal const_s: unsigned(15 downto 0); -- Constante a ser usada

    signal op_ULA_s: unsigned(1 downto 0); -- Código de operação da ULA
    signal reg_src_s, rd_s: unsigned(2 downto 0); -- Registradores fonte e destino
    signal mem_data_read: unsigned(15 downto 0); -- Dado lido da memória (simulação não usa memória)
    
-- Flip Flops para armazenar as flags
    component reg1bit 
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in std_logic; 
        data_out : out std_logic  
        );
    end component;

begin

    maq_est : maq_estados
        port map(
            clk    => clk,
            rst    => rst,
            estado => estado_uc -- Estado de 2 bits
        );

    UC_top : UC 
        port map(
            clk        => clk,
            rst        => rst,       
            data_in    => PCout,
            estado     => estado_uc,
            instr      => instr_out,
            flag_zero  => ff_z_o, -- Flag de zero
            flag_neg   => ff_n_o, -- Flag de negativo
            flag_overflow => ff_v_o, -- Flag de overflow
            data_out   => UCout, 
            wr_enPC    => wr_enPC_s,         
            wr_enIR    => wr_enIR_s,    
            sourceB    => sourceB_s, 
            OP_ULA     => op_ULA_s,
            reg_src    => reg_src_s,
            rd         => rd_s,
            banco_rcv  => banco_rcv_s, 
            A_rcv      => A_rcv_s, 
            constante  => const_s,
            wr_enBanco => wr_enBanco_s,
            wr_enA     => wr_enA_s,
            wr_en_f    => wr_en_f_s 
        );

    PC: reg7bits
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_enPC_s, -- Habilita escrita no PC
            data_in  => UCout, -- Endereço do PC atualizado
            data_out => PCout -- Endereço do PC atual
        );

    ROM_instr : rom
        port map(
            clk      => clk,
            endereco => PCout, 
            dado     => instr_in
        );

    instr_reg : reg16bits
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_enIR_s,
            data_in  => instr_in,
            data_out => instr_out
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
            overflow         => ff_v_i, -- Flag de overflow da ULA 
            negativo         => ff_n_i, -- Flag de negativo da ULA 
            zero             => ff_z_i  -- Flag de zero da ULA 
        );

    ff_negativo: reg1bit
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en_f_s, 
            data_in  => ff_n_i, -- Flag de negativo da ULA
            data_out => ff_n_o -- Saída da flag de negativo
        );

    ff_overflow: reg1bit
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en_f_s, 
            data_in  => ff_v_i, -- Flag de overflow da ULA
            data_out => ff_v_o -- Saída da flag de overflow
        );

    ff_zero: reg1bit
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en_f_s, -- Habilita escrita no acumulador
            data_in  => ff_z_i, -- Flag de zero da ULA
            data_out => ff_z_o -- Saída da flag de zero
        );


end architecture;