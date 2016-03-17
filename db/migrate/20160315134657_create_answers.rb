class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :sport_id
      t.integer :question_id
      t.integer :answer

      t.timestamps null: false
    end
  end
end
