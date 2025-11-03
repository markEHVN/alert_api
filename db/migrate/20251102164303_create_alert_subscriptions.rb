class CreateAlertSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :alert_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :alert, null: false, foreign_key: true
      t.string :notification_method
      t.boolean :is_active

      t.timestamps
    end
  end
end
