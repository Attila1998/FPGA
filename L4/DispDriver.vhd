----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2021 11:53:49 AM
-- Design Name: 
-- Module Name: DispDriver - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DispDriver is
    Port ( src_clk : in STD_LOGIC;
           src_ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (31 downto 0);
           LEDSelect: out STD_LOGIC_VECTOR(7 downto 0);
           LED : out STD_LOGIC_VECTOR (6 downto 0));
end DispDriver;

architecture Behavioral of DispDriver is

signal div_clk: STD_LOGIC;
signal characterData: std_logic_vector(3 downto 0);
signal count: std_logic_vector(2 downto 0);


component binaris_szamlalo
	GENERIC 
	(BITEK_SZAMA : natural :=3);
    Port ( src_clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR (BITEK_SZAMA-1 downto 0));
end component;

begin

LEDSel: binaris_szamlalo
GENERIC MAP
(BITEK_SZAMA=>3)
PORT MAP(
		src_clk => div_clk,
		reset => reset,
		q => count
);

oszto_25000_inst :process (src_clk)
variable szamlalo : integer range 0 to 65535 :=25000; 
variable q: std_logic :='0'; 
begin
    if rising_edge(src_clk) then
        if szamlalo=0 then
            szamlalo :=25000;
            q := not q;           
        end if;
	szamlalo:=szamlalo -1;
    end if;
    div_clk <=q;
end process;


with characterData select
LED<= "1111001" when "0001",   --1
     "0100100" when "0010",   --2
     "0110000" when "0011",   --3
     "0011001" when "0100",   --4
     "0010010" when "0101",   --5
     "0000010" when "0110",   --6
     "1111000" when "0111",   --7
     "0000000" when "1000",   --8
     "0010000" when "1001",   --9
     "0001000" when "1010",   --A
     "0000011" when "1011",   --b
     "1000110" when "1100",   --C
     "0100001" when "1101",   --d
     "0000110" when "1110",   --E
     "0001110" when "1111",   --F
     "1000000" when others;   --0

with count(2 downto 0) select
characterData<=  data(3 downto 0) when "000",
        data(7 downto 4) when "001",
        data(11 downto 8) when "010",
        data(15 downto 12) when "011",
        data(19 downto 16) when "100",
        data(23 downto 20) when "101",
        data(27 downto 24) when "110",
        data(31 downto 28) when others;

with count(2 downto 0) select
LEDSelect <= 
        x"FE" when "000",
        x"FD" when "001",
        x"FB" when "010",
        x"F7" when "011",
        x"EF" when "100",
        x"DF" when "101",
        x"BF" when "110",
        x"7F" when others;

end Behavioral;
