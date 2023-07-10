----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2021 11:53:49 AM
-- Design Name: 
-- Module Name:    binaris_szamlalo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity binaris_szamlalo is
	GENERIC 
	(BITEK_SZAMA : natural :=3);
    Port ( src_clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR (BITEK_SZAMA-1 downto 0));
end binaris_szamlalo;

architecture Behavioral of binaris_szamlalo is

begin
process (src_clk, reset)
variable counter_val : std_logic_vector(BITEK_SZAMA-1 downto 0);
begin
    if rising_edge(src_clk) then
        counter_val:=counter_val+1;
    end if;
    if reset='1' then
        counter_val:=(others =>'0');
    end if;
    q<=counter_val;
end process;
end Behavioral;

