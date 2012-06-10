require 'spec_helper'

describe PlayersController do
  fixtures :users

  before(:each) do
    login_as :quentin
    @main_rank ||= FactoryGirl.create(:rank, :name => "Main")
  end

  def valid_attributes
    {:name => "Me",
    :rank_id => @main_rank.id}
  end

  describe "GET index" do
    it "assigns all players as @players" do
      player = Player.create! valid_attributes
      get :index
      assigns(:players).should eq([player])
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
