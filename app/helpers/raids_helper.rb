module RaidsHelper
  def raid_select(drop)
    if drop.instance and drop.instance.raid
      selected_date = drop.instance.raid.raid_date
    else
      selected_date = 'Select Raid'
    end
    haml_tag :select, :id => "drop_raid_id", :include_blank => 'Select Raid' do
      haml_tag :option, 'Select Raid', :id => '0', :value => '0', :selected => (selected_date == 'Select Raid')
      Raid.order('raid_date desc').each do |raid|
        haml_tag :option, raid.raid_date, :id => raid.id, :value => raid.id, :selected => ((selected_date != 'Select Raid') and Date.parse(selected_date) == drop.drop_time.to_date)
      end
    end
  end
end