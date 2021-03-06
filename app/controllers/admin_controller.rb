# @author Craig Read
#
# Controller for the Administration view.
#
# Many of the actions here are background jobs
# which are handled by Resque workers.
class AdminController < ApplicationController
  include RemoteConnectionHelper
  before_filter :authenticate_user!
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Welcome to the Admin page'
  end

  MIN_LEVEL = 90
  MAX_LEVEL = 95

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def upload
    respond_to do |format|
      format.js
    end
  end

  def upload_files
    uploaded = params[:upl]
    if uploaded.nil?
      render nothing: true, status: 500
    else
      begin
        file = uploaded.tempfile
        file_name = uploaded.original_filename
        new_file_name = File.join(Dir.tmpdir, file_name)
        FileUtils.copy(file.path, new_file_name)
        Resque.enqueue(LogParser, new_file_name)
      ensure
        file.unlink
      end
      render nothing: true, status: 200
    end
  end

  def fix_trash_drops
    incorrect_trash_drops = Item.of_type('Trash').includes(:drops).where('drops.loot_method <> ?', 't').count

    if incorrect_trash_drops == 0
      flash.notice = 'There are no trash drops to fix'
    else
      Resque.enqueue(TrashDropFixer)
      flash.notice = "Queued job to set #{incorrect_trash_drops} drops of trash items to the correct loot method"
    end

    redirect_to '/admin'
  end

  def resolve_duplicate_items
    if SonyDataService.new.resolve_duplicate_items
      flash.notice = 'Item duplicates resolved successfully'
    else
      flash.alert = 'Some Item Duplicates Left Unresolved'
    end

    redirect_to admin_url
  end

  def update_character_list
    updates = SonyDataService.new.update_character_list

    if updates == -1
      flash.alert = 'Could not retrieve character list'
    else
      flash.notice = "#{updates} characters downloaded"
    end

    redirect_to admin_url
  end

  def update_character_details
    characters = Character.order(:name)
    SonyDataService.new.update_character_details(characters)

    flash[:notice] = 'Characters have been successfully updated.'
    redirect_to admin_url
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
