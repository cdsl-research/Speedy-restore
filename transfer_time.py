import os

def calculate_limit_rate(predicted_time, allowable_time):
    """
    許容時間に基づいてディスク読み取り速度制限率を計算する関数。
    
    Args:
        predicted_time (float): 予測転送時間（秒単位）
        allowable_time (float): 許容転送時間（秒単位）

    Returns:
        int: 制限率（パーセント）
    """
    increase_percent = ((allowable_time / predicted_time) - 1) * 100

    # 増加率に基づく制限率の決定
    if increase_percent <= 16:
        return 10
    elif increase_percent <= 30:
        return 20
    elif increase_percent <= 50:
        return 30
    elif increase_percent <= 70:
        return 40
    elif increase_percent <= 100:
        return 50
    elif increase_percent <= 150:
        return 60
    elif increase_percent <= 240:
        return 70
    elif increase_percent <= 400:
        return 80
    else:
        return 90

# メイン処理
data_size = float(input("データサイズ (GB) を入力してください: "))
predicted_time = calculate_transfer_time(data_size)
allowable_time = calculate_allowable_time(predicted_time)
limit_rate = calculate_limit_rate(predicted_time, allowable_time)

# シェルスクリプトの呼び出し
os.system(f"./adjust_rsync_speed.sh {limit_rate}")

print(f"{data_size}GB の予測転送時間: {seconds_to_time_format(predicted_time)}")
print(f"許容転送時間 (基準時間の38%増し): {seconds_to_time_format(allowable_time)}")
print(f"制限率: {limit_rate}%")
