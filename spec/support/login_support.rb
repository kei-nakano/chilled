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
end

RSpec.configure do |config|
  config.include LoginSupport
end
