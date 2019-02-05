`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:03 11/27/2017 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	wire disable_PC, stall_IF_ID, reset_ID_EX;
	wire [1:0] FRSD, FRTD, FRSE, FRTE, FRTM;
	wire [31:0] IR_D;
	wire cmp_d, busy_real;

	datapath dp(clk, reset, disable_PC, stall_IF_ID, reset_ID_EX, FRSD, FRTD, FRSE, FRTE, FRTM, IR_D, cmp_d, busy_real);

	FourController fourcontroller(busy_real, cmp_d, IR_D, clk, reset, disable_PC, stall_IF_ID, reset_ID_EX, FRSD, FRTD, FRSE, FRTE, FRTM);
endmodule

/*
	b����ָ���ALU����ж��źţ���������IFU���������ź�Ϊ��ָ�����ж��ź�Ϊ��ʱִ��ͬbeq����ת
	sllv,srav,srlv�ȿɱ������ƣ�����>>/>>>����ALU
			`srav: begin
					C <= $signed(B) >>> A[4:0];
				end
	sll, sra, srl����λ����MUX_RegData���һ·����ֵΪGPR_rt << im26[10:6](��MUX֮ǰ�Ӹ�wire)
			wire [31:0] srl_result = GPR_rt >> im26[10:6];
			 MUX4_32 MUX_RegData(	//���ƼĴ�����Ҫд�������
				Mem2Reg, 
				ALU_result, //2'b00:����ָ����
				DM_out, 		//2'b01:loadָ����
				PC_add_4, 	//2'b10:jal��PC+4����
				srl_result, 
				RegData
			);
	slt,slti,sltiu,sltu����ALU��ӱȽ��ж��źţ���slt_judge?32'h0000_0001:0,��ALU_result��RegData���з��űȽ�$signed($signed(A)<$signed(B))
	sb,sh����Ҫ�ӿ����ź�sb/sh������DM��������ź�Ϊ��ʱ��case(addr[1:0])mem[addr[11:2]] <= {mem[11:2][31:8],MemData[7:0]}��ע���display��
			DM��if(sb) begin
				$display("@%h: *%h <= %h",PC_add_4-4, addr,MemData[7:0]);
				case(addr[1:0]) 
					2'b00:mem[addr[11:2]] <= {mem[addr[11:2]][31:8],MemData[7:0]};
					2'b01:mem[addr[11:2]] <= {mem[addr[11:2]][31:16],MemData[7:0],mem[addr[11:2]][7:0]};
					2'b10:mem[addr[11:2]] <= {mem[addr[11:2]][31:24],MemData[7:0],mem[addr[11:2]][15:0]};
					2'b11:mem[addr[11:2]] <= {MemData[7:0],mem[addr[11:2]][23:0]};
				endcase
			end
	lb, lh��������ͨ·��wire [31:0] DM_out2 = ALU_result[1] ? {{16{1'b0}},DM_out[31:16]} : {{16{1'b0}},DM_out[15:0]};
				MUX4_32 MUX_RegData(	//���ƼĴ�����Ҫд�������
					Mem2Reg, 
					ALU_result, //2'b00:����ָ����
					DM_out2, 		//2'b01:loadָ����
					PC_add_4, 	//2'b10:jal��PC+4����
					, 
					RegData
				);
	jalr: PCͬjr��PC+4����rd
	j:��jal������PC��$31
	
	tips:
	1.д���ֱ���дλ����������
	2.A?B:C A=1ʱ��B��дMUXʱ������Ҫע�⣡
	3.�˿�������Сдͳһ����
	4.�����߼ǵ���������������������������������������������
*/