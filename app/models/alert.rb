class Alert < ApplicationRecord
  after_create :log_creation

  belongs_to :user
  has_many :alert_subscriptions, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :message, presence: true, length: { maximum: 5000 }
  validates :severity, inclusion: { in: %w[low medium high critical] }
  validates :category, presence: true

  enum :status, {
    active: 0,
    acknowledged: 1,
    resolved: 2,
    dismissed: 3
  }

  scope :unread, -> { where(status: :active) }
  scope :by_severity, ->(severity) { where(severity: severity) }
  scope :by_category, ->(category) { where(category: category) }
  scope :recent, -> { order(created_at: :desc) }

  def acknowledge!(user = nil)
    update!(
      status: :acknowledged,
      acknowledged_at: Time.current,
      metadata: metadata.merge(acknowledged_by: user&.id)
    )
  end

  def resolve!(user)
    update!(
      status: :resolved,
      resolved_at: Time.current,
      metadata: metadata.merge(resolved_by: user&.id)
    )
  end

  def high_priority?
    severity.in?(%w[high critical])
  end

  def overdue?
    active? && created_at < 24.hours.ago
  end

  private

  def log_creation
    Rails.logger.info("[Alert] created id=#{id} user_id=#{user_id}")
  end
end
