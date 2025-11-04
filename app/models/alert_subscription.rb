class AlertSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :alert

  validates :notification_method, inclusion: {
    in: %w[email sms slack],
    message: "must be one of: email, sms, slack"
  }
  validates :user_id, uniqueness: {
    scope: :alert_id,
    message: "User already subscribed to this alert"
  }

  scope :active, -> { where(is_active: true) }
  scope :by_method, ->(method) { where(notification_method: method) }
end
