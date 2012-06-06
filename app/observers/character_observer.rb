class CharacterObserver < ActiveRecord::Observer
  observe Character

  def after_create(character)
    save_new_char_type character
    get_character_details(character) if internet_connection?
  end

  def after_save(character)
    unless character.last_switch and character.last_switch.char_type.eql? character.char_type
      save_new_char_type character
    end
    get_character_details(character) if internet_connection?
  end

  private
  def get_character_details(character)
    CharacterDetailsJob.new(character.name)
  end

  def save_new_char_type(character)
    new_char_type = character.character_types.build(
        :char_type => character.char_type,
        :effective_date => character.updated_at)
    new_char_type.save
  end

  def internet_connection?
    begin
      # Always return false if we're testing'
      if ENV["RAILS_ENV"].eql? "test"
        false
      else
        true if open("http://www.google.com/")
      end
    rescue
      false
    end
  end
end