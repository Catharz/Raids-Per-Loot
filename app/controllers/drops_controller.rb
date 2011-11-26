class DropsController < ApplicationController
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = "Loot Drops"
  end

  # GET /drops
  # GET /drops.xml
  def index
    @drops = Drop.all
    @drops.sort! { |a,b| b.drop_time <=> a.drop_time }

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @drops }
    end
  end

  # GET /drops/1
  # GET /drops/1.xml
  def show
    @drop = Drop.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @drop }
    end
  end

  # GET /drops/new
  # GET /drops/new.xml
  def new
    @drop = Drop.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @drop }
    end
  end

  # GET /drops/1/edit
  def edit
    @drop = Drop.find(params[:id])
  end

  # POST /drops
  # POST /drops.xml
  def create
    @drop = Drop.new(params[:drop])

    respond_to do |format|
      if @drop.save
        format.html { redirect_to(@drop, :notice => 'Drop was successfully created.') }
        format.xml { render :xml => @drop, :status => :created, :location => @drop }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /drops/1
  # PUT /drops/1.xml
  def update
    @drop = Drop.find(params[:id])

    respond_to do |format|
      if @drop.update_attributes(params[:drop])
        format.html { redirect_to(@drop, :notice => 'Drop was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /drops/1
  # DELETE /drops/1.xml
  def destroy
    @drop = Drop.find(params[:id])
    @drop.destroy

    respond_to do |format|
      format.html { redirect_to(drops_url) }
      format.xml { head :ok }
    end
  end

  # ASSIGN_LOOT /drops/1
  # ASSIGN_LOOT /drops/1.xml
  def assign_loot
    @drop = Drop.find(params[:id])
    if @drop.assign_loot
      @drop.assigned = true
      @drop.save
    end

    respond_to do |format|
      format.html { redirect_to(drops_url) }
      format.xml { head :ok }
    end
  end

  # UNASSIGN_LOOT /drops/1
  # UNASSIGN_LOOT /drops/1.xml
  def unassign_loot
    @drop = Drop.find(params[:id])
    if @drop.unassign_loot
      @drop.assigned = false
      @drop.save
    end

    respond_to do |format|
      format.html { redirect_to(drops_url) }
      format.xml { head :ok }
    end
  end
end