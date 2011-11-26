require 'active_support/core_ext'

class RaidValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << "Raid must start before it ends" unless record.start_time < record.end_time
    record.errors[:base] << "Raid date must be the same date as the raid start time" unless record.start_time.to_date.eql? record.raid_date
    record.errors[:base] << "Two raids cannot run simultaneously" unless !Raid.find_by_time(record.start_time)
  end
end