require 'spec_helper'

describe AdminController do
  fixtures :users

  before(:each) do
    login_as :quentin
  end

  describe 'GET #show' do
    it 'renders the :show template ' do
      get :show

      response.should render_template :show
    end
  end

  context 'item clean-up actions' do
    describe 'POST #fix_trash_drops' do
      it 'calls Item.fix_trash_drops' do
        Item.should_receive(:fix_trash_drops).and_return(1)

        post :fix_trash_drops
      end

      it 'redirects to /admin when done' do
        Item.should_receive(:fix_trash_drops).and_return(0)

        post :fix_trash_drops

        response.should redirect_to '/admin'
      end
    end

    describe 'POST #resolve_duplicate_items' do
      it 'calls Item.resolve_duplicate_items' do
        Item.should_receive(:resolve_duplicates).and_return(true)

        post :resolve_duplicate_items
      end

      it 'redirects to /admin when done' do
        Item.should_receive(:resolve_duplicates).and_return(false)

        post :resolve_duplicate_items

        response.should redirect_to '/admin'
      end
    end
  end

  context 'Sony Data API action' do
    describe 'POST #update_character_list' do
      it 'calls SonyDataService.new.update_character_list' do
        SonyDataService.any_instance.should_receive(:update_character_list).and_return(0)

        post :update_character_list
      end

      it 'redirects to /admin when done' do
        SonyDataService.any_instance.should_receive(:update_character_list).and_return(-1)

        post :update_character_list

        response.should redirect_to '/admin'
      end
    end

    describe 'POST #update_character_details' do
      it 'calls SonyDataService.update_character_details' do
        SonyDataService.any_instance.should_receive(:update_character_details)

        post :update_character_details
      end

      it 'redirects to /admin' do
        SonyDataService.any_instance.should_receive(:update_character_details)

        post :update_character_details

        response.should redirect_to admin_url
      end
    end

    describe 'POST #update_player_list' do
      it 'calls SonyDataService.new.update_player_list' do
        SonyDataService.any_instance.should_receive(:update_player_list).and_return(0)

        post :update_player_list
      end

      it 'redirects to /admin when done' do
        SonyDataService.any_instance.should_receive(:update_player_list).and_return(-1)

        post :update_player_list

        response.should redirect_to '/admin'
      end
    end
  end
end