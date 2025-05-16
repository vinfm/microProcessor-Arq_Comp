library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA is
    port
    (
        rg1 : in  unsigned (15 downto 0);
        rg2 : in  unsigned (15 downto 0);
        sel : in  unsigned  (1 downto 0);
        rg_out : out unsigned (15 downto 0);
        Z   : out std_logic;
        N   : out std_logic;
        V   : out std_logic
    );
end entity;

architecture ULA of ULA is 

signal result: unsigned(15 downto 0);
signal overflow: std_logic;
begin
 
    result <= rg1+rg2 when sel = "00" else --soma

           rg1-rg2 when sel = "01" else --sub

           rg1 or rg2 when sel = "10" else -- ou lógico

           rg1 and rg2 when sel = "11" else -- and lógico
           "0000000000000000";

    N <= result(15); -- flag de negativo

    overflow <= '1' when (sel="00" and rg1(15)=rg2(15) and rg1(15) /= result(15)) else         -- overflow
         '1' when (sel="01" and rg1(15)/=rg2(15) and result(15)/=rg1(15)) else
            '0';

    Z <= '1' when result = "0000000000000000" and overflow='0' else -- flag de zero
        '0';

    V <= overflow;
    
    rg_out <= result;

end architecture;