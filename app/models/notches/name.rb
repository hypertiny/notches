class Notches::Name < ActiveRecord::Base
  self.table_name = "notches_names"

  has_many :events, class_name: Notches::Event.to_s,
                    foreign_key: "notches_name_id"

  validates :name, presence: true
end
