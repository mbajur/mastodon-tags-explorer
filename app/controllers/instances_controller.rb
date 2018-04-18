class InstancesController < ApplicationController
  def index
    @instances = Instance.all
                         .order(host: :asc)
                         .page(params[:page])
                         .per(26)
  end

  def show
    @instance = Instance.find(params[:id])
    @tags = @instance.tags
                     .order(taggings_count: :desc)
                     .uniq
  end
end
