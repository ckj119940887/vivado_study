# 文件说明

    hw_generate.tcl:使用vivado tcl command来建立FPGA硬件项目
    sw_generate.tcl:使用xsct tcl command来建立SDK项目，其中包含了生成fsbl.elf和hello.elf
    output.bif:用来生成BOOT.bin

# tcl脚本执行

    ./vivado -mode batch -source /home/ckj/git_dir/vivado_study/hw_generate.tcl
    ./xsct /home/ckj/git_dir/vivado_study/sw_generate.tcl

    其中vivado在/opt/Xilinx_2017/Vivado/2017.4/bin
    其中xsct在/opt/Xilinx_2017/SDK/2017.4/bin
    当然也可以直接通过配置环境变量

# 在执行脚本前的注意事项

    需要修改hw_generate.tcl和sw_generate.tcl中的origin_dir为项目的地址
    同时还要修改output.bif中的地址
