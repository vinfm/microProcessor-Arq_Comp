LIBRARY ieee ;
USE ieee.std_logic_1164.all;

ENTITY Conversor_Aresta_c IS
	PORT ( A, B, C, D: IN STD_LOGIC;
				fc : OUT STD_LOGIC);
END Conversor_Aresta_c;

ARCHITECTURE LogicFunction OF Conversor_Aresta_c IS
BEGIN
		fc <= ((NOT(C) AND D) OR (NOT(A) AND B) OR (A AND NOT(B)) OR (NOT(A) AND NOT(C)) OR (NOT(A) AND D)) ;
END LogicFunction;