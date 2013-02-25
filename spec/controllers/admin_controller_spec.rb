require 'spec_helper'

describe AdminController do
  fixtures :users

  describe 'GET #show' do
    it 'redirects to /session/new if not logged in' do
      get :show

      response.should redirect_to '/session/new'
    end

    it 'renders the :show template if logged in' do
      login_as :quentin
      get :show

      response.should render_template :show
    end
  end

  context 'item clean-up actions' do
    describe 'POST #fix_trash_drops' do
      it 'redirects to /session/new if not logged in' do
        post :fix_trash_drops

        response.should redirect_to '/session/new'
      end

      it 'calls Item.fix_trash_drops' do
        login_as :quentin
        Item.should_receive(:fix_trash_drops).and_return(1)

        post :fix_trash_drops
      end

      it 'redirects to /admin when done' do
        login_as :quentin
        Item.should_receive(:fix_trash_drops).and_return(0)

        post :fix_trash_drops

        response.should redirect_to '/admin'
      end
    end

    describe 'POST #resolve_duplicate_items' do
      it 'redirects to /session/new if not logged in' do
        post :resolve_duplicate_items

        response.should redirect_to '/session/new'
      end

      it 'calls Item.resolve_duplicate_items' do
        login_as :quentin
        Item.should_receive(:resolve_duplicates).and_return(true)

        post :resolve_duplicate_items
      end

      it 'redirects to /admin when done' do
        login_as :quentin
        Item.should_receive(:resolve_duplicates).and_return(false)

        post :resolve_duplicate_items

        response.should redirect_to '/admin'
      end
    end
  end

  context 'Sony Data API action' do
    describe 'POST #update_character_list' do
      it 'redirects to /session/new if not logged in' do
        post :update_character_list

        response.should redirect_to '/session/new'
      end

      it 'calls SonyDataService.new.update_character_list' do
        login_as :quentin
        SonyDataService.any_instance.should_receive(:update_character_list).and_return(0)

        post :update_character_list
      end

      it 'redirects to /admin when done' do
        login_as :quentin
        SonyDataService.any_instance.should_receive(:update_character_list).and_return(-1)

        post :update_character_list

        response.should redirect_to '/admin'
      end
    end

    describe 'POST #update_player_list' do
      it 'redirects to /session/new if not logged in' do
        post :update_player_list

        response.should redirect_to '/session/new'
      end

      it 'calls SonyDataService.new.update_player_list' do
        login_as :quentin
        SonyDataService.any_instance.should_receive(:update_player_list).and_return(0)

        post :update_player_list
      end

      it 'redirects to /admin when done' do
        login_as :quentin
        SonyDataService.any_instance.should_receive(:update_player_list).and_return(-1)

        post :update_player_list

        response.should redirect_to '/admin'
      end
    end
  end
end