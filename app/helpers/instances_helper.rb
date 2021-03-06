# @author Craig Read
#
# InstancesHelper provides a helper function for
# presenting the mob names on the Instance views
module InstancesHelper
  def mob_names(instance)
    names = []
    instance.kills.each do |mob|
      if mob.alias.nil? or mob.alias.empty?
        names << mob.name
      else
        names << mob.alias
      end
    end
    names.join("</br>").html_safe
  end
end