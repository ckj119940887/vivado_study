set origin_dir "/home/ckj/git_dir/vivado_study"
set proj_name proj1
set design_name system

#创建项目
create_project $proj_name -force $origin_dir -part xc7z020clg484-1
#set_property BOARD_PART em.avnet.com:zynq:zed:c [current_project]
#此处的BOARD_PART属性，可以随意建立一个带zynq的项目，在ps7_bd.tcl中就能看到
set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

#创建block design
create_bd_design $design_name
current_bd_design $design_name
#validate_bd_design

#source ./ps7_bd.tcl

#create interface port
set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

#create instance: processing_system7_0
set ip_version [get_ipdefs -filter {NAME == processing_system7}]
set processing_system7_0 [ create_bd_cell -type ip -vlnv $ip_version processing_system7_0 ]
set_property -dict [ list CONFIG.PCW_EN_CLK0_PORT {0} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {0} CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USE_M_AXI_GP0 {0} CONFIG.preset {ZedBoard}  ] $processing_system7_0

# Create interface connections
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]

set_property top $design_name [current_fileset]

update_compile_order

#保存block design
save_bd_design

#generate_target all [get_files $origin_dir/${proj_name}.srcs/sources_1/bd/system/$design_name.bd]

#write_mem_info $origin_dir/${proj_name}.runs/impl_1/$design_name.mmi 

#synthnize
launch_runs synth_1
wait_on_run synth_1

#generate bit stream
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1


# preparing for launch SDK
set bit_filename [lindex [glob -dir "$origin_dir/${proj_name}.runs/impl_1" *.bit] 0]
set bit_filename_only [lindex [split $bit_filename /] end]
set top_module_name [lindex [split $bit_filename_only .] 0]
set export_dir "$origin_dir/$proj_name.sdk"
file mkdir $export_dir

make_wrapper -files [get_files $origin_dir/${proj_name}.srcs/sources_1/bd/system/$top_module_name.bd] -top

write_hwdef -force -file $origin_dir/${proj_name}.runs/impl_1/$top_module_name.hdf

write_sysdef -force \
  -hwdef "$origin_dir/${proj_name}.runs/impl_1/$top_module_name.hdf" \
  -bitfile "$origin_dir/${proj_name}.runs/impl_1/$top_module_name.bit" \
  -meminfo "$origin_dir/${proj_name}.runs/impl_1/$top_module_name.mmi" \
  -file $export_dir/$top_module_name.sysdef

