require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    @review = FactoryBot.build(:review)
  end

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:review)).to be_valid
  end

  # 名前、メール、パスワードがあれば有効な状態であること
  it "is valid with a name, email, and password" do
    expect(@review).to be_valid
  end

  # 名前がなければ無効な状態であること
  it "is invalid without a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "test@gmail.com")
    user = FactoryBot.build(:user, email: "test@gmail.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  # 文字列に一致するメッセージを検索する
  describe "search message for a term" do
    # 一致するデータが見つかるとき
    context "when a match is found" do # 一致する場合の example が並ぶ ...
    end

    # 一致するデータが1件も見つからないとき
    context "when no match is found" do # 一致しない場合の example が並ぶ ...
    end
  end
end
