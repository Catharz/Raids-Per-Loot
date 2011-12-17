require 'active_support/core_ext'

class RaidValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << "Raid must start before it ends" unless ends_after_start?(record)
    record.errors[:base] << "Raid date must be the same date as the raid start time" unless date_matches_start?(record)
    record.errors[:base] << "Two raids cannot run simultaneously" unless runs_singly?(record)
  end

  private

  def ends_after_start?(record)
    record.start_time < record.end_time
  end

  def date_matches_start?(record)
    record.start_time.to_date.eql? record.raid_date
  end

  def runs_singly?(record)
    result = true
    raid_list = Raid.find_by_time(record.start_time)
    raid_list.each do |raid|
      if !raid.id.eql? record.id
        result = false
      end
    end
    result
  end
end