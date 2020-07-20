# host名から開発機かcircleci環境か判定
hostname = `hostname`.chomp # chomp: 末尾の改行コードを削除

# ipアドレスとssh鍵パスの設定
if hostname == ENV["DEVELOPMENT_HOST_NAME"]
  # 開発環境
  set :default_env, { ip_address: ENV['PRIVATE_ADDRESS_PRODUCTION'] }
  set :ssh_options, {
    keys: %w[/home/ec2-user/.ssh/my-key.pem],
    user: fetch(:user).to_s,
    forward_agent: true,
    auth_methods: %w[publickey]
  }
else
  # circleci環境
  set :default_env, { ip_address: ENV["PUBLIC_ADDRESS_PRODUCTION"] }
  set :ssh_options, {
    keys: %w[~/.ssh/id_rsa_030eccfb6de0d06f315c8be4bd8eaab7],
    user: fetch(:user).to_s,
    forward_agent: true,
    auth_methods: %w[publickey]
  }
end

# 本番サーバ接続アドレス/ユーザ設定
server fetch(:default_env).fetch(:ip_address), user: fetch(:user), roles: %w[app db web]
