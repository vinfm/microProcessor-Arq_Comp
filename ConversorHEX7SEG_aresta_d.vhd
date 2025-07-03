LIBRARY ieee ;
USE ieee.std_logic_1164.all;

ENTITY Conversor_Aresta_d IS
	PORT ( A, B, C, D: IN STD_LOGIC;
				fd : OUT STD_LOGIC);
END Conversor_Aresta_d;

ARCHITECTURE LogicFunction OF Conversor_Aresta_d IS
BEGIN
		fd <= ((B AND NOT(C) AND D) OR (A AND NOT(C)) OR (NOT(A) AND NOT(B) AND NOT(D)) OR (NOT(B) AND C AND D) OR (B AND C AND NOT(D)) ) ;
END LogicFunction;