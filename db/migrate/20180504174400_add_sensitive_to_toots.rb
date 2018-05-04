class AddSensitiveToToots < ActiveRecord::Migration[5.2]
  def change
    add_column :toots, :sensitive, :boolean, default: false
  end
end
