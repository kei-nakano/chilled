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

# Manufacturer
nissin = FactoryBot.create(:manufacturer, name: "日清食品", image: File.open(Rails.root.join("public/default/manufacturer/日清食品.png")))
nichirei = FactoryBot.create(:manufacturer, name: "ニチレイフーズ", image: File.open(Rails.root.join("public/default/manufacturer/ニチレイフーズ.jpg")))
meiji = FactoryBot.create(:manufacturer, name: "明治", image: File.open(Rails.root.join("public/default/manufacturer/明治.png")))

# Category
pasta = FactoryBot.create(:category, name: "パスタ", image: File.open(Rails.root.join("public/default/category/パスタ.jpg")))
tantanmen = FactoryBot.create(:category, name: "担々麺", image: File.open(Rails.root.join("public/default/category/担々麺.jpg")))
fried_rice = FactoryBot.create(:category, name: "チャーハン", image: File.open(Rails.root.join("public/default/category/チャーハン.jpg")))
okazu = FactoryBot.create(:category, name: "おかず", image: File.open(Rails.root.join("public/default/category/おかず.jpg")))
ice = FactoryBot.create(:category, name: "アイス", image: File.open(Rails.root.join("public/default/category/アイス.jpg")))

# Item
# 日清*パスタ
Item.create!(title: "日清もちっと生パスタ ほうれん草とベーコンのカルボナーラ",
             image: File.open(Rails.root.join("public/default/item/1.png")),
             manufacturer_id: nissin.id,
             category_id: pasta.id,
             content: 'ほうれん草粉末を練り込んだ鮮やかな色合いの生パスタに、チーズと卵黄に北海道産生クリームを加えた、コクのある濃厚なカルボナーラソースを合わせました。ほうれん草、ベーコン、しめじをトッピングしました。',
             price: 235,
             gram: 288,
             calorie: 430)

Item.create!(title: "日清もちっと生パスタ 牛挽肉とまいたけのクリーミーボロネーゼ",
             image: File.open(Rails.root.join("public/default/item/2.png")),
             manufacturer_id: nissin.id,
             category_id: pasta.id,
             content: 'もちっとした食感の平打ち生パスタ (タリアテッレ) を使用。じっくりと煮込んだ牛肉と北海道産生クリームで仕上げた濃厚で旨みあるボロネーゼソースです。まいたけとパセリをトッピングし彩り豊かに仕上げました。',
             price: 240,
             gram: 295,
             calorie: 472)

Item.create!(title: "日清もちっと生パスタ 海老とそら豆の濃厚クリーム",
             image: File.open(Rails.root.join("public/default/item/3.png")),
             manufacturer_id: nissin.id,
             category_id: pasta.id,
             content: '北海道産生クリームを使用したなめらかで濃厚なクリームソースです。魚介のうまみとさまざまなハーブやスパイスで風味豊かに仕上げました。具材はプリっとした食感の海老、ふっくら大粒のそら豆です。',
             price: 238,
             gram: 276,
             calorie: 422)

# 日清*担々麺
Item.create!(title: "日清中華 汁なし担々麺 大盛り",
             image: File.open(Rails.root.join("public/default/item/4.png")),
             manufacturer_id: nissin.id,
             category_id: tantanmen.id,
             content: '練りごまたっぷりの濃厚な担々だれに、もちっと弾力のある平打ち麺がよく絡みます。具材は食べ応えのある肉みそとチンゲン菜、タケノコ。別添「花椒入り唐辛子」でお好みの辛さに調節できます。',
             price: 236,
             gram: 360,
             calorie: 594)

# ニチレイ*チャーハン
Item.create!(title: "本格炒め炒飯",
             image: File.open(Rails.root.join("public/default/item/5.jpg")),
             manufacturer_id: nichirei.id,
             category_id: fried_rice.id,
             content: '家庭では手作りできない圧倒的な「炒め」パワーで、ごはん一粒一粒に卵をまとわせているから、電子レンジでパラパラのおいしさに！プロの料理人の調理方法にならって卵の炒め方を改良しました。',
             price: 270,
             gram: 450,
             calorie: 968)

