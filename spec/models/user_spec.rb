require 'rails_helper'

RSpec.describe 'User', type: :model do
  describe 'validates :name, presence: true' do
    context 'nameが存在しない' do
      example 'valid?がfalseになる' do
        user = User.create(name: "", email: "test@gmail.com", password: "test")
        expect(user.errors.full_messages.count).to eq 1
        expect(user.errors.full_messages).to eq ["Name can't be blank"]
      end
    end
    context 'emailが存在しない' do
      example 'valid?がfalseになる' do
        user = User.new(name: "test", email: "", password: "test")
        expect(user.errors.full_messages.count).to eq 1
        expect(user.errors.full_messages).to be "Name can't be blank"
      end
    end
  end
end
