class AddIndexesToAlerts < ActiveRecord::Migration[8.0]
  def change
    add_index :alerts, [ :user_id, :status ]

    add_index :alerts, [ :severity, :created_at ]

    add_index :alerts, :category
  end
end
