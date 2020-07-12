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

# shared配下の読み込みファイルの設定
set :linked_files, fetch(:linked_files, []).push("config/master.key")

# set :branch, ENV['BRANCH'] || "master"
set :branch, "capistrano"
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# タスク内でsudoする場合、trueにする
set :pty, true

# シンボリックリンクを作成
# append :linked_files, "config/database.yml"
append :linked_files, "config/credentials.yml.enc"

# 環境変数の読み込み
append :linked_files, ".env"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

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
