`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DIGITAL ORGANIZATION DESIGN LIMITED (OWNED BY RAGHAVENDRA)
// Engineer: RAGHAVENDRA VAMSI TEJA
// 
// Create Date: 21.01.2025 17:42:43
// Design Name: 16 BIT MICROPROCESSOR TESTBENCH
// Module Name: Testbench
// Project Name: 16 BIT MICROPROCESSOR
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Testbench;

integer i =1;

top dut();

initial begin

for (i=0; i < 32; i= i+1) begin
    dut.GENERAL_PURPOSE_REGISTER[i]=2;
    end
    end 
    
initial begin
/////////immediate add op

$display("-------------------------------------------------------------------------");
dut.INSTRUCTION_REGISTER =0;
dut.`imm_mode = 1;
dut.`oper_type =2;
dut.`rsrc1 = 2;
dut.`rdst =0 ;
dut.`isrc =4;
#10
$display("OP:ADI RSRC1:%0d  RSrc2:%0d  Rdst:%0d", dut.GENERAL_PURPOSE_REGISTER[2], dut.`isrc, dut.GENERAL_PURPOSE_REGISTER[0]);
//////////////////////immediate mov op
dut.INSTRUCTION_REGISTER = 0;
dut.`imm_mode = 1;
dut.`oper_type = 1;
dut.`rdst = 4;///gpr[4]
dut.`isrc = 55;
#10;
$display("OP:MOVI Rdst:%0d  imm_data:%0d",dut.GENERAL_PURPOSE_REGISTER[4],dut.`isrc  );
$display("-----------------------------------------------------------------");

//////////////////register mov
dut.INSTRUCTION_REGISTER = 0;
dut.`imm_mode = 0;
dut.`oper_type = 1;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
#10;
$display("OP:MOV Rdst:%0d  RSRC1:%0d",dut.GENERAL_PURPOSE_REGISTER[4],dut.GENERAL_PURPOSE_REGISTER[7] );
$display("-----------------------------------------------------------------");


//////////////////////logical and imm
dut.INSTRUCTION_REGISTER = 0;
dut.`imm_mode = 1;
dut.`oper_type = 6;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
dut.`isrc = 56;
#10;
$display("OP:ANDI Rdst:%8b  Rsrc1:%8b imm_d :%8b",dut.GENERAL_PURPOSE_REGISTER[4],dut.GENERAL_PURPOSE_REGISTER[7],dut.`isrc );
$display("-----------------------------------------------------------------");

///////////////////logical or imm
dut.INSTRUCTION_REGISTER = 0;
dut.`imm_mode = 1;
dut.`oper_type = 7;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
dut.`isrc = 56;
#10;
$display("OP:XORI Rdst:%8b  Rsrc1:%8b imm_d :%8b",dut.GENERAL_PURPOSE_REGISTER[4],dut.GENERAL_PURPOSE_REGISTER[7],dut.`isrc );
$display("-----------------------------------------------------------------");

/////////////////////////// zero flag
dut.INSTRUCTION_REGISTER  = 0;
dut.GENERAL_PURPOSE_REGISTER[0] = 0;
dut.GENERAL_PURPOSE_REGISTER[1] = 0; 
dut.`imm_mode = 0;
dut.`rsrc1 = 0;//GENERAL_PURPOSE_REGISTER[0]
dut.`rsrc2 = 1;//GENERAL_PURPOSE_REGISTER[1]
dut.`oper_type = 2;
dut.`rdst = 2;
#10;
$display("OP:Zero Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GENERAL_PURPOSE_REGISTER[0], dut.GENERAL_PURPOSE_REGISTER[1], dut.GENERAL_PURPOSE_REGISTER[2] );
$display("-----------------------------------------------------------------");

//////////////////////////sign flag
dut.INSTRUCTION_REGISTER = 0;
dut.GENERAL_PURPOSE_REGISTER[0] = 16'h8000; /////1000_0000_0000_0000
dut.GENERAL_PURPOSE_REGISTER[1] = 0; 
dut.`imm_mode = 0;
dut.`rsrc1 = 0;//GENERAL_PURPOSE_REGISTER[0]
dut.`rsrc2 = 1;//GENERAL_PURPOSE_REGISTER[1]
dut.`oper_type = 2;
dut.`rdst = 2;
#10;
$display("OP:Sign Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GENERAL_PURPOSE_REGISTER[0], dut.GENERAL_PURPOSE_REGISTER[1], dut.GENERAL_PURPOSE_REGISTER[2] );
$display("-----------------------------------------------------------------");

////////////////////////carry flag
dut.INSTRUCTION_REGISTER = 0;
dut.GENERAL_PURPOSE_REGISTER[0] = 16'h8000; /////1000_0000_0000_0000   <0
dut.GENERAL_PURPOSE_REGISTER[1] = 16'h8002; /////1000_0000_0000_0010   <0
dut.`imm_mode = 0;
dut.`rsrc1 = 0;//GENERAL_PURPOSE_REGISTER[0]
dut.`rsrc2 = 1;//GENERAL_PURPOSE_REGISTER[1]
dut.`oper_type = 2;
dut.`rdst = 2;    //////// 0000_0000_0000_0010  >0
#10;

$display("OP:Carry & Overflow Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GENERAL_PURPOSE_REGISTER[0], dut.GENERAL_PURPOSE_REGISTER[1], dut.GENERAL_PURPOSE_REGISTER[2] );
$display("-----------------------------------------------------------------");

#20;
$finish;

end

endmodule

