require 'spec_helper'

describe StatisticsController do
  let(:achievement) {
    {
        'id' => 157673149,
        'completedtimestamp' => 1363951600,
        'category' => 'Guild Raid',
        'reward_list' => [],
        "subcategory" => "Chains of Eternity",
        "desc" => "Defeating Oligar of the Dead in the Harrow's End",
        "name" => "Guild: Defeating Oligar of the Dead",
        "previousid" => 0,
        "ts" => 1369837181.786264,
        "last_update" => 1369837181.786264,
        "isguildachievement" => 1,
        "event_list" => [
            {"quota" => 1, "desc" => "Defeating Oligar of the Dead"}],
        "points" => 10,
        "version" => 1,
        "nextid" => 0,
        "hidden" => 0,
        "icon" => 3905
    }
  }

  describe 'guild_achievements' do
    it 'assigns the achievements as @achievements' do
      SonyDataService.any_instance.
          should_receive(:guild_achievements).and_return([achievement])
      get :guild_achievements
      assigns(:achievements).should eq([achievement])
    end

    it 'renders the guild_achievements view' do
      get :guild_achievements
      response.should render_template 'guild_achievements'
    end
  end
end