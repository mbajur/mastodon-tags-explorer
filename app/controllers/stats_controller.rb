class StatsController < ApplicationController
  def index
    @page_title = 'Global stats'
    @page_description = 'Global statistics for Mastodon Tags Explorer'

    @tags_count = Gutentag::Tag.all.count
    @toots_count = Toot.all.count
    @instances_count = Instance.all.count

    json_resp = {
      tags_count: @tags_count,
      toots_count: @toots_count,
      instances_count: @instances_count,
    }

    respond_to do |format|
      format.json { render json: json_resp }
      format.html { render :index }
    end
  end
end
