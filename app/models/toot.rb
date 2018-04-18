class Toot < ApplicationRecord
  Gutentag::ActiveRecord.call self

  belongs_to :instance
end
