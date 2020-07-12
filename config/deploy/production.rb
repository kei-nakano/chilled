# server-based syntax
# ======================
server "172.31.8.114", user: fetch(:user), roles: %w[app db web]

# role-based syntax
# ==================
# role :app, %w{deploy@example.com}, my_property: :my_value
