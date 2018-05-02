class UpdateTrendingTagsToVersion5 < ActiveRecord::Migration[5.2]
  def change
    update_view :trending_tags,
      version: 5,
      revert_to_version: 4,
      materialized: true
  end
end
