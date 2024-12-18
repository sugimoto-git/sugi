import wave

# WAVファイルを読み込み
wav_file = wave.open('music.wav', 'r')
frames = wav_file.readframes(wav_file.getnframes())

# サンプルデータをHEXに変換
data = [hex(sample & 0xFF) for sample in frames]

# Verilogコードを生成
with open('music_data.v', 'w') as f:
    f.write('module music_data(output reg [7:0] audio);\n')
    f.write('  always @(posedge clk) begin\n')
    f.write('    case (address)\n')
    for i, sample in enumerate(data):
        f.write(f'      {i}: audio <= 8\'h{sample};\n')
    f.write('    endcase\n')
    f.write('  end\n')
    f.write('endmodule\n')
