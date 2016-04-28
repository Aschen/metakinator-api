class DropSports < ActiveRecord::Migration
  def change
    drop_table :sports
  end
end
