class TrendingTag < ActiveRecord::Base
  self.primary_key = "id"

  scope :order_by_popularity, -> { order('count_recent / count_all DESC') }

  def readonly?
    true
  end

  def self.refresh
    Scenic
      .database
      .refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
