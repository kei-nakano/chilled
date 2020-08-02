module DebugSupport
  # 現在のurlを表示する
  def debug_path
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq nil
  end

  # ページのDOM要素を表示する
  def debug_dom
    expect(page).to have_content nil
  end
end

RSpec.configure do |config|
  config.include DebugSupport
end
