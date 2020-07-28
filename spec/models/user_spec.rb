require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  # 名前、メール、パスワードがあり、有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

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

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    user.save
    dupulicate_user = FactoryBot.build(:user, email: user.email)
    dupulicate_user.valid?
    expect(dupulicate_user.errors[:email]).to include("はすでに存在します")
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
