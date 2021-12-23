#           ʱ���ź�
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN Y18 [get_ports clk]

#        ��ӭģʽ����   
set_property PACKAGE_PIN W9 [get_ports enable]
set_property IOSTANDARD LVCMOS33 [get_ports enable]

#       ����ģʽ������ģʽ �л�����
set_property PACKAGE_PIN Y9 [get_ports EN]
set_property IOSTANDARD LVCMOS33 [get_ports EN]

#       ����ģʽ������ģʽ ��ʾ��
set_property IOSTANDARD LVCMOS33 [get_ports mode]
set_property PACKAGE_PIN K17 [get_ports mode]

# ------------------------------------------------------------------------------------

#         ����ģʽ���������
set_property PACKAGE_PIN R1 [get_ports long_key]
set_property IOSTANDARD LVCMOS15 [get_ports long_key]

#         ����ģʽ���������
set_property PACKAGE_PIN P1 [get_ports short_key]
set_property IOSTANDARD LVCMOS15 [get_ports short_key]

#         ����ģʽ�˸��
set_property PACKAGE_PIN P2 [get_ports back_space_decoder]
set_property IOSTANDARD LVCMOS15 [get_ports back_space_decoder]

#         ����ģʽ���ͼ�
set_property PACKAGE_PIN P5 [get_ports send_decoder]
set_property IOSTANDARD LVCMOS15 [get_ports send_decoder]

#         ����ģʽ���ü�
set_property PACKAGE_PIN P4 [get_ports reset]
set_property IOSTANDARD LVCMOS15 [get_ports reset]


#        ����ģʽ���������ȱ����
set_property IOSTANDARD LVCMOS33 [get_ports error_out_of_length]
set_property PACKAGE_PIN M13 [get_ports error_out_of_length]

#        ����ģʽ�߶�������ַ������ȱ����
set_property IOSTANDARD LVCMOS33 [get_ports error_character]
set_property PACKAGE_PIN K13 [get_ports error_character]

#        ����ģʽ�������޷����뱨���
set_property IOSTANDARD LVCMOS33 [get_ports error_decode]
set_property PACKAGE_PIN N20 [get_ports error_decode]


# ---------------------------------------------------------------------------

#            ����ģʽ���ü�
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN P20 [get_ports rst]

#            ����ģʽ�˸��
set_property IOSTANDARD LVCMOS33 [get_ports backspace]
set_property PACKAGE_PIN W4 [get_ports backspace]

#            ����ģʽ���ͼ� & ���������ſ���
set_property IOSTANDARD LVCMOS33 [get_ports send]
set_property PACKAGE_PIN R4 [get_ports send]


# -----------------------------------------------------------------------------

#               ������
set_property IOSTANDARD LVCMOS33 [get_ports beep]
set_property PACKAGE_PIN A19 [get_ports beep]

#              ���������Ÿ�������
set_property IOSTANDARD LVCMOS33 [get_ports enMarry]
set_property PACKAGE_PIN U5 [get_ports enMarry]

#              ������0.5���ٲ��ſ���
set_property IOSTANDARD LVCMOS33 [get_ports speedslow]
set_property PACKAGE_PIN T4 [get_ports speedslow]

#              ������2���ٲ��ſ���
set_property IOSTANDARD LVCMOS33 [get_ports speedquick]
set_property PACKAGE_PIN T5 [get_ports speedquick]


# -----------------------------------------------------------------------------

#            LED����ʾģ�������ļ�
set_property PACKAGE_PIN A21 [get_ports {Y_led[14]}]
set_property PACKAGE_PIN E22 [get_ports {Y_led[13]}]
set_property PACKAGE_PIN D22 [get_ports {Y_led[12]}]
set_property PACKAGE_PIN E21 [get_ports {Y_led[11]}]
set_property PACKAGE_PIN D21 [get_ports {Y_led[10]}]
set_property PACKAGE_PIN G21 [get_ports {Y_led[9]}]
set_property PACKAGE_PIN G22 [get_ports {Y_led[8]}]
set_property PACKAGE_PIN F21 [get_ports {Y_led[7]}]
set_property PACKAGE_PIN J17 [get_ports {Y_led[6]}]
set_property PACKAGE_PIN L14 [get_ports {Y_led[5]}]
set_property PACKAGE_PIN L15 [get_ports {Y_led[4]}]
set_property PACKAGE_PIN L16 [get_ports {Y_led[3]}]
set_property PACKAGE_PIN K16 [get_ports {Y_led[2]}]
set_property PACKAGE_PIN M15 [get_ports {Y_led[1]}]
set_property PACKAGE_PIN M16 [get_ports {Y_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[8]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Y_led[0]}]

# ------------------------------------------------------------------------------

#         �߶��������ʾģ��
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_bit_selection[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_selection[7]}]
set_property PACKAGE_PIN A18 [get_ports {seg_bit_selection[7]}]
set_property PACKAGE_PIN A20 [get_ports {seg_bit_selection[6]}]
set_property PACKAGE_PIN B20 [get_ports {seg_bit_selection[5]}]
set_property PACKAGE_PIN E18 [get_ports {seg_bit_selection[4]}]
set_property PACKAGE_PIN F18 [get_ports {seg_bit_selection[3]}]
set_property PACKAGE_PIN D19 [get_ports {seg_bit_selection[2]}]
set_property PACKAGE_PIN E19 [get_ports {seg_bit_selection[1]}]
set_property PACKAGE_PIN C19 [get_ports {seg_bit_selection[0]}]
set_property PACKAGE_PIN E13 [get_ports {seg_selection[7]}]
set_property PACKAGE_PIN C15 [get_ports {seg_selection[6]}]
set_property PACKAGE_PIN C14 [get_ports {seg_selection[5]}]
set_property PACKAGE_PIN E17 [get_ports {seg_selection[4]}]
set_property PACKAGE_PIN F16 [get_ports {seg_selection[3]}]
set_property PACKAGE_PIN F14 [get_ports {seg_selection[2]}]
set_property PACKAGE_PIN F13 [get_ports {seg_selection[1]}]
set_property PACKAGE_PIN F15 [get_ports {seg_selection[0]}]

# ------------------------------------------------------------------------------

#            �������ģ��
set_property PACKAGE_PIN M2 [get_ports {col[3]}]
set_property PACKAGE_PIN K6 [get_ports {col[2]}]
set_property PACKAGE_PIN J6 [get_ports {col[1]}]
set_property PACKAGE_PIN L5 [get_ports {col[0]}]
set_property PACKAGE_PIN K4 [get_ports {row[3]}]
set_property PACKAGE_PIN J4 [get_ports {row[2]}]
set_property PACKAGE_PIN L3 [get_ports {row[1]}]
set_property PACKAGE_PIN K3 [get_ports {row[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {col[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {col[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {col[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {col[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {row[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {row[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {row[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {row[0]}]


