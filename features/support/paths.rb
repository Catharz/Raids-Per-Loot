module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /the new loot_type page/
      new_loot_type_path

    when /the new drop page/
      new_drop_path

    when /the new drop page/
      new_drop_path

    when /the new drop page/
      new_drop_path

    when /the new drop page/
      new_drop_path

    when /the new drop page/
      new_drop_path

    when /the new drop page/
      new_drop_path

    when /the new drop page/
      new_drop_path

    when /the new rank page/
      new_rank_path

    when /the new slot page/
      new_slot_path

    when /the new link_category page/
      new_link_category_path

    when /the new link page/
      new_link_path

    when /the new page page/
      new_page_path

    when /the new mob page/
      new_mob_path

    when /the new item page/
      new_item_path

    when /the new player page/
      new_player_path

    when /the new raid page/
      new_raid_path

    when /the new archetype page/
      new_archetype_path

    when /the new zone page/
      new_zone_path


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
