module seg7( clk,rst,sel,seg);
input clk; //时钟信号
input rst; //复位信号
    output reg[2:0] sel; //数码管位选端口不用这样
output reg[7:0] seg; //数码管段选端口
reg[3:0] num; //显示的数字或字母的输出端口
reg[31:0] counter_5kHz; //计数器 1，控制扫描频率为 5kHz
reg[31:0] counter_1Hz; //计数器 2，控制所要显示的数据 1s 更新一次
reg[2:0] pos; //数码管位选控制信号
always@(posedge clk or negedge rst)
begin
    if(!rst) //复位键按下，初始化
        begin
            seg<=8'b0000_0000;
            sel<=0;
            counter_1Hz<=0;
            counter_5kHz<=0;
            num<=0;
            pos<=0;
        end
    else if(counter_1Hz<5000000)
        begin
             //显示数据刷新控制
                                    //未达到计数值，数据保持且计数器加一
                begin
                    counter_1Hz<=counter_1Hz+1;
                end
            
            else //达到计数值，数据刷新且计数器清零    ?????
                begin
                    num<=num+1;
                    counter_1Hz<=0;
                end
case(num) //判断数据值，将对应数码管显示编码赋给段选端口
4'b0000: seg<=~(8'b0011_1111);
4'b0001: seg<=~(8'b0000_0110);
4'b0010: seg<=~(8'b0101_1011);
4'b0011: seg<=~(8'b0100_1111);
4'b0100: seg<=~(8'b0110_0110);
4'b0101: seg<=~(8'b0110_1101);
4'b0110: seg<=~(8'b0111_1101);
4'b0111: seg<=~(8'b0000_0111);
4'b1000: seg<=~(8'b0111_1111);
4'b1001: seg<=~(8'b0110_1111);
4'b1010: seg<=~(8'b0111_0111);
4'b1011: seg<=~(8'b0111_1100);
4'b1100: seg<=~(8'b0011_1001);
4'b1101: seg<=~(8'b0101_1110);
4'b1110: seg<=~(8'b0111_1001);
4'b1111: seg<=~(8'b0111_0001);
default: seg<=~(8'b0000_0000);
endcase


if(counter_5kHz<1000) //数码管动态扫描，扫描频率 5kHz
//未达到计数值，位选控制信号保持且计数器加一
    begin
    counter_5kHz<=counter_5kHz+1;
    end

else //达到计数值，位选控制信号刷新且计数器清零               ?????


begin
pos<=pos+1;
counter_5kHz<=0;
end


case(pos) //判断数码管位选控制信号，将对应位选信号赋给位选端口
0: sel<=3'b0;
1: sel<=3'b1;
2: sel<=2;
3: sel<=3;
4:sel<=4;
5:sel<=5;
default: sel<=0;
endcase
end
end
endmodule
