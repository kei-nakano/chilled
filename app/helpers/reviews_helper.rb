module ReviewsHelper
  # レビュー評価時のスコアのセレクトボックスのリストを返す
  def score_list
    score_max = 50 # 5点満点に対応
    array = (0..score_max).to_a
    array.map { |n| [n.to_f / 10, n.to_f / 10] }.to_h
  end
end
