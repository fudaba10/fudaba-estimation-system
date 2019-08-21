class RenameTypeColumnToEstimateDetails < ActiveRecord::Migration[5.2]
  def change
    rename_column :estimate_details, :type, :kind
  end
end
