FactoryBot.define do
  factory :note do
    sequence(:title) { |n| "MyString#{n}" }
    content { "MyString" }
  end
end
