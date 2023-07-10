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

--az automata aktu�lis �llapot�nak �s a k�vetkez� �llapot�nak
--t�rol�s�ra szol�l� adatt�pus �s singalok deklar�l�sa
--az automata �llatpo�nak t�rol�s�ra l�trehozott felsorol�s
--t�pusok
type allapot_tipusok is (RDY, INIT, CIKLUS, SZUM);

-- a l�trehozott t�pusok alapj�n az automata aktu�lis �s
-- k�vetkez� �llapotok t�rol�s�ra l�trehozott jel
signal akt_all , kov_all : allapot_tipus;

--az adat�tban alkalmazott jelek deklar�l�sa
-- RI : index t�rol�s�ra szolg�l� jel
-- RY : r�s�sszeg t�rol�s�ra szog�l� jel
-- RP � szorzat t�rol�s�ra szolg�lo jel

signal RI, RI_next : std_logic_vector(7 downto 0);
signal RY, RY_next : std_logic_vector(31 downto 0);
signal RP, RP_next : std_logic_vector(31 downto 0);

begin

-- �llapotregiszter megval=s`t'sa
AR : process(src_clk , reset) --�les�t� jelek
begin
    if reset = '1' then -- reset felt�tel ellen�rz�se
        akt_all <= RDY; --kezdeti �llapot be�ll�t�sa
        -- felfut� �ra�l deklar�l�sa
        elsif src_clk' event and src_clk = '1' then
        akt_all <= kov_all; -- felfut� �ra�lre,az �j �llapot
        --be�r�sa az �llapotregiszterbe
      end if;
 end process AR ;
  -- k�vetkez� �llapotlogika megval�s�t�sa
KAL:process(akt_all, start, RI)
begin
-- a pillanatnyi (akt_all) alapj�n megfelel� le�ga�zs
-- kiv�laszt�sa, majd a k�vetkez� �llapot meghat�roz�sa
-- as aktu�lis �llapot �s modul bementi jeelu alapj�n
   case (akt_all) is
   when RDY =>
      if start = '1' then
      -- ha start, �tl�p�s az INIT �llapotba
        kov_all <= INIT;
        else
        --egy�bk�nt vissza a kezdeti �llapotb
        kov_all <= RDY;
        end if;
   when INIT =>
   --felt�tel nel�li �tl�p�s a CIKLUS �llapotba
      kov_all <= CIKLUS;
    when CIKLUSUS
    if RI >1 then
    -- ha nem t�rt�nik meg a szorz�s az �sszes
    -- elemre maradunk a CIKLUS �llapotban
    kov_all <= CIKLUS;
    else
    -- egy�bk�nt �tl�p�s a SZUM �llapotba
    --az utols� �sszegz�s elv�gz�se cl�j�b�l
    kov_all <= SZUM;
    end if;
    when SZUM =>
    kov_all <= RDY ; --a felt�tel nelk�li visszaugr�s 
    -- a kezdeti �llapota
    end case;
  end process KAL ;
  
  --a kapcsol�h�lozatot megval�s�t�s with select when utas�t�ssal
  -- �s az elv�gzend� m�veletek implement�l�sa
  
  with akt_all select
  -- index regiszter k�r�li kapcsolath�l�zat kialak�t�sa
  RI_next <= (others => '0')when RDY,
    N -1 when INIT,
    RI -1 when CIKLUS,
    RI when SZUM;
   --RP regiszter k�r�li kapcsol�h�lozat kialak�t�sa
   with akt�all select
   RP_next <=(others => '0') when RDY,
       x1 * x2 when INIT,
       x1 *x2  when CIKLUS,
      (others => '0') when SZUM;
   --RY kapcsolo k�r�li kapcsolath�l�zat kialak�t�sa
   with akt_all select
   RY_next <= RY when RDY,
   (others => '0') when INIT,
   PY + RP when CIKLUS,
   RY + RP when SZUM ;
   
 -- RI adatregiszter megval�s�t�sa
 ADAT_RI : process (src_clk , reset)
 begin
 if src_clk' event and src_clk = '1' than
 RI <= RI_next;
 end if;
 end process ADAT_RI
 
  -- RP adatregiszter megval�s�t�sa
 ADAT_RP : process (src_clk , reset)
 begin
 if src_clk' event and src_clk = '1' than
 RP <= RY_next;
 end if;
 end process ADAT_RP;

  -- RY adatregiszter megval�s�t�sa
 ADAT_RY : process (src_clk , reset)
 begin
 if src_clk' event and src_clk = '1' than
 RY <= RY_next;
 end if;
 end process ADAT_RY;

y <= RY ; -- RY regiszter tartalm�nak a kivezet�se
--az y kimeneti jelre
end Behavioral;
