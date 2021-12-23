#           时钟信号
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN Y18 [get_ports clk]

#        欢迎模式开关   
set_property PACKAGE_PIN W9 [get_ports enable]
set_property IOSTANDARD LVCMOS33 [get_ports enable]

#       解码模式，编码模式 切换开关
set_property PACKAGE_PIN Y9 [get_ports EN]
set_property IOSTANDARD LVCMOS33 [get_ports EN]

#       解码模式，编码模式 提示灯
set_property IOSTANDARD LVCMOS33 [get_ports mode]
set_property PACKAGE_PIN K17 [get_ports mode]

# ------------------------------------------------------------------------------------

#         解码模式长码输入键
set_property PACKAGE_PIN R1 [get_ports long_key]
set_property IOSTANDARD LVCMOS15 [get_ports long_key]

#         解码模式短码输入键
set_property PACKAGE_PIN P1 [get_ports short_key]
set_property IOSTANDARD LVCMOS15 [get_ports short_key]

#         解码模式退格键
set_property PACKAGE_PIN P2 [get_ports back_space_decoder]
set_property IOSTANDARD LVCMOS15 [get_ports back_space_decoder]

#         解码模式发送键
set_property PACKAGE_PIN P5 [get_ports send_decoder]
set_property IOSTANDARD LVCMOS15 [get_ports send_decoder]

#         解码模式重置键
set_property PACKAGE_PIN P4 [get_ports reset]
set_property IOSTANDARD LVCMOS15 [get_ports reset]


#        解码模式缓冲区长度报错灯
set_property IOSTANDARD LVCMOS33 [get_ports error_out_of_length]
set_property PACKAGE_PIN M13 [get_ports error_out_of_length]

#        解码模式七段数码管字符区长度报错灯
set_property IOSTANDARD LVCMOS33 [get_ports error_character]
set_property PACKAGE_PIN K13 [get_ports error_character]

#        解码模式长短码无法解码报错灯
set_property IOSTANDARD LVCMOS33 [get_ports error_decode]
set_property PACKAGE_PIN N20 [get_ports error_decode]


# ---------------------------------------------------------------------------

#            编码模式重置键
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN P20 [get_ports rst]

#            编码模式退格键
set_property IOSTANDARD LVCMOS33 [get_ports backspace]
set_property PACKAGE_PIN W4 [get_ports backspace]

#            编码模式发送键 & 蜂鸣器播放开关
set_property IOSTANDARD LVCMOS33 [get_ports send]
set_property PACKAGE_PIN R4 [get_ports send]


# -----------------------------------------------------------------------------

#               蜂鸣器
set_property IOSTANDARD LVCMOS33 [get_ports beep]
set_property PACKAGE_PIN A19 [get_ports beep]

#              蜂鸣器播放歌曲开关
set_property IOSTANDARD LVCMOS33 [get_ports enMarry]
set_property PACKAGE_PIN U5 [get_ports enMarry]

#              蜂鸣器0.5倍速播放开关
set_property IOSTANDARD LVCMOS33 [get_ports speedslow]
set_property PACKAGE_PIN T4 [get_ports speedslow]

#              蜂鸣器2倍速播放开关
set_property IOSTANDARD LVCMOS33 [get_ports speedquick]
set_property PACKAGE_PIN T5 [get_ports speedquick]


# -----------------------------------------------------------------------------

#            LED灯显示模块限制文件
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

#         七段数码管显示模块
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

#            矩阵键盘模块
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


