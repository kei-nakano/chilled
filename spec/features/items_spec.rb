require 'rails_helper'

RSpec.feature "Items", type: :feature do
  # 管理者ユーザーは新しい商品を作成する
  scenario "user creates a new item", js: true do
    # カテゴリとメーカーの事前作成
    FactoryBot.create(:item)

    # 管理者でログインページへ
    user = FactoryBot.create(:admin)
    visit "/"
    click_link "ログイン"

    # pw入力~ログイン
    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "ログイン"
    expect(page).to have_text('ログインしました')

    # 商品投稿ページへ
    click_link "商品投稿"

    expect do
      # 項目入力
      fill_in "item[title]", with: "test item"
      fill_in "item[content]", with: "おいしいです"
      fill_in "item[price]", with: 290
      fill_in "item[gram]", with: 400
      fill_in "item[calorie]", with: 500
      select "1", from: 'item[manufacturer_id]'
      select "1", from: 'item[category_id]'
      click_button "投稿する"
    end.to change(Item.all, :count).by(1)

    click_link "ログアウト"
    expect(page).to have_text('ログアウトしました')
  end
end
