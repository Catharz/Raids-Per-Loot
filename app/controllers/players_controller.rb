class PlayersController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :attendance, :statistics]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Players"
  end

  def option_list
    @players = Player.order(:name)

    options = ""
    @players.each do |player|
      options += "<option value='#{player.id}'>#{player.name}</option>"
    end
    render :text => options, :layout => false
  end

  # GET /players/statistics
  # GET /players/statistics.json
  def statistics
    @players = Player.by_instance(params[:instance_id]).
        includes([:current_main, :current_raid_alternate]).
        order('players.name')
    @players.reject! { |p| p.last_raid.nil? or p.last_raid.raid_date < 3.months.ago.to_date }
  end

  # GET /players
  # GET /players.json
  def index
    @players = Player.of_rank(params[:rank_id]).by_instance(params[:instance_id]) \
      .order("players.name") \
      .includes(:rank)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @players }
      format.csv { render csv: @characters }
      format.xml { render :xml => @players.to_xml }
    end
  end

  def attendance
    @players = Player.order("players.name")

    respond_to do |format|
      format.html
    end
  end

# GET /players/1
# GET /players/1.json
  def show
    @player = Player.includes(:drops => :instance).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @player.to_json(methods: [:armour_count, :jewellery_count, :weapon_count]) }
      format.xml { render :xml => @player.to_xml(:include => [:instances, :drops]) }
    end
  end

# GET /players/new
# GET /players/new.json
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @player }
      format.xml { render :xml => @player }
    end
  end

# GET /players/1/edit
  def edit
    @player = Player.find(params[:id], :include => :characters)
  end

# POST /players
# POST /players.json
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, :notice => 'Player was successfully created.' }
        format.json { render :json => @player, :status => :created, :location => @player }
        format.xml { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.json { render :json => @player.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

# PUT /players/1
# PUT /players/1.json
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to @player, :notice => 'Player was successfully updated.' }
        format.json { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @player.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

# DELETE /players/1
# DELETE /players/1.json
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :ok }
      format.xml { head :ok }
    end
  end
end
