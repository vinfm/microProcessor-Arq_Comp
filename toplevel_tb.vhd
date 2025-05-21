library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topLevel_tb is
end entity;

architecture sim of topLevel_tb is

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal wr_en    : std_logic := '0';
    signal ula_op   : unsigned(1 downto 0) := (others => '0');
    signal data_wr  : unsigned(15 downto 0) := (others => '0');
    signal const    : unsigned(15 downto 0) := (others => '0');
    signal reg_wr   : unsigned(4 downto 0) := (others => '0');
    signal reg_r1   : unsigned(4 downto 0) := (others => '0');
    signal data_wr_bRegs_sel : unsigned (1 downto 0) := (others => '0');
    signal A_wr_sel : unsigned(1 downto 0) := (others => '0');
    signal A_we     : std_logic := '0';
    signal overflow : std_logic;
    signal negativo : std_logic;
    signal zero     : std_logic;

    constant clk_period : time := 10 ns;

    component topLevel
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
    end component;

begin

    -- Instancia o DUT (Device Under Test)
    DUT: topLevel
        port map (
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            ula_op => ula_op,
            data_wr => data_wr,
            const => const,
            reg_wr => reg_wr,
            reg_r1 => reg_r1,
            data_wr_bRegs_sel => data_wr_bRegs_sel, 
            A_wr_sel => A_wr_sel,
            A_we => A_we,
            overflow => overflow,
            negativo => negativo,
            zero => zero
        );

    -- Geração do clock
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Estímulos de teste
    stim_proc : process
    begin
        -- Reset inicial ativo por 30ns para garantir inicialização correta
        rst <= '1';
        wait for 30 ns;
        rst <= '0';

        wait for clk_period;

        -- Escreve valor 5 no registrador 1
        wr_en    <= '1';
        data_wr  <= to_unsigned(5, 16);
        reg_wr   <= "00001";  -- Reg 1
        wait for clk_period;

        wr_en    <= '0';  -- desativa escrita

        -- Lê do registrador 1
        reg_r1   <= "00001";

        -- Coloca o valor lido no acumulador (A)
        A_wr_sel <= "00";  -- pegar resultado direto (ajuste se necessário)
        ula_op   <= "00";  -- operação soma (ajuste conforme seu ULA)
        A_we     <= '1';   -- ativa escrita no acumulador
        wait for clk_period;
        A_we     <= '0';

        -- Soma acumulador com uma constante (3)
        const    <= to_unsigned(3, 16);
        A_wr_sel <= "00";  -- valor vindo da ULA
        ula_op   <= "00";  -- operação soma
        A_we     <= '1';
        wait for clk_period;
        A_we     <= '0';

        -- Aguarda mais ciclos para observar comportamento
        wait for 100 ns;

        report "Fim da simulação" severity note;
        wait;
    end process;

end architecture;
