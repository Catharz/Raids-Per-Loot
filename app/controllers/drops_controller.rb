# @author Craig Read
#
# Controller for the Drop views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
#
# index uses the DropsDataTable class which will handle
# pagination, searching and rendering the drops.
class DropsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Loot Drops'
  end

  # GET /drops
  # GET /drops.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => Drop.select(:chat).by_eq2_item_id(params[:eq2_item_id]).by_time(params[:drop_time]).by_instance(params[:instance_id]).by_zone(params[:zone_id]).by_mob(params[:mob_id]).by_item(params[:item_id]).by_character(params[:character_id]) }
      format.json { render json: DropsDatatable.new(view_context) }
    end
  end

  # GET /drops/invalid
  def invalid
    @drops = Drop.invalidly_assigned(params[:trash]).uniq

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @drops.to_xml }
    end
  end

  # GET /drops/1
  # GET /drops/1.xml
  def show
    @drop = Drop.select(:chat).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @drop }
      format.json {
        render :json => @drop.to_json(
            :methods => [:loot_method_name,
                         :invalid_reason,
                         :character_name,
                         :character_archetype_name,
                         :loot_type_name])
      }
    end
  end

  # GET /drops/new
  # GET /drops/new.xml
  def new
    @drop = Drop.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @drop }
      format.json { render :json => @drop }
    end
  end

  # GET /drops/1/edit
  def edit
    @drop = Drop.select(:chat).find(params[:id])
  end

  # POST /drops
  # POST /drops.xml
  def create
    @drop = Drop.new(params[:drop])

    respond_to do |format|
      if @drop.save
        format.html { redirect_to(@drop, :notice => 'Drop was successfully created.') }
        format.xml { render :xml => @drop, :status => :created, :location => @drop }
        format.json { render :json => @drop, :status => :created, :location => @drop }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @drop.errors, :status => :unprocessable_entity }
        format.json { render :json => @drop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /drops/1
  # PUT /drops/1.xml
  def update
    @drop = Drop.find(params[:id])

    respond_to do |format|
      if @drop.update_attributes(params[:drop])
        format.html {
          if request.env['HTTP_REFERER']
            redirect_to request.env['HTTP_REFERER'], :status => 303, :notice => 'Drop was successfully updated.'
          else
            redirect_to(@drop, :notice => 'Drop was successfully updated.')
          end
        }
        format.json { render :json => @drop, :notice => 'Drop was successfully updated.' }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @drop.errors, :status => :unprocessable_entity }
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
      format.json { head :ok }
    end
  end
end