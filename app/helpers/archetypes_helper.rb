
module ArchetypesHelper
  def consolidate_archetypes(archetype_list)
    if archetype_list.empty?
      "None"
    else
      temp_list = []
      final_list = []
      archetype_list.each do |a|
        if a.self_and_siblings & archetype_list == a.self_and_siblings
          if a.self_and_siblings.count > 0
            temp_list << a.parent unless temp_list.include? a.parent
          else
            temp_list << a unless temp_list.include? a
          end
        else
          temp_list << a unless temp_list.include? a
        end
      end
      temp_list.each do |a|
        if a.self_and_siblings & temp_list == a.self_and_siblings
          final_list << a.parent unless final_list.include? a.parent
        else
          final_list << a unless final_list.include? a
        end
      end
      final_list.flatten!
      final_list.map do |t|
        if t.children.empty?
          t.name
        else
          "All #{t.name}s"
        end
      end.join(", ")
    end
  end
end