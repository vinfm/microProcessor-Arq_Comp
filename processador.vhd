library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
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
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic
   );
    end component;

    component regsMaisULA is
    port(
         clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         ula_op   : in unsigned(2 downto 0);
         data_wr  : in unsigned(15 downto 0);
         const    : in unsigned(15 downto 0);
         reg_wr   : in unsigned(4 downto 0);
         reg_r1   : in unsigned(4 downto 0);
         sel_ULA_optr : in unsigned(1 downto 0); --seleciona o segundo operador da ULA
         data_wr_bRegs_sel :in unsigned(1 downto 0); --seleciona fonte de dados para o banco de registradores
         A_wr_sel : in unsigned(1 downto 0); --seleciona fonte do dado a escrever no A
         A_we     : in std_logic;            --habilita escrita no acumulador
         overflow : out std_logic;
         negativo : out std_logic;
         zero     : out std_logic
        );
    end component; 

    begin

    

end architecture;