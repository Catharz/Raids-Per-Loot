require 'spec_helper'

describe ItemsController do
  fixtures :users

  before(:each) do
    login_as :quentin
  end

  def valid_attributes
    {:name => "Whatever", :eq2_item_id => "numbers"}
  end

  describe "GET index" do
    it "should render JSON" do
      item = Item.create! valid_attributes
      expected = {"sEcho" => 0,
                  "iTotalRecords"  => 1,
                  "iTotalDisplayRecords" => 1,
                  "aaData" => [
                      ['<a href="/items/1" class="itemPopupTrigger" id="1">Whatever</a>',
                       "Unknown",
                       nil,
                       nil,
                       '<a href="/items/1" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Destroy</a>'
                      ]
                  ]
      }

      get :index, :format => :json
      actual = JSON.parse(response.body)

      actual.should == expected
    end
  end

  describe "GET show" do
    it "assigns the requested item as @item" do
      item = Item.create! valid_attributes
      get :show, :id => item.id.to_s
      assigns(:item).should eq(item)
    end
  end

  describe "GET new" do
    it "assigns a new item as @item" do
      get :new
      assigns(:item).should be_a_new(Item)
    end
  end

  describe "GET edit" do
    it "assigns the requested item as @item" do
      item = Item.create! valid_attributes
      get :edit, :id => item.id.to_s
      assigns(:item).should eq(item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Item" do
        expect {
          post :create, :item => valid_attributes
        }.to change(Item, :count).by(1)
      end

      it "assigns a newly created item as @item" do
        post :create, :item => valid_attributes
        assigns(:item).should be_a(Item)
        assigns(:item).should be_persisted
      end

      it "redirects to the created item" do
        post :create, :item => valid_attributes
        response.should redirect_to(Item.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved item as @item" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, :item => {}
        assigns(:item).should be_a_new(Item)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, :item => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested item" do
        item = Item.create! valid_attributes
        # Assuming there are no other items in the database, this
        # specifies that the Item created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Item.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => item.id, :item => {'these' => 'params'}
      end

      it "assigns the requested item as @item" do
        item = Item.create! valid_attributes
        put :update, :id => item.id, :item => valid_attributes
        assigns(:item).should eq(item)
      end

      it "redirects to the item" do
        item = Item.create! valid_attributes
        put :update, :id => item.id, :item => valid_attributes
        response.should redirect_to(item)
      end
    end

    describe "with invalid params" do
      it "assigns the item as @item" do
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
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested item" do
      item = Item.create! valid_attributes
      expect {
        delete :destroy, :id => item.id.to_s
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the items list" do
      item = Item.create! valid_attributes
      delete :destroy, :id => item.id.to_s
      response.should redirect_to(items_url)
    end
  end

end
