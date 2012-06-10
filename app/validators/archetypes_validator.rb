class ArchetypesValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:base] << "Cannot set an archetypes parent to itself" unless !is_own_parent?(record)
      record.errors[:base] << "Cannot set an archetypes parent to one of its descendants" unless !is_own_descendant?(record)
    end

  def is_own_parent?(record)
    if record.parent.nil?
      false
    else
      record.name.eql? record.parent.name
    end
  end

  def is_own_descendant?(record)
    if record.children.empty?
      false
    else
      descendants = Archetype.descendants(record).map {|child| child.name }
      if record.parent
        descendants.include? record.name or descendants.include? record.parent.name
      else
        descendants.include? record.name
      end
    end
  end
end