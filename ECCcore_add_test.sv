`timescale 1ns/1ps

`define prime 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F

// Multiplier state
`define Init      0   //state
`define Mul1      1   //state
`define Mul2      2   //state
`define Mul3      3   //state
`define Mul4      4   //state
`define Mul5      5   //state
`define Mul6      6   //state
`define Mul7      7   //state
`define Mul8      8   //state
`define Mul9      9   //state
`define Mul10    10   //state
`define Mul11    11   //state
`define Mul12    12   //state
`define Mul13    13   //state
`define Mul14    14   //state
`define Mul15    15   //state
`define Mul16    16   //state
`define Add      17   //state
`define Final    18   //state

// Modular Reduction state
`define Init     0   //state
`define Mod1     1   //state
`define Mod2     2   //state
`define Mod3     3   //state
`define Mod4     4   //state
`define Mod5     5   //state
`define Mod6     6   //state
`define Mod7     7   //state
`define Mod8     8   //state
`define Finish   9  //state

// ECCcore state
`define Init      0   //state
`define ML        1   //state

`define Add1a     48   //state
`define Add1b     49   //state
`define Add1c     50   //state
`define Add1d     51   //state
`define Add2a     52   //state
`define Add2b     53   //state
`define Add2c     54   //state
`define Add2d     55   //state
`define Add3a     56   //state
`define Add3b     57   //state
`define Add3c     58   //state
`define Add3d     59   //state
`define Add4a     60   //state
`define Add4b     61   //state
`define Add4c     62   //state
`define Add4d     63   //state
`define Add5a     64   //state
`define Add5b     65   //state
`define Add5c     66   //state
`define Add5d     67   //state
`define Add6a     68   //state
`define Add6b     69   //state
`define Add6c     70   //state
`define Add6d     71   //state
`define Add7a     72   //state
`define Add7b     73   //state
`define Add7c     74   //state
`define Add7d     75   //state
`define Add8a     76   //state
`define Add8b     77   //state
`define Add8c     78   //state
`define Add8d     79   //state
`define Add9a     80   //state
`define Add9b     81   //state
`define Add9c     82   //state
`define Add9d     83   //state
`define Add10a    84   //state
`define Add10b    85   //state
`define Add10c    86   //state
`define Add10d    87   //state
`define Add11a    88   //state
`define Add11b    89   //state
`define Add11c    90   //state
`define Add11d    91   //state
`define Add12a    92   //state
`define Add12b    93   //state
`define Add12c    94   //state
`define Add12d    95   //state
`define Add13a    96   //state
`define Add13b    97   //state
`define Add13c    98   //state
`define Add13d    99   //state
`define Add14a    100   //state
`define Add14b    101   //state
`define Add14c    102   //state
`define Add14d    103   //state
`define Add15a    104   //state
`define Add15b    105   //state
`define Add15c    106   //state
`define Add15d    107   //state
`define Add15e    108   //state
`define Add15f    109   //state
`define Add16a    110   //state
`define Add16b    111   //state
`define Add16c    112   //state
`define Add16d    113   //state
`define Add16e    114   //state
`define Add16f    115   //state
`define Add17a    116   //state
`define Add17b    117   //state
`define Add17c    118   //state
`define Add17d    119   //state
`define Add18a    120   //state
`define Add18b    121   //state
`define Add18c    122   //state
`define Add18d    123   //state
`define Add18e    124   //state
`define Add18f    125   //state
`define MLfinal   126   //state

module Mul256with64(clk, start, busy, A, B, C);

input clk, start;
input [255:0] A,B;
output busy;
output [511:0] C;

reg [63:0] a,b;
reg [319:0] Reg1,Reg2;
reg [511:0] C;
reg [4:0] state;
reg busy;

wire [127:0] c;

assign c = a * b;

