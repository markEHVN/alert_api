class CreateAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :alerts do |t|
      t.string :title
      t.text :message
      t.string :severity
      t.string :category
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.datetime :acknowledged_at
      t.datetime :resolved_at
      t.json :metadata

      t.timestamps
    end
  end
end
