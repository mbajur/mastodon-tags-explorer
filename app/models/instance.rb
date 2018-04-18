class Instance < ApplicationRecord
  has_many :toots
  has_many :tags, through: :toots
end
