class PlayersController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Players"
  end

  def raids
    @player = Player.find(params[:id], :include => [:raids])
    render :xml => @player.raids.to_xml(:include => [:raids])
  end

  # GET /players
  # GET /players.json
  def index
    archetype = Archetype.find_by_name(params[:archetype])
    sort = params[:sort]
    if archetype
      @pagetitle = "Listing " + archetype.name + " Players"
      @players = Player.find_by_archetype(archetype)
    else
      @pagetitle = "Listing All Players"
      @players = Player.all
    end
    if !sort
      @players.sort! { |a,b| a.name <=> b.name }
    else
      # NOTE: This is a reverse sort, as we want the higher rates at the top
      @players.sort! { |a,b| b.loot_rate(sort) <=> a.loot_rate(sort) }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @players }
      format.xml { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @player }
      format.xml { render :xml => @player.to_xml(:include => [:raids]) }
    end
  end

  # GET /players/new
  # GET /players/new.json
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @player }
      format.xml { render :xml => @player.to_xml(:include => [:raids]) }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
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
