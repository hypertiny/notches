class Notches::Time < ActiveRecord::Base
  self.table_name = "notches_times"

  has_many :hits, :class_name => "Notches::Hit",
                  :foreign_key => 'notches_time_id'
end
