require 'rails_helper'

RSpec.feature "EatenItems", type: :feature do
  # 商品に対して、ボタンをクリックして「食べた！」を作成し、各ページの食べた！数が変化すること。
  # また、削除ができること
  scenario "user can create a eaten_item and delete it", js: true do
    # レビューの事前作成
    FactoryBot.create(:item)

    # 一般ユーザでログインページへ
    user = FactoryBot.create(:user)
    login_rspec user

    # 商品に食べた！を追加
    expect do
      visit "/items/#{Item.first.id}"
      click_link "食べた！"
      sleep(1)
    end.to change(Item.first.eaten_items, :count).by(1)

    # 食べた！が1になる
    visit "/"
    expect(page).to have_content('食べた！1')

    # 検索一覧の商品ページの食べたが1になる
    visit "/search"
    expect(page).to have_content('食べた！1', count: 1)

    # ユーザページの食べた実績が1になり、表示される商品についても実績が1になる
    visit "/users/#{user.id}"
    click_link "食べた！(1)"
    expect(page).to have_content('食べた！1', count: 1)

    # 商品で食べた取り消し
    expect do
      visit "/items/#{Item.first.id}"
      click_link "食べた！1"
      sleep(1)
    end.to change(Item.first.eaten_items, :count).by(-1)

    # 食べた！が0になる
    visit "/"
    expect(page).not_to have_content('食べた！1')

    # 検索一覧の商品ページの食べたが0になる
    visit "/search"
    expect(page).to have_content('食べた！1', count: 0)

    # ユーザページの食べた実績が1になり、表示される商品についても実績が1になる
    visit "/users/#{user.id}"
    click_link "食べた！(0)"
    expect(page).to have_content('食べた！1', count: 0)
  end
end
