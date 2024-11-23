#!/bin/bash

# ロケールを強制的に C に設定
export LC_NUMERIC=C

# データサイズの入力
read -p "データサイズ (GB) を入力してください: " data_size

# 平均転送時間データ
time_10GB=92.0
time_100GB=922.7
size_range=90
increase_per_gb=$(echo "scale=4; ($time_100GB - $time_10GB) / $size_range" | bc)

# 予測転送時間の計算
predicted_time=$(echo "scale=4; $time_10GB + ($data_size - 10) * $increase_per_gb" | bc)

# 許容転送時間の計算
allowable_time=$(echo "scale=4; $predicted_time * 1.38" | bc)

# 結果を表示
printf "予測転送時間: %.2f秒\n" "$predicted_time"
printf "許容転送時間: %.2f秒\n" "$allowable_time"

# データサイズ、予測転送時間、許容転送時間を出力
echo "データサイズ: $data_size GB"
echo "予測転送時間: $predicted_time 秒"
echo "許容転送時間: $allowable_time 秒"
