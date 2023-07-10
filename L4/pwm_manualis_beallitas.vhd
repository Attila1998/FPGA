----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.09.2020 09:07:28
-- Design Name: 
-- Module Name: pwm_manualis_beallitas - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_manualis_beallitas is
    generic
            (max_val_32 : natural := 2**31-1;
            max_val_10 : natural:= 2**9-1; 
            min_val_kezd : natural := 0;
            max_val_kezd : natural :=100;
            div_val_kezd : natural :=10;
            h_val_kezd: natural:=10
            );
    
    Port ( src_clk : in STD_LOGIC;
           src_ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           gomb_fel : in STD_LOGIC;
           gomb_le : in STD_LOGIC;
           kapcsolo_1 : in STD_LOGIC;
           kapcsolo_2 : in STD_LOGIC;
           min_val : out STD_LOGIC_VECTOR (31 downto 0);
           max_val : out STD_LOGIC_VECTOR (31 downto 0);
           div_val : out STD_LOGIC_VECTOR (9 downto 0);
           h : out STD_LOGIC_VECTOR (31 downto 0));
end pwm_manualis_beallitas;

architecture Behavioral of pwm_manualis_beallitas is

type casee is(READY,DIVISION,PLUS,PLUS_MIN_VAL,PLUS_MAX_VAL,PLUS_DIV_VAL,PLUS_H,
              MINUS,MINUS_MIN_VAL,MINUS_MAX_VAL,MINUS_DIV_VAL,MINUS_H,RELEASE);
signal actual_case, next_case : casee := READY;

signal min_val_tarolo, min_val_tarolo_next : STD_LOGIC_VECTOR (31 downto 0);
signal max_val_tarolo, max_val_tarolo_next : STD_LOGIC_VECTOR (31 downto 0);
signal div_val_tarolo, div_val_tarolo_next : STD_LOGIC_VECTOR (9 downto 0);
signal h_tarolo, h_tarolo_next : STD_LOGIC_VECTOR (31 downto 0);
signal gombok : STD_LOGIC_VECTOR (1 downto 0);
signal kapcsolok : STD_LOGIC_VECTOR (1 downto 0);

begin

State_R:process(src_clk,reset)
begin
	if rising_edge(src_clk) then
	   
		actual_case <= next_case;
		min_val_tarolo <= min_val_tarolo_next;
		max_val_tarolo <= max_val_tarolo_next;
		div_val_tarolo <= div_val_tarolo_next;
		h_tarolo <= h_tarolo_next;
	  end if;
	  if reset = '1' then
        actual_case <= READY;
        min_val_tarolo <= (OTHERS => '0');
        max_val_tarolo <= x"0000000F";
        div_val_tarolo <= "0000000011";
        h_tarolo <= x"00000010";
        
--        min_val_tarolo_next <= (OTHERS => '0');
--        max_val_tarolo_next <= x"11111111";
--        div_val_tarolo_next <= "1000000000";
--        h_tarolo_next <= x"10000000";
    end if;
end process State_R;

next_case_log:process(actual_case, gombok, kapcsolok)
begin
	case(actual_case) is
        when READY =>
            if gombok="00" then
                next_case<=READY;
            else 
                next_case<=DIVISION;
            end if;
        when DIVISION =>
            if gombok(0)='1' then
                next_case <= PLUS;
            else
                next_case <= MINUS;
            end if;
        when PLUS =>
            case(kapcsolok) is
                when "00" =>
                    next_case <= PLUS_MIN_VAL;
                when "01" =>
                    next_case <= PLUS_MAX_VAL;
                when "10" =>
                    next_case <= PLUS_DIV_VAL;
                when OTHERS =>
                    next_case <= PLUS_H;
                end case;
        when PLUS_MIN_VAL =>
            next_case <= RELEASE;
        when PLUS_MAX_VAL =>
            next_case <= RELEASE;
        when PLUS_DIV_VAL =>
            next_case <= RELEASE;
        when PLUS_H =>
            next_case <= RELEASE;
        when MINUS =>
            case(kapcsolok) is
                when "00" =>
                    next_case <= MINUS_MIN_VAL;
                when "01" =>
                    next_case <= MINUS_MAX_VAL;
                when "10" =>
                    next_case <= MINUS_DIV_VAL;
                when OTHERS =>
                    next_case <= MINUS_H;
                end case;
        when MINUS_MIN_VAL =>
            next_case <= RELEASE;
        when MINUS_MAX_VAL =>
            next_case <= RELEASE;
        when MINUS_DIV_VAL =>
            next_case <= RELEASE;
        when MINUS_H =>
            next_case <= RELEASE;
        when RELEASE =>
            if gombok="00" then
                next_case <= READY;
            else
                next_case <= RELEASE;
            end if;
		end case;
		min_val_tarolo_next <= min_val_tarolo;
		max_val_tarolo_next <= max_val_tarolo;
		div_val_tarolo_next <= div_val_tarolo;
		h_tarolo_next <= h_tarolo;
		--min val modify
		if actual_case = PLUS_MIN_VAL and min_val_tarolo < max_val_tarolo then
                min_val_tarolo_next <= min_val_tarolo+1;
        end if;
 		if actual_case = MINUS_MIN_VAL and min_val_tarolo > x"00000000" then
                min_val_tarolo_next <= min_val_tarolo-1;
        end if;
                   
		--max val modify
		if actual_case = PLUS_MAX_VAL and max_val_tarolo < x"FFFFFFFF" then
                max_val_tarolo_next <= max_val_tarolo+1;
        end if;
        if actual_case = MINUS_MAX_VAL and max_val_tarolo > min_val_tarolo + 2  then
                max_val_tarolo_next <= max_val_tarolo-1;
        end if;   
     
        --div val modify      
		if actual_case = PLUS_DIV_VAL and div_val_tarolo < "1111111111" then
                div_val_tarolo_next <= div_val_tarolo+1;             
        end if;
        if actual_case = MINUS_DIV_VAL and div_val_tarolo > "0000000000" then
                div_val_tarolo_next <= div_val_tarolo-1;              
        end if;
        

        
        if actual_case = PLUS_H and max_val_tarolo > (h_tarolo + min_val_tarolo + 1)  then
            h_tarolo_next <= h_tarolo+1;
        end if;
        if actual_case = MINUS_H and h_tarolo > 0 then
            h_tarolo_next <= h_tarolo-1;
        end if; 
        
