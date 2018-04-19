class AddInstancesCountToGutentagTags < ActiveRecord::Migration[5.2]
  def change
    add_column :gutentag_tags, :instances_count, :integer, default: 0
  end
end
