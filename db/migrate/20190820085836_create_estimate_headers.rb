class CreateEstimateHeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :estimate_headers do |t|
      t.references :customer, foreign_key: true, null: false
      t.string :customer_person, null: false
      t.string :estimate_id, null: false
      t.references :employee, foreign_key: true, null: false
      t.boolean :is_deleted, null: false, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
