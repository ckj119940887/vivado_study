set origin_dir "/home/ckj/git_dir/vivado_study"
set proj_name proj1
set design_name system

set bit_filename [lindex [glob -dir "$origin_dir/${proj_name}.runs/impl_1" *.bit] 0]
set bit_filename_only [lindex [split $bit_filename /] end]
set top_module_name [lindex [split $bit_filename_only .] 0]
set export_dir "$origin_dir/$proj_name.sdk"
file mkdir $export_dir

# set the current workspace
setws $origin_dir/${proj_name}.sdk 

createhw -name ${design_name}_wrapper_hw_platform_0 -hwspec $origin_dir/${proj_name}.runs/impl_1/${design_name}.hdf 

# open hardware design
#openhw $origin_dir/${proj_name}.runs/impl_1/${design_name}.hdf 

# create app for fsbl and hello
createapp -name fsbl -app {Zynq FSBL} -proc ps7_cortexa9_0 -hwproject ${design_name}_wrapper_hw_platform_0 -os standalone
createapp -name hello -app {Hello World} -proc ps7_cortexa9_0 -hwproject ${design_name}_wrapper_hw_platform_0 -os standalone
#createapp -name fsbl -app {Zynq FSBL} -proc ps7_cortexa9_0 -hwproject ${hw_design_name} -os standalone
#createapp -name hello -app {Hello World} -proc ps7_cortexa9_0 -hwproject ${hw_design_name} -os standalone

# build all project
projects -build -type all

# generate BOOT.bin
exec bootgen -arch zynq -image $origin_dir/output.bif -w -o $origin_dir/BOOT.bin

exit
