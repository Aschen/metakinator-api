class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
