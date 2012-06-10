class CharacterObserver < ActiveRecord::Observer
  observe Character

  def after_create(character)
    save_new_char_type character
    get_character_details(character)
  end

  def after_save(character)
    unless character.last_switch and character.last_switch.char_type.eql? character.char_type
      save_new_char_type character
    end
    get_character_details(character)
  end

  private
  def get_character_details(character)
    CharacterDetailsJob.new(character)
  end

  def save_new_char_type(character)
    new_char_type = character.character_types.build(
        :char_type => character.char_type,
        :effective_date => character.updated_at)
    new_char_type.save
  end
end