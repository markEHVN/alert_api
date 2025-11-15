class AddPublishAtToBlogs < ActiveRecord::Migration[8.0]
  def change
    add_column :blogs, :publish_at, :datetime
  end
end
