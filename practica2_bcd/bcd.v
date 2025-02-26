module bcd(
    input wire [9:0] input_bin,
    output wire [6:0] U, D, C, M
);
    wire [3:0] unis_wire, dec_wire, cent_wire, miles_wire;
    assign unis_wire = input_bin % 10;
    assign dec_wire = (input_bin / 10) % 10;  
    assign cent_wire = (input_bin / 100) % 10;  
    assign miles_wire = (input_bin / 1000) % 10; 

    decoder_7_seg disp_uni (
        .decoder_in(unis_wire),
        .decoder_out(U)
    );

    decoder_7_seg disp_dec (
        .decoder_in(dec_wire),
        .decoder_out(D)
    );

    decoder_7_seg disp_cent (
        .decoder_in(cent_wire),
        .decoder_out(C)
    );

    decoder_7_seg disp_miles (
        .decoder_in(miles_wire),
        .decoder_out(M)
    );

endmodule