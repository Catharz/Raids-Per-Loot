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
  respond_to :html
  respond_to :json, :xml, except: [:loot, :statistics, :option_list, :info]
  respond_to :js, only: [:destroy, :edit, :new, :show]

  before_filter :set_item, only: [:show, :edit, :update, :destroy, :info, :fetch_data]
  before_filter :authenticate_user!, :except => [:index, :show, :info]
  before_filter :set_pagetitle
  after_filter { flash.discard if request.xhr? }

  def fetch_all_data
    items = Item.order(:name)
    items.each { |item| Resque.enqueue(SonyItemUpdater, item.id) }
    flash[:notice] = 'Items are being updated.'

    redirect_to '/admin'
  end

  def fetch_data
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
    render :layout => false
  end

  # GET /items/1
  # GET /items/1.json
  def show
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
    respond_with @item
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    if @item.save
      flash[:notice] = 'Item was successfully created.'
      respond_with @item
    else
      render action: :new
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    if @item.update_attributes(params[:item])
      flash[:notice] = 'Item was successfully updated.'
      respond_with @item
    else
      render action: :edit
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_with @item
  end

  private

  def set_item
    @item = Item.where('items.id = ? or items.eq2_item_id = ?', params[:id], params[:id]).first
  end

  def set_pagetitle
    @pagetitle = 'Items'
  end
end
