----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2019 16:21:44
-- Design Name: 
-- Module Name: szim - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity szim is
--  Port ( );
end szim;

architecture Behavioral of szim is

component vsz is
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
end component;

signal src_clk :  STD_LOGIC;
signal src_ce :  STD_LOGIC;
signal reset :  STD_LOGIC;
signal start :  STD_LOGIC;
signal x :  STD_LOGIC_VECTOR (15 downto 0);
signal w :  STD_LOGIC_VECTOR (15 downto 0);
signal RS_ki :  STD_LOGIC_VECTOR (15 downto 0);
signal RP_ki :  STD_LOGIC_VECTOR (15 downto 0);
signal RI_ki :  STD_LOGIC_VECTOR (15 downto 0);
signal RDY_ki :  STD_LOGIC;

begin

vsz_peldany : vsz  
    Port map ( src_clk => src_clk,
           src_ce  => src_ce,
           reset  => reset,
           start  => start,
           x  => x, 
           w  => w,
           RS_ki => RS_ki,
           RP_ki => RP_ki,
           RI_ki =>RI_ki,
           RDY_ki=> RDY_ki);

orajel_gen: process
begin
 src_clk <='1';
 wait for 10 ns;
 src_clk <='0';
 wait for 10 ns;     
end process orajel_gen; 



jelgenerator : process
begin 
reset <= '1';
start <= '0';
wait for 10 ns;

reset <= '0';
wait for 10 ns;

reset <= '1';
wait for 10 ns;

 start<= '1';
wait for 10 ns;
X<= conv_std_logic_vector(7, 16);
W<= conv_std_logic_vector(7, 16);
wait for 10 ns;

X<= conv_std_logic_vector(7, 16);
W<= conv_std_logic_vector(7, 16);
wait for 10 ns;

X<= conv_std_logic_vector(7, 16);
W<= conv_std_logic_vector(7, 16);
wait for 10 ns;

X<= conv_std_logic_vector(7, 16);
W<= conv_std_logic_vector(7, 16);
wait for 10 ns;

X<= conv_std_logic_vector(7, 16);
W<= conv_std_logic_vector(7, 16);
wait for 10 ns;

wait;


end process;
end Behavioral;



