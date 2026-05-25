library ieee;
use ieee.std_logic_1164.all;


entity myxor is
	port(
		signal s: in std_logic_vector(2 downto 0);
		signal a: in std_logic_vector(31 downto 0);
		signal b: in std_logic_vector(31 downto 0);
		signal r: out std_logic_vector(31 downto 0)
	);
end entity myxor;

architecture a_myxor of myxor is
begin
	process(s, a, b)
	begin
		case s is
			when "000" => r <= a xor b;
			
			--when others => result <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
			
			when others => r <= "11111111111111111111111111111111";
		end case;
	end process;
end architecture a_myxor;