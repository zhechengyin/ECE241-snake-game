module game_tick #(
    parameter INPUT_CLK_FREQ = 50_000_000,  // 输入时钟频率 (Hz)
    parameter TICK_FREQ      = 2            // 输出 tick 频率 (Hz)
)(
    input  wire clk,        // 系统时钟 (CLOCK_50)
    input  wire resetn,     // 低电平复位
    output reg  tick        // 每次高电平持续 1 个 clk 周期
);

    // 每个 tick 周期需要计数的时钟周期数
    localparam integer PERIOD_COUNT = INPUT_CLK_FREQ / TICK_FREQ;

    // 计数器位宽 = ceil(log2(PERIOD_COUNT))
    reg [$clog2(PERIOD_COUNT)-1:0] counter;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 0;
            tick    <= 1'b0;
        end else begin
            // 默认 tick 为低
            tick <= 1'b0;

            if (counter == PERIOD_COUNT - 1) begin
                counter <= 0;
                tick    <= 1'b1; // 产生一个时钟周期的脉冲
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
