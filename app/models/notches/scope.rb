class Notches::Scope < ActiveRecord::Base
  self.table_name = "notches_scopes"

  has_many :events, class_name: Notches::Event.to_s,
                    foreign_key: "notches_scope_id"

  validate :no_nulls
  validate :no_secondary_scope_without_primary

  private

  def no_nulls
    errors[:primary] << "can't be null"   if primary.nil?
    errors[:secondary] << "can't be null" if secondary.nil?
  end

  def no_secondary_scope_without_primary
    if secondary.present? && primary.blank?
      errors[:secondary] << "is invalid"
    end
  end
end
