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
input EN, ////解码、编码模式切换开关
output mode,  /////解码、编码模式提示灯

////////////编码模式
input backspace,  ////////编码区退格
input send,       ////////编码发送键 & 蜂鸣器播放键
input rst,        ////////编码区重置键
input [3:0] row,    /////矩阵键盘
output [3:0] col,   //////矩阵键盘

//////////蜂鸣器
input enMarry,      /////播放歌曲开关
input speedslow,    /////蜂鸣器慢速播放开关
input speedquick,   /////蜂鸣器倍速播放开关
output beep,       ////蜂鸣器输出  

///////////  解码模式
input clk,  //时钟信号
input enable,  //无聊模式和解码模式转换开关
input reset,   //重置键
input long_key,  //长码
input short_key,  //短码
input send_decoder,  //发送
input back_space_decoder, //退格
output [14:0] Y_led, //缓冲区, LED显示缓冲区内容
output error_out_of_length, //长度超过缓冲区最大容量的报错灯
output error_character,  //已解码区长度报错，长度满了的时候就一直亮灯
output error_decode,   //解码失败报错灯  

/////// 显示模块
output [7:0] seg_bit_selection, ////哪一位显示
output [7:0] seg_selection  ///显示什么
 );
 

 assign mode = EN; /////////    模式灯
 
 
 /////////  矩阵键盘
 wire press;
 wire [7:0] seg_o;
 wire [7:0] se;
 key_top u(clk, rst, row, col, se, seg_o, press);
 
 ////////  编码器显示内容
 wire [63:0] store;
 
 ////////  蜂鸣器播放内容
 wire [135:0] message;
 
////////////  编码模块
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

/////////   蜂鸣器模块
bp_remake u1(message,send,enMarry,speedslow,speedquick,clk,beep);


//  分频
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


//////////  解码器模块   
wire [3:0] cnt_character;        /////  已解码字符数
wire [39:0] characters_code;     /////  存储已解码字符的全部长短码构成
wire [23:0] cnt_character_code;  /////  存储每个字符所含的长短码个数
            
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



//////////  数码管显示模块
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
