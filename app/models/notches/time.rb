class Notches::Time < ActiveRecord::Base
  self.table_name = "notches_times"

  has_many :hits, :class_name => "Notches::Hit",
                  :foreign_key => 'notches_time_id'

  def self.find_or_create_by_time(time)
    where("time(time) = ?", time.strftime("%H:%M:%S")).first.presence || create(time: time)
  end
end
