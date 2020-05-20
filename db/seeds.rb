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

# メーカー
Manufacturer.create!(name: "日清食品")
Manufacturer.create!(name: "ニチレイフーズ")

# カテゴリー
Category.create!(name: "パスタ")
Category.create!(name: "チャーハン")

# アイテム
Item.create!(title: "日清もちっと生パスタ 牛挽肉とまいたけのクリーミーボロネーゼ",
             image: nil,
             manufacturer_id: 1,
             category_id: 1,
             content: 'もちっとした食感の平打ち生パスタ (タリアテッレ) を使用。じっくりと煮込んだ牛肉と北海道産生クリームで仕上げた濃厚で旨みあるボロネーゼソースです。まいたけとパセリをトッピングし彩り豊かに仕上げました。',
             price: 250,
             gram: 295,
             calorie: 472)

Item.create!(title: "日清もちっと生パスタ 牛挽肉とまいたけのクリーミーボロネーゼ",
             image: nil,
             manufacturer_id: 2,
             category_id: 2,
             content: 'もちっとした食感の平打ち生パスタ (タリアテッレ) を使用。じっくりと煮込んだ牛肉と北海道産生クリームで仕上げた濃厚で旨みあるボロネーゼソースです。まいたけとパセリをトッピングし彩り豊かに仕上げました。',
             price: 250,
             gram: 295,
             calorie: 472)

# users = User.order(:created_at).take(3)
# 1.times do |n|
#  content = (n + 1).to_s
#  users.each { |user| user.items.create!(title: content) }
# end

# レビュー
Review.create!(image: nil,
               user_id: 1,
               item_id: 1,
               content: 'パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。正直もう買いません。',
               score: 2.5)

Review.create!(image: nil,
               user_id: 1,
               item_id: 1,
               content: 'パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。正直もう買いません。',
               score: 5.0)

Review.create!(image: nil,
               user_id: 3,
               item_id: 2,
               content: 'パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。正直もう買いません。',
               score: 1.0)

# コメント
Comment.create!(user_id: 1,
                review_id: 1,
                content: "意外でしたが、参考になりました。")

Comment.create!(user_id: 2,
                review_id: 1,
                content: "ふーん。そうなんだ。")

Comment.create!(user_id: 1,
                review_id: 2,
                content: "意外でしたが、参考になりました。")

Comment.create!(user_id: 2,
                review_id: 2,
                content: "ふーん。そうなんだ。")

# リレーションシップ
users = User.all
user  = users.first
following = users[2..10]
followers = users[1..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
