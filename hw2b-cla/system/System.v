module gp1 (
	a,
	b,
	g,
	p
);
	input wire a;
	input wire b;
	output wire g;
	output wire p;
	assign g = a & b;
	assign p = a | b;
endmodule
module gp4 (
	gin,
	pin,
	cin,
	gout,
	pout,
	cout
);
	input wire [3:0] gin;
	input wire [3:0] pin;
	input wire cin;
	output wire gout;
	output wire pout;
	output wire [2:0] cout;
	assign gout = ((gin[3] | (pin[3] & gin[2])) | ((pin[3] & pin[2]) & gin[1])) | (((pin[3] & pin[2]) & pin[1]) & gin[0]);
	assign pout = ((pin[3] & pin[2]) & pin[1]) & pin[0];
	assign cout[0] = gin[0] | (pin[0] & cin);
	assign cout[1] = (gin[1] | (pin[1] & gin[0])) | ((pin[1] & pin[0]) & cin);
	assign cout[2] = ((gin[2] | (pin[2] & gin[1])) | ((pin[2] & pin[1]) & gin[0])) | (((pin[2] & pin[1]) & pin[0]) & cin);
endmodule
module gp8 (
	gin,
	pin,
	cin,
	gout,
	pout,
	cout
);
	input wire [7:0] gin;
	input wire [7:0] pin;
	input wire cin;
	output wire gout;
	output wire pout;
	output wire [6:0] cout;
	assign gout = ((((((gin[7] | (pin[7] & gin[6])) | ((pin[7] & pin[6]) & gin[5])) | (((pin[7] & pin[6]) & pin[5]) & gin[4])) | ((((pin[7] & pin[6]) & pin[5]) & pin[4]) & gin[3])) | (((((pin[7] & pin[6]) & pin[5]) & pin[4]) & pin[3]) & gin[2])) | ((((((pin[7] & pin[6]) & pin[5]) & pin[4]) & pin[3]) & pin[2]) & gin[1])) | (((((((pin[7] & pin[6]) & pin[5]) & pin[4]) & pin[3]) & pin[2]) & pin[1]) & gin[0]);
	assign pout = ((((((pin[7] & pin[6]) & pin[5]) & pin[4]) & pin[3]) & pin[2]) & pin[1]) & pin[0];
	assign cout[0] = gin[0] | (pin[0] & cin);
	assign cout[1] = (gin[1] | (pin[1] & gin[0])) | ((pin[1] & pin[0]) & cin);
	assign cout[2] = ((gin[2] | (pin[2] & gin[1])) | ((pin[2] & pin[1]) & gin[0])) | (((pin[2] & pin[1]) & pin[0]) & cin);
	assign cout[3] = (((gin[3] | (pin[3] & gin[2])) | ((pin[3] & pin[2]) & gin[1])) | (((pin[3] & pin[2]) & pin[1]) & gin[0])) | ((((pin[3] & pin[2]) & pin[1]) & pin[0]) & cin);
	assign cout[4] = ((((gin[4] | (pin[4] & gin[3])) | ((pin[4] & pin[3]) & gin[2])) | (((pin[4] & pin[3]) & pin[2]) & gin[1])) | ((((pin[4] & pin[3]) & pin[2]) & pin[1]) & gin[0])) | (((((pin[4] & pin[3]) & pin[2]) & pin[1]) & pin[0]) & cin);
	assign cout[5] = (((((gin[5] | (pin[5] & gin[4])) | ((pin[5] & pin[4]) & gin[3])) | (((pin[5] & pin[4]) & pin[3]) & gin[2])) | ((((pin[5] & pin[4]) & pin[3]) & pin[2]) & gin[1])) | (((((pin[5] & pin[4]) & pin[3]) & pin[2]) & pin[1]) & gin[0])) | ((((((pin[5] & pin[4]) & pin[3]) & pin[2]) & pin[1]) & pin[0]) & cin);
	assign cout[6] = ((((((gin[6] | (pin[6] & gin[5])) | ((pin[6] & pin[5]) & gin[4])) | (((pin[6] & pin[5]) & pin[4]) & gin[3])) | ((((pin[6] & pin[5]) & pin[4]) & pin[3]) & gin[2])) | (((((pin[6] & pin[5]) & pin[4]) & pin[3]) & pin[2]) & gin[1])) | ((((((pin[6] & pin[5]) & pin[4]) & pin[3]) & pin[2]) & pin[1]) & gin[0])) | (((((((pin[6] & pin[5]) & pin[4]) & pin[3]) & pin[2]) & pin[1]) & pin[0]) & cin);
endmodule
module cla (
	a,
	b,
	cin,
	sum
);
	input wire [31:0] a;
	input wire [31:0] b;
	input wire cin;
	output wire [31:0] sum;
	wire [31:0] gen;
	wire [31:0] prop;
	wire [27:0] carry_out;
	wire [2:0] c_out;
	wire [3:0] gout;
	wire [3:0] pout;
	wire gp4_g;
	wire gp4_p;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < 32; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			gp1 g1(
				.a(a[i]),
				.b(b[i]),
				.g(gen[i]),
				.p(prop[i])
			);
		end
	endgenerate
	gp8 g8_0(
		.gin(gen[7:0]),
		.pin(prop[7:0]),
		.cin(cin),
		.gout(gout[0]),
		.pout(pout[0]),
		.cout(carry_out[6:0])
	);
	gp8 g8_1(
		.gin(gen[15:8]),
		.pin(prop[15:8]),
		.cin(c_out[0]),
		.gout(gout[1]),
		.pout(pout[1]),
		.cout(carry_out[13:7])
	);
	gp8 g8_2(
		.gin(gen[23:16]),
		.pin(prop[23:16]),
		.cin(c_out[1]),
		.gout(gout[2]),
		.pout(pout[2]),
		.cout(carry_out[20:14])
	);
	gp8 g8_3(
		.gin(gen[31:24]),
		.pin(prop[31:24]),
		.cin(c_out[2]),
		.gout(gout[3]),
		.pout(pout[3]),
		.cout(carry_out[27:21])
	);
	gp4 g4(
		.gin(gout),
		.pin(pout),
		.cin(cin),
		.gout(gp4_g),
		.pout(gp4_p),
		.cout(c_out)
	);
	assign sum = (a ^ b) ^ {carry_out[27:21], c_out[2], carry_out[20:14], c_out[1], carry_out[13:7], c_out[0], carry_out[6:0], cin};
endmodule
module SystemDemo (
	btn,
	led
);
	input wire [6:0] btn;
	output wire [7:0] led;
	wire [31:0] sum;
	cla cla_inst(
		.a(32'd26),
		.b({27'b000000000000000000000000000, btn[1], btn[2], btn[5], btn[4], btn[6]}),
		.cin(1'b0),
		.sum(sum)
	);
	assign led = sum[7:0];
endmodule