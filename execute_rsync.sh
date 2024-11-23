#!/bin/bash

# 1. transfer_time.sh を実行
echo "転送時間を計算しています。transfer_time.sh を実行中..."
transfer_result=$(./transfer_time.sh)

# 結果を取得
data_size=$(echo "$transfer_result" | grep "データサイズ" | awk -F':' '{print $2}' | sed 's/[^0-9.]//g')
predicted_time=$(echo "$transfer_result" | grep "予測転送時間" | awk -F':' '{print $2}' | sed 's/[^0-9.]//g')
allowable_time=$(echo "$transfer_result" | grep "許容転送時間" | awk -F':' '{print $2}' | sed 's/[^0-9.]//g')

# 結果を表示
echo "データサイズ: ${data_size}GB"
echo "予測転送時間: ${predicted_time}秒"
echo "許容転送時間: ${allowable_time}秒"

# 必要な転送速度を計算 (KB/s)
if [[ -z "$data_size" || -z "$allowable_time" ]]; then
    echo "エラー: データサイズまたは許容転送時間が取得できませんでした。"
    exit 1
fi

# 転送速度計算 (KB/s)
required_speed_kbps=$(echo "scale=0; ($data_size * 1024 * 1024) / $allowable_time" | bc)

# 必要な転送速度を整数に変換し、不必要な数字を除去
printf -v required_speed_kbps "%.0f" "$required_speed_kbps"

# ここで必要な転送速度のみ表示
echo "必要な転送速度: ${required_speed_kbps} KB/s"

# LIMIT_SPEEDが負にならないように制限
LIMIT_SPEED=$((110000 - $required_speed_kbps))
if [ $LIMIT_SPEED -lt 0 ]; then
    LIMIT_SPEED=0  # 負の値にならないように0に設定
fi

# 2. limit_rsync.sh を実行 (LIMIT_SPEED を引数として渡す)
./limit_rsync.sh "$LIMIT_SPEED"

# rsync コマンドの実行
restorefile="restorefile"  # 転送するファイル名
destination="ishikawa@backup:~/"  # 転送先

# rsync の実行
echo "rsync を実行します: rsync -avhP --bwlimit=${required_speed_kbps} $restorefile $destination"
rsync -avhP --bwlimit="${required_speed_kbps}" "$restorefile" "$destination"

# rsync の結果を確認
if [ $? -eq 0 ]; then
    echo "rsync による転送が正常に完了しました。"
else
    echo "rsync による転送中にエラーが発生しました。"
    exit 1
fi
