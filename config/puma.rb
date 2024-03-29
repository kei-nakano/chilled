# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

# UNIXドメインソケットでの連携時、TCP通信での連携は不要になるので、port設定をコメントアウトし、tcpでのlisten停止させる
# port ENV.fetch("PORT") { 3000 }

# nginx通信用：UNIXドメインソケット
bind "unix:///tmp/sockets/puma.sock"

# デフォルト起動モード
environment ENV.fetch("RAILS_ENV") { "development" }

# pumaのプロセスIDファイルパス
pidfile ENV.fetch("PIDFILE") { "tmp/pids/puma.pid" }
state_path ENV.fetch("STATEFILE") { "tmp/pids/puma.state" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
