# User
FactoryBot.create(:user, name: "テストユーザー", email: "test@example.com")
FactoryBot.create(:admin, name: "管理者ユーザー", email: "admin@example.com")

20.times do |n|
  name = if n <= 9
            Faker::Name.name
          else
            Faker::Artist.name
          end
  email = "example-#{n + 1}@example.com"
  image = File.open(Rails.root.join("public/default/user/#{n + 1}.jpg"))
  FactoryBot.create(:user, name: name, email: email, image: image)
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

Item.create!(title: "日清もちっと生パスタ 牛挽肉とまいたけのクリーミーボロネゼ",
             image: nil,
             manufacturer_id: 2,
             category_id: 2,
             content: 'もちっとした食感の平打ち生パスタ (タリアテッレ) を使用。じっくりと煮込んだ牛肉と北海道産生クリームで仕上げた濃厚で旨みあるボロネーゼソースです。まいたけとパセリをトッピングし彩り豊かに仕上げました。',
             price: 250,
             gram: 295,
             calorie: 472)

Item.create!(title: "日清もちっと生パスタ 牛挽肉とまいたけのクリーミーボネーゼ",
             image: nil,
             manufacturer_id: 2,
             category_id: 2,
             content: 'もちっとした食感の平打ち生パスタ (タリアテッレ) を使用。じっくりと煮込んだ牛肉と北海道産生クリームで仕上げた濃厚で旨みあるボロネーゼソースです。まいたけとパセリをトッピングし彩り豊かに仕上げました。',
             price: 250,
             gram: 295,
             calorie: 472)

Item.create!(title: "日清もちっと生パスタ 牛挽肉とまいたけのクリボロネーゼ",
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
Review.create!(
  user_id: 1,
  item_id: 1,
  content: 'パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。正直もう買いません。',
  score: 2.5
)

Review.create!(
  user_id: 2,
  item_id: 1,
  content: 'これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。これが2つ目のレビューじゃ。心してみろや。',
  score: 5.0
)

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

Review.all.each do |review|
  review.update(multiple_images: [File.open("./public/default/default_user.png"),
                                  File.open("./public/default/no_image.png"),
                                  File.open("./public/default/tag.jpg")])
end

Review.create!(
  user_id: 4,
  item_id: 2,
  content: 'testtesttesttesttesttesttesttesttesttesttesttest',
  score: 1.9,
  tag_list: %w[まずい ゴミ]
)

# ReviewLike
ReviewLike.create!(user_id: 1,
                   review_id: 1)
ReviewLike.create!(user_id: 2,
                   review_id: 2)
ReviewLike.create!(user_id: 2,
                   review_id: 3)
ReviewLike.create!(user_id: 2,
                   review_id: 4)
ReviewLike.create!(user_id: 2,
                   review_id: 5)

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
