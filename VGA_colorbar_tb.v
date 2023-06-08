`timescale 1ns/1ns	//定义时间刻度
module VGA_colorbar_tb();
reg sys_clk;			
reg sys_rst_n;
		
wire hsync ; 		//输出行同步信号
wire vsync ; 		//输出场同步信号
wire [23:0] rgb; 	//输出像素信息
wire vga_clk ; 	//VGA工作时钟,频率25MHz
wire VGA_BLANK_N;
wire VGA_SYNC_N;


VGA_colorbar VGA_colorbar_new(
.sys_clk(sys_clk),			
.sys_rst_n(sys_rst_n),
		
.hsync(hsync) , 
.vsync(vsync) , 		
.rgb(rgb),
.vga_clk(vga_clk) , 	//VGA工作时钟,频率25MHz
.VGA_BLANK_N(VGA_BLANK_N),
.VGA_SYNC_N(VGA_SYNC_N)	
);

 initial begin
 sys_clk = 1'b1;
 sys_rst_n = 1'b0;
 #200
 sys_rst_n <= 1'b1;
 end

always begin
	#10	sys_clk=~sys_clk;	//时钟20ns,50M
end


endmodule