`timescale 1ns/1ns
module VGA_ctrl_tb();
reg vga_clk ;
reg sys_rst_n ;
reg [15:0] pix_data ;

wire [9:0] pix_x ; 			//输出有效显示区域像素点X轴坐标
wire [9:0] pix_y ; 			//输出有效显示区域像素点Y轴坐标
wire hsync ; 					//输出行同步信号
wire vsync ; 					//输出场同步信号
wire [15:0] rgb ;				//输出像素点色彩信息

 VGA_ctrl VGA_ctrl_new(
 .vga_clk (vga_clk ),			 	//输入工作时钟,频率25MHz,1bit
 .sys_rst_n (sys_rst_n ), 				//输入复位信号,低电平有效,1bit
 .pix_data (pix_data ), 			//输入像素点色彩信息,16bit

 .pix_x (pix_x ), 					//输出VGA有效显示区域像素点X轴坐标,10bit
 .pix_y (pix_y ), 					//输出VGA有效显示区域像素点Y轴坐标,10bit
 .hsync (hsync ), 					//输出行同步信号,1bit
 .vsync (vsync ), 					//输出场同步信号,1bit
 .rgb (rgb ) 							//输出像素点色彩信息,16bit
 );
 

initial begin
 vga_clk = 1'b1;
 sys_rst_n <= 1'b0;
 #200
 sys_rst_n <= 1'b1;
 end

 always #10 vga_clk = ~vga_clk;

 //pix_data:输入像素点色彩信息
 always@(posedge vga_clk or negedge sys_rst_n)
 if(sys_rst_n == 1'b0)
 pix_data <= 16'h0000;
 else
 pix_data <= 16'hffff;

 endmodule