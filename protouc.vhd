library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity protouc is
    port( 
        data_in  : in unsigned(15 downto 0);
        data_out  : out unsigned(15 downto 0)
   );
end entity;

architecture a_protouc of protouc is

begin

    data_out <= data_in + "0000000000000001"; -- Adiciona 1 ao dado de entrada

end architecture;