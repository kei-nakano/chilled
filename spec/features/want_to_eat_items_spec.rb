require 'rails_helper'

RSpec.feature "WantToEatItems", type: :feature do
  # 商品に対して、ボタンをクリックして「食べたい！」を作成し、各ページの食べたい！数が変化すること。
  # また、削除ができること
  scenario "user can create a want_to_eat_item and delete it", js: true do
    # レビューの事前作成
    FactoryBot.create(:item)

    # 一般ユーザでログインページへ
    user = FactoryBot.create(:user)
    login_rspec user

    # 商品に食べたい！を追加
    expect do
      visit "/items/#{Item.first.id}"
      click_link "食べたい！"
      sleep(1)
    end.to change(Item.first.want_to_eat_items, :count).by(1)

    # 食べたい！が1になる
    visit "/"
    expect(page).to have_content('食べたい！1')

    # 検索一覧の商品ページの食べたいが1になる
    visit "/search"
    expect(page).to have_content('食べたい！1', count: 1)

    # ユーザページの食べたい実績が1になり、表示される商品についても実績が1になる
    visit "/users/#{user.id}"
    click_link "食べたい！(1)"
    expect(page).to have_content('食べたい！1', count: 1)

    # 商品で食べたい取り消し
    expect do
      visit "/items/#{Item.first.id}"
      click_link "食べたい！1"
      sleep(1)
    end.to change(Item.first.want_to_eat_items, :count).by(-1)

    # 食べたい！が0になる
    visit "/"
    expect(page).not_to have_content('食べたい！1')

    # 検索一覧の商品ページの食べたいが0になる
    visit "/search"
    expect(page).to have_content('食べたい！1', count: 0)

    # ユーザページの食べたい実績が1になり、表示される商品についても実績が1になる
    visit "/users/#{user.id}"
    click_link "食べたい！(0)"
    expect(page).to have_content('食べたい！1', count: 0)
  end
end
