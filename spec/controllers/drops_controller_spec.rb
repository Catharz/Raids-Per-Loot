require 'spec_helper'
require 'drop_spec_helper'
require 'authentication_spec_helper'

describe DropsController do
  fixtures :users, :services, :archetypes, :loot_types, :ranks
  include AuthenticationSpecHelper
  include DropSpecHelper

  before(:each) do
    # Need to be logged in
    login_as :admin
    @drop_details = create_drop_dependencies
  end

  describe 'GET invalid' do
    it 'lists drops assigned to the wrong archetype' do
      priest = Archetype.find_by_name('Fury')
      FactoryGirl.create(:archetypes_item,
                         archetype_id: priest.id,
                         item_id: @drop_details[:armour_item].id)
      drop = FactoryGirl.create(:drop,
                                item_id: @drop_details[:armour_item].id,
                                loot_method: 'n')

      get :invalid

      assigns(:drops).should eq([drop])
    end

    it 'does not list trash drops' do
      FactoryGirl.create(:drop,
                         item_id: @drop_details[:trash_item].id,
                         loot_method: 't',
                         loot_type_id: @drop_details[:loot_type_id])

      get :invalid

      assigns(:drops).should eq([])
    end

    it 'lists trash drops that were won via need' do
      drop = FactoryGirl.create(:drop,
                                item_id: @drop_details[:trash_item].id,
                                loot_method: 'n')

      get :invalid

      assigns(:drops).should eq([drop])
    end

    it 'lists trash drops that were won via random' do
      drop = FactoryGirl.create(:drop,
                                item_id: @drop_details[:trash_item].id,
                                loot_method: 'r')

      get :invalid

      assigns(:drops).should eq([drop])
    end

    it 'lists trash drops that were won via bid' do
      drop = FactoryGirl.create(:drop,
                                item_id: @drop_details[:trash_item].id,
                                loot_method: 'b')

      get :invalid

      assigns(:drops).should eq([drop])
    end
  end

  describe 'GET index' do
    it 'allows for pagination' do
      Array.new(5) { |n| FactoryGirl.create(:drop, drop_time: DateTime.parse("2013-12-25 18:0#{4 - n}+11:00")) }

      get :index, format: :json, sEcho: 0, iDisplayLength: 3

      JSON.parse(response.body)['aaData'].count.should eq 3
    end

    it 'should render JSON' do
      drop = FactoryGirl.create :drop, drop_time: DateTime.parse('2013-12-25 18:00+11:00')
      expected = drop_as_json(drop)

      get :index, format: :json, sEcho: 0
      actual = JSON.parse(response.body)

      actual.should == expected
    end

    it 'should render XML with chat' do
      FactoryGirl.create :drop, drop_time: DateTime.parse('2013-12-25 18:00+11:00'), chat: 'Blah, de-blah!'

      get :index, format: :xml

      Nokogiri.parse(response.body).at_xpath('/drops/*[1]/chat').inner_text.should eq 'Blah, de-blah!'
    end

    it 'should filter by instance when fetching xml' do
      FactoryGirl.create(:drop)
      instance = FactoryGirl.create(:instance, raid_id: @drop_details[:raid].id, zone_id: @drop_details[:zone].id,
                                    start_time: DateTime.parse('03/01/2012 3:00PM'))
      FactoryGirl.create(:drop, instance_id: instance.id, drop_time: DateTime.parse('03/01/2012 3:00PM'))

      get :index, format: :xml, instance_id: instance.id

      response.should contain '2012-01-04T02:00:00+11:00'
      response.should_not contain '2012-01-04T01:00:00+11:00'
    end

    it 'should filter by drop time when fetching xml' do
      FactoryGirl.create(:drop)
      instance = FactoryGirl.create(:instance, raid_id: @drop_details[:raid].id, zone_id: @drop_details[:zone].id,
                                    start_time: DateTime.parse('03/01/2012 3:00PM'))
      FactoryGirl.create(:drop, instance_id: instance.id, drop_time: DateTime.parse('03/01/2012 3:00PM'))

      get :index, format: :xml, drop_time: DateTime.parse('03/01/2012 3:00PM')

      response.should contain '2012-01-04T02:00:00+11:00'
      response.should_not contain '2012-01-04T01:00:00+11:00'
    end

    it 'should filter by zone when fetching xml' do
      FactoryGirl.create(:drop)
      zone = FactoryGirl.create(:zone, name: 'Loot Lounge')
      instance = FactoryGirl.create(:instance, raid_id: @drop_details[:raid].id, zone_id: zone.id,
                                    start_time: DateTime.parse('03/01/2012 3:00PM'))
      FactoryGirl.create(:drop, instance_id: instance.id, zone_id: zone.id,
                         drop_time: DateTime.parse('03/01/2012 3:00PM'))

      get :index, format: :xml, zone_id: zone.id

      response.should contain '2012-01-04T02:00:00+11:00'
      response.should_not contain '2012-01-04T01:00:00+11:00'
    end

    it 'should filter by mob when fetching xml' do
      FactoryGirl.create(:drop)
      mob = FactoryGirl.create(:mob, zone_id: @drop_details[:zone].id, name: 'Whack-a-mole')
      FactoryGirl.create(:drop, mob_id: mob.id, drop_time: DateTime.parse('03/01/2012 3:00PM'))

      get :index, format: :xml, mob_id: mob.id

      response.should contain '2012-01-04T02:00:00+11:00'
      response.should_not contain '2012-01-04T01:00:00+11:00'
    end

    it 'should filter by item when fetching xml' do
      FactoryGirl.create(:drop)
      item = FactoryGirl.create(:item, name: 'Letter Opener', :eq2_item_id => '1234')
      FactoryGirl.create(:drop, item_id: item.id, drop_time: DateTime.parse('03/01/2012 3:00PM'))

      get :index, format: :xml, item_id: item.id

      response.should contain '2012-01-04T02:00:00+11:00'
      response.should_not contain '2012-01-04T01:00:00+11:00'
    end

    it 'should filter by character when fetching xml' do
      FactoryGirl.create(:drop)
      character = FactoryGirl.create(:character, name: 'Them', player_id: @drop_details[:player_id],
                                     archetype_id: @drop_details[:archetype].id, char_type: 'm')
      FactoryGirl.create(:drop, character_id: character.id, drop_time: DateTime.parse('03/01/2012 3:00PM'))

      get :index, format: :xml, character_id: character.id

      response.should contain '2012-01-04T02:00:00+11:00'
      response.should_not contain '2012-01-04T01:00:00+11:00'
    end
  end

  describe 'GET show' do
    it 'assigns the requested drop as @drop' do
      drop = FactoryGirl.create(:drop)
      get :show, id: drop.id.to_s
      assigns(:drop).should eq(drop)
    end

    it 'renders JSON' do
      drop = FactoryGirl.create(:drop)

      get :show, id: drop, format: :json

      JSON.parse(response.body).should eq JSON.parse(Drop.select(:chat).find(drop.id).
                                                         to_json(methods: [:loot_method_name, :invalid_reason,
                                                                           :character_name, :character_archetype_name,
                                                                           :loot_type_name, :item_name,
                                                                           :mob_name, :zone_name]))
    end

    it 'renders XML' do
      drop = FactoryGirl.create(:drop)

      get :show, format: :xml, id: drop

      Nokogiri.parse(response.body).at_xpath('/drop/zone-name').inner_text.should eq drop.zone_name
    end
  end

  describe 'GET new' do
    it 'assigns a new drop as @drop' do
      get :new
      assigns(:drop).should be_a_new(Drop)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested drop as @drop' do
      drop = FactoryGirl.create(:drop)
      get :edit, id: drop.id.to_s
      assigns(:drop).should eq(drop)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Drop' do
        drop_params = FactoryGirl.attributes_for(:drop)
        expect {
          post :create, drop: drop_params
        }.to change(Drop, :count).by(1)
      end

      it 'assigns a newly created drop as @drop' do
        drop_params = FactoryGirl.attributes_for(:drop)
        post :create, drop: drop_params
        assigns(:drop).should be_a(Drop)
        assigns(:drop).should be_persisted
      end

      it 'redirects to the created drop' do
        drop_params = FactoryGirl.attributes_for(:drop)
        post :create, drop: drop_params
        response.should redirect_to(Drop.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved drop as @drop' do
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        post :create, drop: {drop_time: Time.now}
        assigns(:drop).should be_a_new(Drop)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        post :create, drop: {drop_time: Time.now}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested drop' do
        drop = FactoryGirl.create(:drop)
        # Assuming there are no other drops in the database, this
        # specifies that the Drop created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Drop.any_instance.should_receive(:update_attributes).
            with({'character_id' => '1'})
        put :update, id: drop.id, drop: {character_id: 1}
      end

      it 'assigns the requested drop as @drop' do
        drop = FactoryGirl.create(:drop)
        put :update, id: drop.id, drop: FactoryGirl.attributes_for(:drop)
        assigns(:drop).should eq(drop)
      end

      it 'redirects to the drop' do
        drop = FactoryGirl.create(:drop)
        put :update, id: drop.id, drop: FactoryGirl.attributes_for(:drop)
        response.should redirect_to(drop)
      end

      it 'responds with 303 if HTTP_REFERER is set' do
        drop = FactoryGirl.create(:drop)
        @request.env['HTTP_REFERER'] = admin_path
        put :update, id: drop.id, drop: FactoryGirl.attributes_for(:drop)
        response.status.should == 303
        response.should redirect_to(admin_path)
      end
    end

    describe 'with invalid params' do
      it 'assigns the drop as @drop' do
        drop = FactoryGirl.create(:drop)
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        put :update, id: drop.id.to_s, drop: {drop_time: Time.now}
        assigns(:drop).should eq(drop)
      end

      it "re-renders the 'edit' template" do
        drop = FactoryGirl.create(:drop)
        # Trigger the behavior that occurs when invalid params are submitted
        Drop.any_instance.stub(:save).and_return(false)
        put :update, id: drop.id.to_s, drop: {drop_time: Time.now}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested drop' do
      drop = FactoryGirl.create(:drop)
      expect {
        delete :destroy, id: drop.id.to_s
      }.to change(Drop, :count).by(-1)
    end

    it 'redirects to the drops list' do
      drop = FactoryGirl.create(:drop)
      delete :destroy, id: drop.id.to_s
      response.should redirect_to(drops_url)
    end
  end

  private
  def drop_dependencies
    zone = FactoryGirl.create(:zone)
    mob = FactoryGirl.create(:mob, zone_id: zone.id)
    raid = FactoryGirl.create(:raid)
    instance = FactoryGirl.create(:instance, raid_id: raid.id, zone_id: zone.id)
    character = FactoryGirl.create(:character)
    item = FactoryGirl.create(:item)
    {raid_id: raid.id, zone_id: zone.id, instance_id: instance.id,
      mob_id: mob.id, character_id: character.id, item_id: item.id}
  end
end
