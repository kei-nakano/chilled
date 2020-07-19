# 本番サーバIPアドレス設定
hostname = `hostname`.chomp # 末尾の改行コードを削除

# CI環境からはパブリックIPを参照するようにする。開発機からはプライベートIPを使用する。
if hostname == ENV["DEVELOPMENT_HOST_NAME"]
  set :default_env, { ip_address: ENV['PRIVATE_ADDRESS_PRODUCTION'] }
else
  set :default_env, { ip_address: ENV["PUBLIC_ADDRESS_PRODUCTION"] }
end

# 本番サーバ用設定
server fetch(:default_env).fetch(:ip_address), user: fetch(:user), roles: %w[app db web]
