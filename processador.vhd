library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port( 
        clk      : in std_logic; --clock
        rst      : in std_logic; --reset geral
        wr_en    : in std_logic;
        data_wr  : in unsigned(15 downto 0);
        reg_wr   : in unsigned(4 downto 0);
        reg_r1   : in unsigned(4 downto 0);
        data_r1  : out unsigned(15 downto 0)
   );
end entity;

architecture a_processador of processador is
    component PCMaisUCMaisROM is
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
    end component;

    component regsMaisULA is
    port(
         clk      : in std_logic; --clock
         rst      : in std_logic; --reset geral
         B_wen    : in std_logic; --habilita escrita no banco de registradores
         ula_op   : in unsigned(2 downto 0); --código de operação da ULA
         data_wr  : in unsigned(15 downto 0); --dado a escrever no banco de registradores
         const    : in unsigned(15 downto 0); --constante
         reg_wr   : in unsigned(4 downto 0); --registrador a escrever o dado no banco de registradores
         reg_r1   : in unsigned(4 downto 0); --registrador a ler do banco de registradores
         sel_ULA_optr : in unsigned(1 downto 0); --seleciona o segundo operador da ULA
         data_wr_bRegs_sel :in unsigned(1 downto 0); --seleciona fonte de dados para o banco de registradores
         A_wr_sel : in unsigned(1 downto 0); --seleciona fonte do dado a escrever no A
         A_wen     : in std_logic;            --habilita escrita no acumulador
         overflow : out std_logic; --flag de overflow da ULA
         negativo : out std_logic; --flag de negativo da ULA
         zero     : out std_logic --flag de zero da ULA
        );
    end component; 

    begin

    

end architecture;