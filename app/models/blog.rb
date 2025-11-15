class Blog < ApplicationRecord
  belongs_to :user

  enum :status, { draft: 0, published: 1, archived: 2 }

  validates :title, presence: true
  validates :status, presence: true
end
