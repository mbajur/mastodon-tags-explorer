require 'elasticsearch/model'

class Toot < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  Gutentag::ActiveRecord.call self

  belongs_to :instance
  has_many :trending_tags, through: :taggings

  after_save    { IndexerWorker.perform_async(:index,  id) }
  after_destroy { IndexerWorker.perform_async(:delete, id) }

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :tag_names, type: :keyword
      indexes :language, type: :keyword
      indexes :created_at, type: :date
      indexes :instance do
        indexes :host, type: :keyword
      end
    end
  end

  def as_indexed_json(_options={})
    self.as_json(
      only: [:id, :language, :created_at, :guid, :sensitive, :tag_names],
      include: {
        instance: { only: :host },
      })
  end
end
