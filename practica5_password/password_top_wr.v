module password_top_wr(
    input              MAX10_CLK1_50,
    input       [1:0]  KEY,
    
    input       [9:0]  SW,
    
    output      [6:0]  HEX0,
    output      [6:0]  HEX1,
    output      [6:0]  HEX2,
    output      [6:0]  HEX3,
    output      [6:0]  HEX4,
	 output [6:0] HEX5
);

    // Instancia del módulo original conectado directamente a los pines
    password_top password_inst(
        .clk(MAX10_CLK1_50),
        .rst_a_p(~KEY[0]),          // Los botones son activos en bajo en DE10-Lite
        .switches(SW),              // Conectamos los switches directamente
        .HEX0(HEX0[6:0]),
        .HEX1(HEX1[6:0]),
        .HEX2(HEX2[6:0]),
        .HEX3(HEX3[6:0]),
        .HEX4(HEX4[6:0]),
		  .HEX5(HEX5[6:0])
    );
	 
endmodule

