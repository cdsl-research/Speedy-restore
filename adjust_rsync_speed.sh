#!/bin/bash

# 入力引数: 制限率
LIMIT_RATE=$1

# 実行中の rsync プロセスを停止
echo "現在の rsync プロセスを停止しています..."
pkill -f rsync

# 制限値の計算
BW_LIMIT=$((1024 - (1024 * LIMIT_RATE / 100)))

# 新しい rsync プロセスを制限付きで再開
echo "rsync を制限付きで再開します (制限率: ${LIMIT_RATE}%)..."
rsync --bwlimit=$BW_LIMIT -avhP /source/directory/ /destination/directory/
