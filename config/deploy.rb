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

# git cloneブランチの指定
# カレントブランチを標準出力から取得し、chompで末尾の改行コードを削除する
current_branch = `git symbolic-ref --short HEAD`.chomp
set :branch, ENV['BRANCH'] || current_branch

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

# git管理対象外のディレクトリはシンボリックリンク化する
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets"

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

      # puma.rbをデプロイ時に毎回作成する
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

# capistrano内の変数一覧表示
namespace :config do
  desc 'show variables'
  task :display do
    Capistrano::Configuration.env.keys.each do |key|
      puts "#{key} => #{fetch(key)}"
    end
  end
end

# デプロイ開始前のサーバ停止タスク(nginx => puma => redis)
before 'deploy:starting', 'nginx:stop'
after 'nginx:stop', 'puma:stop'
after 'puma:stop', 'redis:stop'
after 'redis:stop', 'deploy:upload'

# デプロイ完了後のサーバ起動タスク(redis => puma => nginx)。pumaの起動タイミングはデプロイ直後で、gemで挿入済みのため記述しない
before 'puma:start', 'redis:start'
after 'puma:start', 'nginx:start'
