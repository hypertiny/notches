class Notches::URL < ActiveRecord::Base
  self.table_name = "notches_urls"

  has_many :hits, :class_name => "Notches::Hit",
                  :foreign_key => 'notches_url_id'

  validates :url, :presence => true
end
