class Notches::Hit < ActiveRecord::Base
  self.table_name = "notches_hits"

  validates :url,     :presence => true
  validates :session, :presence => true
  validates :ip,      :presence => true

  validates_associated :url, :session, :ip

  belongs_to :url,     :foreign_key => :notches_url_id, :class_name => "URL"
  belongs_to :session, :foreign_key => :notches_session_id
  belongs_to :ip,      :foreign_key => :notches_ip_id, :class_name => "IP"
  belongs_to :date,    :foreign_key => :notches_date_id
  belongs_to :time,    :foreign_key => :notches_time_id

  scope :unique, group("notches_url_id, notches_session_id, notches_ip_id")

  def self.log(attributes)
    hit = self.new
    hit.transaction do
      hit.url = Notches::URL.find_or_create_by_url(attributes[:url])
      hit.session = Notches::Session.find_or_create_by_session_id(attributes[:session_id])
      hit.ip = Notches::IP.find_or_create_by_ip(attributes[:ip])
      hit.date = Notches::Date.find_or_create_by_date(Date.today)
      hit.time = Notches::Time.find_or_create_by_time(Time.now)
      hit.save! rescue ActiveRecord::RecordNotUnique
    end
    hit
  end
end
