class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :employee_name, null: false
      t.string :employee_name_kana, null: false
      t.string :login_id, null: false, unique: true
      t.string :password_digest, null: false
      t.string :email, unique: true
      t.boolean :admin, null: false, default: false
      t.boolean :is_deleted, null: false, default: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
