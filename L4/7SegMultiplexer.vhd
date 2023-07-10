----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2021 11:45:57 AM
-- Design Name: 
-- Module Name: 7SegMultiplexer - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DisMultiplexer is
    Port ( reset:in STD_LOGIC;
           min_val : in STD_LOGIC_VECTOR (31 downto 0);
           max_val : in STD_LOGIC_VECTOR (31 downto 0);
           div_val : in STD_LOGIC_VECTOR (9 downto 0);
           h_val : in STD_LOGIC_VECTOR (31 downto 0);
           kapcsolo_1 : in STD_LOGIC;
           kapcsolo_2 : in STD_LOGIC;
           data : out STD_LOGIC_VECTOR (31 downto 0));
end DisMultiplexer;

architecture Behavioral of DisMultiplexer is
signal kapcsolok : STD_LOGIC_VECTOR (1 downto 0);
begin
    process (min_val, max_val, div_val, h_val, kapcsolo_1,kapcsolo_2)
    begin
    if reset = '1' then
        data <= (OTHERS => '0');
    else
         case kapcsolok is
             when "00" => data <= min_val;
             when "01" => data <= max_val;
             when "10" => data <=("00" & (x"00000" &  div_val));
             when "11" => data <= h_val;
             when others => data <= min_val;
        end case;
    end if;
    end process;
kapcsolok(0) <= kapcsolo_1;
kapcsolok(1) <= kapcsolo_2;
end Behavioral;
