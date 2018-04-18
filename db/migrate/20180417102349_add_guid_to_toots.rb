class AddGuidToToots < ActiveRecord::Migration[5.2]
  def change
    add_column :toots, :guid, :string
    add_index :toots, :guid
  end
end
