`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/11/23 22:43:45
// Design Name:
// Module Name: Music
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


module bp_remake(
input[135:0]message,
input send,
input enMarry,
input speedslow,
input speedquick,
input clk,
output reg[0:0] music = 0);

  reg[1:0] mode=2'b11;//确定参数重置
  reg[1:0] last_mode = 0;//不等于mode时，参数重置，重置后等于mode，不再进行参数重置
  reg[7:0] melody_length = 136;//读取的长短码的长度
  parameter si_high = 25309;//发出的声音音调高度
  parameter silence = 0;//发出声音为空，即不发出声音
  reg[40:0] beat=0;//单个声音的长度
  reg[40:0]gap=0;//每个声音之间的间隔长度
  reg[40:0] index_period=0;//单个声音加间隔的总共长度
  reg[40:0] freq=0;//要播放的声音的频率
  reg[40:0] frequency_count = 0;//实时记录频率大小
  reg[40:0] index_count = 0;//记录当前处于时间周期哪个阶段
  reg[40:0] index =0;//记录播放第几位
  reg [0:0] isSilence = 0;//为1则当前不发出声音
  reg [0:0] isEnd = 0;//为1则播放完毕
  reg [0:0] isPeriodic = 0;//为1则还在播放的阶段

  parameter do_low = 191110;
  parameter re_low = 170259;
  parameter me_low = 151685;
  parameter fa_low = 143172;
  parameter so_low = 127554;
  parameter la_low = 113636;
  parameter si_low = 101239;

  parameter do = 93941;
  parameter re = 85136;
  parameter me = 75838;
  parameter fa = 71582;
  parameter so = 63776;
  parameter la = 56818;
  parameter si = 50618;

  parameter do_high = 47778;
  parameter re_high = 42567;
  parameter me_high = 37921;
  parameter fa_high = 36498;
  parameter so_high = 31888;
  parameter la_high = 28409;
  reg[335:0] MerryChristmas = 335'b01111011110111101110100000110101100011001001101111100001000110000000000110001100011010111001111011100000001110011110111101111011000000001111011110111010000011010110001100000000110101111100001000110010100011000100000011000110000000011000111001111100001000110000100000000001101000000000001101011010111001111100000111101111000000110001100;



  always @(posedge clk )
  begin
    if(send)//发送键打开，蜂鸣器播放
    begin
      if(enMarry)
      begin
        melody_length = 67;
        beat = 40 * 500000;
        gap =  10 * 500000;
      end
      else
      begin
        melody_length = 136;

        if(speedquick)//2倍速
        begin
          beat =  40 * 250000;
          gap=40 * 250000;
          index_period = beat + gap;
        end
        else
        begin
          if(speedslow)//0.5倍速
          begin
            beat =  40 * 1000000;
            gap=40 * 1000000;
            index_period = beat + gap;
          end
          else
          begin//正常倍速
            beat = 40 * 500000;
            gap=40 * 500000;
            index_period = beat + gap;
          end
        end
      end
      if(mode != last_mode)//用于参数重置
      begin
        last_mode = mode;
        isEnd = 0;
        index = 0;
        index_count = 0;

        if(mode >= 3)//处于周期，可以播放音乐
          isPeriodic = 1;
        else
        begin
          isPeriodic = 0;//不播放音乐
          melody_length = 1;
        end
      end
      if(frequency_count >= freq)//声音播放
      begin
        frequency_count = 0;
        music = ~music;
      end
      else
        frequency_count = frequency_count + 1;//未到指定频率时持续加一
      if(index_count <= gap)//若处于间隔阶段，则不发声
      begin
        isSilence = 1;
      end
      if(gap < index_count && index_count <= index_period)//若不处于间隔阶段，且处于周期内，则有声音
      begin
        isSilence = 0;
      end
      if(index_count > index_period)//当前周期结束，读取下一个数字
      begin
        index_count = 0;
        index = index + 1;
        if(index > melody_length && isPeriodic)//整串读完，还处于播放阶段，循环播放
        begin
          isEnd = 0;
          index = 0;
        end
        if(index > melody_length && !isPeriodic)//整串读完，不处于播放阶段，暂定播放
        begin
          index = 0;
          isEnd = 1;
        end
      end

      index_count = index_count + 1;
    end
    if(send==1'b0)//发送键关闭后，last_mode归零,用于再次打开时可以重置
    begin
      last_mode = 0;
    end
  end
  always @ *
  begin
    if(isSilence || isEnd)
      freq = silence;
    else if(enMarry)
    begin
      case(MerryChristmas[index * 5 +4 -:5])
        5'd0 :
          freq = silence;
        5'd1 :
          freq = do_low;
        5'd2 :
          freq = re_low;
        5'd3 :
          freq = me_low;
        5'd4 :
          freq = fa_low;
        5'd5 :
          freq = so_low;
        5'd6 :
          freq = la_low;
        5'd7 :
          freq = si_low;
        5'd8 :
          freq = do;
        5'd9 :
          freq = re;
        5'd10 :
          freq = me;
        5'd11:
          freq = fa;
        5'd12 :
          freq = so;
        5'd13 :
          freq = la;
        5'd14 :
          freq = si;
        5'd15 :
          freq = do_high;
        5'd16 :
          freq = re_high;
        5'd17 :
          freq = me_high;
        5'd18 :
          freq = fa_high;
        5'd19 :
          freq = so_high;
        5'd20 :
          freq = la_high;
        5'd21 :
          freq = si_high;
        default :
          freq = silence;
      endcase


    end




    else
    case(message[index   +:1])
      0'd0 :
        freq = silence;
      1'd1 :
        freq = si_high;
      default :
        freq = silence;
    endcase
  end
endmodule
