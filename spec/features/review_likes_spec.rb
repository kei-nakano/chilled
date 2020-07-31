require 'rails_helper'

RSpec.feature "ReviewLikes", type: :feature do
  # レビューに対して、ボタンをクリックして「いいね！」の作成を作成し、各ページのいいね！数が変化すること。
  # また、削除ができること
  scenario "user can create a review_like and delete it", js: true do
    # レビューの事前作成
    FactoryBot.create(:review)

    # 一般ユーザでログインページへ
    user = FactoryBot.create(:user)
    login_rspec user

    # レビューにいいね！
    expect do
      visit "/items/#{Item.first.id}"
      click_link "いいね！"
      sleep(1)
    end.to change(Review.first.review_likes, :count).by(1)

    # 注目のレビューと最近のレビューのいいねが1になる
    visit "/"
    expect(page).to have_content('いいね！1', count: 2)

    # 検索一覧のレビューページのいいねが1になる
    visit "/search?type=review"
    expect(page).to have_content('いいね！1', count: 1)

    # ユーザページのいいね実績が1になり、表示されるレビューのいいねも1になる
    visit "/users/#{user.id}"
    click_link "いいね！(1)"
    expect(page).to have_content('いいね！1', count: 1)

    # ユーザページのレビュー実績のいいねが1になる
    visit "/users/#{Review.first.user_id}"
    expect(page).to have_content('いいね！1', count: 1)

    # レビューでいいね取り消し
    expect do
      visit "/items/#{Item.first.id}"
      click_link "いいね！1"
      sleep(1)
    end.to change(Review.first.review_likes, :count).by(-1)

    # 注目のレビューと最近のレビューのいいねが0になる
    visit "/"
    expect(page).to have_content('いいね！1', count: 0)

    # 検索一覧のレビューページのいいねが0になる
    visit "/search?type=review"
    expect(page).to have_content('いいね！1', count: 0)

    # ユーザページのいいね実績が0になり、表示されるレビューのいいねも0になる
    visit "/users/#{user.id}"
    click_link "いいね！(0)"
    expect(page).to have_content('いいね！1', count: 0)

    # ユーザページのレビュー実績のいいねが0になる
    visit "/users/#{Review.first.user_id}"
    expect(page).to have_content('いいね！1', count: 0)
  end
end
