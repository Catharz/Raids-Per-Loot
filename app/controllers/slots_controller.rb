# @author Craig Read
#
# Controller for the Slot views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
class SlotsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_pagetitle
  before_filter :set_slot, :only => [:show, :edit, :update, :destroy]

  # GET /slots
  # GET /slots.xml
  def index
    @slots = Slot.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @slots.to_xml( :include => [:items] ) }
    end
  end

  # GET /slots/1
  # GET /slots/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @slot.to_xml( :include => [:items] ) }
    end
  end

  # GET /slots/new
  # GET /slots/new.xml
  def new
    @slot = Slot.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @slot }
    end
  end

  # GET /slots/1/edit
  def edit
  end

  # POST /slots
  # POST /slots.xml
  def create
    @slot = Slot.new(slot_params)

    respond_to do |format|
      if @slot.save
        format.html { redirect_to(@slot, :notice => 'Slot was successfully created.') }
        format.xml  { render :xml => @slot, :status => :created, :location => @slot }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /slots/1
  # PUT /slots/1.xml
  def update
    respond_to do |format|
      if @slot.update_attributes(slot_params)
        format.html { redirect_to(@slot, :notice => 'Slot was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /slots/1
  # DELETE /slots/1.xml
  def destroy
    @slot.destroy

    respond_to do |format|
      format.html { redirect_to(slots_url) }
      format.xml  { head :ok }
    end
  end

  private

  def set_pagetitle
    @pagetitle = 'Item Slots'
  end

  def set_slot
    @slot = Slot.find(params[:id])
  end

  def slot_params
    params.require(:slot).permit(:name)
  end
end
