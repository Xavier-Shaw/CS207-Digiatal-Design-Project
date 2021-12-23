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
input EN, ////���롢����ģʽ�л�����
output mode,  /////���롢����ģʽ��ʾ��

////////////����ģʽ
input backspace,  ////////�������˸�
input send,       ////////���뷢�ͼ� & ���������ż�
input rst,        ////////���������ü�
input [3:0] row,    /////�������
output [3:0] col,   //////�������

//////////������
input enMarry,      /////���Ÿ�������
input speedslow,    /////���������ٲ��ſ���
input speedquick,   /////���������ٲ��ſ���
output beep,       ////���������  

///////////  ����ģʽ
input clk,  //ʱ���ź�
input enable,  //����ģʽ�ͽ���ģʽת������
input reset,   //���ü�
input long_key,  //����
input short_key,  //����
input send_decoder,  //����
input back_space_decoder, //�˸�
output [14:0] Y_led, //������, LED��ʾ����������
output error_out_of_length, //���ȳ�����������������ı����
output error_character,  //�ѽ��������ȱ����������˵�ʱ���һֱ����
output error_decode,   //����ʧ�ܱ����  

/////// ��ʾģ��
output [7:0] seg_bit_selection, ////��һλ��ʾ
output [7:0] seg_selection  ///��ʾʲô
 );
 

 assign mode = EN; /////////    ģʽ��
 
 
 /////////  �������
 wire press;
 wire [7:0] seg_o;
 wire [7:0] se;
 key_top u(clk, rst, row, col, se, seg_o, press);
 
 ////////  ��������ʾ����
 wire [63:0] store;
 
 ////////  ��������������
 wire [135:0] message;
 
////////////  ����ģ��
encoder u_encoder(
EN,
backspace, 
send,
clk,
rst, 
row, 
press,
seg_o,
col, 
store,
message
);

/////////   ������ģ��
bp_remake u1(message,send,enMarry,speedslow,speedquick,clk,beep);


//  ��Ƶ
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


//////////  ������ģ��   
wire [3:0] cnt_character;        /////  �ѽ����ַ���
wire [39:0] characters_code;     /////  �洢�ѽ����ַ���ȫ�������빹��
wire [23:0] cnt_character_code;  /////  �洢ÿ���ַ������ĳ��������
            
decoder u_decoder(
    check,
    long_key,
    short_key,
    send_decoder,
    back_space_decoder,
    reset,
    Y_led,
    error_out_of_length,
    error_character,
    cnt_character,
    error_decode,
    characters_code,
    cnt_character_code
);



//////////  �������ʾģ��
seg_tube u_seg_tube(
    EN,
    enable,
    clk,
    seg_bit_selection,
    characters_code,
    cnt_character_code,
    cnt_character,
    store,
    seg_selection
);

                
endmodule
