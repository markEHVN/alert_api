class Blog < ApplicationRecord
  belongs_to :user

  enum :status, { draft: 0, published: 1, archived: 2 }

  validates :title, presence: true
  validates :status, presence: true

  before_update :set_publish_at, if: :will_save_change_to_status?

  private

  def set_publish_at
    self.publish_at = Time.current if status == "published"
  end
end
