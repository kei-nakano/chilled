require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  # 一般ユーザでコメント作成、編集、削除ができること
  scenario "user can create, edit and destroy a comment", js: true do
    review = FactoryBot.create(:review)
    item = Item.find(review.item_id)

    # 一般ユーザでログイン
    user = FactoryBot.create(:user)
    feature_login user

    # 商品ページへ
    visit "/items/#{item.id}"

    # コメント作成(キャンセル)
    expect do
      click_link "コメントする"
      fill_in "comment[content]", with: "コメント作成"
      click_button "キャンセル"
      sleep(1)
    end.to change(user.comments, :count).by(0)

    # コメント作成
    expect do
      click_link "コメントする"
      expect(find("textarea#comment_content").value).to eq ""
      fill_in "comment[content]", with: "コメント作成"
      click_button "決定"
      sleep(1)
    end.to change(user.comments, :count).by(1)
    expect(page).to have_content('コメント作成', count: 1)

    # コメント編集(キャンセル)
    expect do
      click_link "編集"
      expect(find("textarea#comment_content").value).to eq "コメント作成"
      fill_in "comment[content]", with: "コメント編集"
      click_button "キャンセル"
      sleep(1)
    end.to change(user.comments, :count).by(0)

    # コメント編集
    expect do
      click_link "編集"
      expect(find("textarea#comment_content").value).to eq "コメント作成"
      fill_in "comment[content]", with: "コメント編集"
      click_button "決定"
      sleep(1)
    end.to change(user.comments, :count).by(0)
    expect(page).to have_content('コメント編集', count: 1)

    # コメント削除
    expect do
      click_link "削除"
      sleep(1)
    end.to change(user.comments, :count).by(-1)
    expect(page).to have_content('コメント編集', count: 0)
  end
end
