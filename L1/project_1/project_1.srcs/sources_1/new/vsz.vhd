----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 04:18:15 PM
-- Design Name: 
-- Module Name: vsz - Behavioral
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

entity vsz is
    Port ( src_clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           N : in STD_LOGIC_VECTOR (7 downto 0);
           x1 : in STD_LOGIC_VECTOR (15 downto 0);
           x2 : in STD_LOGIC_VECTOR (15 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end vsz;

architecture Behavioral of vsz is

--az automata aktuális állapotának és a következõ állapotának
--tárolására szoláló adattípus és singalok deklarálása
--az automata állatpoának tárolására létrehozott felsorolás
--típusok
type allapot_tipusok is (RDY, INIT, CIKLUS, SZUM);

-- a létrehozott típusok alapján az automata aktuális és
-- következõ állapotok tárolására létrehozott jel
signal akt_all , kov_all : allapot_tipus;

--az adatútban alkalmazott jelek deklarálása
-- RI : index tárolására szolgáló jel
-- RY : résõsszeg tárolására szogáló jel
-- RP É szorzat tárolására szolgálo jel

signal RI, RI_next : std_logic_vector(7 downto 0);
signal RY, RY_next : std_logic_vector(31 downto 0);
signal RP, RP_next : std_logic_vector(31 downto 0);

begin

-- állapotregiszter megval=s`t'sa
AR : process(src_clk , reset) --élesítõ jelek
begin
    if reset = '1' then -- reset feltétel ellenõrzése
        akt_all <= RDY; --kezdeti állapot beállítása
        -- felfutó óraél deklarálása
        elsif src_clk' event and src_clk = '1' then
        akt_all <= kov_all; -- felfutó óraélre,az ój állapot
        --beírása az állapotregiszterbe
      end if;
 end process AR ;
  -- következõ állapotlogika megvalósítása
KAL:process(akt_all, start, RI)
begin
-- a pillanatnyi (akt_all) alapján megfelelõ leágaázs
-- kiválasztása, majd a következõ állapot meghatározása
-- as aktuális állapot és modul bementi jeelu alapján
   case (akt_all) is
   when RDY =>
      if start = '1' then
      -- ha start, átlépás az INIT állapotba
        kov_all <= INIT;
        else
        --egyébként vissza a kezdeti állapotb
        kov_all <= RDY;
        end if;
   when INIT =>
   --feltétel nelüli átlépés a CIKLUS állapotba
      kov_all <= CIKLUS;
    when CIKLUSUS
    if RI >1 then
    -- ha nem történik meg a szorzás az összes
    -- elemre maradunk a CIKLUS állapotban
    kov_all <= CIKLUS;
    else
    -- egyébként átlépés a SZUM állapotba
    --az utolsó összegzés elvégzése cléjából
    kov_all <= SZUM;
    end if;
    when SZUM =>
    kov_all <= RDY ; --a feltétel nelküli visszaugrás 
    -- a kezdeti állapota
    end case;
  end process KAL ;
  
  --a kapcsolóhálozatot megvalósítás with select when utasítással
  -- és az elvégzendõ múveletek implementálása
  
  with akt_all select
  -- index regiszter körüli kapcsolathálózat kialakítása
  RI_next <= (others => '0')when RDY,
    N -1 when INIT,
    RI -1 when CIKLUS,
    RI when SZUM;
   --RP regiszter körüli kapcsolóhálozat kialakítása
   with aktÜall select
   RP_next <=(others => '0') when RDY,
       x1 * x2 when INIT,
       x1 *x2  when CIKLUS,
      (others => '0') when SZUM;
   --RY kapcsolo körüli kapcsolathálózat kialakítása
   with akt_all select
   RY_next <= RY when RDY,
   (others => '0') when INIT,
   PY + RP when CIKLUS,
   RY + RP when SZUM ;
   
 -- RI adatregiszter megvalósítása
 ADAT_RI : process (src_clk , reset)
 begin
 if src_clk' event and src_clk = '1' than
 RI <= RI_next;
 end if;
 end process ADAT_RI
 
  -- RP adatregiszter megvalósítása
 ADAT_RP : process (src_clk , reset)
 begin
 if src_clk' event and src_clk = '1' than
 RP <= RY_next;
 end if;
 end process ADAT_RP;

  -- RY adatregiszter megvalósítása
 ADAT_RY : process (src_clk , reset)
 begin
 if src_clk' event and src_clk = '1' than
 RY <= RY_next;
 end if;
 end process ADAT_RY;

y <= RY ; -- RY regiszter tartalmának a kivezetése
--az y kimeneti jelre
end Behavioral;
