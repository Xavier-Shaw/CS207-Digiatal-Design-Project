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
 //�����
input check,  //ʱ���ź�
input long_key,  //����
input short_key,  //����
input send,  //����
input back_space, //�˸�
input reset, //����

output reg[14:0] Y_led = 0, //������, LED��ʾ����������
output reg error_out_of_length = 0,  //���������ȱ���

output reg error_character = 0,    //�ѽ��������ȱ���
output reg [3:0]cnt_character = 0, //�ѽ����ַ���
output reg error_decode,          //����ʧ�ܱ���

output reg [39:0] characters_code, //�洢�ѽ����ַ���ȫ�������빹��
output reg [23:0] cnt_character_code //�洢ÿ���ַ������ĳ��������

);

reg [5:0] cnt_code = 0;//���������볤��

reg [2:0] codes_length = 0; //�������ַ����еĳ��������
reg [5:0] index = 0; //����ʱ��Ӧ������λ�õ�ָ��
reg decode_complete;  ////�����Ƿ�����

//��������
reg[3:0] reg_long_key = 0;
reg[3:0] reg_short_key = 0;
reg[3:0] reg_back_space = 0;
reg[3:0] reg_send = 0;
reg[3:0] reg_reset = 0;

always@(posedge check)
begin  
    //////�������ʾʱ��
    if(error_decode)
        #10000_000 error_decode = 0;
    
    ///////��ÿ���������з���������һ������ȷ�����º�������������� reg
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
   
   
    ////////   ��������
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
    ////////   ��������
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
    ////////   �˸���  ����Ҫɾ���ĳ�����Ĳ�ͬ ���в���
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
    ////////    ���͹���
    else if(reg_send[3])
    begin
        codes_length = 0;
        index = 0;
        decode_complete = 1;
        /////���ͳɹ������н���
        if(cnt_character <= 7)                             ////// ���軺����Ϊ�� 110_10_110_10 �������ϢΪ��10100
        begin                        
            repeat(6) //�����˻����� ��ֹͣѭ��
            begin
            if(index <= 14)
            begin
                if(Y_led[index] && Y_led[index + 1]) //11
                begin
                    if(codes_length < 5)  //�Ϸ�ʱ
                    begin
                        codes_length = codes_length + 1;
                        characters_code[5 * (cnt_character + 1) - codes_length] = 1;  //�������ĳ�������Ϣ�洢���ܵĴ洢����
                    end
                    else
                    decode_complete = 0;
                    
                    index = index + 3; 
                end
                else if(Y_led[index] && ~Y_led[index+1]) //10
                begin
                    if(codes_length < 5)  //�Ϸ�ʱ
                    begin
                        codes_length = codes_length + 1;
                        characters_code[5 * (cnt_character + 1) - codes_length] = 0;   //�������ĳ�������Ϣ�洢���ܵĴ洢����
                    end
                    else
                    decode_complete = 0;
                    
                    index = index + 2;
                end
                else  //0
                    index = index + 1;
            end
            end
            
            //////�ж��Ƿ��ܽ���  /////�����ܽ���ʱ,���ѽ�����ַ��� - 1���޸�cnt_character_code�����ݼ���

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
            
            ////////ֻ�б���ɹ��Ҳ��ǿհ����� cnt_character �� + 1
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
           ////������ɺ󣬻ָ���ʼ״̬
            index = 0;
            codes_length = 0;
            if(cnt_character == 8)
            error_character = 1; //˵���ַ�������
        end
        else
        error_character = 1;
        
        ////��ջ��������ָ���ʼ״̬
        Y_led = 0;
        cnt_code = 0;
        error_out_of_length = 0;
        
        reg_long_key = 0;
        reg_short_key = 0;
        reg_back_space = 0;
        reg_send = 0;
        reg_reset = 0;
    end
    /////////����
    else if(reg_reset[3])
    begin
        ////��ճ����뻺��������Ϣ
        cnt_code = 0;
        Y_led = 0;
        error_out_of_length = 0;

        ////����߶�����ܵ���Ϣ
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
    
    
    
    //��黺�������������Ƿ�Ҫ����
    if(cnt_code >= 15)
    begin
    cnt_code = 15;
    error_out_of_length = 1;
    end   
    
end







endmodule
