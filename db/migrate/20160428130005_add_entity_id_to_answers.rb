class AddEntityIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :entity_id, :integer
    add_index :answers, :entity_id
  end
end
