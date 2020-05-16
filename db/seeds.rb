# ユーザー
User.create!(name: "keisuke",
             email: "keisuke@gmail.com",
             password: "keisuke")

10.times do |n|
  name  = (n + 1).to_s
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password)
end

# アイテム
users = User.order(:created_at).take(3)
5.times do |n|
  content = (n + 1).to_s
  users.each { |user| user.items.create!(title: content) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..10]
followers = users[1..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
