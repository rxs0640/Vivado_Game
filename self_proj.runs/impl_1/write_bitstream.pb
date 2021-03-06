
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-349h px� 
x
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
Rule violation (%s) %s - %s
20*drc2
CFGBVS-12default:default2G
3Missing CFGBVS and CONFIG_VOLTAGE Design Properties2default:default2�
�Neither the CFGBVS nor CONFIG_VOLTAGE voltage property is set in the current_design.  Configuration bank voltage select (CFGBVS) must be set to VCCO or GND, and CONFIG_VOLTAGE must be set to the correct configuration voltage, in order to determine the I/O voltage support for the pins in bank 0.  It is suggested to specify these either using the 'Edit Device Properties' function in the GUI or directly in the XDC file using the following syntax:

 set_property CFGBVS value1 [current_design]
 #where value1 is either VCCO or GND

 set_property CONFIG_VOLTAGE value2 [current_design]
 #where value2 is the voltage provided to configuration bank 0

Refer to the device configuration user guide for more information.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net ps2_unit/f0flag_reg[0]_0 is a gated clock net sourced by a combinational pin ps2_unit/prev_out[7]_i_2/O, cell ps2_unit/prev_out[7]_i_2. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/an_unit/s4u/spikeu_rom_addr3_out[4] is a gated clock net sourced by a combinational pin vsync_unit/g0_b6_i_1/O, cell vsync_unit/g0_b6_i_1. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_1 is a gated clock net sourced by a combinational pin vsync_unit/spikeu_rom_data_reg[5]_i_1/O, cell vsync_unit/spikeu_rom_data_reg[5]_i_1. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_15[0] is a gated clock net sourced by a combinational pin vsync_unit/spiked_rom_data_reg[5]_i_1/O, cell vsync_unit/spiked_rom_data_reg[5]_i_1. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_21[0] is a gated clock net sourced by a combinational pin vsync_unit/spikel_rom_data_reg[12]_i_2/O, cell vsync_unit/spikel_rom_data_reg[12]_i_2. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_29[0] is a gated clock net sourced by a combinational pin vsync_unit/spiker_rom_data_reg[9]_i_2__1/O, cell vsync_unit/spiker_rom_data_reg[9]_i_2__1. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_3 is a gated clock net sourced by a combinational pin vsync_unit/spikel_rom_data_reg[12]_i_1__4/O, cell vsync_unit/spikel_rom_data_reg[12]_i_1__4. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_30 is a gated clock net sourced by a combinational pin vsync_unit/spikel_rom_data_reg[11]_i_1__0/O, cell vsync_unit/spikel_rom_data_reg[11]_i_1__0. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_35[0] is a gated clock net sourced by a combinational pin vsync_unit/spiker_rom_data_reg[9]_i_2/O, cell vsync_unit/spiker_rom_data_reg[9]_i_2. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_36[0] is a gated clock net sourced by a combinational pin vsync_unit/spiked_rom_data_reg[5]_i_1__0/O, cell vsync_unit/spiked_rom_data_reg[5]_i_1__0. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_39[0] is a gated clock net sourced by a combinational pin vsync_unit/spiker_rom_data_reg[9]_i_2__0/O, cell vsync_unit/spiker_rom_data_reg[9]_i_2__0. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_40[0] is a gated clock net sourced by a combinational pin vsync_unit/spikel_rom_data_reg[12]_i_1__0/O, cell vsync_unit/spikel_rom_data_reg[12]_i_1__0. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_51 is a gated clock net sourced by a combinational pin vsync_unit/spiked_rom_data_reg[1]_i_1/O, cell vsync_unit/spiked_rom_data_reg[1]_i_1. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_55 is a gated clock net sourced by a combinational pin vsync_unit/g0_b2__8_i_2/O, cell vsync_unit/g0_b2__8_i_2. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_6 is a gated clock net sourced by a combinational pin vsync_unit/g0_b6__3_i_1/O, cell vsync_unit/g0_b6__3_i_1. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PDRC-1532default:default2%
Gated clock check2default:default2�
�Net vsync_unit/rgb_reg_reg[10]_9 is a gated clock net sourced by a combinational pin vsync_unit/spikel_rom_data_reg[12]_i_2__0/O, cell vsync_unit/spikel_rom_data_reg[12]_i_2__0. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.2default:defaultZ23-20h px� 
�
Rule violation (%s) %s - %s
20*drc2
PLHOLDVIO-22default:default2O
;Non-Optimal connections which could lead to hold violations2default:default2�
�A LUT ps2_unit/prev_out[7]_i_2 is driving clock pin of 13 cells. This could lead to large hold time violations. First few involved cells are:
    btn_reg[0] {FDCE}
    btn_reg[1] {FDCE}
    btn_reg[2] {FDCE}
    btn_reg[3] {FDCE}
    f0flag_reg[0] {FDCE}
2default:defaultZ23-20h px� 
g
DRC finished with %s
1905*	planAhead2)
0 Errors, 18 Warnings2default:defaultZ12-3199h px� 
i
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px� 
i
)Running write_bitstream with %s threads.
1750*designutils2
22default:defaultZ20-2272h px� 
?
Loading data files...
1271*designutilsZ12-1165h px� 
>
Loading site data...
1273*designutilsZ12-1167h px� 
?
Loading route data...
1272*designutilsZ12-1166h px� 
?
Processing options...
1362*designutilsZ12-1514h px� 
<
Creating bitmap...
1249*designutilsZ12-1141h px� 
7
Creating bitstream...
7*	bitstreamZ40-7h px� 
_
Writing bitstream %s...
11*	bitstream2"
./self_top.bit2default:defaultZ40-11h px� 
F
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px� 
�
�WebTalk data collection is mandatory when using a WebPACK part without a full Vivado license. To see the specific WebTalk data collected for your design, open the usage_statistics_webtalk.html or usage_statistics_webtalk.xml file in the implementation directory.
120*projectZ1-120h px� 
�
�'%s' has been successfully sent to Xilinx on %s. For additional details about this file, please refer to the Webtalk help file at %s.
186*common2y
eC:/Users/Roger/Documents/Homework/ECE415/self_proj/self_proj.runs/impl_1/usage_statistics_webtalk.xml2default:default2,
Tue Nov 29 15:09:45 20162default:default2I
5C:/Xilinx/Vivado/2016.2/doc/webtalk_introduction.html2default:defaultZ17-186h px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:00:172default:default2
00:00:162default:default2
1480.9532default:default2
358.4022default:defaultZ17-268h px� 
e
Unable to parse hwdef file %s162*	vivadotcl2"
self_top.hwdef2default:defaultZ4-395h px� 


End Record