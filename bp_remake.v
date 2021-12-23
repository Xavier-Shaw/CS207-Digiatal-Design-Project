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

  reg[1:0] mode=2'b11;//ȷ����������
  reg[1:0] last_mode = 0;//������modeʱ���������ã����ú����mode�����ٽ��в�������
  reg[7:0] melody_length = 136;//��ȡ�ĳ�����ĳ���
  parameter si_high = 25309;//���������������߶�
  parameter silence = 0;//��������Ϊ�գ�������������
  reg[40:0] beat=0;//���������ĳ���
  reg[40:0]gap=0;//ÿ������֮��ļ������
  reg[40:0] index_period=0;//���������Ӽ�����ܹ�����
  reg[40:0] freq=0;//Ҫ���ŵ�������Ƶ��
  reg[40:0] frequency_count = 0;//ʵʱ��¼Ƶ�ʴ�С
  reg[40:0] index_count = 0;//��¼��ǰ����ʱ�������ĸ��׶�
  reg[40:0] index =0;//��¼���ŵڼ�λ
  reg [0:0] isSilence = 0;//Ϊ1��ǰ����������
  reg [0:0] isEnd = 0;//Ϊ1�򲥷����
  reg [0:0] isPeriodic = 0;//Ϊ1���ڲ��ŵĽ׶�

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
    if(send)//���ͼ��򿪣�����������
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

        if(speedquick)//2����
        begin
          beat =  40 * 250000;
          gap=40 * 250000;
          index_period = beat + gap;
        end
        else
        begin
          if(speedslow)//0.5����
          begin
            beat =  40 * 1000000;
            gap=40 * 1000000;
            index_period = beat + gap;
          end
          else
          begin//��������
            beat = 40 * 500000;
            gap=40 * 500000;
            index_period = beat + gap;
          end
        end
      end
      if(mode != last_mode)//���ڲ�������
      begin
        last_mode = mode;
        isEnd = 0;
        index = 0;
        index_count = 0;

        if(mode >= 3)//�������ڣ����Բ�������
          isPeriodic = 1;
        else
        begin
          isPeriodic = 0;//����������
          melody_length = 1;
        end
      end
      if(frequency_count >= freq)//��������
      begin
        frequency_count = 0;
        music = ~music;
      end
      else
        frequency_count = frequency_count + 1;//δ��ָ��Ƶ��ʱ������һ
      if(index_count <= gap)//�����ڼ���׶Σ��򲻷���
      begin
        isSilence = 1;
      end
      if(gap < index_count && index_count <= index_period)//�������ڼ���׶Σ��Ҵ��������ڣ���������
      begin
        isSilence = 0;
      end
      if(index_count > index_period)//��ǰ���ڽ�������ȡ��һ������
      begin
        index_count = 0;
        index = index + 1;
        if(index > melody_length && isPeriodic)//�������꣬�����ڲ��Ž׶Σ�ѭ������
        begin
          isEnd = 0;
          index = 0;
        end
        if(index > melody_length && !isPeriodic)//�������꣬�����ڲ��Ž׶Σ��ݶ�����
        begin
          index = 0;
          isEnd = 1;
        end
      end

      index_count = index_count + 1;
    end
    if(send==1'b0)//���ͼ��رպ�last_mode����,�����ٴδ�ʱ��������
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
