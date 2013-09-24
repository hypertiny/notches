class Notches::UserSession < ActiveRecord::Base
  self.table_name = "notches_user_sessions"

  validates :user_id, :presence => true
  validates :session, :presence => true

  belongs_to :session, :foreign_key => :notches_session_id
end
