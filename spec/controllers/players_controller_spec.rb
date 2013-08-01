require 'spec_helper'
require 'authentication_spec_helper'

describe PlayersController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
    @main_rank ||= FactoryGirl.create(:rank, :name => "Main")
  end

  def valid_attributes(options = {})
    {:name => 'Me',
    :rank_id => @main_rank.id}.merge!(options)
  end

  describe 'GET option_list' do
    it 'sorts the players by name' do
      player1 = Player.create!(:name => "Player C", :rank_id => @main_rank.id)
      player2 = Player.create!(:name => "Player B", :rank_id => @main_rank.id)
      player3 = Player.create!(:name => "Player A", :rank_id => @main_rank.id)

      get :option_list

      response.body.should == "<option value='#{player3.id}'>Player A</option><option value='#{player2.id}'>Player B</option><option value='#{player1.id}'>Player C</option>"
      assigns(:players).should eq([player3, player2, player1])
    end
  end

  describe "GET index" do
    it "assigns all players as @players" do
      player = Player.create! valid_attributes
      get :index
      assigns(:players).should eq([player])
    end

    it "returns CSV" do
      jimmy = Player.create! valid_attributes
      jenny = Player.create! valid_attributes.merge! :name => "Jenny"

      get :index, :format => :csv

      assigns(:players).should include jimmy
      assigns(:players).should include jenny

      response.content_type.should eq('text/csv')
      response.header.should eq('Content-Type' => 'text/csv; charset=utf-8')
    end
  end

  describe 'GET attendance' do
    it 'assigns all players as @players, sorted by name' do
      fred = Player.create! valid_attributes(name: 'Fred')
      barney = Player.create! valid_attributes(name: 'Barney')

      get :attendance

      assigns(:players).should eq([barney, fred])
    end
  end

  describe "GET show" do
    it "assigns the requested player as @player" do
      player = Player.create! valid_attributes
      get :show, :id => player.id.to_s
      assigns(:player).should eq(player)
    end
  end

  describe "GET new" do
    it "assigns a new player as @player" do
      get :new
      assigns(:player).should be_a_new(Player)
    end
  end

  describe "GET edit" do
    it "assigns the requested player as @player" do
      player = Player.create! valid_attributes
      get :edit, :id => player.id.to_s
      assigns(:player).should eq(player)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Player" do
        expect {
          post :create, :player => valid_attributes
        }.to change(Player, :count).by(1)
      end

      it "assigns a newly created player as @player" do
        post :create, :player => valid_attributes
        assigns(:player).should be_a(Player)
        assigns(:player).should be_persisted
      end

      it "redirects to the created player" do
        post :create, :player => valid_attributes
        response.should redirect_to(Player.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved player as @player" do
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        post :create, :player => {}
        assigns(:player).should be_a_new(Player)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        post :create, :player => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested player" do
        player = Player.create! valid_attributes
        # Assuming there are no other players in the database, this
        # specifies that the Player created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Player.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => player.id, :player => {'these' => 'params'}
      end

      it "assigns the requested player as @player" do
        player = Player.create! valid_attributes
        put :update, :id => player.id, :player => valid_attributes
        assigns(:player).should eq(player)
      end

      it "redirects to the player" do
        player = Player.create! valid_attributes
        put :update, :id => player.id, :player => valid_attributes
        response.should redirect_to(player)
      end
    end

    describe "with invalid params" do
      it "assigns the player as @player" do
        player = Player.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        put :update, :id => player.id.to_s, :player => {}
        assigns(:player).should eq(player)
      end

      it "re-renders the 'edit' template" do
        player = Player.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Player.any_instance.stub(:save).and_return(false)
        put :update, :id => player.id.to_s, :player => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested player" do
      player = Player.create! valid_attributes
      expect {
        delete :destroy, :id => player.id.to_s
      }.to change(Player, :count).by(-1)
    end

    it "redirects to the players list" do
      player = Player.create! valid_attributes
      delete :destroy, :id => player.id.to_s
      response.should redirect_to(players_url)
    end
  end

end
