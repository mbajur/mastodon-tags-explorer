class Gutentag::Tagging < ActiveRecord::Base
  self.table_name = "gutentag_taggings"

  belongs_to :taggable, :polymorphic => true
  belongs_to :tag, :class_name => "Gutentag::Tag", :counter_cache => true
  belongs_to :trending_tag, foreign_key: :tag_id

  validates :taggable, :presence => true
  validates :tag,      :presence => true
  validates :tag_id,   :uniqueness => {
    :scope => %i[ taggable_id taggable_type ]
  }
end
