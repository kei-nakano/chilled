module ApplicationHelper
  # tweet用のurlを生成
  def tweet_url(url, review_id)
    if url.include?('=')
      position = url.index('=')
      url.slice(0..position) + review_id.to_s
    else
      url + "?review_id=#{review_id}"
    end
  end
end
