FactoryBot.define do
  factory :tmp_deleted_message do
    association :user
    association :message
  end
end
