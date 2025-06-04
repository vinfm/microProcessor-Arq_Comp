library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCMaisUCMaisROM is
    port( 
        clk      : in std_logic; --clock
        rst      : in std_logic; --reset geral
        sourceB    : out std_logic; --fonte do segundo operando da ULA
        wr_enBanco : out std_logic; -- write enable do banco de regs
        wr_enA     : out std_logic; -- write enable do acumulador
        OP_ULA     : out unsigned(1 downto 0); -- código de operação da ULA
        banco_rcv  : out unsigned(2 downto 0); -- qual registrador vai receber dados
        A_rcv      : out unsigned(2 downto 0); -- fonte que o acumulador recebe (imediato, do mov ou da ULA)
   );
end entity;

architecture a_PCMaisUCMaisROM of PCMaisUCMaisROM is
    component PC
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
   );

    end component;

    component UC
    port(
        clk        : in std_logic; -- clock
        instr      : in unsigned(15 downto 0); -- Instrução de 16 bits
        rst        : in std_logic; --reset geral
        data_in    : in unsigned(6 downto 0); -- endereço do PC
        estado     : in unsigned(1 downto 0); -- Estado de 2 bits
        data_out   : out unsigned(6 downto 0); -- endereço do PC atualizado
        sourceB    : out std_logic; --fonte do segundo operando da ULA
        wr_enBanco : out std_logic; -- write enable do banco de regs
        wr_enA     : out std_logic; -- write enable do acumulador
        wr_enIR    : out std_logic; -- write enable do registrador da instrução
        OP_ULA     : out unsigned(1 downto 0); -- código de operação da ULA
        banco_rcv  : out unsigned(2 downto 0); -- qual registrador vai receber dados
        A_rcv      : out unsigned(2 downto 0); -- fonte que o acumulador recebe (imediato, do mov ou da ULA)
        wr_enPC    : out std_logic --habilita escrita no PC
    );
    end component;

    component maq_estados
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out std_logic -- ou unsigned(1 downto 0) se preferir
        );
    end component;

    signal estado_uc : unsigned(1 downto 0); -- Estado de 2 bits

    component rom
    port(
        clk         : in std_logic; 
        endereco    : in unsigned(6 downto 0);
        dado        : out unsigned(15 downto 0)
    );
    end component;
    signal UCout, PCout: unsigned(6 downto 0);
    signal instr_in, instr_out: unsigned(15 downto 0); -- Instrução de 16 bits
    signal sourceB_s, wr_enBanco_s, wr_enA_s: std_logic;
    signal OP_ULA_s: unsigned(1 downto 0);
    signal banco_rcv_s, A_rcv_: unsigned(2 downto 0);

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

    inst_reg : reg16bits
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            data_in  => instr_in,
            data_out => instr_out
        );

    PC_top :   PC 
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            data_in  => UCout,
            data_out => PCout
        );
    
    UC_top : UC 
        port map(
            clk      => clk,
            rst      => rst,
            instr    => instr_out,
            data_in  => PCout,
            data_out => UCout,
            estado   => estado_uc
        );
    ROM_top : rom
        port map(
            clk      => clk,
            endereco => PCout, 
            dado     => instr_in
        );
end architecture;