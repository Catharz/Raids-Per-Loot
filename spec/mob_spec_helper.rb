module MobSpecHelper
  def create_mobs(zone, num_mobs)
    mob_list = []
    mobs = (1..num_mobs).to_a
    mobs.each do |mob_num|
      mob_list << mock_model(Mob, :zone => zone, :name => "Zone #{mob_num.to_s}")
    end
    mob_list
  end

  def create_mob(zone)
    create_mobs(zone, 1)[0]
  end
end