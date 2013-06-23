require 'spec_helper'

describe SonyCharacterUpdater do
  subject { SonyCharacterUpdater }
  let(:character) { FactoryGirl.create(:character) }

  describe '#perform' do
    it 'raises an exception if there is no internet connect' do
      subject.should_receive(:internet_connection?).and_return(false)
      expect {
        subject.perform(character.id)
      }.to raise_exception Exception, 'Internet connection unavailable.'
    end

    it 'raises an exception the character data is nil' do
      subject.should_receive(:internet_connection?).and_return(true)
      Character.should_receive(:find).and_return(character)
      SonyDataService.any_instance.should_receive(:character_data).with(character.name, 'json').and_return(nil)

      expect {
        subject.perform(character.id)
      }.to raise_exception Exception, "Could not obtain character details for #{character.name}"
    end

    it 'raises an exception the character data is empty' do
      subject.should_receive(:internet_connection?).and_return(true)
      Character.should_receive(:find).and_return(character)
      SonyDataService.any_instance.
          should_receive(:character_data).with(character.name, 'json').
          and_return({:character_list => [{}]}.with_indifferent_access)

      expect {
        subject.perform(character.id)
      }.to raise_exception Exception, "Could not obtain character details for #{character.name}"
    end

    context 'updating data' do
      let(:monk_character_data) { {:character_list => [{type: {'class' => 'Monk'}}]}.with_indifferent_access }
      let(:monk) { Archetype.find_by_name('Monk') }
      let(:bruiser) { Archetype.find_by_name('Bruiser') }

      it 'does not update the character unnecessarily' do
        subject.should_receive(:internet_connection?).and_return(true)
        Character.should_receive(:find).and_return(character)
        character.should_receive(:archetype).twice.and_return(monk)
        SonyDataService.any_instance.
            should_receive(:character_data).with(character.name, 'json').
            and_return(monk_character_data)

        character.should_not_receive(:update_attribute)
        subject.perform(character.id)
      end

      it 'updates the characters archetype when necessary' do
        subject.should_receive(:internet_connection?).and_return(true)
        Character.should_receive(:find).and_return(character)
        character.should_receive(:archetype).twice.and_return(bruiser)
        SonyDataService.any_instance.
            should_receive(:character_data).with(character.name, 'json').
            and_return(monk_character_data)

        character.should_receive(:update_attribute).with(:archetype, monk)
        subject.perform(character.id)
      end

      it 'saves the data to external data' do
        subject.should_receive(:internet_connection?).and_return(true)
        Character.should_receive(:find).and_return(character)
        character.should_receive(:archetype).twice.and_return(bruiser)
        SonyDataService.any_instance.
            should_receive(:character_data).with(character.name, 'json').
            and_return(monk_character_data)

        character.should_receive(:update_attribute).with(:archetype, monk)
        character.should_receive(:build_external_data).with(data: monk_character_data['character_list'][0])
        character.external_data.should_receive(:save)

        subject.perform(character.id)
      end
    end
  end
end