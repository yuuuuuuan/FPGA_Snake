module keyin (
    input wire clk,
    input wire [4:0] key,
    output reg [3:0] key_out
);

    parameter xd = 21'd500000;   //20ms

    reg [0:20] cnt_xd = 0;    //消抖计时


    always@(posedge clk) begin    //消抖计时
    if(key == 5'b11111)    //抖动即重新开始
        cnt_xd <= 0;
    else if(cnt_xd == xd)
        cnt_xd <= xd;
    else
        cnt_xd <= cnt_xd + 1;
    end

    always@(posedge clk) begin
    if(cnt_xd == 0)
        key_out <= key_out;
    else if(cnt_xd == (xd - 21'b1))    //产生1个时间单位的按键信号
        case(key)     //根据键入得到对应的值
        5'b01111: key_out <= 4'b0101;    //右
        5'b10111: key_out <= 4'b0100;    //下
        5'b11011: key_out <= 4'b0011;    //左
        5'b11101: key_out <= 4'b0010;    //上
        5'b11110: key_out <= 4'b0001;    //暂停或重新开始游戏
        endcase
    else
       key_out <= key_out;   //0表示无按键按下
    end

endmodule