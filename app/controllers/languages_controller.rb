class LanguagesController < ApplicationController
  def index
    @page_title = 'Languages'
    @page_description = 'Languages used on Mastodon Tags Explorer'

    @languages = Toot.all
                     .group(:language)
                     .count
                     .map { |l| { name: l[0], info: LanguageList::LanguageInfo.find(l[0]), count: l[1] } }
                     .reject { |l| !l[:info].present? }
                     .sort { |a, b| b[:count] <=> a[:count] }
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
