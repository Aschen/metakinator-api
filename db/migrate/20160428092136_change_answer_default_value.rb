class ChangeAnswerDefaultValue < ActiveRecord::Migration
  def change
    change_column :answers, :answer, :integer, default: 3 # don't know
  end
end
