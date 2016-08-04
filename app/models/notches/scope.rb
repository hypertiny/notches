class Notches::Scope < ActiveRecord::Base
  self.table_name = "notches_scopes"

  has_many :events, class_name: Notches::Event.to_s,
                    foreign_key: "notches_scope_id"

  validates :scope, presence: true
end
