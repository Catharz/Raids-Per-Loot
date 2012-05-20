require 'delayed_job'

class ItemsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :info]

  def fetch_all_data
    @items = Item.order(:name)
    @items.each do |item|
      if item.loot_type.nil? or item.loot_type.name.eql? "Unknown"
        Delayed::Job.enqueue(ItemDetailsJob.new(item.name))
      else
        unless item.loot_type.name.eql? "Trash"
          Delayed::Job.enqueue(ItemDetailsJob.new(item.name))
        end
      end
    end

    flash[:notice] = "Items are being updated."
    redirect_to admin_url
  end

  def fetch_data
    @item = Item.find(params[:id])
    @item.download_soe_details

    flash[:notice] = "Item details have been updated."
    redirect_to @item
  end

  # GET /items
  # GET /items.json
  def index
    @items = Item.by_loot_type(params[:loot_type_id]).includes(:loot_type, :items_slots => :slot, :archetypes_items => :archetype)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
      format.xml { render :xml => @items }
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
      format.json { render :json => @item }
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
        format.json { head :ok }
        format.xml { head :ok }
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
