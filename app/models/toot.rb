class Toot < ApplicationRecord
  Gutentag::ActiveRecord.call self

  belongs_to :instance
  has_many :trending_tags, through: :taggings
end
