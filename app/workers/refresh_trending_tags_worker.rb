require 'sidekiq-scheduler'

class RefreshTrendingTagsWorker
  include Sidekiq::Worker

  def perform
    TrendingTag.refresh
  end
end
