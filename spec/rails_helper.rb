# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rspec'
require 'selenium-webdriver'

# アップデートの実行状況をターミナルに出力する
# Webdrivers.logger.level = ::Logger::Severity::DEBUG

# カスタムメソッド等の拡張ファイル読み込み
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
include ConfigSupport

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  bef_image_path = Rails.root.join("public/uploads")
  aft_image_path = Rails.root.join("public/uploads_bk")
  # テストスイートの実行前に、開発環境のイメージアップロードディレクトリをリネーム退避する
  config.before(:suite) do
    # リネーム退避
    Dir.mkdir(bef_image_path) unless Dir.exist?(bef_image_path)
    File.rename(bef_image_path, aft_image_path)

    # 画像アップロードを伴うテストケースがない場合、リネーム戻しがエラーとなるため、空のディレクトリを作成する
    Dir.mkdir(bef_image_path)
  end

  # テストスイートの実行が終わったらアップロードされたファイルを削除する
  config.after(:suite) do
    # テスト用アップロードディレクトリの削除
    recursive_delete(bef_image_path)

    # 退避ディレクトリをリネームして戻す
    File.rename(aft_image_path, bef_image_path)
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # logger
  Rails.logger = Logger.new(STDOUT)

  # SQLのログを有効化する
  # ActiveRecord::Base.logger = Logger.new(STDOUT)
  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
