//Contador arbitrario de 4 bits con biestables JK
// Cuenta a realizar: 4-11-2-0-4-2-10-3-15-1
// Cuenta alternativa: 0-11-6-5-4-2-10-3-15-1
// Alvaro Garcia y Pedro Covelo

// Creacion del modulo de un unico biestable JK
// -----------------------------------------------------------------------------------------------------------

module JK (output reg Q, output wire NQ, input wire J, input wire K,   input wire C);
  not(NQ,Q);

  initial
  begin
    Q=0;
  end    

  always @(posedge C)
    case ({J,K})
      2'b10: Q=1;
      2'b01: Q=0;
      2'b11: Q=~Q;
    endcase
endmodule

// ------------------------------------------------------------------------------------------------------------------
// Creacion del modulo principal del contador de 4 bits con biestables JK

module Contador4bits(output wire [3:0] Q, input wire C);

	wire [3:0] nQ; // Cables correspondientes a las salidas negadas de los biestables
	
	wire Qt0, nQt0; // Cables que almacenan la salida temporal del biestable jk0
	
	wire Qt2, nQt2; // Cables que almacenan la salida temporal del biestable jk2
	
	
	wire j3,j2,j1,j0,k3,k2,k1,k0; // Cables de entrada a los biestables 
	

	wire nq0nq2, q1nq2, nq1nq0q2, q0nq2, q1q0, nq1nq0nq3, nq0nq3, nq0nq3q2, q0q3q2, nq1nq3, q1q3, nq3q2, q1q3nq2; // Cables intermedios del contador
	
// ----------------------------------------------------------------------------------------------------------------------
// Implementacion de las puertas logicas correspondientes a las entradas y salidas de los biestables: 
   
   
   and a1 (nq0nq2, nQt0, nQt2);
   and a2 (q1nq2, Q[1], nQt2);
   or J3 (j3, nq0nq2, q1nq2);
   
   and J2 (j2, Q[1], Qt0);
   
   and a3 (nq0nq3, nQt0, nQ[3]);
   and a4 (nq0nq2, nQt0, nQt2);
   and a5 (q0q3q2, Qt0, Q[3], Qt2);
   or J1 (j1, nq0nq3, nq0nq2, q0q3q2);
   
   and a6 (nq1nq3nq2, nQ[1], nQ[3], nQt2);
   and a7 (q1q2, Q[1], Qt2);
   and a8 (q1q3, Q[1], Q[3]);
   or J0 (j0, nq1nq3nq2, q1q2, q1q3);
   
   and a9 (nq1nq0q2, nQ[1], nQt0, Qt2);
   and a10 (q0nq2, Qt0, nQt2);
   and a11 (q1nq2, Q[1], nQt2);
   and a12 (q1q0, Q[1], Qt0);
   or K3 (k3, nq1nq0q2, q0nq2, q1nq2, q1q0);
   
   and a13 (nq1nq0nq3, nQ[1], nQt0, nQ[3]);
   and a14 (q1q0, Q[1], Qt0);
   or K2 (k2, nq1nq0nq3, q1q0);
   
   and a15 (nq0nq3q2, nQt0, nQ[3], Qt2);
   and a16 (q0q3q2, Qt0, Q[3], Qt2);
   or K1 (k1, nq0nq3q2, q0q3q2);
   
   and a17 (nq1nq3, nQ[1], nQ[3]);
   and a18 (q1q3nq2, Q[1], Q[3], nQt2);
   or K0 (k0, nq1nq3, q1q3nq2);
   
  
   

  
// -----------------------------------------------------------------------------------------------------------------------
// Implementacion de los 4 biestables necesarios

   JK jk0 (Qt0, nQt0, j0, k0, C);
   JK jk1 (Q[1], nQ[1], j1, k1, C);
   JK jk2 (Qt2, nQt2, j2, k2, C);
   JK jk3 (Q[3], nQ[3], j3, k3, C);
   
   
   
// ---------------------------------------------------------------------------------------------------------
// Circuiteria que cambia el 0 por el 4, el 6 por el 2 y el 5 por el 0
	
	and a19 (nq1nq0nq3, nQ[1], nQt0, nQ[3]);
	and a20 (q3q2, Q[3], Qt2);
	and a21 (q1q0q2, Q[1], Qt0, Qt2);
	or Q2 (Q[2], nq1nq0nq3, q3q2, q1q0q2);
	
	and a22 (q0nq2, Qt0, nQt2);
	and a23 (q0q3, Qt0, Q[3]);
	and a24 (q1q0, Q[1], Qt0);
	or Q0 (Q[0], q0nq2, q0q3, q1q0);
	
	

	
   
endmodule

// -----------------------------------------------------------------------------------------------------------------------
// Creacion en ultimo lugar del modulo de testeo para comprobar el correcto funcionamiento del programa con su fichero dumpfile correspondiente
// -------------------------------------------------------------------------------------------------------------------------

module testContador;
  reg I, C;
  wire [3:0] Q;
  Contador4bits counter(Q,C);

  always 
  begin
    #10 C=~C;
  end

  initial
  begin
    $dumpfile("Contador_arbitrario.dmp");
    $dumpvars(2, counter, Q);
    $display ("Initial 1010");
    $monitor ($time, "  %d", Q); 
          
    C=0;
    #500 $finish;
  end
endmodule
   
// -------------------------------------------------------------------------------------------------------------------------
    
