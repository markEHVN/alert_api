FactoryBot.define do
  factory :blog do
    title { "MyString" }
    content { "MyString" }
    status { :draft }
    association :user

    trait :published do
      status { :published }
    end

    trait :archived do
      status { :archived }
    end
  end
end
