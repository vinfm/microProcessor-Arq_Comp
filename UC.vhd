library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port( 
        clk        : in std_logic;
        instr      : in unsigned(15 downto 0); -- Instrução de 16 bits
        rst        : in std_logic;
        data_in    : in unsigned(6 downto 0);
        data_out   : out unsigned(6 downto 0);
        estado     : out std_logic;
        sourceB    : out std_logic;
        wr_enBanco : out std_logic;
        wr_enA     : out std_logic;
        wr_enIR    : out std_logic;
        OP_ULA     : out unsigned(1 downto 0);
        banco_rcv  : out unsigned(1 downto 0);
        A_rcv      : out unsigned(1 downto 0);
        wr_enPC    : out std_logic
        
    );
end entity;

architecture a_UC of UC is

    component reg1bit
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in std_logic;
            data_out : out std_logic
        );
    end component;

    signal estado_reg  : std_logic := '0'; -- Estado da UC, 0 para fetch e 1 para decode/execute
    signal prox_estado : std_logic;
    signal prox_pc : unsigned(6 downto 0);
    signal jump_en : std_logic;
    signal nop_en  : std_logic;

    signal opcode: unsigned(3 downto 0);

begin
    
   -- coloquei o opcode nos 4 bits MSB
   opcode <= instr(15 downto 12);

   -- meu jump: opcode 1111
   jump_en <=  '1' when opcode="1111" else '0'; 
   nop_en  <=  '1' when opcode="0000" else '0';


    -- Alternância de estado
    prox_estado <= '1' when estado_reg = '0' else '0';

    -- Incrementa PC no estado 1
    prox_pc <= data_in + "0000001";


    -- Seleciona saída de acordo com o estado
    data_out <= data_in when estado_reg        = '0' else 
                instr(6 downto 0) when jump_en = '1' else
                prox_pc when nop_en            = '1' else
                prox_pc;


    estado <= estado_reg;

    -- Instancia o registrador de 1 bit
    reg_estado : reg1bit
        port map(
            clk => clk,
            rst => rst,
            wr_en => '1',
            data_in => prox_estado,
            data_out => estado_reg
        );

end architecture;