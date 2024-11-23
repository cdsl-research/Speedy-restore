#!/bin/bash

# 引数で渡された値を取得
LIMIT_SPEED=$1

# リモートVMのホスト名とユーザー
REMOTE_HOST="ishikawa@backup"

# 転送速度制限
#echo "転送速度制限を適用しています... (LIMIT_SPEED = $LIMIT_SPEED)"
ssh "$REMOTE_HOST" "pkill -STOP -f 'rsync.*backupfile1'"

# 転送速度制限を適用し、rsync コマンドを再実行
echo "転送速度制限を適用しています... (rsync --bwlimit=$LIMIT_SPEED)"
ssh "$REMOTE_HOST" "rsync --bwlimit=$LIMIT_SPEED -avhP /home/ishikawa/backupfile1 ishikawa@restore:~/"

# すべてが完了したら、プロセスを再開
echo "rsync プロセスを再開します..."
ssh "$REMOTE_HOST" "pkill -CONT -f 'rsync -avhP backupfile1'"
