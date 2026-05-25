library ieee;
use ieee.std_logic_1164.all;


entity customcombinationalInterface is
	port(
		signal n: in std_logic_vector(2 downto 0);
		signal dataa: in std_logic_vector(31 downto 0);
		signal datab: in std_logic_vector(31 downto 0);
		signal result: out std_logic_vector(31 downto 0)
	);
end entity customcombinationalInterface;


architecture a_customcombinationalInterface of customcombinationalInterface is
	component myxor is port(
		signal s: in std_logic_vector(2 downto 0);
		signal a: in std_logic_vector(31 downto 0);
		signal b: in std_logic_vector(31 downto 0);
		signal r: out std_logic_vector(31 downto 0)
	);
	end component;
begin
	customcombinational_instance: myxor
	port map (
		n,
		dataa,
		datab,
		result
	);
end architecture a_customcombinationalInterface;