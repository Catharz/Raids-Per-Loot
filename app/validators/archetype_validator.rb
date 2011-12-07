class ArchetypeValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:base] << "Cannot set an archetypes parent to itself" unless !is_own_parent?(record)
      record.errors[:base] << "Cannot set an archetypes parent to one of its descendents" unless !is_parent_a_child?(record)
    end

  def is_own_parent?(record)
    if record.parent_class.nil?
      false
    else
      record.name.eql? record.parent_class.name
    end
  end

  def is_parent_a_child?(record)
    is_child = false
    if !record.parent_class.nil?
      Archetype.find_all_children(record).each do |child|
        if child.name.eql? record.parent_class.name
          is_child = true
          break
        end
      end
    end
    is_child
  end
end