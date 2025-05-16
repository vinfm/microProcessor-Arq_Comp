library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder3x6 is
    port(
         sel:in unsigned(4 downto 0);
         s0: out std_logic;
         s1: out std_logic;
         s2: out std_logic;
         s3: out std_logic;
         s4: out std_logic;
         s5: out std_logic
         );
end entity;

architecture a_decoder3x6 of decoder3x6 is

begin
    s0 <= not(sel(0)) and not(sel(1)) and not(sel(3));
    s1 <= sel(0) and not(sel(1)) and not(sel(2));
    s2 <= not(sel(0)) and sel(1) and not(sel(2));
    s3 <= sel(0) and sel(1) and not(sel(2));
    s4 <= not(sel(0)) and not(sel(1)) and sel(2);
    s5 <= sel(0) and not(sel(1)) and sel(2);

end architecture;