LIBRARY ieee ;
USE ieee.std_logic_1164.all;

ENTITY Conversor_Aresta_g IS
	PORT ( A, B, C, D: IN STD_LOGIC;
				fg : OUT STD_LOGIC);
END Conversor_Aresta_g;

ARCHITECTURE LogicFunction OF Conversor_Aresta_g IS
BEGIN
		fg <= ((NOT(B) AND C) OR (C AND NOT(D)) OR (A AND NOT(B)) OR (A AND D) OR (NOT(A) AND B AND NOT(C))) ;
END LogicFunction;