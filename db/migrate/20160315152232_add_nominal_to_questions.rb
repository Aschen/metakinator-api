class AddNominalToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :nominal, :string
  end
end
