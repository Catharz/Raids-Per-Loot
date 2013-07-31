require 'spec_helper'
require 'authentication_spec_helper'

describe ItemsController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  def valid_attributes
    {:name => 'Whatever', :eq2_item_id => 'numbers'}
  end

  describe 'GET info' do
    it 'assigns the requested item as @item' do
      item = Item.create! valid_attributes
      get :info, :id => item.id
      assigns(:item).should eq(item)
    end

    it 'renders the info view' do
      item = FactoryGirl.create(:item)
      get :info, :id => item.id
      response.should render_template("info")
    end
  end

  describe 'POST fetch_all_data' do
    it 'calls SonyDataService.fetch_items_data' do
      item = Item.create! valid_attributes
      Resque.should_receive(:enqueue).with(SonyItemUpdater, item.id)
      post :fetch_all_data
    end

    it 'redirects to the admin view' do
      post :fetch_all_data, :delayed => false
      response.should redirect_to '/admin'
    end
  end

  describe 'POST fetch_data' do
    it 'assigns the requested item as @item' do
      item = Item.create! valid_attributes
      post :fetch_data, :id => item.id.to_s
      assigns(:item).should eq(item)
    end

    it 'uses Resque' do
      item = FactoryGirl.create(:item)
      Resque.should_receive(:enqueue).with(SonyItemUpdater, item.id)
      post :fetch_data, :id => item.id
    end

    it 'redirects to the item' do
      item = FactoryGirl.create(:item)
      Resque.should_receive(:enqueue).with(SonyItemUpdater, item.id)
      post :fetch_data, :id => item.id
      response.should redirect_to(item)
    end
  end

  describe 'GET index' do
    it 'should render JSON by default' do
      item = Item.create! valid_attributes
      expected = {'sEcho' => 0,
                  'iTotalRecords'  => 1,
                  'iTotalDisplayRecords' => 1,
                  'aaData' => [
                      ['Whatever',
                       nil,
                       'None',
                       'None',
                       '<a href="/items/' + item.id.to_s + '" class="table-button">Show</a>',
                       '<a href="/items/' + item.id.to_s + '/edit" class="table-button">Edit</a>',
                       '<a href="/items/' + item.id.to_s + '" class="table-button" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Destroy</a>'
                      ]
                  ]
      }

      get :index, :format => :json
      actual = JSON.parse(response.body)

      actual.should == expected
    end

    it 'should filter by item name when getting xml' do
      FactoryGirl.create(:item, valid_attributes)
      FactoryGirl.create(:item, {:name => 'Tin foil hat', :eq2_item_id => 'another id'})

      get :index, :format => :xml, :name => 'Tin foil hat'
      response.body.should contain 'Tin foil hat'
      response.body.should_not contain 'Whatever'
    end

    it 'should filter by eq2_item_id when getting xml' do
      FactoryGirl.create(:item, valid_attributes)
      FactoryGirl.create(:item, {:name => 'Dagger of letter opening', :eq2_item_id => 'yet another id'})

      get :index, :format => :xml, :eq2_item_id => 'yet another id'
      response.body.should contain 'Dagger of letter opening'
      response.body.should_not contain 'Whatever'
    end

    it 'should filter by loot_type when getting xml' do
      armour = FactoryGirl.create(:loot_type, :name => 'Armour', :default_loot_method => 'n')
      trash = FactoryGirl.create(:loot_type, :name => 'Trash', :default_loot_method => 't')
      FactoryGirl.create(:item, valid_attributes.merge!(:loot_type_id => armour.id))
      FactoryGirl.create(:item, {:name => 'Trash Drop', :eq2_item_id => 'yet another id', :loot_type_id => trash.id})

      get :index, :format => :xml, :loot_type_id => trash.id
      response.body.should contain 'Trash Drop'
      response.body.should_not contain 'Whatever'
    end
  end

  describe 'GET show' do
    it 'assigns the requested item as @item' do
      item = Item.create! valid_attributes
      get :show, :id => item.id.to_s
      assigns(:item).should eq(item)
    end

    it 'renders the show template' do
      item = Item.create! valid_attributes
      get :show, :id => item.id.to_s
      response.should render_template('show')
    end
  end

  describe 'GET new' do
    it 'assigns a new item as @item' do
      get :new
      assigns(:item).should be_a_new(Item)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested item as @item' do
      item = Item.create! valid_attributes
      get :edit, :id => item.id.to_s
      assigns(:item).should eq(item)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Item' do
        expect {
          post :create, :item => valid_attributes
        }.to change(Item, :count).by(1)
      end

      it 'assigns a newly created item as @item' do
        post :create, :item => valid_attributes
        assigns(:item).should be_a(Item)
        assigns(:item).should be_persisted
      end

      it 'redirects to the created item' do
        post :create, :item => valid_attributes
        response.should redirect_to(Item.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved item as @item' do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, :item => {}
        assigns(:item).should be_a_new(Item)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, :item => {}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested item' do
        item = Item.create! valid_attributes
        # Assuming there are no other items in the database, this
        # specifies that the Item created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Item.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => item.id, :item => {'these' => 'params'}
      end

      it 'assigns the requested item as @item' do
        item = Item.create! valid_attributes
        put :update, :id => item.id, :item => valid_attributes
        assigns(:item).should eq(item)
      end

      it 'redirects to the item' do
        item = Item.create! valid_attributes
        put :update, :id => item.id, :item => valid_attributes
        response.should redirect_to(item)
      end
    end

    describe 'with invalid params' do
      it 'assigns the item as @item' do
        item = Item.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, :id => item.id.to_s, :item => {}
        assigns(:item).should eq(item)
      end

      it "re-renders the 'edit' template" do
        item = Item.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, :id => item.id.to_s, :item => {}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested item' do
      item = Item.create! valid_attributes
      expect {
        delete :destroy, :id => item.id.to_s
      }.to change(Item, :count).by(-1)
    end

    it 'redirects to the items list' do
      item = Item.create! valid_attributes
      delete :destroy, :id => item.id.to_s
      response.should redirect_to(items_url)
    end
  end

end
