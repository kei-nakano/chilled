# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

# アプリケーションディレクトリ名
set :application, "sample"

# SSH接続ユーザ
set :user, "ec2-user"

# リポジトリURL
set :repo_url, "git@github.com:kei-nakano/sample.git"

# デプロイパス
set :deploy_to, "/home/#{fetch(:user)}/environment/#{fetch(:application)}"

# 自動生成されるpuma.rbのソケット通信パスを以下に変更
set :puma_bind, %w[unix:///tmp/sockets/puma.sock]

# set :branch, ENV['BRANCH'] || "master"
set :branch, "capistrano"

# 以下ファイルはそのままでは読み込まれず、shared配下に置く必要があるため、リンク対象としてシンボリックリンクを作成する
set :linked_files, fetch(:linked_files, []).push("config/master.key")
append :linked_files, "config/database.yml"
append :linked_files, ".env"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# タスク内でsudoする場合、trueにする
set :pty, true

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# 何世代前までリリースを残しておくか
set :keep_releases, 5

# サーバにSSH接続を行う際の設定
set :ssh_options, {
  user: fetch(:user).to_s,
  keys: %w[/home/ec2-user/.ssh/my-key.pem],
  forward_agent: true,
  auth_methods: %w[publickey]
}

# ----------カスタマイズしたタスク------------
namespace :deploy do
  # linked_filesで使用するファイルをアップロードするタスク。deploy前に実行する。
  desc 'upload linked_files'
  task :upload do
    on roles(:app) do |_host|
      execute :mkdir, '-p', "#{shared_path}/config"
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
      upload!('config/master.key', "#{shared_path}/config/master.key")
      upload!('.env', "#{shared_path}/.env")
      invoke 'puma:config'
    end
  end
end

# nginxの起動・停止・再起動
namespace :nginx do
  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command.to_s do
      on roles(:web) do
        sudo "service nginx #{command}"
      end
    end
  end
end

# redisの起動・停止・再起動
namespace :redis do
  %w[start stop restart].each do |command|
    desc "#{command} redis"
    task command.to_s do
      on roles(:web) do
        sudo "service redis #{command}"
      end
    end
  end
end

before 'nginx:stop', 'puma:stop'
before 'deploy:upload', 'nginx:stop'
before 'nginx:stop', 'redis:stop'
# linked_filesで使用するファイルをアップロードするタスクは、deployが行われる前に実行する必要がある
before 'deploy:starting', 'deploy:upload'
# Capistrano 3.1.0 からデフォルトで deploy:restart タスクが呼ばれなくなったので、ここに以下の1行を書く必要がある
after 'deploy:publishing', 'nginx:start'
after 'nginx:start', 'redis:start'
# after 'puma:start', 'deploy:restart_puma'
