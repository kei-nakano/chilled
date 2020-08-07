module ApplicationHelper
  # tweet用のurlを生成
  # def tweet_url(url, review_id)
  #   if url.include?('=')
  #    position = url.index('=')
  #    url.slice(0..position) + review_id.to_s
  #  else
  #    url + "?review_id=#{review_id}"
  #  end
  # end

  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = "冷凍食品のレビューサイト「Chill℃」"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
