require 'rails_helper'

RSpec.feature "Errors", type: :feature do
  # 各種エラーの発生に対し、404または500ページのレスポンスが返ること
  scenario "it returns 500 page if it raise StandardError", js: true do
    allow_any_instance_of(ErrorsController).to receive(:show).and_raise StandardError
    visit '/raise_error'
    expect(page).to have_content("500 Internal Server Error", count: 1)
  end

  scenario "it returns 404 page if it raise ActiveRecord::RecordNotFound", js: true do
    visit '/items/0'
    expect(page).to have_content("404 Not Found", count: 1)
  end

  scenario "it returns 404 page if it raise ActionController::RoutingError", js: true do
    visit '/raise_error'
    expect(page).to have_content("404 Not Found", count: 1)
  end
end
