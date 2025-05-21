library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topLevel is
    port(
         clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         ula_op   : in unsigned(1 downto 0);
         data_wr  : in unsigned(15 downto 0);
         const    : in unsigned(15 downto 0);
         reg_wr   : in unsigned(4 downto 0);
         reg_r1   : in unsigned(4 downto 0);
         data_wr_bRegs_sel :in unsigned(1 downto 0); --seleciona fonte de dados para o banco de registradores
         A_wr_sel : in unsigned(1 downto 0); --seleciona fonte do dado a escrever no A
         A_we     : in std_logic;            --habilita escrita no acumulador
         overflow : out std_logic;
         negativo : out std_logic;
         zero     : out std_logic
        );
end entity;

architecture a_topLevel of topLevel is

    component bancoRegs 
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_wr  : in unsigned(15 downto 0);
            reg_wr   : in unsigned(4 downto 0);
            reg_r1   : in unsigned(4 downto 0);
            data_r1  : out unsigned(15 downto 0)
            );
    end component;

    component ULA
        port
        (
            rg1 : in  unsigned (15 downto 0); -- usado como A
            rg2 : in  unsigned (15 downto 0); -- possivel cte
            sel : in  unsigned  (1 downto 0);
            rg_out : out unsigned (15 downto 0);
            Z   : out std_logic;
            N   : out std_logic;
            V   : out std_logic
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


    signal result, A_in, A_out, rg1, data_wr_bRegs: unsigned(15 downto 0);

    begin

        A: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>A_we, data_in=>A_in, data_out=>A_out);

        banco: bancoRegs
        port map (
                  clk=>clk, rst=>rst, 
                  wr_en=>wr_en, data_wr=>data_wr_bRegs,
                  reg_wr=>reg_wr, reg_r1=>reg_r1, 
                  data_r1=>rg1
                 );

        ULA0: ULA
        port map(
                rg1 => A_out,      -- acumulador
                rg2 => rg1,        -- segundo operando banco
                sel => ula_op,
                rg_out => result,
                Z => zero, N => negativo, V => overflow
                );

        A_in <= result when A_wr_sel = "00" else
                const  when A_wr_sel = "01" else
                data_r1 when A_wr_sel = "10" else
                data_wr when A_wr_sel = "11" else
                "0000000000000000";

        data_wr_bRegs <= data_wr when data_wr_bRegs_sel = "00" else
                         const when data_wr_bRegs_sel = "01" else
                         A_out when data_wr_bRegs_sel = "10" else
                         "0000000000000000";

end architecture;