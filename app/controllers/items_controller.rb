require 'delayed_job'

class ItemsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :info]

  def fetch_all_data
    @items = Item.order(:name)
    @items.each do |item|
      if params[:delayed]
        flash[:notice] = "Items are being updated."
        Delayed::Job.enqueue(ItemDetailsJob.new(item))
      else
        flash[:notice] = "Items have been updated."
        item.fetch_soe_item_details
      end
    end

    redirect_to '/admin'
  end

  def fetch_data
    @item = Item.find(params[:id])

    if @item.fetch_soe_item_details
      flash[:notice] = "Item details have been updated."
    else
      flash[:notice] = "Could not update item details."
    end
    redirect_to @item
  end

  # GET /items
  # GET /items.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: ItemsDatatable.new(view_context) }
      format.xml { render :xml => Item.by_name(params[:name]).by_eq2_item_id(params[:eq2_item_id]).by_loot_type(params[:loot_type_id]) }
    end
  end

  def info
    @item = Item.find(params[:id])

    render :layout => false
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

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
    @item = Item.new(params[:item])

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
      if @item.update_attributes(params[:item])
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
end
