require 'spec_helper'
require 'authentication_spec_helper'
require 'item_spec_helper'

describe ItemsController do
  include AuthenticationSpecHelper
  include ItemSpecHelper
  fixtures :users, :services, :loot_types

  before(:each) do
    login_as :admin
  end

  def valid_attributes
    {name: 'Whatever', :eq2_item_id => 'numbers'}
  end

  describe 'GET info' do
    it 'assigns the requested item as @item' do
      item = Item.create! valid_attributes
      get :info, id: item.id
      expect(assigns(:item)).to eq item
    end

    it 'renders the info view' do
      item = FactoryGirl.create(:item)
      get :info, id: item.id
      expect(response).to render_template "info"
    end
  end

  describe 'POST fetch_all_data' do
    it 'calls SonyDataService.fetch_items_data' do
      item = Item.create! valid_attributes
      Resque.should_receive(:enqueue).with(SonyItemUpdater, item.id)
      post :fetch_all_data
    end

    it 'redirects to the admin view' do
      post :fetch_all_data, delayed: false
      expect(response).to redirect_to '/admin'
    end
  end

  describe 'POST fetch_data' do
    it 'assigns the requested item as @item' do
      item = Item.create! valid_attributes
      post :fetch_data, id: item.id.to_s
      expect(assigns(:item)).to eq item
    end

    it 'uses Resque' do
      item = FactoryGirl.create(:item)
      Resque.should_receive(:enqueue).with(SonyItemUpdater, item.id)
      post :fetch_data, id: item.id
    end

    it 'redirects to the item' do
      item = FactoryGirl.create(:item)
      Resque.should_receive(:enqueue).with(SonyItemUpdater, item.id)
      post :fetch_data, id: item.id
      expect(response).to redirect_to item
    end
  end

  describe 'GET index' do
    it 'should render JSON formatted for a data table' do
      item = Item.create! valid_attributes
      expected = item_as_json(item)

      get :index, format: :json
      actual = JSON.parse(response.body)

      expect(actual['aaData']).to be_an Array
      expect(actual['aaData'].count).to eq 1
    end

    it 'returns JSON' do
      item = Item.create! valid_attributes
      get :index, format: :json
      result = JSON.parse(response.body)
      expect(response.content_type).to eq 'application/json'
    end

    it 'returns XML' do
      item = Item.create! valid_attributes
      get :index, format: :xml
      expect(response.body).to have_xpath '//items/*[1]/name'
      expect(response.body).to have_content item.name
    end

    context 'renders XML' do
      it 'filtered by item name' do
        FactoryGirl.create(:item, valid_attributes)
        FactoryGirl.create(:item, {name: 'Tin foil hat',
                                   :eq2_item_id => 'another id'})

        get :index, format: :xml, name: 'Tin foil hat'

        expect(Nokogiri.parse(response.body).at_xpath('/items/*[1]/name').inner_text).to eq 'Tin foil hat'
        expect(response.body).to_not contain 'Whatever'
      end

      it 'filtered by eq2_item_id' do
        FactoryGirl.create(:item, valid_attributes)
        FactoryGirl.create(:item, {name: 'Dagger of letter opening',
                                   :eq2_item_id => 'yet another id'})

        get :index, format: :xml, :eq2_item_id => 'yet another id'

        expect(Nokogiri.parse(response.body).at_xpath('/items/*[1]/name').inner_text).to eq 'Dagger of letter opening'
        expect(response.body).to_not contain 'Whatever'
      end

      it 'filtered by loot_type' do
        armour = LootType.find_by_name('Armour')
        trash = LootType.find_by_name('Trash')
        FactoryGirl.create(:item,
                           valid_attributes.merge!(loot_type_id: armour.id))
        FactoryGirl.create(:item, {name: 'Trash Drop',
                                   :eq2_item_id => 'yet another id',
                                   loot_type_id: trash.id})

        get :index, format: :xml, loot_type_id: trash.id

        expect(Nokogiri.parse(response.body).at_xpath('/items/*[1]/name').inner_text).to eq 'Trash Drop'
        expect(response.body).to_not contain 'Whatever'
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested item as @item' do
      item = Item.create! valid_attributes
      get :show, id: item.id.to_s
      expect(assigns(:item)).to eq item
    end

    it 'renders the show template' do
      item = Item.create! valid_attributes
      get :show, id: item.id.to_s
      expect(response).to render_template 'show'
    end

    it 'renders JSON' do
      item = Item.create! valid_attributes
      get :show, id: item.id.to_s, format: :json
      expect(JSON.parse(response.body)['item']['name']).to eq item.name
    end

    it 'renders XML' do
      item = Item.create! valid_attributes
      get :show, id: item.id.to_s, format: :xml
      expect(Nokogiri.parse(response.body).at_xpath('/item/name').inner_text).to eq item.name
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
      get :edit, id: item.id.to_s
      assigns(:item).should eq(item)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Item' do
        expect {
          post :create, item: valid_attributes
        }.to change(Item, :count).by(1)
      end

      it 'assigns a newly created item as @item' do
        post :create, item: valid_attributes
        assigns(:item).should be_a(Item)
        assigns(:item).should be_persisted
      end

      it 'redirects to the created item' do
        post :create, item: valid_attributes
        response.should redirect_to(Item.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved item as @item' do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, item: valid_attributes
        assigns(:item).should be_a_new(Item)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, item: valid_attributes
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
        Item.any_instance.should_receive(:update_attributes).
            with({'name' => 'Something Else'})
        put :update, id: item.id, item: {'name' => 'Something Else'}
      end

      it 'assigns the requested item as @item' do
        item = Item.create! valid_attributes
        put :update, id: item.id, item: valid_attributes
        assigns(:item).should eq(item)
      end

      it 'redirects to the item' do
        item = Item.create! valid_attributes
        put :update, id: item.id, item: valid_attributes
        response.should redirect_to(item)
      end
    end

    describe 'with invalid params' do
      it 'assigns the item as @item' do
        item = Item.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, id: item.id.to_s, item: {'name' => 'whatever'}
        assigns(:item).should eq(item)
      end

      it "re-renders the 'edit' template" do
        item = Item.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, id: item.id.to_s, item: {'name' => 'whatever'}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested item' do
      item = Item.create! valid_attributes
      expect {
        delete :destroy, id: item.id.to_s
      }.to change(Item, :count).by(-1)
    end

    it 'redirects to the items list' do
      item = Item.create! valid_attributes
      delete :destroy, id: item.id.to_s
      response.should redirect_to(items_url)
    end
  end
end
