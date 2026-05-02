set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { dig_en[0] }]; #IO_L22P_T3_34 Sch=rpio_02_r
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { dig_en[1] }]; #IO_L22N_T3_34 Sch=rpio_03_r
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { dig_en[2] }]; #IO_L17P_T2_34 Sch=rpio_04_r
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports { dig_en[3] }]; #IO_L17N_T2_34 Sch=rpio_05_r
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports { dig_en[4] }]; #IO_L22P_T3_13 Sch=rpio_06_r
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports { dig_en[5] }]; #IO_L12P_T1_MRCC_34 Sch=rpio_07_r
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports { dig_en[6] }]; #IO_L12N_T1_MRCC_34 Sch=rpio_08_r
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { dig_en[7] }]; #IO_L21N_T3_DQS_13 Sch=rpio_09_r
set_property -dict { PACKAGE_PIN W9    IOSTANDARD LVCMOS33 } [get_ports { seg_en[0] }]; #IO_L15P_T2_DQS_13 Sch=rpio_10_r
set_property -dict { PACKAGE_PIN Y8   IOSTANDARD LVCMOS33 } [get_ports { seg_en[1] }]; #IO_L16P_T2_13 Sch=rpio_11_r
set_property -dict { PACKAGE_PIN W8   IOSTANDARD LVCMOS33 } [get_ports { seg_en[2] }]; #IO_L1N_T0_AD0N_35 Sch=rpio_12_r
set_property -dict { PACKAGE_PIN U18    IOSTANDARD LVCMOS33 } [get_ports { seg_en[3] }]; #IO_L15N_T2_DQS_13 Sch=rpio_13_r
set_property -dict { PACKAGE_PIN Y19    IOSTANDARD LVCMOS33 } [get_ports { seg_en[4] }]; #IO_L22P_T3_13 Sch=rpio_14_r
set_property -dict { PACKAGE_PIN Y16    IOSTANDARD LVCMOS33 } [get_ports { seg_en[5] }]; #IO_L13N_T2_MRCC_13 Sch=rpio_15_r
set_property -dict { PACKAGE_PIN W10   IOSTANDARD LVCMOS33 } [get_ports { seg_en[6] }]; #IO_L2P_T0_AD8P_35 Sch=rpio_16_r

set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { serial_data }]; #IO_L22P_T3_34 Sch=rpio_02_r

set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk\

set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { srst }]; #IO_L4P_T0_35 Sch=btn[0]
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { reg_select }]; #IO_L4N_T0_35 Sch=btn[1]
set_property -dict { PACKAGE_PIN L20   IOSTANDARD LVCMOS33 } [get_ports { uart_over }]; #IO_L9N_T1_DQS_AD3N_35 Sch=btn[2]

set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { leds[0] }]; #IO_L6N_T0_VREF_34 Sch=led[0]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }]; #IO_L6P_T0_34 Sch=led[1]
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { leds[2] }]; #IO_L21N_T3_DQS_AD14N_35 Sch=led[2]
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { leds[3] }]; #IO_L23P_T3_35 Sch=led[3]