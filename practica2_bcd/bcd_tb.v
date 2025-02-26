module bcd_tb();
    reg [9:0] input_bin;
    wire [6:0] U, D, C, M;  
    
    bcd DUT(
        .input_bin(input_bin),
        .U(U),
        .D(D),
        .C(C),
        .M(M)
    );
    
    initial begin
        
        input_bin = 0;
        #10;
        
        input_bin = 5;
        #10;
        
        input_bin = 66;
        #10;
        
        input_bin = 778;
        #10;
        
        input_bin = 1022;
        #10;
        
        
        $stop;
    end
    
endmodule