class CreateEstimateDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :estimate_details do |t|
      t.string :product_name, null: false
      t.string :detail
      t.integer :quantity, null: false, default: 1
      t.string :type, null: false, default: 'PC'
      t.integer :unit_price, null: false, default: 0
      t.integer :total_fee, null: false, default: 0
      t.integer :tax, null: false, default: 0
      t.integer :tax_amount, null: false, default: 0
      t.string :delivery_period
      t.references :vendor, foreign_key: true, null: false
      t.references :estimate_header, foreign_key: true, null: false
      t.integer :estimate_detail_id, null: false

      t.timestamps
    end
  end
end
