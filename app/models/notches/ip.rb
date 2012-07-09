class Notches::IP < ActiveRecord::Base
  self.table_name = "notches_ips"

  has_many :hits, :class_name => "Notches::Hit",
                  :foreign_key => 'notches_ip_id'

  validates :ip, :presence => true, :allow_blank => false
end
