LIBRARY ieee ;
USE ieee.std_logic_1164.all;

ENTITY Conversor_Aresta_f IS
	PORT ( A, B, C, D: IN STD_LOGIC;
				ff : OUT STD_LOGIC);
END Conversor_Aresta_f;

ARCHITECTURE LogicFunction OF Conversor_Aresta_f IS
BEGIN
		ff <= ((NOT(A) AND B AND NOT(C)) OR (A AND C) OR (B AND NOT(D)) OR (NOT(C) AND NOT(D)) OR (A AND NOT(B))) ;
END LogicFunction;