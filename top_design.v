`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/04 22:11:57
// Design Name: 
// Module Name: top_design
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



module top_design(
input clk,  //ʱ���ź�
input enable,  //����ģʽ��״̬ת������
input reset,   //���ü�
input long_key,  //����
input short_key,  //����
input send,  //����
input back_space, //�˸�
output [14:0] Y_led, //������, LED��ʾ����������
output error_out_of_length, //���ȳ�����������������ı����
output error_character,  //�ѽ��������ȱ����������˵�ʱ���һֱ����
output error_decode,   //����ʧ�ܱ����  
output [7:0] seg_bit_selection,
output [7:0] seg_selection
 );

//��Ƶ
reg [19:0] cnt; 
reg check;
always @ (posedge clk or negedge enable)
  if (!enable)
  begin
    cnt = 0;
    check = 0;
  end
  else
  begin
    if(cnt[19] == 0)  
    cnt = cnt + 1;
    else
    begin
    check = ~check;
    cnt = 0;
    end
  end


//////////������ģ��   
wire [3:0] cnt_character;   
wire [39:0] characters_code;
wire [23:0] cnt_character_code;
      
decoder u_decoder(
    check,
    long_key,
    short_key,
    send,
    back_space,
    reset,
    Y_led,
    error_out_of_length,
    error_character,
    cnt_character,
    error_decode,
    characters_code,
    cnt_character_code
);


//////////�������ʾģ��

seg_tube u_seg_tube(
    clk,
    seg_bit_selection,
    characters_code,
    cnt_character_code,
    cnt_character,
    seg_selection
);
                
endmodule
