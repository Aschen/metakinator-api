class RemoveSportIdFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :sport_id, :string
  end
end
