# 本番サーバIPアドレス
set :default_env, { ip_address: ENV["ADDRESS_PRODUCTION"] }

# 本番サーバ用設定
#server fetch(:default_env).fetch(:ip_address), user: fetch(:user), roles: %w[app db web]
server '54.178.0.15', user: fetch(:user), roles: %w[app db web]
