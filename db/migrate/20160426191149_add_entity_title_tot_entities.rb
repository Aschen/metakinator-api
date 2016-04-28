class AddEntityTitleTotEntities < ActiveRecord::Migration
  def change
    add_column :entities, :title, :string
    add_index :entities, :title
  end
end
