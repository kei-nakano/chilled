# ユーザー
User.create!(name: "keisuke",
             email: "keisuke@gmail.com",
             password: "keisuke",
             activated: true,
             admin: true)

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

Item.create!(title: "日清もちっと生パスタ 牛挽肉とまいたけのクリーミーボロネーゼ",
             image: nil,
             manufacturer_id: 2,
             category_id: 2,
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
               user_id: 2,
               item_id: 1,
               content: 'これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。',
               score: 5.0)

Review.create!(user_id: 3,
               item_id: 2,
               content: 'パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。正直もう買いません。',
               score: 1.0,
               tag_list: %w[うまい 美味しい])

Review.create!(
  user_id: 4,
  item_id: 2,
  content: 'パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。',
  score: 1.9,
  tag_list: %w[うまい 美味しい]
)

Review.create!(
  user_id: 4,
  item_id: 2,
  content: 'testtesttesttesttesttesttesttesttesttesttesttest',
  score: 1.9,
  tag_list: %w[まずい ゴミ]
)

Review.last.update(multiple_images: [File.open("./public/uploads/default/1.jpg"),
                                     File.open("./public/uploads/default/11.jpg"),
                                     File.open("./public/uploads/default/1.jpg")])

# ReviewLike
ReviewLike.create!(user_id: 1,
                   review_id: 1)

ReviewLike.create!(user_id: 2,
                   review_id: 1)

ReviewLike.create!(user_id: 2,
                   review_id: 2)

# 食べた
EatenItem.create!(user_id: 1,
                  item_id: 1)

EatenItem.create!(user_id: 2,
                  item_id: 1)

EatenItem.create!(user_id: 2,
                  item_id: 2)

# 食べてみたい
WantToEatItem.create!(user_id: 1,
                      item_id: 1)

WantToEatItem.create!(user_id: 2,
                      item_id: 1)

WantToEatItem.create!(user_id: 2,
                      item_id: 2)

# コメント
Comment.create!(user_id: 1,
                review_id: 1,
                content: "1-意外でしたが、参考になりました。")
Comment.first.update(created_at: Time.zone.today + 1.minute)

Comment.create!(user_id: 2,
                review_id: 1,
                content: "2-ふーん。そうなんだ。")
Comment.second.update(created_at: Time.zone.today + 2.minutes)

Comment.create!(user_id: 1,
                review_id: 2,
                content: "3-意外でしたが、参考になりました。")
Comment.third.update(created_at: Time.zone.today + 3.minutes)

Comment.create!(user_id: 2,
                review_id: 2,
                content: "4-ふーん。そうなんだ。")
Comment.fourth.update(created_at: Time.zone.today + 4.minutes)

# いいね
CommentLike.create!(user_id: 1,
                    comment_id: 1)

CommentLike.create!(user_id: 2,
                    comment_id: 2)

users = User.all
user  = users.first
following = users[2..10]
followers = users[1..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# room
Room.create!

# Entry
Entry.create!(user_id: 1,
              room_id: 1)

Entry.create!(user_id: 2,
              room_id: 1)

# message
Message.create!(user_id: 1,
                room_id: 1,
                content: "keiのmsg")

Message.create!(user_id: 2,
                room_id: 1,
                content: "No.1のmsg")

Message.create!(user_id: 1,
                room_id: 1,
                content: "keiのmsg")

Message.create!(user_id: 2,
                room_id: 1,
                content: "No.1のmsg")

Message.create!(user_id: 1,
                room_id: 1,
                content: "keiのmsg")

Message.create!(user_id: 2,
                room_id: 1,
                content: "No.1のmsg")
