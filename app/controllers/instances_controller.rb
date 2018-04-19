class InstancesController < ApplicationController
  def index
    @instances = Instance.all
                         .left_joins(:tags)
                         .group(:id)
                         .order('COUNT(gutentag_tags.id) DESC')
                         .page(params[:page])
                         .per(26)
  end

  def alphabetical
    @instances = Instance.all
                         .order(host: :asc)
                         .page(params[:page])
                         .per(26)

    render :index
  end

  def show
    @instance = Instance.find(params[:id])
    @tags = @instance.tags
                     .order(taggings_count: :desc)
                     .uniq
  end
end
