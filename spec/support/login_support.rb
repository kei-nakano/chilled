module LoginSupport
  def login_rspec(user)
    # login userの代替
    # ActionDispatch::Requestクラスの全インスタンスに対して、sessionメソッドが呼ばれた場合に、user_idを返す
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ user_id: user.id })
  end

  def logout_rspec(*)
    # logout userの代替
    # ActionDispatch::Requestクラスの全インスタンスに対して、sessionメソッドが呼ばれた場合に、nilを返す
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ user_id: nil })
  end

  def feature_login(user)
    visit "/"
    click_link "ログイン"
    fill_in "email", with: user.email
    fill_in "password", with: "Password12"
    click_button "ログイン"
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
