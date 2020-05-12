require 'rails_helper'

RSpec.describe 'User', type: :model do
  describe 'validates presence of name ' do
    context 'no name' do
      it 'is not valid' do
        user = User.create(name: "", email: "test@gmail.com", password: "12345678")
        expect(user).not_to be_valid
        expect(user.errors).to be_added(:name, :blank)
      end
    end

    context 'name is present' do
      it 'is valid' do
        user = User.create(name: "taka", email: "test@gmail.com", password: "12345678")
        expect(user).to be_valid
      end
    end
  end
end
