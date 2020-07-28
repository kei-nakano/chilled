require 'selenium-webdriver'
require 'capybara/rspec'

Capybara.configure do |config|
  # select drivers: :rack_test, :selenium, :selenium_headless, :selenium_chrome, :selenium_chrome_headless
  config.default_driver = :selenium_chrome_headless
  config.javascript_driver = :selenium_chrome_headless

  # Configurable options:
  config.run_server = true              # ローカルのRack Serverを使用しない (Default: true)
  config.default_selector = :css        # デフォルトのセレクターを`:css`または`:xpath`で指定する (Default: :css)
  config.default_max_wait_time = 5      # Ajaxなどの非同期プロセスが終了するまで待機する最大秒数 (seconds, Default: 2)
  config.ignore_hidden_elements = true  # ページ上の隠れた要素を無視するかどうか (Default: true)
  config.save_path = Dir.pwd            # save_(page|screenshot), save_and_open_(page|screenshot)を使用した時にファイルが保存されるパス (Default: Dir.pwd)
  config.automatic_label_click = false  # チェックボックスやラジオボタンが非表示の場合に関連するラベル要素をクリックするかどうか (Default: false)
end

# chromeのカスタム設定
# Capybara.register_driver :chrome do |app|
#  options = Selenium::WebDriver::Chrome::Options.new
#
#  #options.add_argument("--disable-dev-shm-usage")
#  #options.add_argument("--no-sandbox")
#  options.add_argument('disable-notifications') # 通知を無効
#  options.add_argument('disable-translate') # 翻訳を無効
#  options.add_argument('disable-extensions') # 拡張機能を無効
#  options.add_argument('disable-infobars') # 通知無効
#  options.add_argument('window-size=1280,960') # windowサイズ
#
#  # ブラウザーを起動する
#  Capybara::Selenium::Driver.new(
#    app,
#    browser: :chrome,
#    options: options
#  )
# end
