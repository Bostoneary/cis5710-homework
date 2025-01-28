/* INSERT NAME AND PENNKEY HERE */
// NAME:Zhiye Zhang
// PENNKEY:zhiyez

`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

    // TODO: your code here
    wire [31:0] remainder_tmp[33];
    wire [31:0] dividend_tmp[33];
    wire [31:0] quotient_tmp[33];

    assign remainder_tmp[0]=0;
    assign dividend_tmp[0]=i_dividend;
    assign quotient_tmp[0]=0;

    genvar i;
    for(i=0;i<32;i++)
    begin
        divu_1iter d(
            .i_dividend(dividend_tmp[i]),
            .i_divisor(i_divisor),
            .i_remainder(remainder_tmp[i]),
            .i_quotient(quotient_tmp[i]),
            .o_dividend(dividend_tmp[i+1]),
            .o_remainder(remainder_tmp[i+1]),
            .o_quotient(quotient_tmp[i+1])
        );
    end
    assign o_remainder=remainder_tmp[32];
    assign o_quotient=quotient_tmp[32];

endmodule


module divu_1iter (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    input  wire [31:0] i_remainder,
    input  wire [31:0] i_quotient,
    output wire [31:0] o_dividend,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
  /*
    for (int i = 0; i < 32; i++) {
        remainder = (remainder << 1) | ((dividend >> 31) & 0x1);
        if (remainder < divisor) {
            quotient = (quotient << 1);
        } else {
            quotient = (quotient << 1) | 0x1;
            remainder = remainder - divisor;
        }
        dividend = dividend << 1;
    }
    */

    // TODO: your code here
    logic [31:0] remainder_tmp;
    logic [31:0] quotient_tmp;
    logic [31:0] dividend_tmp;
    always_comb
    begin
        remainder_tmp=(i_remainder<<1)|((i_dividend>>31)&32'b1);
        if(remainder_tmp<i_divisor)
        begin
            quotient_tmp=i_quotient<<1;
        end
        else
        begin
            remainder_tmp=remainder_tmp-i_divisor;
            quotient_tmp=(i_quotient<<1)|32'b1;
        end
        dividend_tmp=i_dividend<<1;
    end
    assign o_dividend=dividend_tmp;
    assign o_quotient=quotient_tmp;
    assign o_remainder=remainder_tmp;
endmodule
