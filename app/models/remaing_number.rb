class RemaingNumber
  REPETITION_NUMBER = 10  # セレクトボックス内要素数
  UNIT_NUMBER = 100       # 取得ツイートの区切り単位
  def initialize(tweet_count)
    @remaing_number = tweet_count / UNIT_NUMBER
  end

  def lower_count
    @remaing_number -= 1
  end
end
