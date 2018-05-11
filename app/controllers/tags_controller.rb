class TagsController < ApplicationController
  def index
    @page_title = 'Trending tags'
    tags = TagsQuery.new.trending
    @tags = tags.buckets
  end

  def popular
    @page_title = 'Popular tags'
    @tags = TagsQuery.new.popular.page(params[:page])
    render :index
  end

  def broad
    @page_title = 'Broad tags'
    @tags = TagsQuery.new.broad.page(params[:page])
    render :index
  end

  def all
    @page_title = 'All tags'
    tags = TagsQuery.new.all
    tags = TagsQuery.new(tags).search(params[:q]) if params[:q].present?
    @tags = tags.page(params[:page])

    render :index
  end

  def show
    @tag = Gutentag::Tag.find_by!(name: params[:id])

    @page_title = "##{@tag.name}"
    @page_description = "##{@tag.name} hashtag statistics on Mastodon Tags Explorer"

    @instances_count = Instance.where(
      id: Toot.tagged_with(names: [@tag.name]).select(:instance_id)
    ).count

    @instances = Instance.all
                         .left_joins(:tags)
                         .group(:id)
                         .order('COUNT(gutentag_tags.id) DESC')
                         .where('gutentag_tags.name = ?', @tag.name)
                         .limit(6)
  end
end
