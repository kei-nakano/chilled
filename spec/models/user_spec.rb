require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:comment) { FactoryBot.create(:comment, user: user) }

  # 名前、メール、パスワードがあり、有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 存在性チェック
  describe "test of presence" do
    # 名前がなければ無効な状態であること
    it "is invalid without a name" do
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    # メールアドレスがなければ無効な状態であること
    it "is invalid without an email address" do
      user.email = nil
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    # パスワードがなければ無効な状態であること
    it "is invalid without a password" do
      user.password = nil
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    user.save
    dupulicate_user = FactoryBot.build(:user, email: user.email)
    dupulicate_user.valid?
    expect(dupulicate_user.errors[:email]).to include("はすでに存在します")
  end

  # メールアドレスは保存前に小文字変換されること
  it "convert  capital letters into email into small" do
    user.email = "TEST@GMAIL.COM"
    user.save
    expect(user.email).to eq "test@gmail.com"
  end

  # メールアドレスは規定の正規表現に従うこと
  describe "email obeys VALID_EMAIL_REGEX" do
    # ドメインのないメールアドレスは無効なこと
    it "is invalid with no domain" do
      user.email = "test"
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です")
    end

    # ドメインのあるメールアドレスは有効なこと
    it "is valid with a domain" do
      user.email = "test@ruby.org"
      expect(user).to be_valid
    end
  end

  # パスワードの正規表現
  describe "regex of password" do
    # 10文字以上20文字以下で、大文字・小文字・数字を最低1文字含むパスワードは有効であること
    it "is valid with a password which contains captal and small letters and number" do
      user.password = "Password12"
      expect(user).to be_valid
    end

    # 大文字を含まないパスワードは無効であること
    it "is valid with a password which does not contain capital letter" do
      user.password = "password12"
      user.valid?
      expect(user.errors[:password]).to include("は半角10~20文字英大文字・小文字・数字をそれぞれ１文字以上含む必要があります")
    end

    # 小文字を含まないパスワードは無効であること
    it "is valid with a password which does not contain small letter" do
      user.password = "PASSWORD12"
      user.valid?
      expect(user.errors[:password]).to include("は半角10~20文字英大文字・小文字・数字をそれぞれ１文字以上含む必要があります")
    end

    # 数字を含まないパスワードは無効であること
    it "is valid with a password which does not contain number" do
      user.password = "PASSWORDfail"
      user.valid?
      expect(user.errors[:password]).to include("は半角10~20文字英大文字・小文字・数字をそれぞれ１文字以上含む必要があります")
    end
  end

  # 名前の長さ
  describe "length of name" do
    # 21文字の名前は無効であること
    it "is invalid with a name which has over 21 characters" do
      user.name = "あ" * 21
      user.valid?
      expect(user.errors[:name]).to include("は20文字以内で入力してください")
    end

    # 20文字の名前は有効であること
    it "is valid with a name which has 300 characters" do
      user.name = "あ" * 20
      expect(user).to be_valid
    end
  end

  # メールアドレスの長さ
  describe "length of email" do
    # 256文字の名前は無効であること
    it "is invalid with a email which has over 256 characters" do
      user.email = "あ" * 256
      user.valid?
      expect(user.errors[:email]).to include("は255文字以内で入力してください")
    end

    # 255文字の名前は有効であること
    it "is valid with a email which has 255 characters" do
      domain = "@a.com"
      user.email = "a" * (255 - domain.length) + domain
      expect(user).to be_valid
    end
  end

  # 画像のアップロード
  describe "check image upload" do
    # 画像なしでも有効であること
    it "is valid with no image" do
      user = FactoryBot.build(:user, image: nil)
      expect(user).to be_valid
    end

    # 画像なしの場合、デフォルト画像が設定されること
    it "has a default image with no image" do
      user = FactoryBot.build(:user, image: nil)
      expect(user.image.url).to eq "/default/default_user.png"
    end

    # デフォルト画像以外の画像を設定できること
    it "can set an image except default image" do
      image_path = Rails.root.join("public/default/no_image.png")
      user = FactoryBot.build(:user, image: File.open(image_path))
      user.save
      expect(user.image.url).to eq "/uploads/user/image/#{user.id}/no_image.png"
    end

    # 5MBを超える画像はアップロードできないこと
    it "can not upload an image over 5MB" do
      image_path = Rails.root.join("public/default/over_5MB.jpg")
      user = FactoryBot.build(:user, image: File.open(image_path))
      user.valid?
      expect(user.errors[:image]).to include "は5MB以下にする必要があります"
    end
  end

  # 削除の依存関係
  describe "dependent: destoy" do
    # 削除すると、紐づくフォローも全て削除されること
    it "destroys all follows when deleted" do
      user.follow(user1)
      user.follow(user2)
      expect { user.destroy }.to change(user.following, :count).by(-2)
    end

    # 削除すると、紐づくフォロワーも全て削除されること
    it "destroys all followers when deleted" do
      user.follow(user1)
      user.follow(user2)
      expect { user.destroy }.to change(user1.followers, :count).by(-1) and change(user2.followers, :count).by(-1)
    end

    # 削除すると、紐づくレビューも全て削除されること
    it "destroys all reviews when deleted" do
      2.times { FactoryBot.create(:review, user: user) }
      expect { user.destroy }.to change(user.reviews, :count).by(-2)
    end

    # 削除すると、紐づくコメントも全て削除されること
    it "destroys all comments when deleted" do
      2.times { FactoryBot.create(:comment, user: user) }
      expect { user.destroy }.to change(user.comments, :count).by(-2)
    end

    # 削除すると、紐づくいいね！(review)も全て削除されること
    it "destroys all review_likes when deleted" do
      2.times { FactoryBot.create(:review_like, user: user) }
      expect { user.destroy }.to change(user.review_likes, :count).by(-2)
    end

    # 削除すると、紐づく食べた！も全て削除されること
    it "destroys all eaten_items when deleted" do
      2.times { FactoryBot.create(:eaten_item, user: user) }
      expect { user.destroy }.to change(user.eaten_items, :count).by(-2)
    end

    # 削除すると、紐づく食べてみたい！も全て削除されること
    it "destroys all want_to_eat_items when deleted" do
      2.times { FactoryBot.create(:want_to_eat_item, user: user) }
      expect { user.destroy }.to change(user.want_to_eat_items, :count).by(-2)
    end

    # 削除すると、紐づくいいね！(comment)も全て削除されること
    it "destroys all commnt_likes when deleted" do
      2.times { FactoryBot.create(:comment_like, user: user) }
      expect { user.destroy }.to change(user.comment_likes, :count).by(-2)
    end

    # 削除すると、紐づくメッセージも全て削除されること
    it "destroys all messages when deleted" do
      2.times { FactoryBot.create(:message, user: user) }
      expect { user.destroy }.to change(user.messages, :count).by(-2)
    end

    # 削除すると、紐づくエントリーも全て削除されること
    it "destroys all entries when deleted" do
      2.times { FactoryBot.create(:entry, user: user) }
      expect { user.destroy }.to change(user.entries, :count).by(-2)
    end

    # 削除すると、紐づくルームも全て削除されること
    it "destroys all rooms when deleted" do
      2.times { FactoryBot.create(:entry, user: user) }
      expect { user.destroy }.to change(user.rooms, :count).by(-2)
    end

    # 削除すると、紐づく通知も全て削除されること
    it "destroys all follows when deleted" do
      comment.create_notice_comment_like(user1)
      comment.create_notice_comment_like(user2)
      expect { user.destroy }.to change(user.passive_notices, :count).by(-2)
    end

    # 削除すると、紐づくブロックも全て削除されること
    it "destroys all blocks when deleted" do
      user.block(user1)
      user.block(user2)
      expect { user.destroy }.to change(user.blocking, :count).by(-2)
    end
  end

  # 検索機能
  describe "search method" do
    before do
      FactoryBot.create(:user, name: "rubyonrails")     # OKパターン
      FactoryBot.create(:user, name: "car_onroad")      # OKパターン
      FactoryBot.create(:user, name: "train_on_road")   # NGパターン
    end

    # 検索文字列に部分一致するカテゴリを検索できること
    it "can search users if keyword matches partially" do
      users = User.search("onr")
      expect(users.count).to eq 2
    end

    # 条件に一致するものがない場合、blankとなること
    it "returns blank if keyword matches partially" do
      users = User.search("abc")
      expect(users.blank?).to be_truthy
    end
  end

  # bcryptによるダイジェスト生成がうまくいくこと
  it "can generate digest successfully by bcrypt" do
    expect(User.digest("test")).to include("$2a")
  end

  # base64によるトークン生成がうまくいくこと
  it "can generate a token successfully by base64" do
    expect(User.new_token.length).to eq 22
  end

  # remember_digestにトークンが保存されること
  it "saves remember digest successfully" do
    expect(user.remember_digest).to eq nil
    user.remember
    expect(user.remember_digest).to include("$2a")
  end

  # autenticated?メソッドでダイジェストと適切に照合ができること
  it "can match with the result of authenticated?" do
    expect(user.authenticated?(:password, "Password12")).to be_truthy
  end

  # パスワード再設定のダイジェストを設定できること
  it "can set password reset digest successfully" do
    expect(user.reset_digest).to eq nil
    user.create_reset_digest

    expect(user.reset_digest).to include("$2a")
    # 複数回のリセットも問題ないこと
    user.create_reset_digest
    expect(user.reset_digest).to include("$2a")
  end

  # パスワード再設定の設定時に時刻が設定できること
  it "can set password reset digest sent time successfully" do
    expect(user.reset_sent_at).to eq nil
    current_time = Time.zone.now
    sleep(1)
    user.create_reset_digest

    expect(user.reset_sent_at >= current_time).to be_truthy
  end

  # パスワードの再設定期限
  describe "time limit of password reset" do
    # 2時間以内ならfalseとなること
    it "returns false password within 2 hours" do
      user.reset_sent_at = Time.zone.now - 2.hours + 1.second
      expect(user.password_reset_expired?).to be_falsy
    end

    # 2時間を超えるならtrueできること
    it "returns true password within 2 hours" do
      user.reset_sent_at = Time.zone.now - 2.hours
      expect(user.password_reset_expired?).to be_truthy
    end
  end

  # ユーザーのremember digestを破棄できること
  it "can delete remember digest" do
    user.remember_digest = "test"
    user.save
    user.forget
    expect(User.find(user.id).remember_digest).to eq nil
  end

  # フォロー
  describe "follow" do
    # うまくフォローできること
    it "can follow successfully" do
      expect { user.follow(user1) }.to change(user1.followers, :count).by(1)
    end

    # うまくアンフォローできること
    it "can unfollow successfully" do
      user.follow(user1)
      expect { user.unfollow(user1) }.to change(user1.followers, :count).by(-1)
    end

    # フォローしていたらtrue、フォローしていないときはfalseを返すこと
    it "returns true if he is follower, not if false" do
      user.follow(user1)
      expect(user.following?(user1)).to be_truthy
      expect(user.following?(user2)).to be_falsy
    end
  end

  # ブロック
  describe "block" do
    # うまくブロックできること
    it "can block successfully" do
      expect { user.block(user1) }.to change(user.blocking, :count).by(1)
    end

    # うまくアンブロックできること
    it "can unblock successfully" do
      user.block(user1)
      expect { user.unblock(user1) }.to change(user.blocking, :count).by(-1)
    end

    # ブロックしていたらtrue、ブロックしていないときはfalseを返すこと
    it "returns true if he is blocked, not if false" do
      user.block(user1)
      expect(user.blocking?(user1)).to be_truthy
      expect(user.blocking?(user2)).to be_falsy
    end
  end
end