always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    state <= `Init;
end else begin
    if(state == `Init) begin
    busy <= 1;
    C <= 512'b0;
    Reg1 <= 320'b0;
    Reg2 <= 320'b0;
    a <= A[63:0];
    b <= B[63:0];
    state <= `Mul1;
    end else if(state == `Mul1) begin
    C[127:0] <= c;
    a <= A[63:0];
    b <= B[127:64];
    state <= `Mul2;
    end else if(state == `Mul2) begin
    C[191:64] <= C[191:64] + c;
    a <= A[63:0];
    b <= B[191:128];
    state <= `Mul3;
    end else if(state == `Mul3) begin
    C[255:128] <= C[255:128] + c;
    a <= A[63:0];
    b <= B[255:192];
    state <= `Mul4;
    end else if(state == `Mul4) begin
    C[319:192] <= C[319:192] + c;
    a <= A[127:64];
    b <= B[63:0];
    state <= `Mul5;
    end else if(state == `Mul5) begin
    Reg1[127:0] <= c;
    a <= A[127:64];
    b <= B[127:64];
    state <= `Mul6;
    end else if(state == `Mul6) begin
    Reg1[191:64] <= Reg1[191:64] + c;
    a <= A[127:64];
    b <= B[191:128];
    state <= `Mul7;
    end else if(state == `Mul7) begin
    Reg1[255:128] <= Reg1[255:128] + c;
    a <= A[127:64];
    b <= B[255:192];
    state <= `Mul8;
    end else if(state == `Mul8) begin
    Reg1[319:192] <= Reg1[319:192] + c;
    a <= A[191:128];
    b <= B[63:0];
    state <= `Mul9;
    end else if(state == `Mul9) begin
    C[383:64] <= C[383:64] + Reg1;
    Reg2[127:0] <= c;
    a <= A[191:128];
    b <= B[127:64];
    state <= `Mul10;
    end else if(state == `Mul10) begin
    Reg1 <= 320'b0;
    Reg2[191:64] <= Reg2[191:64] + c;
    a <= A[191:128];
    b <= B[191:128];
    state <= `Mul11;
    end else if(state == `Mul11) begin
    Reg2[255:128] <= Reg2[255:128] + c;
    a <= A[191:128];
    b <= B[255:192];
    state <= `Mul12;
    end else if(state == `Mul12) begin
    Reg2[319:192] <= Reg2[319:192] + c;
    a <= A[255:192];
    b <= B[63:0];
    state <= `Mul13;
    end else if(state == `Mul13) begin
    C[447:128] <= C[447:128] + Reg2;
    Reg1[127:0] <= c;
    a <= A[255:192];
    b <= B[127:64];
    state <= `Mul14;
    end else if(state == `Mul14) begin
    Reg1[191:64] <= Reg1[191:64] + c;
    a <= A[255:192];
    b <= B[191:128];
    state <= `Mul15;
    end else if(state == `Mul15) begin
    Reg1[255:128] <= Reg1[255:128] + c;
    a <= A[255:192];
    b <= B[255:192];
    state <= `Mul16;
    end else if(state == `Mul16) begin  
    Reg1[319:192] <= Reg1[319:192] + c;
    state <= `Add;
    end else if(state == `Add) begin
    C[511:192] <= C[511:192] + Reg1;
    state <= `Final;
    end else if(state == `Final) begin    
    busy <= 0;
    end
end
end
endmodule

module ModRed(clk, start, busy, A, B);

input clk, start;
input [511:0] A;
output busy;
output [255:0] B;

reg busy;
reg [511:0] Reg;
reg [255:0] B, RegH, RegL;
reg [3:0] state;

