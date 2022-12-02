`timescale 1ns/1ps

`define prime 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
`define delay   10

class seq_item #();

  rand bit [255:0] rand_X1, rand_Y1, rand_Z1, rand_X2, rand_Y2, rand_Z2;
  constraint value_X1 {rand_X1 inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}
  constraint value_Y1 {rand_Y1 inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}
  constraint value_Z1 {rand_Z1 inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}
  constraint value_X2 {rand_X2 inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}
  constraint value_Y2 {rand_Y2 inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}
  constraint value_Z2 {rand_Z2 inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}

endclass

module ECCcore_add_test_tb;

reg [255:0] Xout, Yout, Zout;

reg clk, start;
reg [255:0] X1in, Y1in, Z1in, X2in, Y2in, Z2in;
wire [255:0] X, Y, Z;
wire busy;

ECCcoreAdd ECCcore(clk, X1in, Y1in, Z1in, X2in, Y2in, Z2in, X, Y, Z, start, busy);
seq_item #() item;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #1000000
  $finish;
end

always #50  clk = ~clk;

function [767:0] ecc;
    input [255:0] X1in,Y1in,Z1in, X2in,Y2in,Z2in;

    reg [255:0] Xout, Yout, Zout, U1, U2, S1, S2, H, R, A;
    reg [1027:0] U;

begin
    U = X1in*Z2in*Z2in;
    U1 = U % `prime;
    U = X2in*Z1in*Z1in;
    U2 = U % `prime;
    U = Y1in*Z2in*Z2in*Z2in;
    S1 = U % `prime;
    U = Y2in*Z1in*Z1in*Z1in;
    S2 = U % `prime;
  	U = (X2in*Z1in*Z1in - U1) ;
    H = U % `prime;
    U = (Y2in*Z1in*Z1in*Z1in - S1) ;
    R = U % `prime;

    U = (H*H*H + 2*U1*H*H);
    A = U % `prime;
    U = R*R - A;
    Xout = U % `prime;

    U = (R*X + S1*H*H*H);
    A = U % `prime;
    U = R*U1*H*H - A;
    Yout = U % `prime;

    U = H*Z1in*Z2in;
    Zout = U % `prime;

    ecc = {Xout, Yout, Zout};
end  
endfunction

initial begin
  clk = 1;  // initialize clk
  item = new();
    repeat(10) begin
        start = 0;
        item.randomize();
        X1in = item.rand_X1;
        Y1in = item.rand_Y1;
        Z1in = item.rand_Z1;
        X2in = item.rand_X2;
        Y2in = item.rand_Y2;
        Z2in = item.rand_Z2;
        @(posedge clk)  #`delay;
        start = 1;
        @(posedge clk)  #`delay;
        while (busy==1) @(posedge clk);
        {Xout, Yout, Zout} = ecc(X1in, Y1in, Z1in, X2in, Y2in, Z2in);
        if((X==Xout)&&(Y==Yout)&&(Z==Zout)) begin
            $display("Pass");
        end else begin
            $display("Error X=%h    Y=%h    Z=%h",X, Y, Z);
            $display("   Xout=%h Yout=%h Zout=%h", Xout, Yout, Zout);
        end
    end
$finish;
end

endmodule