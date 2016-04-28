class ChangeColumnNameFromEntities < ActiveRecord::Migration
  def change
    rename_column :entities, :title, :klass
  end
end
