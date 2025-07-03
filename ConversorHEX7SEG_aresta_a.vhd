LIBRARY ieee ;
USE ieee.std_logic_1164.all;

ENTITY Conversor_Aresta_a IS
	PORT ( A, B, C, D: IN STD_LOGIC;
				fa : OUT STD_LOGIC);
END Conversor_Aresta_a;

ARCHITECTURE LogicFunction OF Conversor_Aresta_a IS
BEGIN
		fa <= ((NOT(A) AND B AND D) OR (A AND NOT(B) AND NOT(C)) OR (NOT(B) AND NOT(D)) OR(NOT(A) AND C) OR (A AND NOT(D)) OR (B AND C));
END LogicFunction;