----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2019 15:34:11
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
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vsz is
    Port ( src_clk : in STD_LOGIC;
           src_ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (15 downto 0);
           w : in STD_LOGIC_VECTOR (15 downto 0);
           RS_ki : out STD_LOGIC_VECTOR (15 downto 0);
           RP_ki : out STD_LOGIC_VECTOR (15 downto 0);
           RI_ki : out STD_LOGIC_VECTOR (15 downto 0);
           RDY_ki : out STD_LOGIC);
end vsz;

architecture Behavioral of vsz is
type allapot_tipus is (RDY,INIT,SUM,SUM2, SET_A);
signal akt_all, kov_all : allapot_tipus;

signal RS : std_logic_vector(15 downto 0);
signal RS_kov : std_logic_vector(15 downto 0);
signal RP : std_logic_vector(15 downto 0);
signal RP_kov : std_logic_vector(15 downto 0);
signal RI : std_logic_vector(15 downto 0);
signal RI_kov : std_logic_vector(15 downto 0);
begin

KAL:process(akt_all, start, RI)
begin
   case (akt_all) is
   when RDY =>
      if start = '1' then
        kov_all <= INIT;
        else
        kov_all <= RDY;
        end if;
   when INIT =>
      kov_all <= SUM;
   when SUM =>
      if RI > 0 then
        kov_all <= SUM;
        else
        kov_all <= SUM2;
        end if; 
   when SUM2 =>
      kov_all <= SET_A;
   when SET_A =>
      kov_all <= RDY;
--   when others =>
--      <statement>;
end case;
   

end process KAL;


AR:process (src_clk, reset)
begin
    if reset ='1' then
        akt_all<=RDY;
    elsif src_clk'event and src_clk='1' then
        akt_all<=kov_all;
    end if;
end process AR;


RS_A:process (src_clk)
begin
   if src_clk'event and src_clk='1' then
        RS<=RS_kov;
    end if;
end process RS_A;

RP_A:process (src_clk)
begin
   if src_clk'event and src_clk='1' then
        RP<=RP_kov;
    end if;
end process RP_A;

RI_A:process (src_clk)
begin
   if src_clk'event and src_clk='1' then
        RI<=RI_kov;
    end if;
end process RI_A;

with akt_all select 
    RS_kov <= RS when RDY,
                (others => '0') when INIT,
                 --  conv_std_logic_vector(0,16) when INIT,
                 RS+RP when SUM,
                 RS+RP when SUM2,
                 RS when SET_A;
                 
 with akt_all select 
     RP_kov <= RP when RDY,
                 x*w when INIT,
                  --  conv_std_logic_vector(0,16) when INIT,
                  x*w when SUM,
                  RP when SUM2,
                  RP when SET_A;                
with akt_all select 
      RI_kov <= RI when RDY,
               conv_std_logic_vector(6,16) when INIT,
                   --  conv_std_logic_vector(0,16) when INIT,
                   RI-1 when SUM,
                   RI-1 when SUM2,
                   RI when SET_A;

end Behavioral;
