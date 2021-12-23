`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/11 23:31:08
// Design Name: 
// Module Name: seg_tube
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


module seg_tube(
    input switch,  /////解码或者编码
    input mode_selection,   ///mode selection 无聊或者解码
    input clk, //system clock 100MHz
    output [7:0] DIG, //bit selection
    input [39:0] characters_code,
    input [23:0] cnt_character_code,
    input [3:0] cnt_characters,
    input [63:0] store,
    output [7:0] Y  //seg selection
  );  
    
    wire [4:0] character_1;   wire [2:0] length_1;
    wire [4:0] character_2;   wire [2:0] length_2;
    wire [4:0] character_3;   wire [2:0] length_3;
    wire [4:0] character_4;   wire [2:0] length_4;
    wire [4:0] character_5;   wire [2:0] length_5;
    wire [4:0] character_6;   wire [2:0] length_6;
    wire [4:0] character_7;   wire [2:0] length_7;
    wire [4:0] character_8;   wire [2:0] length_8;
    
    
    assign character_1 = {characters_code[4],characters_code[3],characters_code[2],characters_code[1],characters_code[0]};
    assign character_2 = {characters_code[9],characters_code[8],characters_code[7],characters_code[6],characters_code[5]};
    assign character_3 = {characters_code[14],characters_code[13],characters_code[12],characters_code[11],characters_code[10]};
    assign character_4 = {characters_code[19],characters_code[18],characters_code[17],characters_code[16],characters_code[15]};
    assign character_5 = {characters_code[24],characters_code[23],characters_code[22],characters_code[21],characters_code[20]};
    assign character_6 = {characters_code[29],characters_code[28],characters_code[27],characters_code[26],characters_code[25]};
    assign character_7 = {characters_code[34],characters_code[33],characters_code[32],characters_code[31],characters_code[30]};
    assign character_8 = {characters_code[39],characters_code[38],characters_code[37],characters_code[36],characters_code[35]};
    
    assign length_1 = {cnt_character_code[0],cnt_character_code[1],cnt_character_code[2]};
    assign length_2 = {cnt_character_code[3],cnt_character_code[4],cnt_character_code[5]};
    assign length_3 = {cnt_character_code[6],cnt_character_code[7],cnt_character_code[8]};
    assign length_4 = {cnt_character_code[9],cnt_character_code[10],cnt_character_code[11]};
    assign length_5 = {cnt_character_code[12],cnt_character_code[13],cnt_character_code[14]};
    assign length_6 = {cnt_character_code[15],cnt_character_code[16],cnt_character_code[17]};
    assign length_7 = {cnt_character_code[18],cnt_character_code[19],cnt_character_code[20]};
    assign length_8 = {cnt_character_code[21],cnt_character_code[22],cnt_character_code[23]};
    
    reg clkout = 0;
    reg [31:0] cnt = 0;
    reg [31:0] mode_cnt = 0;
    reg [2:0] scan_cnt = 0;
    
    parameter period = 200000; //500HZ stable
    //parameter period = 250000; //400HZ stable 
    //parameter period = 5000000; //20HZ loop one by one
    //parameter period = 2500000; //40HZ twenkle
    //parameter period = 1000000; //100HZ twenkle
    
   
    reg [6:0] Y_r;
    reg [7:0] DIG_r;
    reg [4:0] mode = 0;
    
    assign Y = {1'b1,(~Y_r[6:0])}; //dont light
    assign DIG = ~DIG_r;
    
     
    always@( posedge clk)  //frequency division : clk -> clkout
    begin
        if(cnt == (period >> 1) - 1)   //偶数分频
            begin
            clkout <= ~clkout;
            cnt <= 0;
            end
        else
            cnt <= cnt + 1;   
    end
   
   
    always@(posedge clkout) //change scan_cnt based on clkout
    begin
            scan_cnt <= scan_cnt + 1;
            if(scan_cnt == 7) scan_cnt <= 0;
            
            if(!mode_selection)
            begin
                if(mode_cnt == (1200 >> 1) - 1)   //分频
                begin
                    if(mode == 23)
                    begin
                        mode <= 0;
                    end
                    else
                    mode <= mode + 1;
               
                    mode_cnt <= 0;
                end
                else
                mode_cnt <= mode_cnt + 1;
          end
            else
            begin
                mode_cnt <= 0;
                mode <= 0;
            end
    end 


    always@(scan_cnt)  //select tube
    begin
    case(switch)
    0:
    begin
    /////解码模式
        case (scan_cnt)
            0: DIG_r = 8'b1000_0000;
            1: DIG_r = 8'b0100_0000;
            2: DIG_r = 8'b0010_0000;
            3: DIG_r = 8'b0001_0000;
            4: DIG_r = 8'b0000_1000;
            5: DIG_r = 8'b0000_0100; 
            6: DIG_r = 8'b0000_0010;
            7: DIG_r = 8'b0000_0001;
            default:DIG_r = 8'b0000_0000;
        endcase
    end
    
    ///////编码模式
    1:
    begin
       case(scan_cnt) 
            0: DIG_r = 8'b0000_0001;
            1: DIG_r = 8'b0000_0010;
            2: DIG_r = 8'b0000_0100;
            3: DIG_r = 8'b0000_1000;
            4: DIG_r = 8'b0001_0000;
            5: DIG_r = 8'b0010_0000;
            6: DIG_r = 8'b0100_0000;
            7: DIG_r = 8'b1000_0000;
            default:DIG_r = 8'b0000_0000;
        endcase   
    end
    
    endcase
    end
    
    
    always@(scan_cnt)  //decoder to display on 7-seg tube
    begin
        case(switch)
        0:  ///////////////解码状态
        begin
          case(mode_selection)
            0:  //////无聊模式
            begin
                case(mode)
                        0:   ///sustech
                        begin
                            case(scan_cnt)
                                0: Y_r = 7'b1101_101; //S
                                1: Y_r = 7'b0111_110; //U
                                2: Y_r = 7'b1101_101; //S
                                3: Y_r = 7'b0000_111; //T
                                4: Y_r = 7'b1111_001; //E
                                5: Y_r = 7'b0111_001; //C
                                6: Y_r = 7'b1110_110; //H
                                7: Y_r = 7'b0000_000;
                            endcase
                        end
                        1:   ///sustech
                        begin
                            case(scan_cnt)
                                0: Y_r = 7'b1101_101; //S
                                1: Y_r = 7'b0111_110; //U
                                2: Y_r = 7'b1101_101; //S
                                3: Y_r = 7'b0000_111; //T
                                4: Y_r = 7'b1111_001; //E
                                5: Y_r = 7'b0111_001; //C
                                6: Y_r = 7'b1110_110; //H
                                7: Y_r = 7'b0000_000;
                            endcase
                        end            
                        2:   ////cs207
                        begin
                            case(scan_cnt)
                                0: Y_r = 7'b0111_001; //C
                                1: Y_r = 7'b1101_101; //S
                                2: Y_r = 7'b1011_011; //2
                                3: Y_r = 7'b0111_111; //0
                                4: Y_r = 7'b0100_111; //7
                                5: Y_r = 7'b0000_000;
                                6: Y_r = 7'b0000_000;
                                7: Y_r = 7'b0000_000;
                            endcase
                        end 
                        3:   ////cs207
                        begin
                            case(scan_cnt)
                                0: Y_r = 7'b0111_001; //C
                                1: Y_r = 7'b1101_101; //S
                                2: Y_r = 7'b1011_011; //2
                                3: Y_r = 7'b0111_111; //0
                                4: Y_r = 7'b0100_111; //7
                                5: Y_r = 7'b0000_000;
                                6: Y_r = 7'b0000_000;
                                7: Y_r = 7'b0000_000;
                            endcase
                        end           
                        4:  ///// 12012902
                        begin
                            case(scan_cnt)
                            0: Y_r = 7'b0000_110; //1
                            1: Y_r = 7'b1011_011; //2
                            2: Y_r = 7'b0111_111; //0
                            3: Y_r = 7'b0000_110; //1
                            4: Y_r = 7'b1011_011; //2
                            5: Y_r = 7'b1101_111; //9
                            6: Y_r = 7'b0111_111; //0
                            7: Y_r = 7'b1011_011; //2
                        endcase            
                        end
                        5:  ///// 12012902
                        begin
                            case(scan_cnt)
                            0: Y_r = 7'b0000_110; //1
                            1: Y_r = 7'b1011_011; //2
                            2: Y_r = 7'b0111_111; //0
                            3: Y_r = 7'b0000_110; //1
                            4: Y_r = 7'b1011_011; //2
                            5: Y_r = 7'b1101_111; //9
                            6: Y_r = 7'b0111_111; //0
                            7: Y_r = 7'b1011_011; //2
                        endcase            
                        end            
                        6:  ///// 12012719
                        begin
                            case(scan_cnt)
                            0: Y_r = 7'b0000_110; //1
                            1: Y_r = 7'b1011_011; //2
                            2: Y_r = 7'b0111_111; //0 
                            3: Y_r = 7'b0000_110; //1
                            4: Y_r = 7'b1011_011; //2
                            5: Y_r = 7'b0100_111; //7
                            6: Y_r = 7'b0000_110; //1
                            7: Y_r = 7'b1101_111; //9
                        endcase            
                        end
                        7:  ///// 12012719
                        begin
                            case(scan_cnt)
                            0: Y_r = 7'b0000_110; //1
                            1: Y_r = 7'b1011_011; //2
                            2: Y_r = 7'b0111_111; //0 
                            3: Y_r = 7'b0000_110; //1
                            4: Y_r = 7'b1011_011; //2
                            5: Y_r = 7'b0100_111; //7
                            6: Y_r = 7'b0000_110; //1
                            7: Y_r = 7'b1101_111; //9
                        endcase            
                        end            
                        8:  /////  12010336
                        begin
                           case(scan_cnt)
                           0: Y_r = 7'b0000_110; //1
                           1: Y_r = 7'b1011_011; //2
                           2: Y_r = 7'b0111_111; //0
                           3: Y_r = 7'b0000_110; //1
                           4: Y_r = 7'b0111_111; //0
                           5: Y_r = 7'b1001_111; //3
                           6: Y_r = 7'b1001_111; //3
                           7: Y_r = 7'b1111_101; //6
                        endcase  
                        end
                        9:  /////  12010336
                        begin
                           case(scan_cnt)
                           0: Y_r = 7'b0000_110; //1
                           1: Y_r = 7'b1011_011; //2
                           2: Y_r = 7'b0111_111; //0
                           3: Y_r = 7'b0000_110; //1
                           4: Y_r = 7'b0111_111; //0
                           5: Y_r = 7'b1001_111; //3
                           6: Y_r = 7'b1001_111; //3
                           7: Y_r = 7'b1111_101; //6
                        endcase  
                        end            
                        10:
                        begin
                            case(scan_cnt)
                                7: Y_r = 7'b1110_110; //H
                                default: Y_r = 7'b0000_000;
                            endcase
                        end
                        11:
                        begin
                            case(scan_cnt)
                                6: Y_r = 7'b1110_110; //H
                                7: Y_r = 7'b1111_001; //E
                                default: Y_r = 7'b0000_000;
                            endcase
                        end
                        12:
                        begin
                            case(scan_cnt)
                                5: Y_r = 7'b1110_110; //H
                                6: Y_r = 7'b1111_001; //E
                                7: Y_r = 7'b0111_000; //L
                                default: Y_r = 7'b0000_000;
                            endcase
                        end
                        13:
                        begin
                            case(scan_cnt)
                                4: Y_r = 7'b1110_110; //H
                                5: Y_r = 7'b1111_001; //E
                                6: Y_r = 7'b0111_000; //L
                                7: Y_r = 7'b0111_000; //L 
                                default: Y_r = 7'b0000_000;
                            endcase
                        end        
                        14:
                        begin
                            case(scan_cnt)
                                3: Y_r = 7'b1110_110; //H
                                4: Y_r = 7'b1111_001; //E
                                5: Y_r = 7'b0111_000; //L
                                6: Y_r = 7'b0111_000; //L 
                                7: Y_r = 7'b0111_111; //0
                                default: Y_r = 7'b0000_000;
                            endcase
                        end  
                        15:
                        begin
                           case(scan_cnt) 
                            2: Y_r = 7'b1110_110; //H
                            3: Y_r = 7'b1111_001; //E
                            4: Y_r = 7'b0111_000; //L
                            5: Y_r = 7'b0111_000; //L
                            6: Y_r = 7'b0111_111; //0
                            default: Y_r = 7'b0000_000;
                        endcase                
                        end
                        16:
                        begin
                           case(scan_cnt) 
                            1: Y_r = 7'b1110_110; //H
                            2: Y_r = 7'b1111_001; //E
                            3: Y_r = 7'b0111_000; //L
                            4: Y_r = 7'b0111_000; //L
                            5: Y_r = 7'b0111_111; //0
                            default: Y_r = 7'b0000_000;
                        endcase
                        end                                                         
                        17:  /////// HELLO
                        begin
                           case(scan_cnt)
                           0: Y_r = 7'b1110_110; //H
                           1: Y_r = 7'b1111_001; //E
                           2: Y_r = 7'b0111_000; //L
                           3: Y_r = 7'b0111_000; //L
                           4: Y_r = 7'b0111_111; //0
                           default: Y_r = 7'b0000_000;
                        endcase  
                        end
                        18:  
                        begin
                           case(scan_cnt)
                           0: Y_r = 7'b1111_001; //E
                           1: Y_r = 7'b0111_000; //L
                           2: Y_r = 7'b0111_000; //L
                           3: Y_r = 7'b0111_111; //0
                           default: Y_r = 7'b0000_000;
                        endcase  
                        end 
                        19:
                        begin
                            case(scan_cnt)
                            0: Y_r = 7'b0111_000; //L
                            1: Y_r = 7'b0111_000; //L
                            2: Y_r = 7'b0111_111; //0
                            default: Y_r = 7'b0000_000;
                        endcase
                        end
                        20:
                         begin
                            case(scan_cnt)
                            0: Y_r = 7'b0111_000; //L
                            1: Y_r = 7'b0111_111; //0
                            default: Y_r = 7'b0000_000;
                        endcase   
                        end
                        21:
                         begin
                            case(scan_cnt)
                            0: Y_r = 7'b0111_111; //0
                            default: Y_r = 7'b0000_000;
                        endcase   
                        end
                        default: Y_r = 7'b0000_000;                             
                  endcase
            end
            
            1:  /////解码模式
            begin
                if(scan_cnt + 1 > cnt_characters)
                begin
                    Y_r = 7'b0000_000;  //当超过了已解码字符数时，不显示任何内容
                end
                else
                begin
                    case(scan_cnt)
                       0: 
                       begin
                       case(length_1)
                            3'b001: 
                            begin
                                casex(character_1)
                                    5'b0xxxx: Y_r = 7'b1111_001; //E
                                    5'b1xxxx: Y_r = 7'b1111_000; //t
                                endcase
                            end
                            3'b010: 
                            begin
                                casex(character_1)
                                    5'b00xxx: Y_r = 7'b0001_111; //I
                                    5'b01xxx: Y_r = 7'b1110_111; //A
                                    5'b10xxx: Y_r = 7'b1010_100; //n
                                    5'b11xxx: Y_r = 7'b0110_111; //M
                                endcase
                            end
                            3'b011: 
                            begin
                                casex(character_1)
                                    5'b000xx: Y_r = 7'b1001_001;  //S
                                    5'b001xx: Y_r = 7'b0111_110;  //U
                                    5'b010xx: Y_r = 7'b0110_001;  //r
                                    5'b011xx: Y_r = 7'b1111_110;  //W
                                    5'b100xx: Y_r = 7'b1011_110;  //d
                                    5'b101xx: Y_r = 7'b1110_101;  //K
                                    5'b110xx: Y_r = 7'b0111_101;  //G
                                    5'b111xx: Y_r = 7'b1011_100;  //o
                                endcase
                            end
                            3'b100: 
                            begin
                                casex(character_1)
                                    5'b0000x: Y_r = 7'b1110_110; //H
                                    5'b0001x: Y_r = 7'b0011_100; //v 
                                    5'b0010x: Y_r = 7'b1110_001; //F
                                    5'b0100x: Y_r = 7'b0111_000; //L
                                    5'b0110x: Y_r = 7'b1110_011; //P
                                    5'b0111x: Y_r = 7'b0001_110; //J
                                    5'b1000x: Y_r = 7'b1111_100; //b
                                    5'b1001x: Y_r = 7'b1100_100; //X
                                    5'b1010x: Y_r = 7'b0111_001; //C
                                    5'b1011x: Y_r = 7'b1101_110; //y
                                    5'b1100x: Y_r = 7'b1011_010; //Z
                                    5'b1101x: Y_r = 7'b1100_111; //q
                                    default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                endcase
                            end
                            3'b101:
                            begin
                                casex(character_1)      
                                    5'b01111: Y_r = 7'b0000_110; //1
                                    5'b00111: Y_r = 7'b1011_011; //2
                                    5'b00011: Y_r = 7'b1001_111; //3
                                    5'b00001: Y_r = 7'b1100_110; //4
                                    5'b00000: Y_r = 7'b1101_101; //5
                                    5'b10000: Y_r = 7'b1111_101; //6
                                    5'b11000: Y_r = 7'b0100_111; //7
                                    5'b11100: Y_r = 7'b1111_111; //8
                                    5'b11110: Y_r = 7'b1101_111; //9
                                    5'b11111: Y_r = 7'b0111_111; //0
                                    default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                endcase
                            end
                            /////////字符总长度超过5 或者为0 ， 那么就不显示任何内容  一般不可能发生，保险起见
                            default: Y_r = 7'b0000_000;
                       endcase
                       end
                       
                       1: 
                       begin
                          case(length_2)
                               3'b001: 
                               begin
                                   casex(character_2)
                                       5'b0xxxx: Y_r = 7'b1111_001; //E
                                       5'b1xxxx: Y_r = 7'b1111_000; //t
                                   endcase
                               end
                               3'b010: 
                               begin
                                   casex(character_2)
                                       5'b00xxx: Y_r = 7'b0001_111; //I
                                       5'b01xxx: Y_r = 7'b1110_111; //A
                                       5'b10xxx: Y_r = 7'b1010_100; //n
                                       5'b11xxx: Y_r = 7'b0110_111; //M
                                   endcase
                               end
                               3'b011: 
                               begin
                                   casex(character_2)
                                       5'b000xx: Y_r = 7'b1001_001;  //S
                                       5'b001xx: Y_r = 7'b0111_110;  //U
                                       5'b010xx: Y_r = 7'b0110_001;  //r
                                       5'b011xx: Y_r = 7'b1111_110;  //W
                                       5'b100xx: Y_r = 7'b1011_110;  //d
                                       5'b101xx: Y_r = 7'b1110_101;  //K
                                       5'b110xx: Y_r = 7'b0111_101;  //G
                                       5'b111xx: Y_r = 7'b1011_100;  //o
                                   endcase
                               end
                               3'b100: 
                               begin
                                   casex(character_2)
                                       5'b0000x: Y_r = 7'b1110_110; //H
                                       5'b0001x: Y_r = 7'b0011_100; //v 
                                       5'b0010x: Y_r = 7'b1110_001; //F
                                       5'b0100x: Y_r = 7'b0111_000; //L
                                       5'b0110x: Y_r = 7'b1110_011; //P
                                       5'b0111x: Y_r = 7'b0001_110; //J
                                       5'b1000x: Y_r = 7'b1111_100; //b
                                       5'b1001x: Y_r = 7'b1100_100; //X
                                       5'b1010x: Y_r = 7'b0111_001; //C
                                       5'b1011x: Y_r = 7'b1101_110; //y
                                       5'b1100x: Y_r = 7'b1011_010; //Z
                                       5'b1101x: Y_r = 7'b1100_111; //q
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               3'b101:
                               begin
                                   casex(character_2)      
                                       5'b01111: Y_r = 7'b0000_110; //1
                                       5'b00111: Y_r = 7'b1011_011; //2
                                       5'b00011: Y_r = 7'b1001_111; //3
                                       5'b00001: Y_r = 7'b1100_110; //4
                                       5'b00000: Y_r = 7'b1101_101; //5
                                       5'b10000: Y_r = 7'b1111_101; //6
                                       5'b11000: Y_r = 7'b0100_111; //7
                                       5'b11100: Y_r = 7'b1111_111; //8
                                       5'b11110: Y_r = 7'b1101_111; //9
                                       5'b11111: Y_r = 7'b0111_111; //0
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               /////////字符总长度超过5 或者为0， 那么就不显示任何内容，一般不可能发生，保险起见
                               default: Y_r = 7'b0000_000;
                          endcase
                        end
                       
                       2: 
                       begin
                          case(length_3)
                               3'b001: 
                               begin
                                   casex(character_3)
                                        5'b0xxxx: Y_r = 7'b1111_001; //E
                                        5'b1xxxx: Y_r = 7'b1111_000; //t
                                   endcase
                               end
                               3'b010: 
                               begin
                                   casex(character_3)
                                       5'b00xxx: Y_r = 7'b0001_111; //I
                                       5'b01xxx: Y_r = 7'b1110_111; //A
                                       5'b10xxx: Y_r = 7'b1010_100; //n
                                       5'b11xxx: Y_r = 7'b0110_111; //M
                                   endcase
                               end
                               3'b011: 
                               begin
                                   casex(character_3)
                                       5'b000xx: Y_r = 7'b1001_001;  //S
                                       5'b001xx: Y_r = 7'b0111_110;  //U
                                       5'b010xx: Y_r = 7'b0110_001;  //r
                                       5'b011xx: Y_r = 7'b1111_110;  //W
                                       5'b100xx: Y_r = 7'b1011_110;  //d
                                       5'b101xx: Y_r = 7'b1110_101;  //K
                                       5'b110xx: Y_r = 7'b0111_101;  //G
                                       5'b111xx: Y_r = 7'b1011_100;  //o
                                   endcase
                               end
                               3'b100: 
                               begin
                                   casex(character_3)
                                       5'b0000x: Y_r = 7'b1110_110; //H
                                       5'b0001x: Y_r = 7'b0011_100; //v 
                                       5'b0010x: Y_r = 7'b1110_001; //F
                                       5'b0100x: Y_r = 7'b0111_000; //L
                                       5'b0110x: Y_r = 7'b1110_011; //P
                                       5'b0111x: Y_r = 7'b0001_110; //J
                                       5'b1000x: Y_r = 7'b1111_100; //b
                                       5'b1001x: Y_r = 7'b1100_100; //X
                                       5'b1010x: Y_r = 7'b0111_001; //C
                                       5'b1011x: Y_r = 7'b1101_110; //y
                                       5'b1100x: Y_r = 7'b1011_010; //Z
                                       5'b1101x: Y_r = 7'b1100_111; //q
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               3'b101:
                               begin
                                   casex(character_3)      
                                       5'b01111: Y_r = 7'b0000_110; //1
                                       5'b00111: Y_r = 7'b1011_011; //2
                                       5'b00011: Y_r = 7'b1001_111; //3
                                       5'b00001: Y_r = 7'b1100_110; //4
                                       5'b00000: Y_r = 7'b1101_101; //5
                                       5'b10000: Y_r = 7'b1111_101; //6
                                       5'b11000: Y_r = 7'b0100_111; //7
                                       5'b11100: Y_r = 7'b1111_111; //8
                                       5'b11110: Y_r = 7'b1101_111; //9
                                       5'b11111: Y_r = 7'b0111_111; //0
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               /////////字符总长度超过5 或者为0， 那么就不显示任何内容，一般不可能发生，保险起见
                               default: Y_r = 7'b0000_000;
                          endcase
                       end                
                       
                       3: 
                       begin
                          case(length_4)
                               3'b001: 
                               begin
                                   casex(character_4)
                                        5'b0xxxx: Y_r = 7'b1111_001; //E
                                        5'b1xxxx: Y_r = 7'b1111_000; //t
                                   endcase
                               end
                               3'b010: 
                               begin
                                   casex(character_4)
                                       5'b00xxx: Y_r = 7'b0001_111; //I
                                       5'b01xxx: Y_r = 7'b1110_111; //A
                                       5'b10xxx: Y_r = 7'b1010_100; //n
                                       5'b11xxx: Y_r = 7'b0110_111; //M
                                   endcase
                               end
                               3'b011: 
                               begin
                                   casex(character_4)
                                       5'b000xx: Y_r = 7'b1001_001;  //S
                                       5'b001xx: Y_r = 7'b0111_110;  //U
                                       5'b010xx: Y_r = 7'b0110_001;  //r
                                       5'b011xx: Y_r = 7'b1111_110;  //W
                                       5'b100xx: Y_r = 7'b1011_110;  //d
                                       5'b101xx: Y_r = 7'b1110_101;  //K
                                       5'b110xx: Y_r = 7'b0111_101;  //G
                                       5'b111xx: Y_r = 7'b1011_100;  //o
                                   endcase
                               end
                               3'b100: 
                               begin
                                   casex(character_4)
                                       5'b0000x: Y_r = 7'b1110_110; //H
                                       5'b0001x: Y_r = 7'b0011_100; //v 
                                       5'b0010x: Y_r = 7'b1110_001; //F
                                       5'b0100x: Y_r = 7'b0111_000; //L
                                       5'b0110x: Y_r = 7'b1110_011; //P
                                       5'b0111x: Y_r = 7'b0001_110; //J
                                       5'b1000x: Y_r = 7'b1111_100; //b
                                       5'b1001x: Y_r = 7'b1100_100; //X
                                       5'b1010x: Y_r = 7'b0111_001; //C
                                       5'b1011x: Y_r = 7'b1101_110; //y
                                       5'b1100x: Y_r = 7'b1011_010; //Z
                                       5'b1101x: Y_r = 7'b1100_111; //q
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               3'b101:
                               begin
                                   casex(character_4)      
                                       5'b01111: Y_r = 7'b0000_110; //1
                                       5'b00111: Y_r = 7'b1011_011; //2
                                       5'b00011: Y_r = 7'b1001_111; //3
                                       5'b00001: Y_r = 7'b1100_110; //4
                                       5'b00000: Y_r = 7'b1101_101; //5
                                       5'b10000: Y_r = 7'b1111_101; //6
                                       5'b11000: Y_r = 7'b0100_111; //7
                                       5'b11100: Y_r = 7'b1111_111; //8
                                       5'b11110: Y_r = 7'b1101_111; //9
                                       5'b11111: Y_r = 7'b0111_111; //0
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               /////////字符总长度超过5 或者为0， 那么就不显示任何内容，一般不可能发生，保险起见
                               default: Y_r = 7'b0000_000;
                          endcase
                       end               
                       
                       4: 
                       begin
                          case(length_5)
                               3'b001: 
                               begin
                                   casex(character_5)
                                        5'b0xxxx: Y_r = 7'b1111_001; //E
                                        5'b1xxxx: Y_r = 7'b1111_000; //t
                                   endcase
                               end
                               3'b010: 
                               begin
                                   casex(character_5)
                                       5'b00xxx: Y_r = 7'b0001_111; //I
                                       5'b01xxx: Y_r = 7'b1110_111; //A
                                       5'b10xxx: Y_r = 7'b1010_100; //n
                                       5'b11xxx: Y_r = 7'b0110_111; //M
                                   endcase
                               end
                               3'b011: 
                               begin
                                   casex(character_5)
                                       5'b000xx: Y_r = 7'b1001_001;  //S
                                       5'b001xx: Y_r = 7'b0111_110;  //U
                                       5'b010xx: Y_r = 7'b0110_001;  //r
                                       5'b011xx: Y_r = 7'b1111_110;  //W
                                       5'b100xx: Y_r = 7'b1011_110;  //d
                                       5'b101xx: Y_r = 7'b1110_101;  //K
                                       5'b110xx: Y_r = 7'b0111_101;  //G
                                       5'b111xx: Y_r = 7'b1011_100;  //o
                                   endcase
                               end
                               3'b100: 
                               begin
                                   casex(character_5)
                                       5'b0000x: Y_r = 7'b1110_110; //H
                                       5'b0001x: Y_r = 7'b0011_100; //v 
                                       5'b0010x: Y_r = 7'b1110_001; //F
                                       5'b0100x: Y_r = 7'b0111_000; //L
                                       5'b0110x: Y_r = 7'b1110_011; //P
                                       5'b0111x: Y_r = 7'b0001_110; //J
                                       5'b1000x: Y_r = 7'b1111_100; //b
                                       5'b1001x: Y_r = 7'b1100_100; //X
                                       5'b1010x: Y_r = 7'b0111_001; //C
                                       5'b1011x: Y_r = 7'b1101_110; //y
                                       5'b1100x: Y_r = 7'b1011_010; //Z
                                       5'b1101x: Y_r = 7'b1100_111; //q
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               3'b101:
                               begin
                                   casex(character_5)      
                                       5'b01111: Y_r = 7'b0000_110; //1
                                       5'b00111: Y_r = 7'b1011_011; //2
                                       5'b00011: Y_r = 7'b1001_111; //3
                                       5'b00001: Y_r = 7'b1100_110; //4
                                       5'b00000: Y_r = 7'b1101_101; //5
                                       5'b10000: Y_r = 7'b1111_101; //6
                                       5'b11000: Y_r = 7'b0100_111; //7
                                       5'b11100: Y_r = 7'b1111_111; //8
                                       5'b11110: Y_r = 7'b1101_111; //9
                                       5'b11111: Y_r = 7'b0111_111; //0
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               /////////字符总长度超过5，一般不可能发生，保险起见
                               default: Y_r = 7'b0000_000;
                          endcase
                       end               
                       
                       5: 
                       begin
                          case(length_6)
                               3'b001: 
                               begin
                                   casex(character_6)
                                        5'b0xxxx: Y_r = 7'b1111_001; //E
                                        5'b1xxxx: Y_r = 7'b1111_000; //t
                                   endcase
                               end
                               3'b010: 
                               begin
                                   casex(character_6)
                                       5'b00xxx: Y_r = 7'b0001_111; //I
                                       5'b01xxx: Y_r = 7'b1110_111; //A
                                       5'b10xxx: Y_r = 7'b1010_100; //n
                                       5'b11xxx: Y_r = 7'b0110_111; //M
                                   endcase
                               end
                               3'b011: 
                               begin
                                   casex(character_6)
                                       5'b000xx: Y_r = 7'b1001_001;  //S
                                       5'b001xx: Y_r = 7'b0111_110;  //U
                                       5'b010xx: Y_r = 7'b0110_001;  //r
                                       5'b011xx: Y_r = 7'b1111_110;  //W
                                       5'b100xx: Y_r = 7'b1011_110;  //d
                                       5'b101xx: Y_r = 7'b1110_101;  //K
                                       5'b110xx: Y_r = 7'b0111_101;  //G
                                       5'b111xx: Y_r = 7'b1011_100;  //o
                                   endcase
                               end
                               3'b100: 
                               begin
                                   casex(character_6)
                                       5'b0000x: Y_r = 7'b1110_110; //H
                                       5'b0001x: Y_r = 7'b0011_100; //v 
                                       5'b0010x: Y_r = 7'b1110_001; //F
                                       5'b0100x: Y_r = 7'b0111_000; //L
                                       5'b0110x: Y_r = 7'b1110_011; //P
                                       5'b0111x: Y_r = 7'b0001_110; //J
                                       5'b1000x: Y_r = 7'b1111_100; //b
                                       5'b1001x: Y_r = 7'b1100_100; //X
                                       5'b1010x: Y_r = 7'b0111_001; //C
                                       5'b1011x: Y_r = 7'b1101_110; //y
                                       5'b1100x: Y_r = 7'b1011_010; //Z
                                       5'b1101x: Y_r = 7'b1100_111; //q
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               3'b101:
                               begin
                                   casex(character_6)      
                                       5'b01111: Y_r = 7'b0000_110; //1
                                       5'b00111: Y_r = 7'b1011_011; //2
                                       5'b00011: Y_r = 7'b1001_111; //3
                                       5'b00001: Y_r = 7'b1100_110; //4
                                       5'b00000: Y_r = 7'b1101_101; //5
                                       5'b10000: Y_r = 7'b1111_101; //6
                                       5'b11000: Y_r = 7'b0100_111; //7
                                       5'b11100: Y_r = 7'b1111_111; //8
                                       5'b11110: Y_r = 7'b1101_111; //9
                                       5'b11111: Y_r = 7'b0111_111; //0
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               /////////字符总长度超过5 或者为0， 那么就不显示任何内容，一般不可能发生，保险起见
                               default: Y_r = 7'b0000_000;
                          endcase
                       end 
                       
                       6: 
                       begin
                          case(length_7)
                               3'b001: 
                               begin
                                   casex(character_7)
                                        5'b0xxxx: Y_r = 7'b1111_001; //E
                                        5'b1xxxx: Y_r = 7'b1111_000; //t
                                   endcase
                               end
                               3'b010: 
                               begin
                                   casex(character_7)
                                       5'b00xxx: Y_r = 7'b0001_111; //I
                                       5'b01xxx: Y_r = 7'b1110_111; //A
                                       5'b10xxx: Y_r = 7'b1010_100; //n
                                       5'b11xxx: Y_r = 7'b0110_111; //M
                                   endcase
                               end
                               3'b011: 
                               begin
                                   casex(character_7)
                                       5'b000xx: Y_r = 7'b1001_001;  //S
                                       5'b001xx: Y_r = 7'b0111_110;  //U
                                       5'b010xx: Y_r = 7'b0110_001;  //r
                                       5'b011xx: Y_r = 7'b1111_110;  //W
                                       5'b100xx: Y_r = 7'b1011_110;  //d
                                       5'b101xx: Y_r = 7'b1110_101;  //K
                                       5'b110xx: Y_r = 7'b0111_101;  //G
                                       5'b111xx: Y_r = 7'b1011_100;  //o
                                   endcase
                               end
                               3'b100: 
                               begin
                                   casex(character_7)
                                       5'b0000x: Y_r = 7'b1110_110; //H
                                       5'b0001x: Y_r = 7'b0011_100; //v 
                                       5'b0010x: Y_r = 7'b1110_001; //F
                                       5'b0100x: Y_r = 7'b0111_000; //L
                                       5'b0110x: Y_r = 7'b1110_011; //P
                                       5'b0111x: Y_r = 7'b0001_110; //J
                                       5'b1000x: Y_r = 7'b1111_100; //b
                                       5'b1001x: Y_r = 7'b1100_100; //X
                                       5'b1010x: Y_r = 7'b0111_001; //C
                                       5'b1011x: Y_r = 7'b1101_110; //y
                                       5'b1100x: Y_r = 7'b1011_010; //Z
                                       5'b1101x: Y_r = 7'b1100_111; //q
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               3'b101:
                               begin
                                   casex(character_7)      
                                       5'b01111: Y_r = 7'b0000_110; //1
                                       5'b00111: Y_r = 7'b1011_011; //2
                                       5'b00011: Y_r = 7'b1001_111; //3
                                       5'b00001: Y_r = 7'b1100_110; //4
                                       5'b00000: Y_r = 7'b1101_101; //5
                                       5'b10000: Y_r = 7'b1111_101; //6
                                       5'b11000: Y_r = 7'b0100_111; //7
                                       5'b11100: Y_r = 7'b1111_111; //8
                                       5'b11110: Y_r = 7'b1101_111; //9
                                       5'b11111: Y_r = 7'b0111_111; //0
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               /////////字符总长度超过5 或者为0， 那么就不显示任何内容，一般不可能发生，保险起见
                               default: Y_r = 7'b0000_000;
                          endcase
                       end
                       
                       7: 
                       begin
                          case(length_8)
                               3'b001: 
                               begin
                                   casex(character_8)
                                        5'b0xxxx: Y_r = 7'b1111_001; //E
                                        5'b1xxxx: Y_r = 7'b1111_000; //t
                                   endcase
                               end
                               3'b010: 
                               begin
                                   casex(character_8)
                                       5'b00xxx: Y_r = 7'b0001_111; //I
                                       5'b01xxx: Y_r = 7'b1110_111; //A
                                       5'b10xxx: Y_r = 7'b1010_100; //n
                                       5'b11xxx: Y_r = 7'b0110_111; //M
                                   endcase
                               end
                               3'b011: 
                               begin
                                   casex(character_8)
                                       5'b000xx: Y_r = 7'b1001_001;  //S
                                       5'b001xx: Y_r = 7'b0111_110;  //U
                                       5'b010xx: Y_r = 7'b0110_001;  //r
                                       5'b011xx: Y_r = 7'b1111_110;  //W
                                       5'b100xx: Y_r = 7'b1011_110;  //d
                                       5'b101xx: Y_r = 7'b1110_101;  //K
                                       5'b110xx: Y_r = 7'b0111_101;  //G
                                       5'b111xx: Y_r = 7'b1011_100;  //o
                                   endcase
                               end
                               3'b100: 
                               begin
                                   casex(character_8)
                                       5'b0000x: Y_r = 7'b1110_110; //H
                                       5'b0001x: Y_r = 7'b0011_100; //v 
                                       5'b0010x: Y_r = 7'b1110_001; //F
                                       5'b0100x: Y_r = 7'b0111_000; //L
                                       5'b0110x: Y_r = 7'b1110_011; //P
                                       5'b0111x: Y_r = 7'b0001_110; //J
                                       5'b1000x: Y_r = 7'b1111_100; //b
                                       5'b1001x: Y_r = 7'b1100_100; //X
                                       5'b1010x: Y_r = 7'b0111_001; //C
                                       5'b1011x: Y_r = 7'b1101_110; //y
                                       5'b1100x: Y_r = 7'b1011_010; //Z
                                       5'b1101x: Y_r = 7'b1100_111; //q
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               3'b101:
                               begin
                                   casex(character_8)      
                                       5'b01111: Y_r = 7'b0000_110; //1
                                       5'b00111: Y_r = 7'b1011_011; //2
                                       5'b00011: Y_r = 7'b1001_111; //3
                                       5'b00001: Y_r = 7'b1100_110; //4
                                       5'b00000: Y_r = 7'b1101_101; //5
                                       5'b10000: Y_r = 7'b1111_101; //6
                                       5'b11000: Y_r = 7'b0100_111; //7
                                       5'b11100: Y_r = 7'b1111_111; //8
                                       5'b11110: Y_r = 7'b1101_111; //9
                                       5'b11111: Y_r = 7'b0111_111; //0
                                       default:  Y_r = 7'b0000_000; //无法解码出任何字符
                                   endcase
                               end
                               /////////字符总长度超过5 或者为0， 那么就不显示任何内容，一般不可能发生，保险起见
                               default: Y_r = 7'b0000_000;
                          endcase
                       end               
                          
                       default: Y_r = 7'b0000_000;                             
                    endcase
                    end
                end 
            endcase 
          end  
        
        1:  ////////////编码状态
        begin
             case(DIG_r)
               8'b10000000:
                   begin
                   Y_r[0] = ~store[0];
                   Y_r[1] = ~store[1];
                   Y_r[2] = ~store[2];
                   Y_r[3] = ~store[3];
                   Y_r[4] = ~store[4];
                   Y_r[5] = ~store[5];
                   Y_r[6] = ~store[6];
                   end
               8'b01000000:
                   begin
                   Y_r[0] = ~store[8];
                   Y_r[1] = ~store[9];
                   Y_r[2] = ~store[10];
                   Y_r[3] = ~store[11];
                   Y_r[4] = ~store[12];
                   Y_r[5] = ~store[13];
                   Y_r[6] = ~store[14];
                   end
               8'b00100000:
                   begin
                   Y_r[0] = ~store[16];
                   Y_r[1] = ~store[17];
                   Y_r[2] = ~store[18];
                   Y_r[3] = ~store[19];
                   Y_r[4] = ~store[20];
                   Y_r[5] = ~store[21];
                   Y_r[6] = ~store[22];
                   end
               8'b00010000:
                   begin
                   Y_r[0] = ~store[24];
                   Y_r[1] = ~store[25];
                   Y_r[2] = ~store[26];
                   Y_r[3] = ~store[27];
                   Y_r[4] = ~store[28];
                   Y_r[5] = ~store[29];
                   Y_r[6] = ~store[30];
                   end
               8'b00001000:
                   begin
                   Y_r[0] = ~store[32];
                   Y_r[1] = ~store[33];
                   Y_r[2] = ~store[34];
                   Y_r[3] = ~store[35];
                   Y_r[4] = ~store[36];
                   Y_r[5] = ~store[37];
                   Y_r[6] = ~store[38];
                   end
               8'b00000100:
                   begin
                   Y_r[0] = ~store[40];
                   Y_r[1] = ~store[41];
                   Y_r[2] = ~store[42];
                   Y_r[3] = ~store[43];
                   Y_r[4] = ~store[44];
                   Y_r[5] = ~store[45];
                   Y_r[6] = ~store[46];
                   end
               8'b00000010:
                   begin
                   Y_r[0] = ~store[48];
                   Y_r[1] = ~store[49];
                   Y_r[2] = ~store[50];
                   Y_r[3] = ~store[51];
                   Y_r[4] = ~store[52];
                   Y_r[5] = ~store[53];
                   Y_r[6] = ~store[54];
                   end
               8'b00000001:
                   begin
                   Y_r[0] = ~store[56];
                   Y_r[1] = ~store[57];
                   Y_r[2] = ~store[58];
                   Y_r[3] = ~store[59];
                   Y_r[4] = ~store[60];
                   Y_r[5] = ~store[61];
                   Y_r[6] = ~store[62];
                   end
               default: Y_r = 7'b0000000;
           endcase
        end
          
        endcase
    end
       
endmodule
