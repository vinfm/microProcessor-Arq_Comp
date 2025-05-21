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


    signal   finished    : std_logic := '0';
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
    reset_global: process
    begin
        rst <= '1';
        wait for clk_period*2; -- espera 2 clocks, pra garantir
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;         
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process clk_proc;

    -- Estímulos de teste
    stim_proc : process
    begin

        -- Aguarda reset
        wait for 3*clk_period;

        -- Escreve 10 no registrador 1
        data_wr <= to_unsigned(10, 16);
        reg_wr  <= "00001";
        wr_en   <= '1';
        data_wr_bRegs_sel <= "00"; -- data_wr como fonte
        wait for clk_period;
        wr_en   <= '0';

        wait for 100 ns;

        -- Escreve 7 no registrador 2
        data_wr <= to_unsigned(7, 16);
        reg_wr  <= "00010";
        wr_en   <= '1';
        wait for clk_period;
        wr_en   <= '0';

        wait for 100 ns;

        -- Lê registrador 1 e carrega no acumulador
        reg_r1  <= "00001";
        A_wr_sel <= "10"; -- data_rg1 como fonte
        A_we <= '1';
        wait for clk_period;
        A_we <= '0';

        wait for 100 ns;

        -- Soma acumulador (10) com registrador 2 (7)
        reg_r1 <= "00010";
        ula_op <= "00"; -- operação soma
        A_wr_sel <= "00"; -- resultado da ULA
        A_we <= '1';
        wait for clk_period;
        A_we <= '0';

        wait for 100 ns;

        -- Subtrai acumulador (17) com constante 5
        const <= to_unsigned(5, 16);
        ula_op <= "01"; -- operação subtração (ajuste conforme sua ULA)
        A_wr_sel <= "00"; -- resultado da ULA
        A_we <= '1';
        wait for clk_period;
        A_we <= '0';

        wait for 100 ns;

        -- Testa resultado zero
        const <= to_unsigned(12, 16);
        ula_op <= "01"; -- subtrai 12 de 12
        A_wr_sel <= "00"; 
        A_we <= '1';
        wait for clk_period;
        A_we <= '0';
        wait for 50 ns;
        wait;
    end process;

end architecture;
