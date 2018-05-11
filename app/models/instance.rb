class Instance < ApplicationRecord
  include PgSearch

  has_many :toots
  has_many :tags, through: :toots

  pg_search_scope :search, against: :host, using: { tsearch: { prefix: true } }
end
