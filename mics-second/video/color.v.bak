module color(
    input Clk, 
    input Reset, 
    input [9:0] Hcount, 
    input [8:0] Vcount, 
    output [7:0] Red, 
    output [7:0] Green, 
    output [7:0] Blue,
    input Btnl,
    input Btnr
);

    reg [127:0] map;      // 表示用マップ（背景 + 動くブロック）
    reg [6:0] block_pos;  // 動くブロックの位置（1次元）
    reg [3:0] block_dir;  // 動くブロックの方向制御（1: 左, 2: 右）
    reg [23:0] delay_cnt; // 一定間隔のカウント
    reg move_enable;      // ブロック移動の許可フラグ

    wire [6:0] pos;       // 現在の位置
    wire [127:0] cage;    // 背景（かご状の形）

    // 背景データ（かご状の形）
	assign cage = 128'b1111111111111111 |
				(128'b1000000000000001 << 16) |
				(128'b1000000000000001 << 32) |
				(128'b1000000000000001 << 48) |
				(128'b1000000000000001 << 64) |
				(128'b1000000000000001 << 80) |
				(128'b1000000000000001 << 96) |
				(128'b1111111111111111 << 112);

    // 現在のピクセル位置を計算
    assign pos = {Vcount[8:6], Hcount[9:6]};

    // ブロック移動の一定間隔のカウント
    always @(posedge Clk) begin
        if (Reset) begin
            delay_cnt <= 0;
            move_enable <= 0;
        end else if (delay_cnt == 24'd1000000) begin // 任意の間隔
            delay_cnt <= 0;
            move_enable <= 1;
        end else begin
            delay_cnt <= delay_cnt + 1;
            move_enable <= 0;
        end
    end

    // 動くブロックの制御
    always @(posedge Clk) begin
        if (Reset) begin
            block_pos <= 7'd65;  // 初期位置（中央付近）
            block_dir <= 0;      // 停止状態
        end else begin
            // ボタン入力で方向を決定
            if (Btnl && !Btnr) block_dir <= 1;  // 左移動
            else if (Btnr && !Btnl) block_dir <= 2;  // 右移動
            else block_dir <= 0;  // 停止

            // 一定間隔で移動
            if (move_enable) begin
                if (block_dir == 1 && block_pos > 7'd16) begin
                    // 左移動 (左端で止まる)
                    block_pos <= block_pos - 1;
                end else if (block_dir == 2 && block_pos < 7'd111) begin
                    // 右移動 (右端で止まる)
                    block_pos <= block_pos + 1;
                end
            end
        end
    end

    // 背景 + 動くブロックを統合
    always @(posedge Clk) begin
        map <= cage | (1 << block_pos); // 背景とかご状ブロックをOR結合
    end

    // RGB信号生成
    assign Red = map[pos] == 1 ? 255 : 0;
    assign Green = map[pos] == 1 ? 255 : 0;
    assign Blue = map[pos] == 1 ? 255 : 0;

endmodule
