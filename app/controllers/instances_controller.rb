class InstancesController < ApplicationController
  def index
    @page_title = 'Popular instances'

    @instances = Instance.all
                         .left_joins(:tags)
                         .group(:id)
                         .order('COUNT(gutentag_tags.id) DESC')

    @instances = @instances.page(params[:page]).per(26)
  end

  def alphabetical
    @page_title = 'All instances'

    @instances = Instance.all
                         .order(host: :asc)

    @instances = @instances.search(params[:q]) if params[:q].present?

    @instances = @instances.page(params[:page]).per(26)

    render :index
  end

  def show
    @instance = Instance.find_by!(host: params[:id])

    @page_title = @instance.host
    @page_description = "#{@instance.host} statistics on Mastodon Tags Explorer"

    @tags = @instance.tags
                     .order(taggings_count: :desc)
                     .distinct
                     .page(params[:page])
  end
end
