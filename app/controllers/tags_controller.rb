class TagsController < ApplicationController
  def index
    @page_title = 'Trending tags'
    @tags = TrendingTag.order_by_popularity
                       .where('count_all > 0')
                       .where('count_recent > ?', ENV.fetch('MIN_COUNT_RECENT_FOR_TRENDING', 6))
                       .first(25)
  end

  def popular
    @page_title = 'Popular tags'
    @tags = Gutentag::Tag.all
                         .order(taggings_count: :desc)
                         .page(params[:page])
    render :index
  end

  def broad
    @page_title = 'Broad tags'
    @tags = Gutentag::Tag.all
                         .order(instances_count: :desc)
                         .page(params[:page])
    render :index
  end

  def all
    @page_title = 'All tags'
    @tags = Gutentag::Tag.all
                         .order(name: :asc)
                         .page(params[:page])

    @tags = apply_search(@tags)

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

  private

  def apply_search(tags)
    return tags if !params[:q].present?

    query = params[:q].delete('#').downcase
    tags.where('name LIKE ?', "%#{query}%")
  end
end
