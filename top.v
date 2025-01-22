`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DIGITAL ORGANIZATION DESIGN LIMITED (OWNED BY RAGHAVENDRA)
// Engineer: RAGHAVENDRA VAMSI TEJA
// 
// Create Date: 21.01.2025 17:42:43
// Design Name: 16 BIT MICROPROCESSOR TOP
// Module Name: TOP
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


// INSTRUCTION REGISTER FIELDS
`define oper_type INSTRUCTION_REGISTER[31:27]
`define rdst      INSTRUCTION_REGISTER[26:22]
`define rsrc1     INSTRUCTION_REGISTER[21:17]
`define imm_mode  INSTRUCTION_REGISTER[16]
`define rsrc2     INSTRUCTION_REGISTER[15:11]
`define isrc      INSTRUCTION_REGISTER[15:0]


///////// ARITHMETIC OPERATIONS
`define movsgpr  5'b00000
`define mov 5'b00001
`define add 5'b00010
`define sub 5'b00011
`define mul 5'b00100 

//////// LOGICAL OPERATIONS

`define ror  5'b00101
`define rand 5'b00110
`define rxor 5'b00111
`define rxnor 5'b01000
`define rnand 5'b01001
`define rnor  5'b01010
`define rnot  5'b01011

module top();

reg [31:0] INSTRUCTION_REGISTER;
reg [15:0] GENERAL_PURPOSE_REGISTER [31:0];

reg [15:0] SPECIAL_GENERAL_PURPOSE_REGISTER;
reg [31:0] MUL_RES;
reg sign =0, zero =0, overflow=0, carry =0;
reg [15:0] temp_sum=0;
always@(*)
    begin
        case(`oper_type)
        ////////////////////
            `movsgpr: begin
                GENERAL_PURPOSE_REGISTER[`rdst] =SPECIAL_GENERAL_PURPOSE_REGISTER;
                end
            
             `mov: begin
             if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = `isrc;
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1];
             
             end
        //////////////// START OF ARITHMETIC OPERATIONS 
            `add:begin
                if(`imm_mode) GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1]+`isrc;
                else GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1] + GENERAL_PURPOSE_REGISTER[`rsrc2];
            end
              
            `sub:begin
                if(`imm_mode) GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1]-`isrc;
                else GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1] - GENERAL_PURPOSE_REGISTER[`rsrc2];
            end
    
           `mul: begin
                if(`imm_mode) GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1]*`isrc;
                else GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1] * GENERAL_PURPOSE_REGISTER[`rsrc2];
                
                GENERAL_PURPOSE_REGISTER[`rdst] = MUL_RES[15:0];
                SPECIAL_GENERAL_PURPOSE_REGISTER       = MUL_RES[31:16];
                end
           //////////////// START OF LOGIC OPERATIONS 
           `ror: begin
            if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rdst] | `isrc;
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1] | GENERAL_PURPOSE_REGISTER[`rsrc2];
             
             end
             
             `rand: begin
            if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rdst] & `isrc;
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1] & GENERAL_PURPOSE_REGISTER[`rsrc2];
             
             end
             
                `rxor: begin
            if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rdst] ^ `isrc;
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1] ^ GENERAL_PURPOSE_REGISTER[`rsrc2];
             
             end
             
              `rnor: begin
            if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rdst] ~^ `isrc;
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = GENERAL_PURPOSE_REGISTER[`rsrc1] ~^ GENERAL_PURPOSE_REGISTER[`rsrc2];
             
             end
             
              `rnand: begin
            if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = ~(GENERAL_PURPOSE_REGISTER[`rdst] & `isrc);
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = ~(GENERAL_PURPOSE_REGISTER[`rsrc1] & GENERAL_PURPOSE_REGISTER[`rsrc2]);
             
             end
             
             `rnor: begin
            if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = ~(GENERAL_PURPOSE_REGISTER[`rdst] | `isrc);
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = ~(GENERAL_PURPOSE_REGISTER[`rsrc1] | GENERAL_PURPOSE_REGISTER[`rsrc2]);
             
             end
             
              `rnot: begin
            if(`imm_mode) 
                    GENERAL_PURPOSE_REGISTER[`rdst] = ~ `isrc;
                    
             else 
                GENERAL_PURPOSE_REGISTER[`rdst] = ~GENERAL_PURPOSE_REGISTER[`rsrc1];
             
             end
           
    endcase
    end
    
    
    always@(*)
    begin
    
    //////Flags setting
    
        if (`oper_type ==`mul)begin 
        sign = SPECIAL_GENERAL_PURPOSE_REGISTER[15]; 
        zero = ~ ((SPECIAL_GENERAL_PURPOSE_REGISTER[15])| (GENERAL_PURPOSE_REGISTER[`rdst]));
        end
        else begin
        sign = GENERAL_PURPOSE_REGISTER[`rdst][15];
        zero = ~(GENERAL_PURPOSE_REGISTER[`rdst]);
        end
        
    
        if(`oper_type == `add)
        begin 
        if(`imm_mode)
            begin
                temp_sum = GENERAL_PURPOSE_REGISTER[`rsrc1] + `isrc;
                carry = temp_sum[16];
                overflow = ( (~GENERAL_PURPOSE_REGISTER[`rsrc1][15] & ~INSTRUCTION_REGISTER[15] & GENERAL_PURPOSE_REGISTER[`rdst][15] ) | (GENERAL_PURPOSE_REGISTER[`rsrc1][15] & INSTRUCTION_REGISTER[15] & ~GENERAL_PURPOSE_REGISTER[`rdst][15]) );
                end
         else
            begin
            temp_sum = GENERAL_PURPOSE_REGISTER[`rsrc1] + GENERAL_PURPOSE_REGISTER[`rsrc2];
            carry = temp_sum[16];
            overflow = ((~GENERAL_PURPOSE_REGISTER[`rsrc1][15] & ~GENERAL_PURPOSE_REGISTER[`rsrc2][15] & GENERAL_PURPOSE_REGISTER[`rdst][15]) | (GENERAL_PURPOSE_REGISTER[`rsrc1][15] & GENERAL_PURPOSE_REGISTER[`rsrc2][15] & ~GENERAL_PURPOSE_REGISTER[`rdst][15]));
            end
            end
            
     else carry =1'b0;
     
       if(`oper_type == `sub)
       begin
       if(`imm_mode) overflow = ( (~GENERAL_PURPOSE_REGISTER[`rsrc1][15] & INSTRUCTION_REGISTER[15] & GENERAL_PURPOSE_REGISTER[`rdst][15] ) | (GENERAL_PURPOSE_REGISTER[`rsrc1][15] & ~INSTRUCTION_REGISTER[15] & ~GENERAL_PURPOSE_REGISTER[`rdst][15]) );       
       else  overflow = ( (~GENERAL_PURPOSE_REGISTER[`rsrc1][15] & GENERAL_PURPOSE_REGISTER[`rsrc2][15] & GENERAL_PURPOSE_REGISTER[`rdst][15]) | (GENERAL_PURPOSE_REGISTER[`rsrc1][15] & ~GENERAL_PURPOSE_REGISTER[`rsrc2][15] & ~GENERAL_PURPOSE_REGISTER[`rdst][15]));
    
    end
    end
    
endmodule