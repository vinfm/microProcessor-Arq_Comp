library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA_tb is

end entity;

architecture a_ULA_tb of ULA_tb is
    component ULA
        port(        
            rg1 : in  unsigned (15 downto 0);
            rg2 : in  unsigned (15 downto 0);
            sel : in  unsigned  (1 downto 0);
            rg0 : out unsigned (15 downto 0);
            Z   : out std_logic;
            N   : out std_logic;
            V   : out std_logic
            );
    end component;

    signal resultado, rg1, rg2: unsigned (15 downto 0);
    signal sel: unsigned (1 downto 0);
    signal zero, negativo, overflow: std_logic;

begin
    uut: ULA 
        port map( 
            
                    rg1 => rg1,
                    rg2 => rg2,
                    sel => sel,
                    rg0 => resultado,
                    Z => zero,
                    N => negativo,
                    V => overflow
                  );

    process
    begin
        
        rg1 <= "1000000000000000";
        rg2 <= "1000000000000000";

        sel <= "00";

        wait for 50 ns;

        sel <= "01";

        wait for 50 ns;

        sel <= "10";

        wait for 50 ns;

        sel <= "11";
        
        wait for 50 ns;

        rg1 <= "0111001010101010";
        rg2 <= "1100101001110100";

        sel <= "00";
        
        wait for 50 ns;

        sel <= "01";

        wait for 50 ns;

        sel <= "10";

        wait for 50 ns;

        sel <= "11";
        
        wait for 50 ns;

        rg1 <= "1100101001110100";
        rg2 <= "0110111111000001";

        sel <= "00";
        
        wait for 50 ns;

        sel <= "01";

        wait for 50 ns;

        sel <= "10";

        wait for 50 ns;

        sel <= "11";
        
        wait for 50 ns;

        rg1 <= unsigned(to_signed(-5, 16));
        rg2 <= unsigned(to_signed(5, 16));

        sel <= "00";
        
        wait for 50 ns;

        sel <= "01";

        wait for 50 ns;

        sel <= "10";

        wait for 50 ns;

        sel <= "11";
        
        wait for 50 ns;
        wait;    
    end process;
end architecture;