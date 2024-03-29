class Notches::Hit < ActiveRecord::Base
  self.table_name = "notches_hits"

  validates :url,     :presence => true
  validates :session, :presence => true
  validates :ip,      :presence => true

  validates_associated :url, :session, :ip

  belongs_to :url,        :foreign_key => :notches_url_id, :class_name => "Notches::URL"
  belongs_to :user_agent, :foreign_key => :notches_user_agent_id
  belongs_to :session,    :foreign_key => :notches_session_id
  belongs_to :ip,         :foreign_key => :notches_ip_id, :class_name => "Notches::IP"
  belongs_to :date,       :foreign_key => :notches_date_id
  belongs_to :time,       :foreign_key => :notches_time_id

  scope :unique, -> { group("notches_url_id, notches_session_id, notches_ip_id") }

  def self.log(attributes)
    attributes[:user_agent] ||= ''
    hit = self.new
    hit.transaction do
      Rails.logger.info("[Notches] Tracking #{attributes.inspect} at #{Date.today} #{Time.now}")
      now            = Time.zone.now
      hit.url        = Notches::URL.find_or_create_by(url: attributes[:url])
      hit.user_agent = Notches::UserAgent.find_or_create_by(
        user_agent_md5: Digest::MD5.hexdigest(attributes[:user_agent]),
        :user_agent => attributes[:user_agent]
      )
      hit.session = Notches::Session.find_or_create_by(session_id: attributes[:session_id])
      hit.ip      = Notches::IP.find_or_create_by(ip: attributes[:ip])
      hit.date    = Notches::Date.find_or_create_by(date: now.to_date)
      hit.time    = Notches::Time.find_or_create_by_time(now)

      if attributes[:user_id].present?
        Notches::UserSession.find_or_create_by(
          user_id: attributes[:user_id],
          notches_session_id: hit.session.id
        )
      end

      begin
        hit.save!
      rescue
        Rails.logger.info "Skipping non-unique hit"
      end
    end
    hit
  end
end
