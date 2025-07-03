LIBRARY ieee ;
USE ieee.std_logic_1164.all;

ENTITY Conversor_Aresta_e IS
	PORT ( A, B, C, D: IN STD_LOGIC;
				fe : OUT STD_LOGIC);
END Conversor_Aresta_e;

ARCHITECTURE LogicFunction OF Conversor_Aresta_e IS
BEGIN
		fe <= ((NOT(B) AND NOT (D)) OR (C AND NOT(D)) OR (A AND B) OR (A AND C)) ;
END LogicFunction;