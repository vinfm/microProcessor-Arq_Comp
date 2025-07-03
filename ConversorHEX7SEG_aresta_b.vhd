LIBRARY ieee ;
USE ieee.std_logic_1164.all;

ENTITY Conversor_Aresta_b IS
	PORT ( A, B, C, D: IN STD_LOGIC;
				fb : OUT STD_LOGIC);
END Conversor_Aresta_b;

ARCHITECTURE LogicFunction OF Conversor_Aresta_b IS
BEGIN
		fb <= ((NOT(A) AND NOT(C) AND NOT (D)) OR (A AND NOT(C) AND D) OR (NOT(A) AND C AND D) OR (NOT(B) AND NOT (D)) OR (NOT(B) AND NOT(C)));
END LogicFunction;