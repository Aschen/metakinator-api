class RenameColumnFromQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :entity_name, :entity_class
  end
end
