# @author Craig Read
#
# Controller for the Item views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
#
# xml formatting is provided on actions used by the ACT plug-in.
#
# index uses the ItemsDataTable class which will handle
# pagination, searching and rendering the drops.
class ItemsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :info]
  before_filter :set_pagetitle

  def set_pagetitle
    @pagetitle = 'Items'
  end

  def fetch_all_data
    items = Item.order(:name)
    items.each { |item| Resque.enqueue(SonyItemUpdater, item.id) }
    flash[:notice] = 'Items are being updated.'

    redirect_to '/admin'
  end

  def fetch_data
    @item = Item.find(params[:id])

    Resque.enqueue(SonyItemUpdater, @item.id)
    flash[:notice] = 'Item details are being updated.'
    redirect_to @item
  end

  # GET /items
  # GET /items.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: ItemsDatatable.new(view_context) }
      format.xml { render :xml => Item.by_name(params[:name]).by_eq2_item_id(params[:eq2_item_id]).
          by_loot_type(params[:loot_type_id]).of_type(params[:loot_type_name]) }
    end
  end

  def info
    @item = Item.find(params[:id])

    render :layout => false
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.where('items.id = ? or items.eq2_item_id = ?', params[:id], params[:id]).first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item.to_json(:methods => [:class_names, :slot_names, :loot_type_name]) }
      format.xml { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @item }
      format.xml { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, :notice => 'Item was successfully created.' }
        format.json { render :json => @item, :status => :created, :location => @item }
        format.xml { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(item_params)
        format.html { redirect_to @item, :notice => 'Item was successfully updated.' }
        format.json { render :json => @item, :notice => 'Item was successfully updated.' }
        format.xml {  render :xml => @item, :notice => 'Item was successfully updated.'  }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :ok }
      format.xml { head :ok }
    end
  end

  def item_params
    params.require(:item).permit(:name, :eq2_item_id, :info_url, :loot_type_id)
  end
end
