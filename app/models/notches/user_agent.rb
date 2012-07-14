class Notches::UserAgent < ActiveRecord::Base
  self.table_name = "notches_user_agents"

  has_many :hits, :class_name => "Notches::Hit"
end
