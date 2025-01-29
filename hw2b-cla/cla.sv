`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);

   // TODO: your code here
       // Generate and Propagate outputs
    assign gout = gin[3] | (pin[3] & gin[2]) | (pin[3] & pin[2] & gin[1]) | (pin[3] & pin[2] & pin[1] & gin[0]);
    assign pout = pin[3] & pin[2] & pin[1] & pin[0];

    // Carry outputs
    assign cout[0] = gin[0] | (pin[0] & cin);
    assign cout[1] = gin[1] | (pin[1] & gin[0]) | (pin[1] & pin[0] & cin);
    assign cout[2] = gin[2] | (pin[2] & gin[1]) | (pin[2] & pin[1] & gin[0]) | (pin[2] & pin[1] & pin[0] & cin);

endmodule

/** Same as gp4 but for an 8-bit window instead */
module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);

   // TODO: your code here
// Generate and Propagate outputs for the entire 8-bit window
    assign gout = gin[7] | 
                  (pin[7] & gin[6]) | 
                  (pin[7] & pin[6] & gin[5]) | 
                  (pin[7] & pin[6] & pin[5] & gin[4]) | 
                  (pin[7] & pin[6] & pin[5] & pin[4] & gin[3]) | 
                  (pin[7] & pin[6] & pin[5] & pin[4] & pin[3] & gin[2]) | 
                  (pin[7] & pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & gin[1]) | 
                  (pin[7] & pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & gin[0]);

    assign pout = pin[7] & pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & pin[0];

    // Carry outputs
    assign cout[0] = gin[0] | (pin[0] & cin);
    assign cout[1] = gin[1] | (pin[1] & gin[0]) | (pin[1] & pin[0] & cin);
    assign cout[2] = gin[2] | (pin[2] & gin[1]) | (pin[2] & pin[1] & gin[0]) |
                     (pin[2] & pin[1] & pin[0] & cin);
    assign cout[3] = gin[3] | (pin[3] & gin[2]) | (pin[3] & pin[2] & gin[1]) |
                     (pin[3] & pin[2] & pin[1] & gin[0]) |
                      (pin[3] & pin[2] & pin[1] & pin[0] & cin);
    assign cout[4] = gin[4] | (pin[4] & gin[3]) | (pin[4] & pin[3] & gin[2]) |
                      (pin[4] & pin[3] & pin[2] & gin[1]) |
                     (pin[4] & pin[3] & pin[2] & pin[1] & gin[0])
                     | (pin[4] & pin[3] & pin[2] & pin[1] & pin[0] & cin);
    assign cout[5] = gin[5] | (pin[5] & gin[4]) | (pin[5] & pin[4] & gin[3]) |
                      (pin[5] & pin[4] & pin[3] & gin[2]) |
                     (pin[5] & pin[4] & pin[3] & pin[2] & gin[1])
                     | (pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & gin[0]) |
                     (pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & pin[0] & cin);
    assign cout[6] = gin[6] | (pin[6] & gin[5]) | (pin[6] & pin[5] & gin[4]) |
                     (pin[6] & pin[5] & pin[4] & gin[3]) |
                     (pin[6] & pin[5] & pin[4] & pin[3] & gin[2]) |
                      (pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & gin[1]) |
                     (pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & gin[0]) |
                     (pin[6] & pin[5] & pin[4] & pin[3] & pin[2] & pin[1] & pin[0] & cin);

endmodule

module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   // TODO: your code here
   wire [31:0] gen,prop;
   wire [27:0] carry_out;
   wire c_out[3];
   wire gout[4];
   wire pout[4];

   genvar i;
   for(i=0;i<32;i++)
   begin
      gp1 g1(
         .a(a[i]),
         .b(b[i]),
         .g(gen[i]),
         .p(prop[i])
      );
   end
   gp8 g8_0(
         .gin(gen[7:0]),
         .pin(prop[7:0]),
         .cin(cin),
         .gout(gout[0]),
         .pout(pout[0]),
         .cout(carry_out[6:0])
   );
   assign c_out[0]=gout[0]|(pout[0]&carry_out[6]);
   gp8 g8_1(
         .gin(gen[15:8]),
         .pin(prop[15:8]),
         .cin(c_out[0]),
         .gout(gout[1]),
         .pout(pout[1]),
         .cout(carry_out[13:7])
   );
   assign c_out[1]=gout[1]|(pout[1]&carry_out[13]);
   gp8 g8_2(
         .gin(gen[23:16]),
         .pin(prop[23:16]),
         .cin(c_out[1]),
         .gout(gout[2]),
         .pout(pout[2]),
         .cout(carry_out[20:14])
   );
   assign c_out[2]=gout[2]|(pout[2]&carry_out[20]);
   gp8 g8_3(
         .gin(gen[31:24]),
         .pin(prop[31:24]),
         .cin(c_out[2]),
         .gout(gout[3]),
         .pout(pout[3]),
         .cout(carry_out[27:21])
   );


   // assign c_out[6:0]=carry_out[6:0];
   // assign c_out[14:8]=carry_out[14:8];
   // assign c_out[22:16]=carry_out[22:16];
   // assign c_out[30:24]=carry_out[30:24];

   assign sum=a^b^{carry_out[27:21],c_out[2],carry_out[20:14],c_out[1],carry_out[13:7],c_out[0],carry_out[6:0],cin};

endmodule
