----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 10:07:36 PM
-- Design Name: 
-- Module Name: vsz_szim - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vsz_szim is
--  Port ( );
end vsz_szim;

architecture Behavioral of vsz_szim is
component vsz is
    Port ( src_clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           N : in STD_LOGIC_VECTOR (7 downto 0);
           x1 : in STD_LOGIC_VECTOR (15 downto 0);
           x2 : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);

end component;

signal clk :  STD_LOGIC;
signal reset :  STD_LOGIC;
signal start :  STD_LOGIC;
signal N :  STD_LOGIC_VECTOR (7 downto 0);
signal x1 :  STD_LOGIC_VECTOR (15 downto 0);
signal x2 :  STD_LOGIC_VECTOR (15 downto 0);
--kimeneti jelek
signal y :  STD_LOGIC_VECTOR (31 downto 0);

--�rajel periodus�nak meghat�roz�sa [ ns ]
constant clp_period : tim := 10 ns;

begin

-- szimul�land� modul p�ld�nyos�t�sa, �s a modul port
-- jeleire a megfelel� signal jelek kapcsol�sa
-- baloldalon : a modul portjelei
--jobboldalon � az Architecture r�sz�bwn a meghat�rozott jelek
--tesztelt �ramk�r p�ld�nyos�t�sa ( UUT )
uut : vsz PORT MAP (
        src_clk => clk,
        reset => reset,
        start => start;
        N => N,
        z1 => x1,
        x2 => x2,
        y => y
);

--�rajel gener�l�sa, ha a szimul�land� redszer t�bb
--�rajelet kelll alkalmaznia, minden �rajelet az al�bbi
--minta alapj�n lehet l�trehozni

clk_process : process
begin
    clk <= '0';--�rajel logikai null�ra val�kapcsol�sa
    waint for clk_period/2; -- f�lperi�dusnyi v�rakoz�s
    clk <= '1'; --�rajel logikai 1 val� kapcsol�sa
    waint for clk_period/2; -- f�lperi�dusnyi v�rakoz�s
end process;

stim_proc : process
begin

end process;

end Behavioral;
