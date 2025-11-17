class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :content
      t.string :status
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
