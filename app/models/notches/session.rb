class Notches::Session < ActiveRecord::Base
  self.table_name = "notches_sessions"

  has_many :hits, :class_name => "Notches::Hit"

  validates :session_id, :presence => true
end
