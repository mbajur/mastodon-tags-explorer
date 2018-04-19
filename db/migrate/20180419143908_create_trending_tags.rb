class CreateTrendingTags < ActiveRecord::Migration[5.2]
  def change
    create_view :trending_tags, materialized: true
  end
end
