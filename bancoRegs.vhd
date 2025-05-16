library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoRegs is
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_wr  : in unsigned(15 downto 0);
        reg_wr   : in unsigned(4 downto 0);
        reg_r1   : in unsigned(4 downto 0);
        data_r1  : out unsigned(15 downto 0)
   );
end entity;

architecture a_bancoRegs of bancoRegs is
    component reg16bits
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
    end component;

    component decoder3x6 
    port(
        sel:in unsigned(4 downto 0);
        s0: out std_logic;
        s1: out std_logic;
        s2: out std_logic;
        s3: out std_logic;
        s4: out std_logic;
        s5: out std_logic
    );
    end component;

    signal out0, out1, out2, out3, out4, out5: unsigned(15 downto 0);
    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5: std_logic;

    begin

        data_r1 <=  out0 when reg_r1="00000" else
                    out1 when reg_r1="00001" else
                    out2 when reg_r1="00010" else
                    out3 when reg_r1="00011" else
                    out4 when reg_r1="00100" else
                    out5 when reg_r1="00101" 
                    else "0000000000000000";

        decoder_wr : decoder3x6 
        port map(
            sel=>reg_wr,
            s0=> wr_en0,
            s1=> wr_en1,
            s2=> wr_en2,
            s3=> wr_en3,
            s4=> wr_en4,
            s5=> wr_en5
            );

        rg0: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>wr_en0, data_in=>data_wr, data_out=>out0);

        rg1: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>wr_en1, data_in=>data_wr, data_out=>out1);

        rg2: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>wr_en2, data_in=>data_wr, data_out=>out2);

        rg3: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>wr_en3, data_in=>data_wr, data_out=>out3);

        rg4: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>wr_en4, data_in=>data_wr, data_out=>out4);

        rg5: reg16bits
        port map (clk=>clk, rst=>rst, wr_en=>wr_en5, data_in=>data_wr, data_out=>out5);

end architecture;