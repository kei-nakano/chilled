require 'rails_helper'

RSpec.feature "WantToEatItems", type: :feature do
  # 商品に対して、ボタンをクリックして「食べてみたい！」を作成し、各ページの食べてみたい！数が変化すること。
  # また、削除ができること
  scenario "user can create a want_to_eat_item and delete it", js: true do
    # レビューの事前作成
    FactoryBot.create(:item)

    # 一般ユーザでログインページへ
    user = FactoryBot.create(:user)
    login_rspec user

    # 商品に食べてみたい！を追加
    expect do
      visit "/items/#{Item.first.id}"
      click_link "食べてみたい！"
      sleep(1)
    end.to change(Item.first.want_to_eat_items, :count).by(1)

    # 食べてみたい！が1になる
    visit "/"
    expect(page).to have_content('食べてみたい！1')

    # 検索一覧の商品ページの食べてみたいが1になる
    visit "/search"
    expect(page).to have_content('食べてみたい！1', count: 1)

    # ユーザページの食べてみたい実績が1になり、表示される商品についても実績が1になる
    visit "/users/#{user.id}"
    click_link "食べてみたい！(1)"
    expect(page).to have_content('食べてみたい！1', count: 1)

    # 商品で食べてみたい取り消し
    expect do
      visit "/items/#{Item.first.id}"
      click_link "食べてみたい！1"
      sleep(1)
    end.to change(Item.first.want_to_eat_items, :count).by(-1)

    # 食べてみたい！が0になる
    visit "/"
    expect(page).not_to have_content('食べてみたい！1')

    # 検索一覧の商品ページの食べてみたいが0になる
    visit "/search"
    expect(page).to have_content('食べてみたい！1', count: 0)

    # ユーザページの食べてみたい実績が1になり、表示される商品についても実績が1になる
    visit "/users/#{user.id}"
    click_link "食べてみたい！(0)"
    expect(page).to have_content('食べてみたい！1', count: 0)
  end
end
