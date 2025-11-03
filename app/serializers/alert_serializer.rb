class AlertSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :message, :severity, :category, :status, :metadata

  attribute :created_at do |alert|
    alert.created_at.iso8601
  end

  attribute :updated_at do |alert|
    alert.updated_at.iso8601
  end

  attribute :acknowledged_at do |alert|
    alert.acknowledged_at&.iso8601
  end

  attribute :resolved_at do |alert|
    alert.resolved_at&.iso8601
  end

  attribute :is_overdue do |alert|
    alert.overdue?
  end

  attribute :is_high_priority do |alert|
    alert.high_priority?
  end

  belongs_to :user, serializer: UserSerializer
  has_many :alert_subscriptions, serializer: AlertSubscriptionSerializer
end
