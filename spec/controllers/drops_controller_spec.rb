require 'spec_helper'
require 'drop_spec_helper'

describe DropsController do
  include DropSpecHelper
  fixtures :users

  before(:each) do
    # Need to be logged in
    login_as :quentin
    @drop_details = create_drop_dependencies
  end

  describe "GET invalid" do
    it "lists drops assigned to the wrong archetype" do
      priest = FactoryGirl.create(:archetype, :name => 'Priest')
      FactoryGirl.create(:archetypes_item, :archetype_id => priest.id, :item_id => @drop_details[:armour_item].id)
      drop = FactoryGirl.create(:drop, valid_attributes(:item_id => @drop_details[:armour_item].id, :loot_method => 'n'))

      get :invalid

      assigns(:drops).should eq([drop])
    end

    it "does not list trash drops" do
      FactoryGirl.create(:drop, valid_attributes(:item_id => @drop_details[:trash_item].id, :loot_method => 't', :loot_type_id => @drop_details[:loot_type_id]))

      get :invalid

      assigns(:drops).should eq([])
    end

    it "lists trash drops that were won via need" do
      drop = FactoryGirl.create(:drop, valid_attributes(:item_id => @drop_details[:trash_item].id, :loot_method => 'n'))

      get :invalid

      assigns(:drops).should eq([drop])
    end

    it "lists trash drops that were won via random" do
      drop = FactoryGirl.create(:drop, valid_attributes(:item_id => @drop_details[:trash_item].id, :loot_method => 'r'))

      get :invalid

      assigns(:drops).should eq([drop])
    end

    it "lists trash drops that were won via bid" do
      drop = FactoryGirl.create(:drop, valid_attributes(:item_id => @drop_details[:trash_item].id, :loot_method => 'b'))

      get :invalid

      assigns(:drops).should eq([drop])
    end
  end

  #TODO: Fix these tests, relying on my time zone is too brittle
  describe "GET index" do
    it "should render JSON" do
      drop = FactoryGirl.create(:drop, valid_attributes)
      expected = {"sEcho" => 0,
                  "iTotalRecords" => 1,
                  "iTotalDisplayRecords" => 1,
                  "aaData" => [
                      ["Armour",
                       "Me",
                       "Armour",
                       "Wherever",
                       "Whoever",
                       "2012-01-04T01:00:00+11:00",
                       "Trash",
                       '<a href="/drops/' + drop.id.to_s + '" class="table-button">Show</a>',
                       '<a href="/drops/' + drop.id.to_s + '/edit" class="table-button">Edit</a>',
                       '<a href="/drops/' + drop.id.to_s + '" class="table-button" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Destroy</a>'
                      ]
                  ]
      }

      get :index, :format => :json
      actual = JSON.parse(response.body)

      actual.should == expected
    end

    it "should filter by instance when fetching xml" do
      FactoryGirl.create(:drop, valid_attributes)
      instance = FactoryGirl.create(:instance, :raid_id => @drop_details[:raid].id, :zone_id => @drop_details[:zone].id, :start_time => DateTime.parse("03/01/2012 3:00PM"))
      FactoryGirl.create(:drop, valid_attributes.merge!(:instance_id => instance.id, :drop_time => DateTime.parse("03/01/2012 3:00PM")))

      get :index, :format => :xml, :instance_id => instance.id
      response.should contain "2012-01-04T02:00:00+11:00"
      response.should_not contain "2012-01-04T01:00:00+11:00"
    end

    it "should filter by drop time when fetching xml" do
      FactoryGirl.create(:drop, valid_attributes)
      instance = FactoryGirl.create(:instance, :raid_id => @drop_details[:raid].id, :zone_id => @drop_details[:zone].id, :start_time => DateTime.parse("03/01/2012 3:00PM"))
      FactoryGirl.create(:drop, valid_attributes.merge!(:instance_id => instance.id, :drop_time => DateTime.parse("03/01/2012 3:00PM")))

      get :index, :format => :xml, :drop_time => DateTime.parse("03/01/2012 3:00PM")
      response.should contain "2012-01-04T02:00:00+11:00"
      response.should_not contain "2012-01-04T01:00:00+11:00"
    end

    it "should filter by zone when fetching xml" do
      FactoryGirl.create(:drop, valid_attributes)
      zone = FactoryGirl.create(:zone, :name => 'Loot Lounge')
      instance = FactoryGirl.create(:instance, :raid_id => @drop_details[:raid].id, :start_time => DateTime.parse("03/01/2012 3:00PM"), :zone_id => zone.id)
      FactoryGirl.create(:drop, valid_attributes.merge!(:instance_id => instance.id, :zone_id => zone.id, :drop_time => DateTime.parse("03/01/2012 3:00PM")))

      get :index, :format => :xml, :zone_id => zone.id
      response.should contain "2012-01-04T02:00:00+11:00"
      response.should_not contain "2012-01-04T01:00:00+11:00"
    end

    it "should filter by mob when fetching xml" do
      FactoryGirl.create(:drop, valid_attributes)
      mob = FactoryGirl.create(:mob, :zone_id => @drop_details[:zone].id, :name => "Whack-a-mole")
      FactoryGirl.create(:drop, valid_attributes.merge!(:mob_id => mob.id, :drop_time => DateTime.parse("03/01/2012 3:00PM")))

      get :index, :format => :xml, :mob_id => mob.id
      response.should contain "2012-01-04T02:00:00+11:00"
      response.should_not contain "2012-01-04T01:00:00+11:00"
    end

    it "should filter by item when fetching xml" do
      FactoryGirl.create(:drop, valid_attributes)
      item = FactoryGirl.create(:item, :name => 'Letter Opener', :eq2_item_id => '1234')
      FactoryGirl.create(:drop, valid_attributes.merge!(:item_id => item.id, :drop_time => DateTime.parse("03/01/2012 3:00PM")))

      get :index, :format => :xml, :item_id => item.id
      response.should contain "2012-01-04T02:00:00+11:00"
      response.should_not contain "2012-01-04T01:00:00+11:00"
    end

    it "should filter by character when fetching xml" do
      FactoryGirl.create(:drop, valid_attributes)
      character = FactoryGirl.create(:character, :name => "Them", :player_id => @drop_details[:player_id], :archetype_id => @drop_details[:archetype].id, :char_type => "m")
      FactoryGirl.create(:drop, valid_attributes.merge!(:character_id => character.id, :drop_time => DateTime.parse("03/01/2012 3:00PM")))

      get :index, :format => :xml, :character_id => character.id
      response.should contain "2012-01-04T02:00:00+11:00"
      response.should_not contain "2012-01-04T01:00:00+11:00"
    end
  end

  describe "GET show" do
    it "assigns the requested drop as @drop" do
      drop = FactoryGirl.create(:drop, valid_attributes)
      get :show, :id => drop.id.to_s
      assigns(:drop).should eq(drop)
    end
  end

  describe "GET new" do
    it "assigns a new drop as @drop" do
      get :new
      assigns(:drop).should be_a_new(Drop)
    end
  end

  describe "GET edit" do
    it "assigns the requested drop as @drop" do
      drop = FactoryGirl.create(:drop, valid_attributes)
      get :edit, :id => drop.id.to_s
      assigns(:drop).should eq(drop)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Drop" do
        expect {
          post :create, :drop => valid_attributes
        }.to change(Drop, :count).by(1)
      end

      it "assigns a newly created drop as @drop" do
        post :create, :drop => valid_attributes
        assigns(:drop).should be_a(Drop)
        assigns(:drop).should be_persisted
      end

      it "redirects to the created drop" do
        post :create, :drop => valid_attributes
        response.should redirect_to(Drop.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved drop as @drop" do
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        post :create, :drop => {}
        assigns(:drop).should be_a_new(Drop)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        post :create, :drop => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested drop" do
        drop = FactoryGirl.create(:drop, valid_attributes)
        # Assuming there are no other drops in the database, this
        # specifies that the Drop created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Drop.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => drop.id, :drop => {'these' => 'params'}
      end

      it "assigns the requested drop as @drop" do
        drop = FactoryGirl.create(:drop, valid_attributes)
        put :update, :id => drop.id, :drop => valid_attributes
        assigns(:drop).should eq(drop)
      end

      it "redirects to the drop" do
        drop = FactoryGirl.create(:drop, valid_attributes)
        put :update, :id => drop.id, :drop => valid_attributes
        response.should redirect_to(drop)
      end
    end

    describe "with invalid params" do
      it "assigns the drop as @drop" do
        drop = FactoryGirl.create(:drop, valid_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        put :update, :id => drop.id.to_s, :drop => {}
        assigns(:drop).should eq(drop)
      end

      it "re-renders the 'edit' template" do
        drop = FactoryGirl.create(:drop, valid_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        put :update, :id => drop.id.to_s, :drop => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested drop" do
      drop = FactoryGirl.create(:drop, valid_attributes)
      expect {
        delete :destroy, :id => drop.id.to_s
      }.to change(Drop, :count).by(-1)
    end

    it "redirects to the drops list" do
      drop = FactoryGirl.create(:drop, valid_attributes)
      delete :destroy, :id => drop.id.to_s
      response.should redirect_to(drops_url)
    end
  end
end