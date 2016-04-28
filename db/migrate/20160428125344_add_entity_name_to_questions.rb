class AddEntityNameToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :entity_name, :string
    add_index :questions, :entity_name
  end
end
