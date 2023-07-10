----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.09.2020 12:25:29
-- Design Name: 
-- Module Name: nyomogomb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nyomogomb is
    Port ( src_clk : in STD_LOGIC;
           src_ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           button : in STD_LOGIC;
           pressed : out STD_LOGIC);
end nyomogomb;

architecture Behavioral of nyomogomb is

type casee is(DOWN,WAIT_50MS_DOWN,UP,WAIT_50MS_UP);
signal actual_case_button, next_case_button : casee := DOWN;

signal counter, counter_next : STD_LOGIC_VECTOR(31 downto 0);

begin

State_R:process(src_clk,reset)
begin
	if rising_edge(src_clk) then
		actual_case_button <= next_case_button;
		counter <= counter_next;
	end if;
	if reset = '1' then
        actual_case_button <= DOWN;
        counter <= (OTHERS => '0');
    end if;
end process State_R;

next_case_button_log:process(actual_case_button, counter, button)
begin
	case(actual_case_button) is
        when DOWN =>
            if button='1' then
                next_case_button<=WAIT_50MS_DOWN;
            else 
                next_case_button<=DOWN;
            end if;
        when WAIT_50MS_DOWN =>
            if counter=5000000 then
                next_case_button<=UP;
            else
                next_case_button<=WAIT_50MS_DOWN;
            end if;
        when UP =>
            if button='0' then
                next_case_button<=WAIT_50MS_UP;
            else
                next_case_button<=UP;
            end if;
        when WAIT_50MS_UP =>
            if counter=5000000 then
                next_case_button<=DOWN;
            else
                next_case_button<=WAIT_50MS_UP;
            end if;
		end case;
end process next_case_button_log;

WITH actual_case_button SELECT 
counter_next <= (others => '0') WHEN DOWN,
                (others => '0') WHEN UP,
				counter+1 WHEN others; 

WITH actual_case_button SELECT
pressed <= '1' WHEN WAIT_50MS_DOWN,
		   '1' WHEN UP,
           '0' WHEN OTHERS;
           
end Behavioral;
