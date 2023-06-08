module VGA_pic(
input wire vga_clk , 		//输入工作时钟,频率25MHz
input wire sys_rst_n , 		//输入复位信号,低电平有效
input wire [9:0] pix_x , 	//输入有效显示区域像素点X轴坐标
input wire [9:0] pix_y , 	//输入有效显示区域像素点Y轴坐标
input	wire [3:0] key_out,
output reg [23:0] pix_data//输出像素点色彩信息
);

//parameter define
parameter H_VALID = 10'd640 , 	//行有效数据
V_VALID = 10'd480 ; 				//场有效数据

parameter RED = 24'hFF0000, 	//红色
ORANGE = 24'hFC000, 			//橙色
YELLOW = 24'hFFFF00, 			//黄色
GREEN = 24'h00FF00, 			//绿色
CYAN = 24'h00FFFF, 				//青色
BLUE = 24'h0000FF, 				//蓝色
PURPPLE = 24'hFF00FF, 			//紫色
BLACK = 24'h000000, 			//黑色
WHITE = 24'hFFFFFF, 			//白色
GRAY = 24'h35141A;				//灰色

    parameter h_begin = 100;
    parameter v_begin = 300;
    parameter h_diff = 100;
    parameter v_diff = 240;
    parameter h_lose = 256;
    parameter v_lose = 224;
    parameter h_start = 240;
    parameter v_start = 134;
    parameter pass_diff = 200;
    parameter length = 20;
	 parameter	vidon = 1;

    reg [0:25] cnt_js = 0;
    reg [0:23] speed;
    reg [99:0] h_all = 0;
    reg [99:0] v_all = 0;
    reg [2:0] state = 0;
    reg [3:0] num = 4'd4;
    reg [4:0] rand_x,rand_y;
    reg [9:0] food_x = 10'd300;
    reg [9:0] food_y = 10'd200;
    reg [7:0] rom_pix;
    reg [3:0] color = 0;
    reg [1:0] pos;
    reg [1:0] diff;
    reg [1:0] cs = 0;
    reg eat = 0;
    reg DIR = 0;
    reg foodflag = 1;
    reg isbody = 0;
    reg isfood = 0;
    reg ishit = 0;
    reg ishit1 = 0;
    reg isword = 0;

    
    always @(*) begin   //判断当前刷新像素位置是否为蛇身或者难度色块，其中判断里的num大于几非常重要
    if((pix_x >= h_diff)&&(pix_x <h_diff + length)&&(pix_y >= v_diff)&&(pix_y < v_diff + length)&&(state == 0))
        begin isbody <= 1; color <= 1; end
    else if((pix_x >= h_diff + pass_diff)&&(pix_x < h_diff + pass_diff + length)&&(pix_y >= v_diff)&&(pix_y < v_diff + length)&&(state == 0))
        begin isbody <= 1; color <= 2; end
    else if((pix_x >= h_diff + pass_diff*2)&&(pix_x < h_diff + pass_diff*2 + length)&&(pix_y >= v_diff)&&(pix_y < v_diff + length)&&(state == 0))
        begin isbody <= 1; color <= 3; end
    else if((pix_x >= h_all[9:0] )&&(pix_x < h_all[9:0] + length)&&(pix_y >= v_all[9:0])&&(pix_y < v_all[9:0] + length)&&(state != 0))
        begin isbody <= 1; color <= 3; end
    else if((pix_x >= h_all[19:10])&&(pix_x < h_all[19:10] +length)&&(pix_y >= v_all[19:10])&&(pix_y < v_all[19:10] + length)&&(num >= 2)&&(state != 0))
        begin isbody <= 1; color <= 1; end
    else if((pix_x >= h_all[29:20])&&(pix_x < h_all[29:20] + length)&&(pix_y >= v_all[29:20])&&(pix_y < v_all[29:20] + length)&&(num >= 3)&&(state != 0))
        begin isbody <= 1; color <= 5; end
    else if((pix_x >= h_all[39:30])&&(pix_x < h_all[39:30] + length)&&(pix_y >= v_all[39:30])&&(pix_y < v_all[39:30] + length)&&(num >= 4)&&(state != 0))
        begin isbody <= 1; color <= 1; end
    else if((pix_x >= h_all[49:40])&&(pix_x < h_all[49:40] + length)&&(pix_y >= v_all[49:40])&&(pix_y < v_all[49:40] + length)&&(num >= 5)&&(state != 0))
        begin isbody <= 1; color <= 5; end
    else if((pix_x >= h_all[59:50])&&(pix_x < h_all[59:50] + length)&&(pix_y >= v_all[59:50])&&(pix_y < v_all[59:50] + length)&&(num >= 6)&&(state != 0))
        begin isbody <= 1; color <= 1; end
    else if((pix_x >= h_all[69:60])&&(pix_x < h_all[69:60] + length)&&(pix_y >= v_all[69:60])&&(pix_y < v_all[69:60] + length)&&(num >= 7)&&(state != 0))
        begin isbody <= 1; color <= 5; end
    else if((pix_x >= h_all[79:70])&&(pix_x < h_all[79:70] + length)&&(pix_y >= v_all[79:70])&&(pix_y < v_all[79:70] + length)&&(num >= 8)&&(state != 0))
        begin isbody <= 1; color <= 1; end
    else if((pix_x >= h_all[89:80])&&(pix_x < h_all[89:80] + length)&&(pix_y >= v_all[89:80])&&(pix_y < v_all[89:80] + length)&&(num >= 9)&&(state != 0))
        begin isbody <= 1; color <= 5; end
    else if((pix_x >= h_all[99:90])&&(pix_x < h_all[99:90] + length)&&(pix_y >= v_all[99:90])&&(pix_y < v_all[99:90] + length)&&(num >= 10)&&(state != 0))
        begin isbody <= 1; color <= 1; end
    else
    begin
        isbody <= 0;
        color <= color;
    end
    end
    //判断蛇是否撞到了下和右墙或者身体，其中判断里的num大于几非常重要
    always @(*) begin
    if((h_all[9:0] == h_all[19:10])&&(v_all[9:0] == v_all[19:10])&&(state == 2)&&(num >= 2))
        ishit <= 1;
    else if((h_all[9:0] == h_all[29:20])&&(v_all[9:0] == v_all[29:20])&&(state == 2)&&(num >= 3))
        ishit <= 1;
    else if((h_all[9:0] == h_all[39:30])&&(v_all[9:0] == v_all[39:30])&&(state == 2)&&(num >= 4))
        ishit <= 1;
    else if((h_all[9:0] == h_all[49:40])&&(v_all[9:0] == v_all[49:40])&&(state == 2)&&(num >= 5))
        ishit <= 1;
    else if((h_all[9:0] == h_all[59:50])&&(v_all[9:0] == v_all[59:50])&&(state == 2)&&(num >= 6))
        ishit <= 1;
    else if((h_all[9:0] == h_all[69:60])&&(v_all[9:0] == v_all[69:60])&&(state == 2)&&(num >= 7))
        ishit <= 1;
    else if((h_all[9:0] == h_all[79:70])&&(v_all[9:0] == v_all[79:70])&&(state == 2)&&(num >= 8))
        ishit <= 1;
    else if((h_all[9:0] == h_all[89:80])&&(v_all[9:0] == v_all[89:80])&&(state == 2)&&(num >= 9))
        ishit <= 1;
    else if((h_all[9:0] == h_all[99:90])&&(v_all[9:0] == v_all[99:90])&&(state == 2)&&(num >= 10))
        ishit <= 1;
    else if((h_all[9:0] > 630)||(v_all[9:0] > 470))
        ishit <= 1;
    else
        ishit <= 0;    
    end

    always @(posedge vga_clk) begin   //消除吃一个长两格的bug模块
    if((food_x == h_all[9:0]) && (food_y == v_all[9:0])&&(state == 2))
        cs <= cs + 1;
    else if(cs == 2)
        cs <= 0;
    else
        cs <= cs;
    end
    //方向控制模块
    always @(posedge vga_clk) begin
    if(!sys_rst_n || state == 1)
        pos <= 0;   //游戏初始化或复位置为0，即向左
    else if(state != 0)
        case(key_out)
            3'd1: begin
                if(pos == 1)   //如果此时方向向下，不执行
                    pos <= pos;
                else 
                    pos <= 3;   //上
                end
            3'd2: begin
                if(pos == 3)   //如果此时方向向上，不执行
                    pos <= pos;
                else 
                    pos <= 1;   //下
                end
            3'd3: begin
                if(pos == 0)   //如果此时方向向左，不执行
                    pos <= pos;
                else
                    pos <= 2;   //右
                end
            3'd4: begin
                if(pos == 2)   //如果此时方向向右，不执行
                    pos <= pos;
                else
                    pos <= 0;   //左
                end
            default: pos <= pos;
        endcase
    else
        pos <= pos;   
    end

    always @(posedge vga_clk) begin
    if((vidon == 1)&&(state == 2))   //只有状态为2才会计时
    begin
        if(cnt_js == speed)   //计数到速度的数值
        begin
            DIR <= 1;    //产生上升沿控制蛇身刷新
            cnt_js <= 0;
        end
        else
        begin
            DIR <= 0;
            cnt_js <= cnt_js + 1; 
        end
    end
    else if(state == 0)
        cnt_js <= 0;
    else
        cnt_js <= cnt_js;   //这里很重要，不要将这些改写为cnt_js <= 0
    end


    always@(posedge vga_clk) begin    //状态逻辑转化模块
    if(!sys_rst_n)   //复位将状态置零
        state <= 0;
    else if(state == 0)
    begin
        case (key_out)  //根据开发板上的按键选择对应的难度
            3'd1 : begin diff <= 2; state <= 1; end   //困难
            3'd2 : begin diff <= 1; state <= 1; end   //中等
            3'd3 : begin diff <= 0; state <= 1; end   //简单
            default: state <= 0;
        endcase
    end
    else if(state == 1)
    begin
        state <= 2;
        case (diff)   //根据难度去设置相应的速度
            2'd0 : speed <= 24'd15000000;
            2'd1 : speed <= 24'd10000000;
            2'd2 : speed <= 24'd5000000;
            default: speed <= 24'd15000000;
        endcase        
    end
    else if(state == 3 && key_out == 5)   //在状态3下按S2可以进行新一局的游戏
        state <= 0;
    else if(ishit == 1 || ishit1 == 1)   //如果小蛇死亡，进入状态3，即游戏结束状态
        state <= 3;
    else if(state == 2 && key_out == 5)  //如果处于游戏运行状态，按下S2可以暂停游戏
        state <= 4;
    else if(state <= 4 && key_out == 5)  //如果处于游戏暂停状态，按下S2可以再开始游戏
        state <= 2;
    else
        state <= state;   //其他条件下state不变
    end

    always @(posedge vga_clk) begin    //蛇身刷新模块
    if(!sys_rst_n || state == 1)    //复位或游戏初始化进行身体的刷新，初始长度为4
    begin
        h_all[9:0] <= h_begin + length * 3;
        h_all[19:10] <= h_begin + length * 2;
        h_all[29:20] <= h_begin + length;
        h_all[39:30] <= h_begin;
        h_all[99:40] <= 60'd0;
        v_all[39:30] <= v_begin;
        v_all[29:20] <= v_begin;
        v_all[19:10] <= v_begin;
        v_all[9:0] <= v_begin;
        v_all[99:40] <= 60'd0;
    end
    else if(cs == 2)   //吃到食物后
    begin
        case (pos)   //由于num的变化要相对滞后些，这里是将下一刻要展示的色块等于相邻色块的坐标
            2'd0: begin
                h_all[(num*10+9)-:10] <= h_all[(10*num-1)-:10] - length;   //往运动的方向进行刷新
                v_all[(num*10+9)-:10] <= v_all[(10*num-1)-:10];
            end
            2'd1: begin
                h_all[(num*10+9)-:10] <= h_all[(10*num-1)-:10];
                v_all[(num*10+9)-:10] <= v_all[(10*num-1)-:10] - length;
            end
            2'd2: begin
                h_all[(num*10+9)-:10] <= h_all[(10*num-1)-:10] + length;
                v_all[(num*10+9)-:10] <= v_all[(10*num-1)-:10];
            end
            2'd3: begin
                h_all[(num*10+9)-:10] <= h_all[(10*num-1)-:10];
                v_all[(num*10+9)-:10] <= v_all[(10*num-1)-:10] + length;
            end
        endcase      
    end
    else if(DIR == 1)   //DIR上升沿，开始身体的刷新
    begin
        if(num >= 10)   //首先根据num的值来决定刷新多少色块
        begin
            h_all[99:90] = h_all[89:80];
            v_all[99:90] = v_all[89:80];
        end
        if(num >= 9)
        begin
            h_all[89:80] = h_all[79:70];
            v_all[89:80] = v_all[79:70];
        end
        if(num >= 8)
        begin
            h_all[79:70] = h_all[69:60];
            v_all[79:70] = v_all[69:60];
        end
        if(num >= 7)
        begin
            h_all[69:60] = h_all[59:50];
            v_all[69:60] = v_all[59:50];
        end
        if(num >= 6)
        begin
            h_all[59:50] = h_all[49:40];
            v_all[59:50] = v_all[49:40];
        end
        if(num >= 5)
        begin
            h_all[49:40] = h_all[39:30];
            v_all[49:40] = v_all[39:30];
        end
        if(num >= 4)
        begin
            h_all[39:30] = h_all[29:20];
            v_all[39:30] = v_all[29:20];
        end
        if(num >= 3)
        begin
            h_all[29:20] = h_all[19:10];
            v_all[29:20] = v_all[19:10];
        end
        if(num >= 2)
        begin
            h_all[19:10] = h_all[9:0];
            v_all[19:10] = v_all[9:0];
        end
        case(pos)   //根据方向来决定下一时刻蛇头的位置
        2'd0: h_all[9:0] <= h_all[9:0] + length;
        2'd1: v_all[9:0] <= v_all[9:0] + length;
        2'd2: begin
            if(h_all[9:0] == 0)   //如果此时蛇头位于行边缘，且下一刻又往边缘方向继续走
                ishit1 <= 1;   //判定为撞墙
            else
            begin   //其他情况下进行正常身体刷新
                h_all[9:0] <= h_all[9:0] - length;
                ishit1 <= 0;
            end
        end
        2'd3: begin   //同上
            if(v_all[9:0] == 0)
                ishit1 <= 1;
            else
            begin
                v_all[9:0] <= v_all[9:0] - length;
                ishit1 <= 0;
            end
        end
        endcase
    end
    else
    begin
        h_all <= h_all;
        v_all <= v_all;
        ishit1 <= 0;
    end
    end

    always @(*) begin    //判断食物的刷新位置是否和当前小蛇身体重叠，重叠就重新刷新位置
    if((food_x == h_all[9:0]) && (food_y == v_all[9:0])&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[19:10]) && (food_y == v_all[19:10])&&(num >= 2)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[29:20]) && (food_y == v_all[29:20])&&(num >= 3)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[39:30]) && (food_y == v_all[39:30]) && (num >= 4)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[49:40]) && (food_y == v_all[49:40]) && (num >= 5)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[59:50]) && (food_y == v_all[59:50]) && (num >= 6)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[69:60]) && (food_y == v_all[69:60]) && (num >= 7)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[79:70]) && (food_y == v_all[79:70]) && (num >= 8)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[89:80]) && (food_y == v_all[89:80]) && (num >= 9)&&(state == 2))
        eat <= 1;
    else if((food_x == h_all[99:90]) && (food_y == v_all[99:90]) && (num >= 10)&&(state == 2))
        eat <= 1;
    else
        eat <= 0; 
    end
    
    always @(posedge vga_clk or negedge sys_rst_n) begin   //身体成长模块
    if(!sys_rst_n)   //复位或游戏初始化，身体长度置为4
        num = 4;
	 else	if(state == 1)
		  num = 4;
    else if(cs == 2)   //蛇迟到食物
    begin
        num = num + 1;   //身体长度+1
        if(num == 11)  
            num = 10;   //达到最大长度后，将不变
        else
            num = num;
    end
    else
        num = num;
    end
    //下面为随机数产生模块，原理是利用计数器来一直刷新rand_x和rand_y，当食物要刷新时取当前的rand_x和rand_y值
    //由于我们说不定在哪一个时刻迟到食物，所以就产生了随机的效果
    //x
    always@(posedge vga_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n)
        rand_x <= 0;
    else
        begin
            if (rand_x == 31)
                rand_x <= 0;
            else
                rand_x <= rand_x+1;
        end    
    end
    //y
    always@(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        rand_y <= 0;
    else
        begin
            if (rand_y == 23 && rand_x == 31)
                rand_y <= 0;
            else if (rand_x == 31)
                rand_y <= rand_y+1;
            else
                rand_y <= rand_y;  
        end
    end

    always @(posedge vga_clk) begin   //食物刷新模块
    if(foodflag == 0)   //foodflag为0，表示食物需要进行刷新
    begin
        food_x <= rand_x * length;   //根据rand_x得到食物的行坐标
        food_y <= rand_y * length;   //根据rand_y得到食物的场坐标
        foodflag <= 1;   //刷新完后置1
    end
    else if(eat == 1)   //当食物和身体重叠
        foodflag <= 0;   //置零，表示需要重新刷新食物
    else   //其他情况下保持不变
    begin
        foodflag <= foodflag;
        food_x <= food_x;
        food_y <= food_y;
    end   
    end

    always @(*) begin    //食物像素刷新模块
    if((pix_x >= food_x)&&(pix_x < food_x + length)&&(pix_y >= food_y)&&(pix_y < food_y + length)&&(state != 0))
        isfood = 1;    //判断当前像素是否为食物的部分，是置一，否置零
    else
        isfood = 0;
    end

    always @(*) begin   //图像刷新模块
    pix_data	<=	WHITE;
    if(vidon == 1 && isbody == 1)   //如果此时为身体位置像素
    begin
        case (color)   //根据color值去刷新不同的颜色
            4'd0 : begin   //白色
                pix_data	<=	WHITE; 
            end
            4'd1 : begin   //绿色
                pix_data	<=	GREEN; 
            end
            4'd2 : begin   //蓝色
                pix_data	<=	BLUE; 
            end
            4'd3 : begin   //红色
                pix_data	<=	RED;
				end
				4'd4 : begin   //黑色
                pix_data	<=	BLACK;
				end
				4'd5 : begin   //青色
                pix_data	<=	CYAN;	 
            end
            default: begin
                pix_data	<=	BLACK;
            end
        endcase
    end
    else if(vidon && isfood == 1)   //如果此时为食物位置像素
    begin
        pix_data	<=	GREEN;
    end
end

endmodule