class CreateVendors < ActiveRecord::Migration[5.2]
  def change
    create_table :vendors do |t|
      t.string :vendor_name, null: false
      t.string :vendor_name_kana, null: false
      t.string :postal_code
      t.string :address
      t.string :tel
      t.string :fax
      t.boolean :is_deleted, null: false, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
