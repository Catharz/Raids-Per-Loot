class ArchetypesValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:base] << "Cannot set an archetypes parent to itself" unless !is_own_parent?(record)
      record.errors[:base] << "Cannot set an archetypes parent to one of its descendents" unless !is_own_descendant?(record)
    end

  def is_own_parent?(record)
    if record.parent.nil?
      false
    else
      record.name.eql? record.parent.name
    end
  end

  def is_own_descendant?(record)
    is_child = false
    unless record.children.empty?
      Archetype.descendants(record).each do |child|
        if child.name.eql? record.name
          is_child = true
          break
        end
      end
    end
    is_child
  end
end