module soundtop(
	input CLK48M,
	input [8:1] SW,
	input [2:1] PSW,
	output [10:1] LED
);
   // Do not modify following lines
   reg SPEAKER;
   reg  CLK24M = 0;
   always @(posedge CLK48M) CLK24M <= ~CLK24M;
	
	// haisen
	wire SPEAKER_DO, SPEAKER_LE, SPEAKER_ME;
	
	// Regarding to LED
   assign LED[ 2] = SPEAKER;
   assign LED[ 5] = SPEAKER;
   assign LED[ 6] = 1;
   assign LED[ 8] = 1;
   assign LED[ 9] = ^SW;
   assign LED[10] = ^PSW;
   
   sounddo sound_do(CLK24M, ~SW[1], PSW, SPEAKER_DO);
	soundle sound_le(CLK24M, ~SW[1], PSW, SPEAKER_LE);
	soundme sound_me(CLK24M, ~SW[1], PSW, SPEAKER_ME);
	
/*
	always @(*) begin
		case (PSW)
			2'b01: SPEAKER = SPEAKER_DO; // PSW1 が押された場合
			2'b10: SPEAKER = SPEAKER_LE; // PSW2 が押された場合
			2'b11: SPEAKER = SPEAKER_ME; // PSW1 と PSW2 が同時に押された場合
			default: SPEAKER = 0;        // 何も押されていない場合
		endcase
	end
*/
	
	reg [25:0] counter = 0;
	reg [1:0] state = 0; // 2ビットの状態（0: ド, 1: レ, 2: ミ）
	
	always @(posedge CLK24M) begin
		if (counter == 24000000 - 1) begin // 1秒が経過
			counter <= 0;
			state <= state + 1; // 状態を進める
		end else begin
			counter <= counter + 1;
		end
	end
	
	always @(*) begin
	  case (state)
			2'b00: SPEAKER = SPEAKER_DO; // ド
			2'b01: SPEAKER = SPEAKER_LE; // レ
			2'b10: SPEAKER = SPEAKER_ME; // ミ
			default: SPEAKER = 0;
	  endcase
	end

endmodule

module delay(
    input CLK,              // クロック信号
    input [31:0] DELAY_MS,  // 遅延時間（ミリ秒）
    output reg delay_done         // 遅延完了信号
);
    // 定数（クロック周波数に基づく）
    localparam CLK_FREQ_HZ = 24_000_000; // 24MHz クロック
    localparam CLK_PER_MS = CLK_FREQ_HZ / 1000; // 1ミリ秒あたりのクロック数

    // カウンタの定義
    reg [31:0] counter = 0;
    reg [31:0] max_count = 0;

    // 遅延動作の実現
    always @(posedge CLK) begin
        if (counter == 0) begin
            max_count <= DELAY_MS * CLK_PER_MS; // 最大カウントを計算
        end
        if (counter < max_count) begin
            counter <= counter + 1; // カウントを増加
            delay_done <= 0;              // 遅延中
        end else begin
            delay_done <= 1;              // 遅延完了
        end
    end
endmodule
