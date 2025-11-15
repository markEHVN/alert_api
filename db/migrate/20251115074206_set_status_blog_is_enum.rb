class SetStatusBlogIsEnum < ActiveRecord::Migration[8.0]
  def change
    remove_column :blogs, :status
    add_column :blogs, :status, :integer, default: 0
  end
end
