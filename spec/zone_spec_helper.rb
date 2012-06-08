module ZoneSpecHelper
  def create_zones(num_zones)
    zones = (1..num_zones).to_a
    zones.each do |zone_num|
      Zone.find_or_create_by_name("Zone #{zone_num.to_s}")
    end
    Zone.all
  end
end