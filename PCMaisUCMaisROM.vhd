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
        estado    : out std_logic
    );
    end component;

    signal estado_uc : std_logic;

    component rom
    port(
        clk         : in std_logic; 
        endereco    : in unsigned(6 downto 0);
        dado        : out unsigned(15 downto 0)
    );
    end component;
    signal UCout, PCout: unsigned(6 downto 0);
    signal instr : unsigned(15 downto 0); -- Instrução de 16 bits
    
begin

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