always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    state <= `Init;
end else begin
    if(state == `Init) begin    //Initialization
        {RegH, RegL} <= A;
        busy <= 1;
        state <= `Mod1;       
    end else if(state == `Mod1) begin
        Reg <= {256'b0, RegH} + {256'b0, RegL};
        state <= `Mod2;
    end else if(state == `Mod2) begin
        Reg <= {252'b0, RegH, 4'b0} + Reg;
        state <= `Mod3;
    end else if(state == `Mod3) begin
        Reg <= {250'b0, RegH, 6'b0} + Reg;
        state <= `Mod4;
    end else if(state == `Mod4) begin
        Reg <= {249'b0, RegH, 7'b0} + Reg;
        state <= `Mod5;
    end else if(state == `Mod5) begin
        Reg <= {248'b0, RegH, 8'b0} + Reg;
        state <= `Mod6;
    end else if(state == `Mod6) begin
        Reg <= {247'b0, RegH, 9'b0} + Reg;
        state <= `Mod7;
    end else if(state == `Mod7) begin
        Reg <= {224'b0, RegH, 32'b0} + Reg;
        state <= `Mod8;
    end else if(state == `Mod8) begin
        if(Reg[511:256] != 256'b0) begin
            {RegH, RegL} <= Reg;
            state <= `Mod1;
        end else begin
            B <= Reg[255:0];
            state <= `Finish;
        end
    end else begin
        busy <= 0;  //finish state
    end
end
end

endmodule

module ECCcoreAdd(clk, X1in, Y1in, Z1in, X2in, Y2in, Z2in, X, Y, Z, start, busy);

input clk, start;
input [255:0] X1in, Y1in, Z1in, X2in, Y2in, Z2in;
output [255:0] X, Y, Z;
output busy;

reg [255:0] X,Y,Z,X1,Y1,Z1,X2,Y2,Z2,A,B,C,D,E,F,a1,a2,s1,s2,mulA,mulB;
reg [511:0] U;
reg main_state;
reg [6:0] state;
reg busy, mul_start, red_start;

wire [255:0] add, sub, red_out;
wire [511:0] mul_out;
wire [256:0] addx, subx;
wire mul_busy, red_busy;

Mul256with64 mul(.clk(clk),.start(mul_start),.busy(mul_busy),.A(mulA),.B(mulB),.C(mul_out));
ModRed red(.clk(clk),.start(red_start),.busy(red_busy),.A(U),.B(red_out));
assign      addx = a1 + a2;
assign      add  = (addx[256])? (a1 + a2 - `prime):(a1 + a2);
assign      subx = s1 - s2;
assign      sub  = (subx[256])? (s1 - s2 + `prime):(s1 - s2);


always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    main_state <= `Init;
end else begin
    if(main_state == `Init) begin    //Initialization
        busy <= 1;
        state <= `Add1a;
        mul_start <= 0; //Reset multiplier *important
        red_start <= 0; //Reset modred *important
        {X1,Y1,Z1} <= {X1in,Y1in,Z1in};
        {X2,Y2,Z2} <= {X2in,Y2in,Z2in};
        main_state <= `ML;
    end else if(main_state == `ML) begin
            if(state == `Add1a) begin
            //wait_mul(Z1, Z1);
                mul_start <= 1;
                mulA <= Z1;
                mulB <= Z1;
                state <= `Add1b;
            end else if(state == `Add1b) begin
                state <= `Add1c; // wait 1 clk
            end else if(state == `Add1c) begin
                state <= (mul_busy == 1)? `Add1c:`Add1d;
            end else if(state == `Add1d) begin
                mul_start <= 0;
                U <= mul_out;
                state <= `Add2a;
            end else if(state == `Add2a) begin
            //wait_mulred(Z2, Z2, A);
                mul_start <= 1;
                red_start <= 1;
                mulA <= Z2;
                mulB <= Z2;
                state <= `Add2b;
            end else if(state == `Add2b) begin
                state <= `Add2c; // wait 1 clk
            end else if(state == `Add2c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add2d:`Add2c;
            end else if(state == `Add2d) begin
                U <= mul_out;
                A <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add3a; 
            end else if(state == `Add3a) begin
            //wait_mulred(A, Z1, E);
                mul_start <= 1;
                red_start <= 1;
                mulA <= A;
                mulB <= Z1;
                state <= `Add3b;
            end else if(state == `Add3b) begin
                state <= `Add3c; // wait 1 clk
            end else if(state == `Add3c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add3d:`Add3c;
            end else if(state == `Add3d) begin
                U <= mul_out;
                E <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add4a; 
            end else if(state == `Add4a) begin
            //wait_mulred(E, Z2, B);
                mul_start <= 1;
                red_start <= 1;
                mulA <= E;
                mulB <= Z2;
                state <= `Add4b;
            end else if(state == `Add4b) begin
                state <= `Add4c; // wait 1 clk
            end else if(state == `Add4c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add4d:`Add4c;
            end else if(state == `Add4d) begin
                U <= mul_out;
                B <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add5a; 
            end else if(state == `Add5a) begin
            //wait_mulred(A, X2, F);
                mul_start <= 1;
                red_start <= 1;
                mulA <= A;
                mulB <= X2;
                state <= `Add5b;
            end else if(state == `Add5b) begin
                state <= `Add5c; // wait 1 clk
            end else if(state == `Add5c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add5d:`Add5c;
            end else if(state == `Add5d) begin
                U <= mul_out;
                F <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add6a; 
            end else if(state == `Add6a) begin
            //wait_mulred(B, Y2, A);
                mul_start <= 1;
                red_start <= 1;
                mulA <= B;
                mulB <= Y2;
                state <= `Add6b;
            end else if(state == `Add6b) begin
                state <= `Add6c; // wait 1 clk
            end else if(state == `Add6c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add6d:`Add6c;
            end else if(state == `Add6d) begin
                U <= mul_out;
                A <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add7a; 
            end else if(state == `Add7a) begin
            //wait_mulred(E, X1, B);
                mul_start <= 1;
                red_start <= 1;
                mulA <= E;
                mulB <= X1;
                state <= `Add7b;
            end else if(state == `Add7b) begin
                state <= `Add7c; // wait 1 clk
            end else if(state == `Add7c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add7d:`Add7c;
            end else if(state == `Add7d) begin
                U <= mul_out;
                B <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add8a; 
            end else if(state == `Add8a) begin
            //wait_mulred(F, Y1, E);
                mul_start <= 1;
                red_start <= 1;
                mulA <= F;
                mulB <= Y1;
                state <= `Add8b;
            end else if(state == `Add8b) begin
                state <= `Add8c; // wait 1 clk
            end else if(state == `Add8c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add8d:`Add8c;
            end else if(state == `Add8d) begin
                U <= mul_out;
                E <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add9a; 
            end else if(state == `Add9a) begin
            //wait_mulred(Z1, Z2, F);
            //wait_sub(A, E, A);
                mul_start <= 1;
                red_start <= 1;
                mulA <= Z1;
                mulB <= Z2;
                s1 <= A;
                s2 <= E;
                state <= `Add9b;
            end else if(state == `Add9b) begin
                A <= sub;                
                state <= `Add9c; // wait 1 clk
            end else if(state == `Add9c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add9d:`Add9c;
            end else if(state == `Add9d) begin
                U <= mul_out;
                F <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add10a;
            end else if(state == `Add10a) begin
            //wait_mulred(A, A, D);
            //wait_sub(B, F, B);
                mul_start <= 1;
                red_start <= 1;
                mulA <= A;
                mulB <= A;
                s1 <= B;
                s2 <= F;                
                state <= `Add10b;
            end else if(state == `Add10b) begin
                B <= sub;                
                state <= `Add10c; // wait 1 clk
            end else if(state == `Add10c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add10d:`Add10c;
            end else if(state == `Add10d) begin
                U <= mul_out;
                D <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add11a; 
            end else if(state == `Add11a) begin
            //wait_mulred(A, D, C);
                mul_start <= 1;
                red_start <= 1;
                mulA <= A;
                mulB <= D;
                state <= `Add11b;
            end else if(state == `Add11b) begin
                state <= `Add11c; // wait 1 clk
            end else if(state == `Add11c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add11d:`Add11c;
            end else if(state == `Add11d) begin
                U <= mul_out;
                C <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add12a; 
            end else if(state == `Add12a) begin
            //wait_mulred(C, A, Z2);
                mul_start <= 1;
                red_start <= 1;
                mulA <= C;
                mulB <= A;
                state <= `Add12b;
            end else if(state == `Add12b) begin
                state <= `Add12c; // wait 1 clk
            end else if(state == `Add12c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add12d:`Add12c;
            end else if(state == `Add12d) begin
                U <= mul_out;
                Z2 <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add13a;
            end else if(state == `Add13a) begin
            //wait_mulred(C, E, D);
                mul_start <= 1;
                red_start <= 1;
                mulA <= C;
                mulB <= E;
                state <= `Add13b;
            end else if(state == `Add13b) begin
                state <= `Add13c; // wait 1 clk
            end else if(state == `Add13c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add13d:`Add13c;
            end else if(state == `Add13d) begin
                U <= mul_out;
                D <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add14a; 
            end else if(state == `Add14a) begin
            //wait_mulred(B, B, C);
                mul_start <= 1;
                red_start <= 1;
                mulA <= B;
                mulB <= B;
                state <= `Add14b;
            end else if(state == `Add14b) begin
                state <= `Add14c; // wait 1 clk
            end else if(state == `Add14c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add14d:`Add14c;
            end else if(state == `Add14d) begin
                U <= mul_out;
                C <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add15a; 
            end else if(state == `Add15a) begin
            //wait_mulred(D, F, X2);
            //wait_add(C, C, A);
                mul_start <= 1;
                red_start <= 1;
                mulA <= D;
                mulB <= F;
                a1 <= C;
                a2 <= C;
                state <= `Add15b;
            end else if(state == `Add15b) begin
                A <= add;
                state <= `Add15c; // wait 1 clk
            end else if(state == `Add15c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Add15d:`Add15c;
            end else if(state == `Add15d) begin
                U <= mul_out;
                X2 <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Add15e; 
            end else if(state == `Add15e) begin
            //wait_add(A, D, A);
                a1 <= A;
                a2 <= D;
                state <= `Add15f;
            end else if(state == `Add15f) begin
                A <= add;
                state <= `Add16a;
            end else if(state == `Add16a) begin
            //wait_red(D);
            //wait_sub(X2, A, X2);
                s1 <= X2;
                s2 <= A;
                red_start <= 1;
                state <= `Add16b;
            end else if(state == `Add16b) begin
                X2 <= sub;
                state <= `Add16c; // wait 1 clk
            end else if(state == `Add16c) begin
                state <= (red_busy == 1)? `Add16c:`Add16d;
            end else if(state == `Add16d) begin
                D <= red_out;
                red_start <= 0;
                state <= `Add16e;
            end else if(state == `Add16e) begin
            //wait_sub(C, X2, C);
                s1 <= C;
                s2 <= X2;    
                state <= `Add16f;
            end else if(state == `Add16f) begin
                C <= sub;
                state <= `Add17a;
            end else if(state == `Add17a) begin
            //wait_mul(B, C);
                mul_start <= 1;
                mulA <= B;
                mulB <= C;
                state <= `Add17b;
            end else if(state == `Add17b) begin
                state <= `Add17c; // wait 1 clk
            end else if(state == `Add17c) begin
                state <= (mul_busy == 1)? `Add17c:`Add17d;
            end else if(state == `Add17d) begin
                mul_start <= 0;
                U <= mul_out;
                state <= `Add18a;
            end else if(state == `Add18a) begin
            //wait_red(C);
                red_start <= 1;
                state <= `Add18b;
            end else if(state == `Add18b) begin
                state <= `Add18c; // wait 1 clk
            end else if(state == `Add18c) begin
                state <= (red_busy == 1)? `Add18c:`Add18d;
            end else if(state == `Add18d) begin
                C <= red_out;
                red_start <= 0;
                state <= `Add18e;
            end else if(state == `Add18e) begin
            //wait_sub(C, D, Y2);
                s1 <= C;
                s2 <= D;    
                state <= `Add18f;
            end else if(state == `Add18f) begin
                Y2 <= sub;
                state <= `MLfinal;                 
            end else if(state == `MLfinal) begin
                {X,Y,Z} <= {X2,Y2,Z2};
                busy <= 0;
            end
    end
end
end
endmodule