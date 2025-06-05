library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder3x6 is
    port(
        sel: in unsigned(2 downto 0);
        s0 : out std_logic;
        s1 : out std_logic;
        s2 : out std_logic;
        s3 : out std_logic;
        s4 : out std_logic;
        s5 : out std_logic
    );
end entity;

architecture a_decoder3x6 of decoder3x6 is
begin
    s0 <= '1' when sel = "000" else '0';
    s1 <= '1' when sel = "001" else '0';
    s2 <= '1' when sel = "010" else '0';
    s3 <= '1' when sel = "011" else '0';
    s4 <= '1' when sel = "100" else '0';
    s5 <= '1' when sel = "101" else '0';
end architecture;
