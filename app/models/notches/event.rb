class Notches::Event < ActiveRecord::Base
  self.table_name = "notches_events"

  validates :name, presence: true

  validates_associated :name, :scope

  belongs_to :date,  foreign_key: :notches_date_id
  belongs_to :name,  foreign_key: :notches_name_id, :class_name => Name.to_s
  belongs_to :scope, foreign_key: :notches_scope_id, :class_name => Scope.to_s
  belongs_to :time,  foreign_key: :notches_time_id

  def self.log(attributes)
    event = self.new
    event.transaction do
      Rails.logger.info("[Notches] Tracking #{attributes.inspect} at #{Date.today} #{Time.now}")
      now            = Time.zone.now
      event.name  = Notches::Name.find_or_create_by(name: attributes[:name])
      event.scope = Notches::Scope.find_or_create_by(scope: attributes[:scope]) if attributes[:scope].present?
      event.date  = Notches::Date.find_or_create_by(date: now.to_date)
      event.time  = Notches::Time.find_or_create_by_time(now)

      begin
        event.save!
      rescue
        Rails.logger.info "Skipping non-unique event"
      end
    end
    event
  end
end
