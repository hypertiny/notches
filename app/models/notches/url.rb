class Notches::URL < ActiveRecord::Base
  self.table_name = "notches_urls"

  has_many :hits, :class_name => "Notches::Hit"

  validates :url, :presence => true
end