Item.create!(title: "具材たっぷり五目炒飯",
             image: File.open(Rails.root.join("public/default/item/6.jpg")),
             manufacturer_id: nichirei.id,
             category_id: fried_rice.id,
             content: '７種類の具材（ねぎ、卵、焼豚、にんじん、たけのこ、しいたけ、きくらげ）を使い、中華の高級調味料ＸＯ醤とオイスターソースで仕上げた五目炒飯です。家庭では手作りできない圧倒的な「炒め」パワーで、ごはん一粒一粒に卵をまとわせているから、電子レンジでパラパラのおいしさに！',
             price: 280,
             gram: 500,
             calorie: 950)

# ニチレイ*おかず
Item.create!(title: "極上ヒレかつ",
             image: File.open(Rails.root.join("public/default/item/7.jpg")),
             manufacturer_id: nichirei.id,
             category_id: okazu.id,
             content: '専門店にならった丁寧な下拵えで、箸で切れるほどやわらかな肉質に仕上げたヒレかつです。ボリューム感のあるヒレかつを、レンジ調理で手軽にお楽しみいただけます。',
             price: 279,
             gram: 180,
             calorie: 468)

Item.create!(title: "若鶏たれづけ唐揚げ",
             image: File.open(Rails.root.join("public/default/item/8.jpg")),
             manufacturer_id: nichirei.id,
             category_id: okazu.id,
             content: '特製甘酢だれをスッキリとした味わいにして、さらにご飯が進む味付けになりました。鶏肉にもしっかり下味をつけ、たれの味とのバランスを整えました。',
             price: 281,
             gram: 300,
             calorie: 747)

Item.create!(title: "若鶏タツタ",
             image: File.open(Rails.root.join("public/default/item/9.jpg")),
             manufacturer_id: nichirei.id,
             category_id: okazu.id,
             content: '当社独自の製法で、タツタ揚げらしい「サクッ」とした食感が、唐揚げの美味しさを引き立てます。醤油の風味と生姜が上品に香る和風の若鶏竜田揚げです。',
             price: 295,
             gram: 240,
             calorie: 617)

# 明治*アイス
Item.create!(title: "明治 エッセル スーパーカップ 白いチョコミント",
             image: File.open(Rails.root.join("public/default/item/10.jpg")),
             manufacturer_id: meiji.id,
             category_id: ice.id,
             content: 'エッセルならではの、なめらかでコクのあるベースアイスをさわやかな味わいの“白い”ミントアイスに仕上げ、パリパリ食感のチョコチップを混ぜ込みました。パリパリとした食感でありながら口溶けの良いチョコチップと、ミントアイスのおいしい組み合わせを楽しめます。',
             price: 140,
             gram: 200,
             calorie: 340)

Item.create!(title: "明治 エッセル スーパーカップ 超バニラ",
             image: File.open(Rails.root.join("public/default/item/11.jpg")),
             manufacturer_id: meiji.id,
             category_id: ice.id,
             content: '濃厚な味わいとシャープなキレのあるおいしさをなめらかな舌触りで楽しめるバニラアイスの定番「明治 エッセル スーパーカップ 超バニラ」。',
             price: 140,
             gram: 200,
             calorie: 374)

Item.create!(title: "明治 エッセル スーパーカップ 抹茶",
             image: File.open(Rails.root.join("public/default/item/12.jpg")),
             manufacturer_id: meiji.id,
             category_id: ice.id,
             content: '濃厚な味わいとシャープなキレのあるおいしさをなめらかな舌触りで風味豊かな抹茶の味わいが楽しめる「明治 エッセル スーパーカップ 抹茶」。',
             price: 140,
             gram: 200,
             calorie: 301)

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
