class TrendingTag < ActiveRecord::Base
  scope :order_by_popularity, -> { order('count_current - count_old DESC') }

  def readonly?
    true
  end

  def self.refresh
    Scenic
      .database
      .refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
