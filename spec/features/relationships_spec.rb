require 'rails_helper'

RSpec.feature "Relationships", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  # ユーザに対して、ボタンをクリックして「フォロー」を作成し、各ページのフォロー数が変化すること。
  # また、フォロー解除ができること
  scenario "user can follow and unfollow", js: true do
    # 事前作成
    FactoryBot.create(:item)

    # ログイン
    login_rspec user

    # プロフィールに移動
    visit "/users/#{user.id}"
    expect(page).to have_content('フォロー(0)')
    expect(page).to have_content('フォロワー(0)')

    # フォローを実行
    expect do
      visit "/users/#{other_user.id}"
      click_link "フォロー"
      sleep(1)
    end.to change(user.following, :count).by(1)

    # userのフォローが1になる
    visit "/users/#{user.id}"
    click_link "フォロー(1)"
    expect(page).to have_content(other_user.name.to_s, count: 1)
    expect(page).to have_content("フォロワー(1)", count: 1) # other_userのフォロワー
    expect(page).to have_content("フォロー(0)", count: 1) # other_userのフォロー

    # other_userのフォロワーが1になる
    visit "/users/#{other_user.id}"
    click_link "フォロワー(1)"
    expect(page).to have_content(user.name.to_s, count: 1)
    expect(page).to have_content("フォロー(1)", count: 1) # userのフォロワー
    expect(page).to have_content("フォロワー(0)", count: 1) # userのフォロー

    # 被フォロー状態作成
    other_user.follow(user)

    # ユーザ検索結果
    visit "/search?type=user"
    expect(page).to have_content("フォローしています", count: 1) # other_user
    expect(page).to have_content("フォローされています", count: 1) # other_user

    # アンフォローを実行
    expect do
      visit "/users/#{other_user.id}"
      click_link "フォロー解除"
      sleep(1)
    end.to change(user.following, :count).by(-1)
  end
end
