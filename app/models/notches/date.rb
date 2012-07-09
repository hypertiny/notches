class Notches::Date < ActiveRecord::Base
  self.table_name = "notches_dates"

  has_many :hits, :class_name => "Notches::Hit",
                  :foreign_key => 'notches_date_id'
end
