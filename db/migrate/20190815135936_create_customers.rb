class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :customer_name, null: false
      t.string :customer_name_kana, null: false
      t.string :customer_initial, null: false
      t.string :postal_code
      t.string :address
      t.string :tel
      t.string :fax
      t.string :remarks
      t.boolean :is_deleted, null: false, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
