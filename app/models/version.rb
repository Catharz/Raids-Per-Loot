# @author Craig Read
#
# Version represents a version of a model
# edited with paper trail turned on
class Version < ActiveRecord::Base
  def item
    return Character.find(item_id) if item_type == 'Character'
    return Player.find(item_id) if item_type == 'Player'
    return Drop.find(item_id) if item_type == 'Drop'
    nil
  end

  def previous_version
    return Character.find(item_id).previous_version if item_type == 'Character'
    return Player.find(item_id).previous_version if item_type == 'Player'
    return Drop.find(item_id).previous_version if item_type == 'Drop'
    return nil
  end
end
