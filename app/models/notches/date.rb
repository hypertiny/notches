class Notches::Date < ActiveRecord::Base
  self.table_name = "notches_dates"

  has_many :hits, :class_name => "Notches::Hit"
end
