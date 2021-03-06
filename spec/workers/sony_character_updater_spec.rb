require 'spec_helper'

describe SonyCharacterUpdater do
  subject { SonyCharacterUpdater }
  let(:character) { FactoryGirl.create(:character) }

  after(:each) do
    Resque.queues.each { |queue_name| Resque.remove_queue queue_name }
  end

  describe '#perform' do
    it 'raises an exception if there is no internet connect' do
      subject.stub(:internet_connection?).and_return(false)
      expect {
        subject.perform(character.id)
      }.to raise_exception Exception, 'Internet connection unavailable.'
    end

    it 'raises an exception the character data is nil' do
      subject.stub(:internet_connection?).and_return(true)
      Character.stub(:find).and_return(character)
      SonyDataService.any_instance.stub(:character_data).and_return(nil)

      expect {
        subject.perform(character.id)
      }.to raise_exception Exception, 'Could not obtain character details for ' + character.name
    end

    it 'raises an exception the character data is empty' do
      subject.stub(:internet_connection?).and_return(true)
      Character.stub(:find).and_return(character)
      SonyDataService.any_instance.stub(:character_data).and_return({}.with_indifferent_access)

      expect {
        subject.perform(character.id)
      }.to raise_exception Exception, 'Could not obtain character details for ' + character.name
    end

    context 'updating data' do
      let(:monk_character_data) { {type: {'class' => 'Monk'}}.with_indifferent_access }
      let(:monk) { Archetype.find_by_name('Monk') }
      let(:bruiser) { Archetype.find_by_name('Bruiser') }

      it 'deletes the external data if it exists' do
        subject.stub(:internet_connection?).and_return(true)
        Character.stub(:find).and_return(character)
        character.stub(:archetype_name).and_return('Monk')
        data = FactoryGirl.create(:external_data, data: monk_character_data)
        character.stub(:external_data).and_return(data)
        data.should_receive(:delete)
        SonyDataService.any_instance.stub(:character_data).and_return(monk_character_data)

        subject.perform(character.id)
      end

      it 'does not update the character unnecessarily' do
        subject.stub(:internet_connection?).and_return(true)
        Character.stub(:find).and_return(character)
        character.stub(:archetype_name).and_return('Monk')
        SonyDataService.any_instance.stub(:character_data).and_return(monk_character_data)

        character.should_not_receive(:update_attribute)
        subject.perform(character.id)
      end

      it 'updates the characters archetype when necessary' do
        subject.stub(:internet_connection?).and_return(true)
        Character.stub(:find).and_return(character)
        character.stub(:archetype_name).and_return('Bruiser')
        SonyDataService.any_instance.stub(:character_data).and_return(monk_character_data)

        character.should_receive(:update_attribute).with(:archetype, monk)
        subject.perform(character.id)
      end

      it 'build external data when it is nil' do
        subject.stub(:internet_connection?).and_return(true)
        Character.stub(:find).and_return(character)
        character.stub(:archetype_name).and_return('Bruiser')
        SonyDataService.any_instance.stub(:character_data).and_return(monk_character_data)

        character.should_receive(:update_attribute).with(:archetype, monk)
        external_data = double(ExternalData)
        character.stub(:external_data).and_return(nil)
        character.should_receive(:build_external_data).with(data: {"type" => {"class" => "Monk"}}).
            and_return(external_data)
        character.should_receive(:external_data=).with(external_data)

        subject.perform(character.id)
      end
    end
  end
end