library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA is
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
end entity;

architecture ULA of ULA is 

signal result: unsigned(15 downto 0);
signal overflow: std_logic;
begin
 
    result <= rg1+rg2 when sel = "00" else --soma

           rg1-rg2 when sel = "01" else --sub

           rg1 xor rg2 when sel = "10" else -- xor lógico

           rg1 and rg2 when sel = "11" else -- and lógico
           "0000000000000000";

    N <= result(15); -- flag de negativo

    overflow <= '1' when (sel="00" and rg1(15)=rg2(15) and rg1(15) /= result(15)) else         -- overflow
         '1' when (sel="01" and rg1(15)/=rg2(15) and result(15)/=rg1(15)) else
            '0';

    Z <= '1' when result = "0000000000000000" else -- flag de zero
        '0';

    V <= overflow;
    
    rg_out <= result;

end architecture;