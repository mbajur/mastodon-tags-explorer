class StatsController < ApplicationController
  def index
    @page_title = 'Global stats'
    @page_description = 'Global statistics for Mastodon Tags Explorer'
  end
end
