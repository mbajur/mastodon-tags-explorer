class InstancesController < ApplicationController
  def index
    @page_title = 'Trending instances'

    instances = InstancesQuery.new.trending
    @instances = instances.buckets
  end

  def popular
    @page_title = 'Popular instances'

    @instances = InstancesQuery.new.popular.page(params[:page]).per(26)

    render :index
  end

  def alphabetical
    @page_title = 'All instances'

    instances = InstancesQuery.new.alphabetical
    instances = InstancesQuery.new(instances).search(params[:q]) if params[:q].present?

    @instances = instances.page(params[:page]).per(26)

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
