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
input clk,  //时钟信号
input enable,  //解码模式的状态转换开关
input reset,   //重置键
input long_key,  //长码
input short_key,  //短码
input send,  //发送
input back_space, //退格
output [14:0] Y_led, //缓冲区, LED显示缓冲区内容
output error_out_of_length, //长度超过缓冲区最大容量的报错灯
output error_character,  //已解码区长度报错，长度满了的时候就一直亮灯
output error_decode,   //解码失败报错灯  
output [7:0] seg_bit_selection,
output [7:0] seg_selection
 );

//分频
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


//////////解码器模块   
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


//////////数码管显示模块

seg_tube u_seg_tube(
    clk,
    seg_bit_selection,
    characters_code,
    cnt_character_code,
    cnt_character,
    seg_selection
);
                
endmodule
