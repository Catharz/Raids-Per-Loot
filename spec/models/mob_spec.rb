require 'spec_helper'

describe Mob do
  describe 'progression' do
    context 'should be a progression mob' do
      it 'if killed less than 10 times and normal or lower difficulty' do
        normal = FactoryGirl.create(:difficulty, name: 'Normal', rating: 2)
        mob = FactoryGirl.create(:mob, name: 'New Mob', difficulty: normal)
        mob.stub(:kills).and_return(9)

        mob.progression.should be_true
        mob.is_progression?.should eq 'Yes'
      end

      it 'if mob is hard to kill' do
        hard = FactoryGirl.create(:difficulty, name: 'Hard', rating: 3)
        mob = FactoryGirl.create(:mob, name: 'Hard Mob', difficulty: hard)
        mob.stub(:kills).and_return(15)

        mob.progression.should be_true
        mob.is_progression?.should eq 'Yes'
      end
    end

    context 'should not be a progression mob' do
      it 'if mob is easy to kill' do
        easy = FactoryGirl.create(:difficulty, name: 'Easy', rating: 1)
        mob = FactoryGirl.create(:mob, name: 'Easy Mob', difficulty: easy)
        mob.stub(:kills).and_return(5)

        mob.progression.should be_false
        mob.is_progression?.should eq 'No'
      end

      it 'if mob is killed more than 20 times' do
        hard = FactoryGirl.create(:difficulty, name: 'Hard', rating: 3)
        mob = FactoryGirl.create(:mob, name: 'Hard Mob', difficulty: hard)
        mob.stub(:kills).and_return(21)

        mob.progression.should be_false
        mob.is_progression?.should eq 'No'
      end
    end
  end

  describe '#difficulty_name' do
    it 'should show the difficulty name when set' do
      hard = FactoryGirl.create(:difficulty, name: 'Hard', rating: 3)
      mob = FactoryGirl.create(:mob, name: 'Hard Mob', difficulty: hard)

      mob.difficulty_name.should eq 'Hard'
    end
  end

  describe '#zone_name' do
    it 'should return the zone name when set' do
      zone = FactoryGirl.create(:zone, name: 'Wherever')
      mob = FactoryGirl.create(:mob, name: 'Pinyata', zone_id: zone.id)

      mob.zone_name.should eq 'Wherever'
    end
  end

  describe '#first_killed' do
    it 'should return the first drop date if drops exist' do
      zone = FactoryGirl.create(:zone, name: 'Wherever')
      mob = FactoryGirl.create(:mob, name: 'Pinyata', zone_id: zone.id)
      character = FactoryGirl.create(:character, name: 'Whoever')
      item = FactoryGirl.create(:item, name: 'Whatever', eq2_item_id: '123')
      first_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-01-31 18:00'))
      second_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-02-28 18:00'))
      third_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-03-31 18:00'))

      FactoryGirl.create(:drop,
                         instance_id: first_instance.id,
                         mob_id: mob.id,
                         drop_time: DateTime.parse('31/01/2012 18:00'),
                         zone_id: zone.id,
                         character_id: character.id,
                         item_id: item.id)
      FactoryGirl.create(:drop,
                         instance_id: second_instance.id,
                         mob_id: mob.id,
                         drop_time: DateTime.parse('28/02/2012 18:00'),
                         zone_id: zone.id,
                         character_id: character.id,
                         item_id: item.id)
      FactoryGirl.create(:drop,
                         instance_id: third_instance.id,
                         mob_id: mob.id,
                         drop_time: DateTime.parse('31/03/2012 18:00'),
                         zone_id: zone.id,
                         character_id: character.id,
                         item_id: item.id)

      mob.first_killed.should eq DateTime.parse('31/01/2012 18:00')
    end

    it 'should return nil if no drops exist' do
      zone = FactoryGirl.create(:zone, name: 'Wherever')
      mob = FactoryGirl.create(:mob, name: 'Pinyata', zone_id: zone.id)

      mob.first_killed.should be_nil
    end
  end

  describe '#last_killed' do
    it 'should return the last drop date if drops exist' do
      zone = FactoryGirl.create(:zone, name: 'Wherever')
      mob = FactoryGirl.create(:mob, name: 'Pinyata', zone_id: zone.id)
      character = FactoryGirl.create(:character, name: 'Whoever')
      item = FactoryGirl.create(:item, name: 'Whatever', eq2_item_id: '123')
      first_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-01-31 18:00'))
      second_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-02-28 18:00'))
      third_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-03-31 18:00'))

      FactoryGirl.create(:drop,
                         instance_id: first_instance.id,
                         mob_id: mob.id,
                         drop_time: DateTime.parse('31/01/2012 18:00'),
                         zone_id: zone.id,
                         character_id: character.id,
                         item_id: item.id)
      FactoryGirl.create(:drop,
                         instance_id: second_instance.id,
                         mob_id: mob.id,
                         drop_time: DateTime.parse('28/02/2012 18:00'),
                         zone_id: zone.id,
                         character_id: character.id,
                         item_id: item.id)
      FactoryGirl.create(:drop,
                         instance_id: third_instance.id,
                         mob_id: mob.id,
                         drop_time: DateTime.parse('31/03/2012 18:00'),
                         zone_id: zone.id,
                         character_id: character.id,
                         item_id: item.id)

      mob.last_killed.should eq DateTime.parse('31/03/2012 18:00')
    end

    it 'should return be nil if no drops exist' do
      zone = FactoryGirl.create(:zone, name: 'Wherever')
      mob = FactoryGirl.create(:mob, name: 'Pinyata', zone_id: zone.id)

      mob.last_killed.should be_nil
    end
  end

  describe '#kills' do
    it 'returns the number of times a mob has been killed' do
      zone = FactoryGirl.create(:zone)
      mob = FactoryGirl.create(:mob, zone: zone)

      first_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-01-31 18:00'),
                             zone: zone)
      second_instance =
          FactoryGirl.create(:instance,
                             start_time: DateTime.parse('2012-02-28 18:00'),
                             zone: zone)
      third_instance =
          FactoryGirl.create(:instance,
                             start_time:
                                 DateTime.parse('2012-03-31 18:00'),
                             zone: zone)

      FactoryGirl.create(:drop,
                         instance: first_instance,
                         mob: mob,
                         drop_time: DateTime.parse('31/01/2012'),
                         zone: zone)
      FactoryGirl.create(:drop,
                         instance: second_instance,
                         mob: mob,
                         drop_time: DateTime.parse('28/02/2012'),
                         zone: zone)
      FactoryGirl.create(:drop,
                         instance: third_instance,
                         mob: mob,
                         drop_time: DateTime.parse('31/03/2012'),
                         zone: zone)

      mob.kills.should eq 3
    end
  end
end