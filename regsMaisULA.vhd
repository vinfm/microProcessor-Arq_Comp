library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regsMaisULA is
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
end entity;

architecture a_regsMaisULA of regsMaisULA is

    component bancoRegs 
        port( 
            clk      : in std_logic; --clock
            rst      : in std_logic; --reset geral
            wr_en    : in std_logic; -- write enable do banco de regs
            data_wr  : in unsigned(15 downto 0); --dado a escrever no banco de registradores
            reg_wr   : in unsigned(4 downto 0); --registrador a escrever o dado no banco de registradores
            reg_r1   : in unsigned(4 downto 0); --registrador a ler do banco de registradores
            data_r1  : out unsigned(15 downto 0) --dado lido do banco de registradores
            );
    end component;

    component ULA
        port
        (
            rg1 : in  unsigned (15 downto 0); --operando A da ULA
            rg2 : in  unsigned (15 downto 0); --operando B da ULA
            sel : in  unsigned  (1 downto 0); --selecao da operacao da ULA
            rg_out : out unsigned (15 downto 0); --resultado da ULA
            Z   : out std_logic; -- flag de zero
            N   : out std_logic; -- flag de negativo
            V   : out std_logic -- flag de overflow
        );
    end component;

    component reg16bits 
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;


    signal result, A_in, seg_op_ULA, A_out, data_wr_bRegs, data_rg1: unsigned(15 downto 0);

    begin

        A: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>A_wen, data_in=>A_in, data_out=>A_out);

        banco: bancoRegs
        port map (
                  clk=>clk, 
                  rst=>rst, 
                  wr_en=>B_wen, 
                  data_wr=>data_wr_bRegs,
                  reg_wr=>reg_wr, 
                  reg_r1=>reg_r1, 
                  data_r1=>data_rg1
                 );

        ULA0: ULA
        port map(
                rg1 => A_out,      -- acumulador
                rg2 => seg_op_ULA,        -- segundo operando
                sel => ula_op,
                rg_out => result,
                Z => zero, 
                N => negativo, 
                V => overflow
                );

        seg_op_ULA <= const when sel_ULA_optr = "01" else
                      data_rg1 when sel_ULA_optr = "00" else
                     "0000000000000000";

        A_in <= result when A_wr_sel = "00" else
                const  when A_wr_sel = "01" else
                data_rg1 when A_wr_sel = "10" else
                data_wr when A_wr_sel = "11" else
                "0000000000000000";

        data_wr_bRegs <= A_out when data_wr_bRegs_sel = "00" else
                         const when data_wr_bRegs_sel = "01" else
                         data_rg1 when data_wr_bRegs_sel = "10" else
                         data_wr when data_wr_bRegs_sel = "11" else
                         "0000000000000000";

        

end architecture;