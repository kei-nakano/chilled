require 'rails_helper'

RSpec.feature "Items", type: :feature do
  # 管理者ユーザーは新しい商品を作成する
  scenario "user creates a new item", js: true do
    user = FactoryBot.create(:user)
    user.update(admin: true)

    visit "/"
    click_link "ログイン"
    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "ログイン"
    # click_link "商品投稿"
    # expect do
    #  click_link "New Project"
    #  fill_in "Name", with: "Test Project"
    #  fill_in "Description", with: "Trying out Capybara"
    #  click_button "Create Project"
    #
    #  expect(page).to have_content "Project was successfully created"
    #  expect(page).to have_content "Test Project"
    #  expect(page).to have_content "Owner: #{user.name}"
    # end.to change(Item.all, :count).by(1)
  end

  scenario "guest adds a project" do
    visit "/"
    click_link "ログイン"
  end
end
