require 'rails_helper'

RSpec.feature "Messages", type: :feature do
  # トークルームに入り、ユーザにメッセージを送れること
  # 相手がルームに入った後、メッセージのステータスが既読に変化すること
  scenario "user can send messages and when they are read, their status will change to already read", js: true do
    # 事前処理
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)

    # 一般ユーザでログイン
    feature_login(user)
    sleep(1)
    # 自身のプロフィールページでステータスがアクティブになること
    visit "/users/#{user.id}"
    expect(page).to have_content('(アクティブ)', count: 1)

    # ユーザの検索一覧ページでアクティブアイコンが表示されること
    visit "/search?type=user"
    expect(page).to have_css('.active-icon', count: 1)

    # 相手ユーザのプロフィールでトークルームに入る
    # トークルームが作成され、自分と相手のエントリーも作成される
    expect do
      visit "/users/#{other_user.id}"
      find(".dm-area").click_link "メッセージ"
      sleep(1)
    end.to change(Room.all, :count).by(1) and change(Entry.all, :count).by(2)

    # メッセージを作成
    expect do
      fill_in "room-speaker", with: "test message"
      click_button "決定"
      sleep(1)
    end.to change(user.messages, :count).by(1)

    # フォームのリセットがされること
    expect(find("textarea#room-speaker").value).to eq ""

    # 自分から見て、メッセージのステータスが未読となること
    expect(page).to have_content('未読', count: 1)

    # ログアウト
    click_link "ログアウト"

    # 相手ユーザでログイン
    feature_login(other_user)

    # ヘッダーの未読カウントが1になる
    expect(page).to have_content('メッセージ 1', count: 1)

    # トーク相手一覧に未読メッセージの説明が入る
    find('.dm-area').click_link 'メッセージ'
    expect(page).to have_content('未読のメッセージが1件あります', count: 1)

    # トークルームに入る
    click_link user.name

    # トーク相手一覧の未読メッセージの説明が消える
    visit '/rooms'
    expect(page).to have_content('未読のメッセージが1件あります', count: 0)

    # ログアウト
    click_link "ログアウト"

    # 一般ユーザでログイン
    feature_login(user)

    # メッセージが既読になっていること
    visit "/rooms/#{user.room_with(other_user).id}?user_id=#{other_user.id}"
    expect(page).to have_content('既読', count: 1)
    expect(page).to have_content('未読', count: 0)
  end
end
