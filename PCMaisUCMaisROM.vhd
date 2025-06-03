library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCMaisUCMaisROM is
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic
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
        clk       : in std_logic;
        rst       : in std_logic;
        instr     : in unsigned(15 downto 0); -- Instrução de 16 bits
        data_in   : in unsigned(6 downto 0);
        data_out  : out unsigned(6 downto 0);
        estado    : out std_logic;
        sourceB   : out std_logic;
        wr_enBanco: out std_logic;
        wr_enA    : out std_logic;
        wr_enIR   : out std_logic;
        OP_ULA    : out unsigned(1 downto 0);
        banco_rcv : out unsigned(1 downto 0);
        A_rcv     : out unsigned(1 downto 0);
        wr_enPC   : out std_logic
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
    signal instr : unsigned(15 downto 0); -- Instrução de 16 bits
    
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
            data_in  => instr,
            data_out => instr
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
            instr    => instr,
            data_in  => PCout,
            data_out => UCout,
            estado   => estado_uc
        );
    ROM_top : rom
        port map(
            clk      => clk,
            endereco => PCout, 
            dado     => instr
        );
end architecture;