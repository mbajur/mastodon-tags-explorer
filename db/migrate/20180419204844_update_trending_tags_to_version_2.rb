class UpdateTrendingTagsToVersion2 < ActiveRecord::Migration[5.2]
  def change
    update_view :trending_tags,
      version: 2,
      revert_to_version: 1,
      materialized: true
  end
end
