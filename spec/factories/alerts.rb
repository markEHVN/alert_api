FactoryBot.define do
  factory :alert do
    title { "Test Alert" }
    message { "This is a test alert message" }
    severity { "medium" }
    category { "system" }
    status { "active" }
    metadata { {} }
    association :user

    trait :high_severity do
      severity { "high" }
    end

    trait :critical_severity do
      severity { "critical" }
    end

    trait :acknowledged do
      status { "acknowledged" }
      acknowledged_at { Time.current }
    end

    trait :resolved do
      status { "resolved" }
      resolved_at { Time.current }
    end
  end
end
