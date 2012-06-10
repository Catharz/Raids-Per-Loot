module ZoneSpecHelper
  def create_zones(num_zones)
    zone_list = []
    zones = (1..num_zones).to_a
    zones.each do |zone_num|
      zone_list << mock_model(Zone, :name => "Zone #{zone_num.to_s}")
    end
    zone_list
  end

  def create_zone
    create_zones(1)[0]
  end
end