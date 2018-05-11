class LanguagesController < ApplicationController
  def index
    @page_title = 'Trending languages'
    @page_description = 'Languages trending on Mastodon Tags Explorer'

    @languages = LanguagesQuery.new.trending.buckets
  end

  def popular
    @page_title = 'Popular languages'
    @page_description = 'Languages popular on Mastodon Tags Explorer'

    @languages = LanguagesQuery.new.popular

    render :index
  end

  def show
    @toots = Toot.where(language: params[:id])
    @language = LanguageList::LanguageInfo.find(params[:id])

    @page_title = @language.name
    @page_description = "#{@language.name} language statsu on Mastodon Tags Explorer"

    @tags = Gutentag::Tag.joins('INNER JOIN gutentag_taggings ON gutentag_tags.id = gutentag_taggings.tag_id')
                         .joins('INNER JOIN toots ON gutentag_taggings.taggable_id = toots.id')
                         .where('toots.language = ?', params[:id])
                         .order(taggings_count: :desc)
                         .distinct
                         .page(params[:page])

    @instances = Instance.all
                         .joins(:toots)
                         .where('toots.language = ?', params[:id])
                         .distinct
  end
end
