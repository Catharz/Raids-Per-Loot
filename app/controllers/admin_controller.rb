class AdminController < ApplicationController
  include RemoteConnectionHelper
  before_filter :login_required
  MIN_LEVEL = 90
  MAX_LEVEL = 95

  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def fix_trash_drops
    incorrect_trash_drops = Item.fix_trash_drops

    if incorrect_trash_drops > 0
      flash.notice = 'There were no trash drops to fix'
    else
      flash.notice = "Set #{incorrect_trash_drops} drops of trash items to the correct loot method"
    end

    redirect_to '/admin'
  end

  def resolve_duplicate_items
    if Item.resolve_duplicates
      flash.notice = 'Item duplicates resolved successfully'
    else
      flash.alert = 'Some Item Duplicates Left Unresolved'
    end

    redirect_to '/admin'
  end

  def update_character_list
    updates = SonyDataService.new.update_character_list

    if updates == -1
      flash.alert = 'Could not retrieve character list'
    else
      flash.notice = "#{updates} characters downloaded"
    end

    redirect_to '/admin'
  end

  def update_player_list
    updates = SonyDataService.new.update_player_list

    if updates == -1
      flash.alert = 'Could not retrieve player list'
    else
      flash.notice = "#{updates} players downloaded"
    end

    redirect_to '/admin'
  end
end