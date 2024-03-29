Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.after_initialize do
    Bullet.enable = true # Bulletプラグインを有効
    Bullet.bullet_logger = true # log/bullet.logへの出力
    Bullet.console = true # ブラウザのコンソールログに記録
  end

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # エラーの詳細画面(赤画面)を表示するか(false -> カスタム404/500ページ)
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # メーラー設定
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'ec2-54-150-77-245.ap-northeast-1.compute.amazonaws.com', protocol: 'http' }

  # 送信方法を指定
  config.action_mailer.delivery_method = :smtp

  # 送信方法として:smtpを指定した場合は、このconfigを使って送信詳細の設定を行う
  config.action_mailer.smtp_settings = {
    address: "email-smtp.ap-northeast-1.amazonaws.com",
    port: 587,
    user_name: Rails.application.credentials.ses_access_key,
    password: Rails.application.credentials.ses_secret_key,
    # パスワードをBase64でエンコード
    authentication: :login
  }

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Action Cableは指定されていない送信元からのリクエストを受け付けないため、送信元リストを定義する
  config.action_cable.allowed_request_origins = ['http://ec2-54-150-77-245.ap-northeast-1.compute.amazonaws.com']
end