--        --h val modify
----        if actual_case = PLUS_H and h_tarolo_next < max_val_tarolo then
----            h_tarolo_next <= h_tarolo+1;
----        end if;
----        if actual_case = MINUS_H and h_tarolo_next > min_val_tarolo then
----            h_tarolo_next <= h_tarolo-1;
----        end if; 


        if max_val_tarolo < (h_tarolo + min_val_tarolo + 1) then
            h_tarolo_next <= max_val_tarolo - min_val_tarolo -1;
        end if;
end process next_case_log;

--overflow/underflow hibak

--WITH actual_case SELECT
--min_val_tarolo_next <= min_val_tarolo+1 WHEN PLUS_MIN_VAL,
--                       min_val_tarolo-1 WHEN MINUS_MIN_VAL,
--                       min_val_tarolo WHEN OTHERS;
--WITH actual_case SELECT
--max_val_tarolo_next <= max_val_tarolo+1 WHEN PLUS_MAX_VAL,
--                       max_val_tarolo-1 WHEN MINUS_MAX_VAL,
--                       max_val_tarolo WHEN OTHERS;
                                              
--WITH actual_case SELECT
--div_val_tarolo_next <= div_val_tarolo+1 WHEN PLUS_DIV_VAL,
--                       div_val_tarolo-1 WHEN MINUS_DIV_VAL,
--                       div_val_tarolo WHEN OTHERS;
                     
--WITH actual_case SELECT
--h_tarolo_next <= h_tarolo+1 WHEN PLUS_H,
--                 h_tarolo-1 WHEN MINUS_H,
--                 h_tarolo WHEN OTHERS;

gombok(0) <= gomb_fel;
gombok(1) <= gomb_le;

kapcsolok(0) <= kapcsolo_1;
kapcsolok(1) <= kapcsolo_2;

min_val <= min_val_tarolo;
max_val <= max_val_tarolo;
div_val <= div_val_tarolo;
h <= h_tarolo;

end Behavioral;

architecture Simplified of pwm_manualis_beallitas is
signal impulse: std_logic;
signal kapcsolo : std_logic_vector(1 downto 0);
begin
impulse <= gomb_fel or gomb_le;
kapcsolo <= kapcsolo_2&kapcsolo_1;
process(impulse,reset)
variable min_val_tarolo : STD_LOGIC_VECTOR (31 downto 0):= conv_std_logic_vector(min_val_kezd,32);
variable max_val_tarolo : STD_LOGIC_VECTOR (31 downto 0):= conv_std_logic_vector(max_val_kezd,32);
variable div_val_tarolo : STD_LOGIC_VECTOR (9 downto 0):=conv_std_logic_vector(div_val_kezd,10);
variable h_tarolo : STD_LOGIC_VECTOR (31 downto 0):=conv_std_logic_vector(h_val_kezd,32);

begin 
if reset='1' then
 min_val_tarolo:=conv_std_logic_vector(min_val_kezd,32);
 max_val_tarolo:=conv_std_logic_vector(max_val_kezd,32);
 div_val_tarolo:=conv_std_logic_vector(div_val_kezd,10);
 h_tarolo:=conv_std_logic_vector(h_val_kezd,32);
elsif impulse'event and impulse ='1' then
if gomb_fel = '1' then
    case kapcsolo is
  when "00" =>  
    if min_val_tarolo + h_tarolo < max_val_tarolo  then
        min_val_tarolo:=min_val_tarolo+1;
    end if;
  when "01" => if max_val_tarolo < max_val_32 then  
                    max_val_tarolo :=max_val_tarolo+1;
             end if;
  when "10" => if div_val_tarolo <  max_val_10 then
                div_val_tarolo := div_val_tarolo+1;
                end if;
  when "11" =>  if min_val_tarolo + h_tarolo < max_val_tarolo  then
                       h_tarolo:=h_tarolo+1;
                   end if;
end case;
end if;

if gomb_le = '1' then
    case kapcsolo is
  when "00" =>  
    if min_val_tarolo > conv_std_logic_vector(0, 32)  then
        min_val_tarolo:=min_val_tarolo-1;
    end if;
  when "01" =>  if max_val_tarolo > conv_std_logic_vector(0, 32)  then
                    max_val_tarolo :=max_val_tarolo-1;
             end if;
  when "10" =>if div_val_tarolo > conv_std_logic_vector(0, 10)  then
                div_val_tarolo := div_val_tarolo-1;
                end if;
  when "11" =>  if h_tarolo > conv_std_logic_vector(0, 32)  then
                       h_tarolo:=h_tarolo-1;
                   end if;
end case;
end if;

end if;
min_val <= min_val_tarolo;
max_val <= max_val_tarolo;
div_val <= div_val_tarolo;
h <= h_tarolo;
end process;



end Simplified;


