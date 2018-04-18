class TagsController < ApplicationController
  def index
    @tags = Gutentag::Tag.all
                         .order(taggings_count: :desc)
                         .page(params[:page])
  end

  def popular
    @tags = Gutentag::Tag.all
                         .order(taggings_count: :desc)
                         .page(params[:page])
    render :index
  end

  def all
    @tags = Gutentag::Tag.all
                         .order(name: :asc)
                         .page(params[:page])

    @tags = @tags.where('name LIKE ?', "%#{params[:q]}%") if params[:q]

    render :index
  end

  def show
    @tag = Gutentag::Tag.find(params[:id])
    @instances = Instance.where(
      id: Toot.tagged_with(names: [@tag.name]).select(:instance_id)
    ).limit(6)
  end
end
