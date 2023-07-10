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

--Órajel periodusának meghatározása [ ns ]
constant clp_period : tim := 10 ns;

begin

-- szimulálandó modul példányosítása, és a modul port
-- jeleire a megfelelõ signal jelek kapcsolása
-- baloldalon : a modul portjelei
--jobboldalon É az Architecture részébwn a meghatározott jelek
--tesztelt áramkör példányosítása ( UUT )
uut : vsz PORT MAP (
        src_clk => clk,
        reset => reset,
        start => start;
        N => N,
        z1 => x1,
        x2 => x2,
        y => y
);

--órajel generálása, ha a szimulálandó redszer több
--órajelet kelll alkalmaznia, minden órajelet az alábbi
--minta alapján lehet létrehozni

clk_process : process
begin
    clk <= '0';--órajel logikai nullára valókapcsolása
    waint for clk_period/2; -- félperiódusnyi várakozás
    clk <= '1'; --órajel logikai 1 való kapcsolása
    waint for clk_period/2; -- félperiódusnyi várakozás
end process;

stim_proc : process
begin

end process;

end Behavioral;
