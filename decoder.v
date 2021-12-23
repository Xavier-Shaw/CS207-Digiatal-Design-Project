`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/04 15:30:29
// Design Name: 
// Module Name: decoder
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

module decoder(
 //解码键
input check,  //时钟信号
input long_key,  //长码
input short_key,  //短码
input send,  //发送
input back_space, //退格
input reset, //重置

output reg[14:0] Y_led = 0, //缓冲区, LED显示缓冲区内容
output reg error_out_of_length = 0,  //缓冲区长度报错

output reg error_character = 0,    //已解码区长度报错
output reg [3:0]cnt_character = 0, //已解码字符数
output reg error_decode,          //解码失败报错

output reg [39:0] characters_code, //存储已解码字符的全部长短码构成
output reg [23:0] cnt_character_code //存储每个字符所含的长短码个数

);

reg [5:0] cnt_code = 0;//缓冲区编码长度

reg [2:0] codes_length = 0; //解码后的字符含有的长短码个数
reg [5:0] index = 0; //解码时对应缓冲区位置的指针
reg decode_complete;  ////解码是否正常

//按键防抖
reg[3:0] reg_long_key = 0;
reg[3:0] reg_short_key = 0;
reg[3:0] reg_back_space = 0;
reg[3:0] reg_send = 0;
reg[3:0] reg_reset = 0;

always@(posedge check)
begin  
    //////报错灯显示时长
    if(error_decode)
        #10000_000 error_decode = 0;
    
    ///////对每个按键进行防抖处理，当一个按键确定按下后，清空其它按键的 reg
    if(long_key) 
    begin
        if(reg_long_key[3] != 1)
        reg_long_key = reg_long_key + 1;   
    end
    if(short_key)
    begin
        if(reg_short_key[3] != 1)
        reg_short_key = reg_short_key + 1;
    end
    if(back_space)
    begin
        if(reg_back_space[3] != 1)
        reg_back_space = reg_back_space + 1;
    end
    if(send)
    begin
        if(reg_send[3] != 1)
        reg_send = reg_send + 1;
    end
    if(reset)
    begin
        if(reg_reset[3] != 1)
        reg_reset = reg_reset + 1;
    end
   
   
    ////////   长码输入
    if(reg_long_key[3])
    begin
        if(cnt_code <= 13)
        begin
            Y_led[cnt_code] = 1;                       
            Y_led[cnt_code + 1] = 1;
            cnt_code = cnt_code + 3;
            if(cnt_code > 14)
            begin
                cnt_code = 15;
            end            
        end
        else
        cnt_code = 15;
        
        reg_long_key = 0;
        reg_short_key = 0;
        reg_back_space = 0;
        reg_send = 0;
    end
    ////////   短码输入
    else if(reg_short_key[3])
    begin
        if(cnt_code <= 14)
        begin
            Y_led[cnt_code] = 1;    
            cnt_code = cnt_code + 2;
            if(cnt_code > 14)
            cnt_code = 15;
        end
        
        reg_long_key = 0;
        reg_short_key = 0;
        reg_back_space = 0;
        reg_send = 0;
        reg_reset = 0;
    end
    ////////   退格功能  根据要删除的长短码的不同 进行操作
    else if(reg_back_space[3])
    begin             
        if(cnt_code == 15)
        begin
            error_out_of_length = 0;
            if(Y_led[14] && Y_led[13]) 
            begin
                Y_led[14] = 0;
                Y_led[13] = 0;
                cnt_code = 13;
            end
            else if(Y_led[14] && ~Y_led[13])  
            begin
                Y_led[14] = 0;
                cnt_code = 14;
            end
            else if(~Y_led[14] && Y_led[13] && Y_led[12]) 
            begin
                Y_led[13] = 0;
                Y_led[12] = 0;
                cnt_code = 12;
            end
            else if(~Y_led[14] && Y_led[13] && ~Y_led[12]) 
            begin
                Y_led[13] = 0;
                cnt_code = 13;
            end
            else if(~Y_led[14] && ~Y_led[13] && Y_led[12] && ~Y_led[11]) 
            begin
                Y_led[12] = 0;
                cnt_code = 12;
            end
            else if(~Y_led[14] && ~Y_led[13] && Y_led[12] && Y_led[11]) 
            begin
                Y_led[12] = 0;
                Y_led[11] = 0;
                cnt_code = 11;
            end
        end
        else if(cnt_code > 2)
        begin   
            cnt_code = cnt_code - 2; 
            Y_led[cnt_code] = 0;                  
            if(Y_led[cnt_code - 1] == 1)
            begin
                Y_led[cnt_code - 1] = 0;
                cnt_code = cnt_code - 1;
            end
        end
        else
        begin
        Y_led = 0;
        cnt_code = 0;
        end
        
        reg_long_key = 0;
        reg_short_key = 0;
        reg_back_space = 0;
        reg_send = 0;  
        reg_reset = 0;          
    end
    ////////    发送功能
    else if(reg_send[3])
    begin
        codes_length = 0;
        index = 0;
        decode_complete = 1;
        /////发送成功，进行解码
        if(cnt_character <= 7)                             ////// 假设缓冲区为： 110_10_110_10 则解码信息为：10100
        begin                        
            repeat(6) //读完了缓冲区 则停止循环
            begin
            if(index <= 14)
            begin
                if(Y_led[index] && Y_led[index + 1]) //11
                begin
                    if(codes_length < 5)  //合法时
                    begin
                        codes_length = codes_length + 1;
                        characters_code[5 * (cnt_character + 1) - codes_length] = 1;  //将解码后的长短码信息存储到总的存储块中
                    end
                    else
                    decode_complete = 0;
                    
                    index = index + 3; 
                end
                else if(Y_led[index] && ~Y_led[index+1]) //10
                begin
                    if(codes_length < 5)  //合法时
                    begin
                        codes_length = codes_length + 1;
                        characters_code[5 * (cnt_character + 1) - codes_length] = 0;   //将解码后的长短码信息存储到总的存储块中
                    end
                    else
                    decode_complete = 0;
                    
                    index = index + 2;
                end
                else  //0
                    index = index + 1;
            end
            end
            
            //////判断是否能解码  /////当不能解码时,将已解码的字符数 - 1并修改cnt_character_code的内容即可

            case(codes_length)
                4:
                begin
                    case({characters_code[5 * (cnt_character + 1) - 1], characters_code[5 * (cnt_character + 1) - 2], characters_code[5 * (cnt_character + 1) - 3], characters_code[5 * (cnt_character + 1) - 4]})
                        4'b0011: 
                        begin
                        codes_length = 0;
                        decode_complete = 0;
                        end
                        4'b0101: 
                        begin
                        codes_length = 0;
                        decode_complete = 0;
                        end
                        4'b1110: 
                        begin
                        codes_length = 0;
                        decode_complete = 0;
                        end
                        4'b1111:
                        begin
                        codes_length = 0;
                        decode_complete = 0; 
                        end
                        default: codes_length = codes_length;
                    endcase
                end
                5:               
                begin
                    case({characters_code[5 * (cnt_character + 1) - 1], characters_code[5 * (cnt_character + 1) - 2], characters_code[5 * (cnt_character + 1) - 3], characters_code[5 * (cnt_character + 1) - 4], characters_code[5 * (cnt_character + 1) - 5]}) 
                        5'b01111: codes_length = codes_length;
                        5'b00111: codes_length = codes_length;
                        5'b00011: codes_length = codes_length;
                        5'b00001: codes_length = codes_length;
                        5'b00000: codes_length = codes_length;
                        5'b10000: codes_length = codes_length;
                        5'b11000: codes_length = codes_length;
                        5'b11100: codes_length = codes_length;
                        5'b11110: codes_length = codes_length;
                        5'b11111: codes_length = codes_length;
                        default:
                        begin
                            codes_length = 0; 
                            decode_complete = 0;
                        end
                    endcase
                end
              
                default: 
                begin
                codes_length = codes_length;
                end
            endcase
            
            ////////只有编码成功且不是空按按键 cnt_character 才 + 1
            if(decode_complete && codes_length != 0)
            begin
                cnt_character = cnt_character + 1;
                error_decode = 0;
            end
            else   
            begin
                codes_length = 0;
                error_decode = 1; 
            end
            
            case(codes_length)
                1: {cnt_character_code[3 * cnt_character - 3], cnt_character_code[3 * cnt_character - 2] ,cnt_character_code[3 * cnt_character - 1]} = 3'b001;
                2: {cnt_character_code[3 * cnt_character - 3], cnt_character_code[3 * cnt_character - 2] ,cnt_character_code[3 * cnt_character - 1]} = 3'b010;
                3: {cnt_character_code[3 * cnt_character - 3], cnt_character_code[3 * cnt_character - 2] ,cnt_character_code[3 * cnt_character - 1]} = 3'b011;
                4: {cnt_character_code[3 * cnt_character - 3], cnt_character_code[3 * cnt_character - 2] ,cnt_character_code[3 * cnt_character - 1]} = 3'b100;
                5: {cnt_character_code[3 * cnt_character - 3], cnt_character_code[3 * cnt_character - 2] ,cnt_character_code[3 * cnt_character - 1]} = 3'b101; 
                default: 
                begin
                {characters_code[5 * (cnt_character + 1) - 1], characters_code[5 * (cnt_character + 1) - 2]} = 2'b00; 
                {characters_code[5 * (cnt_character + 1) - 3], characters_code[5 * (cnt_character + 1) - 4], characters_code[5 * (cnt_character + 1) - 5]} = 3'b000;
                end
            endcase            
           ////解码完成后，恢复初始状态
            index = 0;
            codes_length = 0;
            if(cnt_character == 8)
            error_character = 1; //说明字符数已满
        end
        else
        error_character = 1;
        
        ////清空缓存区，恢复初始状态
        Y_led = 0;
        cnt_code = 0;
        error_out_of_length = 0;
        
        reg_long_key = 0;
        reg_short_key = 0;
        reg_back_space = 0;
        reg_send = 0;
        reg_reset = 0;
    end
    /////////重置
    else if(reg_reset[3])
    begin
        ////清空长短码缓冲区的信息
        cnt_code = 0;
        Y_led = 0;
        error_out_of_length = 0;

        ////清空七段数码管的信息
        error_character = 0;
        characters_code = 0;
        cnt_character_code = 0;
        cnt_character = 0;
        
        reg_long_key = 0;
        reg_short_key = 0;
        reg_back_space = 0;
        reg_send = 0;
        reg_reset = 0;
    end
    else
        Y_led = Y_led; 
    
    
    
    //检查缓冲区长短码数是否要报错
    if(cnt_code >= 15)
    begin
    cnt_code = 15;
    error_out_of_length = 1;
    end   
    
end







endmodule
