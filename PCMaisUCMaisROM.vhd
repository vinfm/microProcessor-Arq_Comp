library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- não vejo mais serventia nesse aqui, mas vou deixar por enquanto
entity PCMaisUCMaisROM is
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
end entity;

architecture a_PCMaisUCMaisROM of PCMaisUCMaisROM is
    component PC
    port( 
        clk      : in std_logic; --clock
        rst      : in std_logic; --reset geral
        wr_en    : in std_logic; -- write enable do PC
        data_in  : in unsigned(6 downto 0); -- endereço do PC atualizado
        data_out  : out unsigned(6 downto 0) -- endereço do PC atual
   );

    end component;

    component UC
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
    end component;

    component maq_estados
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out unsigned(1 downto 0) 
        );
    end component;

    component rom
    port(
        clk         : in std_logic; 
        endereco    : in unsigned(6 downto 0);
        dado        : out unsigned(15 downto 0)
    );
    end component;

    signal UCout, PCout: unsigned(6 downto 0); -- Endereço do PC atual e próximo
    signal instr_in, instr_out: unsigned(15 downto 0); -- Instrução de 16 bits
    signal estado_uc : unsigned(1 downto 0); -- Estado de 2 bits
    signal wr_enPC_s, wr_enIR_s : std_logic; -- Sinais de controle para escrita no PC e IR

    component reg16bits 
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
begin

    maq_est : maq_estados
        port map(
            clk    => clk,
            rst    => rst,
            estado => estado_uc
        );

    instr_reg : reg16bits
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_enIR_s,
            data_in  => instr_in,
            data_out => instr_out
        );

    PC_top :   PC 
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_enPC_s,
            data_in  => UCout,
            data_out => PCout
        );
    
    UC_top : UC 
        port map(
        clk        => clk,
        rst        => rst,       
        data_in    => PCout,
        estado     => estado_uc,
        data_out   => UCout, 
        wr_enPC    => wr_enPC_s,    
        instr      => instr_out,      
        wr_enIR    => wr_enIR_s,    
        sourceB    => sourceB, 
        OP_ULA     => OP_ULA,
        reg_src    => reg_src,
        rd         => rd,
        banco_rcv  => banco_rcv, 
        A_rcv      => A_rcv, 
        constante  => constante,
        wr_enBanco => wr_enBanco,
        wr_enA     => wr_enA
        );
    ROM_top : rom
        port map(
            clk      => clk,
            endereco => PCout, 
            dado     => instr_in
        );
end architecture;