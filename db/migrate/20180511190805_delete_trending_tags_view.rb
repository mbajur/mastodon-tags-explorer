class DeleteTrendingTagsView < ActiveRecord::Migration[5.2]
  def up
    execute "DROP MATERIALIZED VIEW trending_tags"
  end
end
