# @author Craig Read
#
# RaidsHelper provides helper methods
# for Raid related views.
module RaidsHelper
  def raid_select(drop)
    selected_date = get_selected_raid(drop)
    haml_tag :select, :id => 'drop_raid_id', :include_blank => 'Select Raid' do
      haml_tag :option, 'Select Raid', :id => '0', :value => '0', :selected => (selected_date == 'Select Raid')
      Raid.order('raid_date desc').each do |raid|
        haml_tag :option,
                 raid.raid_date,
                 :id => raid.id,
                 :value => raid.id,
                 :selected => ((selected_date != 'Select Raid') and
                     selected_date == raid.raid_date)
      end
    end
  end

  def get_selected_raid(drop)
    return drop.instance.raid.raid_date if drop.instance and drop.instance.raid
    'Select Raid'
  end
end