require 'rails_helper'

RSpec.feature "Blocks", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:my_review) { FactoryBot.create(:review, user: user) }
  let(:other_review) { FactoryBot.create(:review, user: other_user) }

  # ユーザに対して、ボタンをクリックして「ブロック」を作成し、各ページのブロック数が変化すること。
  # また、ブロック解除ができること
  scenario "user can block and unblock", js: true do
    # ログイン
    login_rspec user

    # プロフィールに移動
    visit "/users/#{user.id}"
    expect(page).to have_content('ブロック(0)')

    # ブロックを実行
    expect do
      visit "/users/#{other_user.id}"
      click_link "ブロック"
      sleep(1)
    end.to change(user.blocking, :count).by(1)

    # userのブロックが1になる
    visit "/users/#{user.id}"
    click_link "ブロック(1)"
    expect(page).to have_content(other_user.name.to_s, count: 1)
    expect(page).to have_content("ブロックしています", count: 1)

    # ユーザ検索結果
    visit "/search?type=user"
    expect(page).to have_content("ブロックしています", count: 1) # other_user

    # アンブロックを実行
    expect do
      visit "/users/#{other_user.id}"
      click_link "ブロック解除"
      sleep(1)
    end.to change(user.blocking, :count).by(-1)
  end

  # ブロックしたユーザのコメント、レビューが表示されないこと
  scenario "comments, reviews of blocked users are hidden", js: true do
    # 事前作成(コメントを付けないと、Topページに表示されない)
    FactoryBot.create(:comment, review: my_review, user: other_user, content: "このコメントはブロック後検出できません")
    FactoryBot.create(:comment, review: other_review, user: other_user)

    # ログイン
    login_rspec user

    # Topページに移動
    visit "/"
    expect(page).to have_css('.review-scroll-wrapper', count: 4) # user*2, other_user*2

    # 検索結果ページに移動
    visit "/search"
    expect(page).to have_content("レビュー(2)", count: 1)

    # 商品ページに移動
    visit "/items/#{my_review.item_id}"
    expect(page).to have_content("このコメントはブロック後検出できません", count: 1)

    # ブロックを実行
    expect do
      visit "/users/#{other_user.id}"
      click_link "ブロック"
      sleep(1)
    end.to change(user.blocking, :count).by(1)

    # Topページに移動
    visit "/"
    expect(page).to have_css('.review-scroll-wrapper', count: 2) # user*2, other_user*0

    # 検索結果ページに移動
    visit "/search"
    expect(page).to have_content("レビュー(1)", count: 1)

    # 商品ページに移動
    visit "/items/#{my_review.item_id}"
    expect(page).to have_content("このコメントはブロック後検出できません", count: 0)
  end
end
