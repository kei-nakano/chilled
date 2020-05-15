# ユーザー
User.create!(name: "keisuke",
             email: "keisuke@gmail.com",
             password: "keisuke")

55.times do |n|
  name  = n.to_s
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password)
end

# アイテム
users = User.order(:created_at).take(6)
50.times do |n|
  content = n.to_s
  users.each { |user| user.items.create!(title: content) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
