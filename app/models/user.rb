class User < ApplicationRecord
  has_many :alerts, dependent: :destroy
  has_many :alert_subscriptions, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  before_create :generate_auth_token

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def unread_alerts_count
    alerts.unread.count
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.hex(20)
  end
end
