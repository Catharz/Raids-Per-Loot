require 'spec_helper'
require 'authentication_spec_helper'

describe PlayersController do
  include AuthenticationSpecHelper
  fixtures :users, :services, :ranks

  before(:each) do
    login_as :admin
    @main_rank ||= Rank.find_by_name('Main')
  end

  describe 'GET option_list' do
    it 'sorts the players by name' do
      player1 = Player.create!(name: 'Player C', rank_id: @main_rank.id)
      player2 = Player.create!(name: 'Player B', rank_id: @main_rank.id)
      player3 = Player.create!(name: 'Player A', rank_id: @main_rank.id)

      get :option_list

      response.body.
          should == "<option value='#{player3.id}'>Player A</option>" +
          "<option value='#{player2.id}'>Player B</option>" +
          "<option value='#{player1.id}'>Player C</option>"
      assigns(:players).should eq([player3, player2, player1])
    end
  end

  describe 'GET index' do
    it 'assigns all players as @players' do
      player = Player.create! FactoryGirl.attributes_for(:player,
                                                         rank_id: @main_rank.id)
      get :index
      assigns(:players).should eq([player])
    end

    it 'returns CSV' do
      jimmy = Player.create! FactoryGirl.attributes_for(:player,
                                                        rank_id: @main_rank.id)
      jenny = Player.create! FactoryGirl.attributes_for(:player,
                                                        rank_id: @main_rank.id,
                                                        name: 'Jenny')

      get :index, format: :csv

      assigns(:players).should include jimmy
      assigns(:players).should include jenny

      response.content_type.should eq('text/csv')
      response.header.should eq('Content-Type' => 'text/csv; charset=utf-8')
    end

    it 'returns JSON' do
      3.times { FactoryGirl.create(:player) }
      players = Player.all

      get :index, format: :json

      result = JSON.parse(response.body)
      expect(response.content_type).to eq 'application/json'
      expect(result).to eq players.collect { |a| JSON.parse(a.to_json) }
    end

    it 'returns XML' do
      3.times { FactoryGirl.create(:player) }
      players = Player.all

      get :index, format: :xml

      expect(response.content_type).to eq 'application/xml'
      expect(response.body).to have_xpath '//players/*[1]/name'
    end
  end

  describe 'GET attendance' do
    it 'assigns all players as @players, sorted by name' do
      fred = Player.create! FactoryGirl.attributes_for(:player,
                                                       rank_id: @main_rank.id,
                                                       name: 'Fred')
      barney = Player.create! FactoryGirl.attributes_for(:player,
                                                         rank_id: @main_rank.id,
                                                         name: 'Barney')

      get :attendance

      assigns(:players).should eq([barney, fred])
    end
  end

  describe 'GET show' do
    it 'assigns the requested player as @player' do
      player = Player.create! FactoryGirl.attributes_for(:player,
                                                         rank_id: @main_rank.id)
      get :show, id: player.id.to_s
      assigns(:player).should eq(player)
    end

    it 'returns JSON' do
      player = FactoryGirl.create(:player)

      get :show, format: :json, id: player

      result = JSON.parse(response.body)
      expect(response.content_type).to eq 'application/json'
      expect(result).to eq JSON.parse(player.to_json)
    end

    it 'returns XML' do
      player = FactoryGirl.create(:player)

      get :show, format: :xml, id: player

      expect(response.content_type).to eq 'application/xml'
      expect(response.body).to have_xpath '//player/name'
    end
  end

  describe 'GET new' do
    it 'assigns a new player as @player' do
      get :new
      assigns(:player).should be_a_new(Player)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested player as @player' do
      player = Player.create! FactoryGirl.attributes_for(:player,
                                                         rank_id: @main_rank.id)
      get :edit, id: player.id.to_s
      assigns(:player).should eq(player)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Player' do
        expect {
          post :create,
               player: FactoryGirl.attributes_for(:player,
                                                  rank_id: @main_rank.id)
        }.to change(Player, :count).by(1)
      end

      it 'assigns a newly created player as @player' do
        post :create,
             player: FactoryGirl.attributes_for(:player,
                                                rank_id: @main_rank.id)
        assigns(:player).should be_a(Player)
        assigns(:player).should be_persisted
      end

      it 'redirects to the created player' do
        post :create,
             player: FactoryGirl.attributes_for(:player,
                                                rank_id: @main_rank.id)
        response.should redirect_to(Player.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved player as @player' do
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        post :create, player: {"name" => "doofus"}
        assigns(:player).should be_a_new(Player)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        post :create, player: {"name" => "doofus"}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested player' do
        player =
            Player.create! FactoryGirl.attributes_for(:player,
                                                      rank_id: @main_rank.id)
        # Assuming there are no other players in the database, this
        # specifies that the Player created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Player.any_instance.should_receive(:update_attributes).
            with({"name" => "doofus"})
        put :update, id: player.id, player: {"name" => "doofus"}
      end

      it 'assigns the requested player as @player' do
        player =
            Player.create! FactoryGirl.attributes_for(:player,
                                                      rank_id: @main_rank.id)
        put :update, id: player.id,
            player: FactoryGirl.attributes_for(:player, rank_id: @main_rank.id)
        assigns(:player).should eq(player)
      end

      it 'redirects to the player' do
        player =
            Player.create! FactoryGirl.attributes_for(:player,
                                                      rank_id: @main_rank.id)
        put :update, id: player.id,
            player: FactoryGirl.attributes_for(:player, rank_id: @main_rank.id)
        response.should redirect_to(player)
      end

      it 'responds to JSON' do
        player =
            Player.create! FactoryGirl.attributes_for(:player,
                                                      rank_id: @main_rank.id)
        put :update, format: :json, id: player.id,
            player: FactoryGirl.attributes_for(:player, rank_id: @main_rank.id)

        result = JSON.parse(response.body)
        expect(response.content_type).to eq 'application/json'
        expect(result['player']).to have_key 'rank_name'
      end
    end

    describe 'with invalid params' do
      it 'assigns the player as @player' do
        player =
            Player.create! FactoryGirl.attributes_for(:player,
                                                      rank_id: @main_rank.id)
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        put :update, id: player.id.to_s, player: {"name" => "doofus"}
        assigns(:player).should eq(player)
      end

      it "re-renders the 'edit' template" do
        player =
            Player.create! FactoryGirl.attributes_for(:player,
                                                      rank_id: @main_rank.id)
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        put :update, id: player.id.to_s, player: {"name" => "doofus"}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested player' do
      player =
          Player.create! FactoryGirl.attributes_for(:player,
                                                    rank_id: @main_rank.id)
      expect {
        delete :destroy, id: player.id.to_s
      }.to change(Player, :count).by(-1)
    end

    it 'redirects to the players list' do
      player =
          Player.create! FactoryGirl.attributes_for(:player,
                                                    rank_id: @main_rank.id)
      delete :destroy, id: player.id.to_s
      response.should redirect_to(players_url)
    end
  end
end
