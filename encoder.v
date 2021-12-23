`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/04 15:34:09
// Design Name: 
// Module Name: encoder
// Project Name: 
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


module encoder(enable, backspace, send, clk, rst, row,press, seg_o, col, store, message);//Լ���ļ��ǵø���
input enable;        ///////����ģʽʹ���ź�
input backspace;     //////�˸��
input send;          //////���ͼ� & ���������ż�
input clk;           ///// ʱ���ź�
input rst;           ////// ���ü�

//////�������
input [3:0] row;     
input press;         
input [7:0] seg_o;
output [3:0] col;

output reg [63:0] store  = 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;   ///////�߶��������ʾ����
output reg [135:0] message = 0;  ////////��������������


reg [3:0] counter;   //���㰴�˼��ΰ���
reg [24:0] cnt;      // ������
wire k_clk;
 
/////////// ��Ƶ
always @ (posedge clk or posedge rst)
  if (rst)
    cnt <= 0;
  else
    cnt <= cnt + 1'b1;
    
assign k_clk = cnt[24];      
     

always @ (posedge k_clk or posedge rst)
 if(rst)
     begin
        ///////���ü�����ʱ����� �߶��������ʾ���� �� ��������������
        if(enable)
        begin
            counter <= 0;
            store <= 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
            message <= 0;
        end
     end   
else
     begin
        if(enable)
        begin
            if(press) begin
             //////////���ݾ�����̵�����ı��߶��������ʾ����
                if(counter<=4'b1000)begin
                counter = counter + 1;
                store[8*counter-8] <= seg_o[0];
                store[8*counter-7] <= seg_o[1];
                store[8*counter-6] <= seg_o[2];
                store[8*counter-5] <= seg_o[3];
                store[8*counter-4] <= seg_o[4];
                store[8*counter-3] <= seg_o[5];
                store[8*counter-2] <= seg_o[6];
                store[8*counter-1] <= seg_o[7];
                
          //////////���ݾ�����̵�����ı��������������      
                case(seg_o)
                            8'b11000000:
                            begin //0
                              message[17*counter -17] <= 1'b1; 
                              message[17*counter -16] <= 1'b1; 
                              message[17*counter -15] <= 1'b0; 
                              message[17*counter -14] <= 1'b1; 
                              message[17*counter -13] <= 1'b1; 
                              message[17*counter -12] <= 1'b0; 
                              message[17*counter -11] <= 1'b1;  
                              message[17*counter -10] <= 1'b1;  
                              message[17*counter -9] <=  1'b0;  
                              message[17*counter -8] <=  1'b1;  
                              message[17*counter -7] <=  1'b1;  
                              message[17*counter -6] <=  1'b0;  
                              message[17*counter -5] <=  1'b1;  
                              message[17*counter -4] <=  1'b1;  
                              message[17*counter -3] <=  1'b0;  
                              message[17*counter -2] <=  1'b0;  
                              message[17*counter -1] <=  1'b0;  
                
                            end
                            8'b11111001:
                            begin //1
                               message[17*counter -17] <= 1'b1;
                               message[17*counter -16] <= 1'b0;
                               message[17*counter -15] <= 1'b1;
                               message[17*counter -14] <= 1'b1;
                               message[17*counter -13] <= 1'b0;
                               message[17*counter -12] <= 1'b1;
                               message[17*counter -11] <=1'b1;
                               message[17*counter -10] <=1'b0;
                               message[17*counter -9] <= 1'b1;
                               message[17*counter -8] <= 1'b1;
                               message[17*counter -7] <= 1'b0;
                               message[17*counter -6] <= 1'b1;
                               message[17*counter -5] <= 1'b1;
                               message[17*counter -4] <= 1'b0;
                               message[17*counter -3] <= 1'b0;
                               message[17*counter -2] <= 1'b0; 
                               message[17*counter -1] <= 1'b0; 
                              
                            end
                            8'b10100100:
                            begin //2
                              message[17*counter -17] <= 1'b1;
                              message[17*counter -16] <= 1'b0;
                              message[17*counter -15] <= 1'b1;
                              message[17*counter -14] <= 1'b0;
                              message[17*counter -13] <= 1'b1;
                              message[17*counter -12] <= 1'b1;
                              message[17*counter -11] <=1'b0;
                              message[17*counter -10] <=1'b1;
                              message[17*counter -9] <= 1'b1;
                              message[17*counter -8] <= 1'b0;
                              message[17*counter -7] <= 1'b1;
                              message[17*counter -6] <= 1'b1;
                              message[17*counter -5] <= 1'b0;
                              message[17*counter -4] <= 1'b0;
                              message[17*counter -3] <= 1'b0;
                              message[17*counter -2] <= 1'b0;
                              message[17*counter -1] <= 1'b0;
                              
                            end
                            8'b10110000:
                            begin //3
                              message[17*counter -17] <=1'b1;
                              message[17*counter -16] <=1'b0;
                              message[17*counter -15] <=1'b1;
                              message[17*counter -14] <=1'b0;
                              message[17*counter -13] <=1'b1;
                              message[17*counter -12] <=1'b0;
                              message[17*counter -11] <= 1'b1;
                              message[17*counter -10] <= 1'b1;
                              message[17*counter -9] <=  1'b0;
                              message[17*counter -8] <=  1'b1;
                              message[17*counter -7] <=  1'b1;
                              message[17*counter -6] <=  1'b0;
                              message[17*counter -5] <=  1'b0;
                              message[17*counter -4] <=  1'b0;
                              message[17*counter -3] <=  1'b0;
                              message[17*counter -2] <=  1'b0;
                              message[17*counter -1] <=  1'b0;
          
                            end
                            8'b10011001:
                            begin //4
                              message[17*counter -17] <= 1'b1;
                              message[17*counter -16] <= 1'b0;
                              message[17*counter -15] <= 1'b1;
                              message[17*counter -14] <= 1'b0;
                              message[17*counter -13] <= 1'b1;
                              message[17*counter -12] <= 1'b0;
                              message[17*counter -11] <= 1'b1;
                              message[17*counter -10] <= 1'b0;
                              message[17*counter -9] <=  1'b1;
                              message[17*counter -8] <=  1'b1;
                              message[17*counter -7] <=  1'b0;
                              message[17*counter -6] <=  1'b0;
                              message[17*counter -5] <=  1'b0;
                              message[17*counter -4] <=  1'b0;
                              message[17*counter -3] <=  1'b0;
                              message[17*counter -2] <=  1'b0;
                              message[17*counter -1] <=  1'b0;
                            
                            end
                            8'b10010010:
                            begin //5
                             message[17*counter -17] <= 1'b1;
                             message[17*counter -16] <= 1'b0;
                             message[17*counter -15] <= 1'b1;
                             message[17*counter -14] <= 1'b0;
                             message[17*counter -13] <= 1'b1;
                             message[17*counter -12] <= 1'b0;
                             message[17*counter -11] <=1'b1;
                             message[17*counter -10] <=1'b0;
                             message[17*counter -9] <= 1'b1;
                             message[17*counter -8] <= 1'b0;
                             message[17*counter -7] <= 1'b0;
                             message[17*counter -6] <= 1'b0;
                             message[17*counter -5] <= 1'b0;
                             message[17*counter -4] <= 1'b0;
                             message[17*counter -3] <= 1'b0;
                             message[17*counter -2] <= 1'b0;
                             message[17*counter -1] <= 1'b0;
                        
                            end
                            8'b10000010:
                            begin //6
                               message[17*counter -17] <= 1'b1;
                               message[17*counter -16] <= 1'b1;
                               message[17*counter -15] <= 1'b0;
                               message[17*counter -14] <= 1'b1;
                               message[17*counter -13] <= 1'b0;
                               message[17*counter -12] <= 1'b1;
                               message[17*counter -11] <=1'b0;
                               message[17*counter -10] <=1'b1;
                               message[17*counter -9] <= 1'b0;
                               message[17*counter -8] <= 1'b1;
                               message[17*counter -7] <= 1'b0;
                               message[17*counter -6] <= 1'b0;
                               message[17*counter -5] <= 1'b0;
                               message[17*counter -4] <= 1'b0;
                               message[17*counter -3] <= 1'b0;
                               message[17*counter -2] <= 1'b0;
                               message[17*counter -1] <= 1'b0;
                            
                            end
                            8'b11111000:
                            begin //7
                              message[17*counter -17] <= 1'b1;
                              message[17*counter -16] <= 1'b1;
                              message[17*counter -15] <= 1'b0;
                              message[17*counter -14] <= 1'b1;
                              message[17*counter -13] <= 1'b1;
                              message[17*counter -12] <= 1'b0;
                              message[17*counter -11] <=  1'b1;
                              message[17*counter -10] <=  1'b0;
                              message[17*counter -9] <=   1'b1;
                              message[17*counter -8] <=   1'b0;
                              message[17*counter -7] <=   1'b1;
                              message[17*counter -6] <=   1'b0;
                              message[17*counter -5] <=   1'b0;
                              message[17*counter -4] <=   1'b0;
                              message[17*counter -3] <=   1'b0;
                              message[17*counter -2] <= 1'b0;
                              message[17*counter -1] <= 1'b0;
                           
                            end
                            8'b10000000:
                            begin //8
                             message[17*counter -17] <= 1'b1;
                             message[17*counter -16] <= 1'b1;
                             message[17*counter -15] <= 1'b0;
                             message[17*counter -14] <= 1'b1;
                             message[17*counter -13] <= 1'b1;
                             message[17*counter -12] <= 1'b0;
                             message[17*counter -11] <=1'b1;
                             message[17*counter -10] <=1'b1;
                             message[17*counter -9] <= 1'b0;
                             message[17*counter -8] <= 1'b1;
                             message[17*counter -7] <= 1'b0;
                             message[17*counter -6] <= 1'b1;
                             message[17*counter -5] <= 1'b0;
                             message[17*counter -4] <= 1'b0;
                             message[17*counter -3] <= 1'b0;
                             message[17*counter -2] <=  1'b0;
                             message[17*counter -1] <=  1'b0;
                              
                            end
                            8'b10010000:
                            begin //9
                              message[17*counter -17] <= 1'b1;
                              message[17*counter -16] <= 1'b1;
                              message[17*counter -15] <= 1'b0;
                              message[17*counter -14] <= 1'b1;
                              message[17*counter -13] <= 1'b1;
                              message[17*counter -12] <= 1'b0;
                              message[17*counter -11] <=1'b1;
                              message[17*counter -10] <=1'b1;
                              message[17*counter -9] <= 1'b0;
                              message[17*counter -8] <= 1'b1;
                              message[17*counter -7] <= 1'b1;
                              message[17*counter -6] <= 1'b0;
                              message[17*counter -5] <= 1'b1;
                              message[17*counter -4] <= 1'b0;
                              message[17*counter -3] <= 1'b0;
                              message[17*counter -2] <= 1'b0;
                              message[17*counter -1] <= 1'b0;
                            
                            end
                            8'b10001000:
                            begin //A
                               message[17*counter -17] <= 1'b1;
                               message[17*counter -16] <= 1'b0;
                               message[17*counter -15] <= 1'b1;
                               message[17*counter -14] <= 1'b1;
                               message[17*counter -13] <= 1'b0;
                               message[17*counter -12] <= 1'b0;
                               message[17*counter -11] <=1'b0;
                               message[17*counter -10] <=1'b0;
                               message[17*counter -9] <= 1'b0;
                               message[17*counter -8] <= 1'b0;
                               message[17*counter -7] <= 1'b0;
                               message[17*counter -6] <= 1'b0;
                               message[17*counter -5] <= 1'b0;
                               message[17*counter -4] <= 1'b0;
                               message[17*counter -3] <= 1'b0;
                               message[17*counter -2] <= 1'b0;
                               message[17*counter -1] <= 1'b0;
                           
                            end
                            8'b10000011:
                            begin //b
                             message[17*counter -17] <= 1'b1;
                             message[17*counter -16] <= 1'b1;
                             message[17*counter -15] <= 1'b0;
                             message[17*counter -14] <= 1'b1;
                             message[17*counter -13] <= 1'b0;
                             message[17*counter -12] <= 1'b1;
                             message[17*counter -11] <=1'b0;
                             message[17*counter -10] <=1'b1;
                             message[17*counter -9] <= 1'b0;
                             message[17*counter -8] <= 1'b0;
                             message[17*counter -7] <= 1'b0;
                             message[17*counter -6] <= 1'b0;
                             message[17*counter -5] <= 1'b0;
                             message[17*counter -4] <= 1'b0;
                             message[17*counter -3] <= 1'b0;
                             message[17*counter -2] <=  1'b0; 
                             message[17*counter -1] <=   1'b0;
                              
                            end
                            8'b11000110:
                            begin //c
                              message[17*counter -17] <= 1'b1;
                              message[17*counter -16] <= 1'b1;
                              message[17*counter -15] <= 1'b0;
                              message[17*counter -14] <= 1'b1;
                              message[17*counter -13] <= 1'b0;
                              message[17*counter -12] <= 1'b1;
                              message[17*counter -11] <=1'b1;
                              message[17*counter -10] <=1'b0;
                              message[17*counter -9] <= 1'b1;
                              message[17*counter -8] <= 1'b0;
                              message[17*counter -7] <= 1'b0;
                              message[17*counter -6] <= 1'b0;
                              message[17*counter -5] <= 1'b0;
                              message[17*counter -4] <= 1'b0;
                              message[17*counter -3] <= 1'b0;
                              message[17*counter -2] <= 1'b0;
                              message[17*counter -1] <= 1'b0;
                            
                            end
                            8'b10100001:
                            begin //d
                               message[17*counter -17] <= 1'b1;
                               message[17*counter -16] <= 1'b1;
                               message[17*counter -15] <= 1'b0;
                               message[17*counter -14] <= 1'b1;
                               message[17*counter -13] <= 1'b0;
                               message[17*counter -12] <= 1'b1;
                               message[17*counter -11] <=1'b0;
                               message[17*counter -10] <=1'b0;
                               message[17*counter -9] <= 1'b0;
                               message[17*counter -8] <= 1'b0;
                               message[17*counter -7] <= 1'b0;
                               message[17*counter -6] <= 1'b0;
                               message[17*counter -5] <= 1'b0;
                               message[17*counter -4] <= 1'b0;
                               message[17*counter -3] <= 1'b0;
                               message[17*counter -2] <= 1'b0;
                               message[17*counter -1] <= 1'b0;
                            
                            
                            end
                            8'b10000110:
                            begin //e
                              message[17*counter -17] <= 1'b1;
                              message[17*counter -16] <= 1'b0;
                              message[17*counter -15] <= 1'b0;
                              message[17*counter -14] <= 1'b0;
                              message[17*counter -13] <= 1'b0;
                              message[17*counter -12] <= 1'b0;
                              message[17*counter -11] <=1'b0;
                              message[17*counter -10] <=1'b0;
                              message[17*counter -9] <= 1'b0;
                              message[17*counter -8] <= 1'b0;
                              message[17*counter -7] <= 1'b0;
                              message[17*counter -6] <= 1'b0;
                              message[17*counter -5] <= 1'b0;
                              message[17*counter -4] <= 1'b0;
                              message[17*counter -3] <= 1'b0;
                              message[17*counter -2] <= 1'b0;
                              message[17*counter -1] <= 1'b0;
    
                            end
                            8'b10001110:
                            begin //f
                               message[17*counter -17] <= 1'b1;
                               message[17*counter -16] <= 1'b0;
                               message[17*counter -15] <= 1'b1;
                               message[17*counter -14] <= 1'b0;
                               message[17*counter -13] <= 1'b1;
                               message[17*counter -12] <= 1'b1;
                               message[17*counter -11] <=1'b0;
                               message[17*counter -10] <=1'b1;
                               message[17*counter -9] <= 1'b0;
                               message[17*counter -8] <= 1'b0;
                               message[17*counter -7] <= 1'b0;
                               message[17*counter -6] <= 1'b0;
                               message[17*counter -5] <= 1'b0;
                               message[17*counter -4] <= 1'b0;
                               message[17*counter -3] <= 1'b0;
                               message[17*counter -2] <= 1'b0;
                               message[17*counter -1] <= 1'b0;
    
                            end
                          endcase
                end
            end
            else begin 
            ///////////////�����˸����ʹ�ã�ͬʱ�ı� �߶��������ʾ���� �� ��������������
                if (backspace) begin
                    if(counter>0)begin
                        store[8*counter-8] <= 1'b1;
                        store[8*counter-7] <= 1'b1;
                        store[8*counter-6] <= 1'b1;
                        store[8*counter-5] <= 1'b1;
                        store[8*counter-4] <= 1'b1;
                        store[8*counter-3] <= 1'b1;
                        store[8*counter-2] <= 1'b1;
                        store[8*counter-1] <= 1'b1;  
                        
                         message[17*counter -17] <= 1'b0;
                         message[17*counter -16] <= 1'b0;
                         message[17*counter -15] <= 1'b0;
                         message[17*counter -14] <= 1'b0;
                         message[17*counter -13] <= 1'b0;
                         message[17*counter -12] <= 1'b0;
                         message[17*counter -11] <=1'b0;
                         message[17*counter -10] <=1'b0;
                         message[17*counter -9] <= 1'b0;
                         message[17*counter -8] <= 1'b0;
                         message[17*counter -7] <= 1'b0;
                         message[17*counter -6] <= 1'b0;
                         message[17*counter -5] <= 1'b0;
                         message[17*counter -4] <= 1'b0;
                         message[17*counter -3] <= 1'b0;
                         message[17*counter -2] <= 1'b0;
                         message[17*counter -1] <= 1'b0;
                         
                         
                        counter = counter - 1'b1;
                    end
                end
             end
          end
        end



endmodule
