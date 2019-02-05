`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:44:00 12/12/2017 
// Design Name: 
// Module Name:    WB 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "head.v"
module WB(
	input [31:0] XAO_W,
	input cmp_w,
    input [31:0] IR_W,
    input [31:0] ALUout_W,
    input [31:0] DM_W,
    input [31:0] PC8_W,
    output [4:0] RegAddr,
    output [31:0] RegData,
	 output RegWrite,
	 output [31:0] PC8_W2D
    );
	 wire [1:0] RegDst, Mem2Reg;
	 assign PC8_W2D = PC8_W;
	 wire [2:0] ltype;
	 wire [31:0] Dout;
	Controller func_ctrl_B(
		.cmp_w(cmp_w),
		.IR(IR_W),
		.RegDst(RegDst),
		.Mem2Reg(Mem2Reg),
		.RegWrite(RegWrite),
		.ltype(ltype)
	);
	MUX4_5 MUX_RegAddr(	//���ƼĴ�����д���Ŀ���ַ
		RegDst, 
		IR_W[`rt], 			//2'b00:д$rt
		IR_W[`rd], 			//2'b01:д$rd
		5'b11111,	//2'b10:д$ra
		, 
		RegAddr
	);					//д����ƺ�λ����������
	
	loadext l_e(ALUout_W[1:0], DM_W, ltype, Dout);
	
	 MUX4_32 MUX_RegData(	//���ƼĴ�����Ҫд�������
		Mem2Reg, 
		ALUout_W, //2'b00:����ָ����
		Dout, 		//2'b01:loadָ����
		PC8_W, 	//2'b10:jal��PC+8����
		, 
		RegData
	);
endmodule
