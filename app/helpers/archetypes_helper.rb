# @author Craig Read
#
# ArchetypesHelper provides a utility function for consolidating
# an array of archetypes up to their roots.
#
# e.g. ['Bruiser', 'Monk'] will become 'All Brawlers'
module ArchetypesHelper
  def consolidate_archetypes(archetype_list)
    if archetype_list.empty?
      'None'
    else
      archetype_list = consolidate_parents(archetype_list) until
          consolidate_parents(archetype_list) & archetype_list == archetype_list
      archetype_list.map { |archetype| final_description(archetype) }.join(', ')
    end
  end

  private

  def final_description(archetype)
    return '' if archetype.nil?
    archetype.children.empty? ? archetype.name : "All #{archetype.name}s"
  end

  def consolidate_parents(archetype_list)
    results = []
    archetype_list.each do |archetype|
      if all_siblings_included?(archetype, archetype_list)
        results << archetype.parent unless results.include? archetype.parent
      else
        results << archetype
      end
    end
    results
  end

  def all_siblings_included?(child, list)
    return false if child.nil?
    child.self_and_siblings & list == child.self_and_siblings
  end
end