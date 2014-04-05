require 'spec_helper'
require 'authentication_spec_helper'

describe AdminController do
  include AuthenticationSpecHelper
  fixtures :users, :services, :loot_types

  before(:each) do
    login_as :admin
  end

  describe 'GET #show' do
    it 'renders the :show template ' do
      get :show

      response.should render_template :show
    end
  end

  describe 'GET #upload' do
    it 'renders the :upload template' do
      get :upload, format: 'js'

      response.should render_template :upload
    end
  end

  describe 'POST #upload_files' do
    it 'copies the uploaded files to temp' do
      temp_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/eq2log_Catharz.01.txt'), 'text/plain')
      temp_file.stub(:tempfile).and_return(temp_file)
      post :upload_files, {upl: temp_file}

      File.exist?(File.join(Dir.tmpdir, 'eq2log_Catharz.01.txt')).should be_true
      response.should be_success
    end

    it 'returns failure if the file is nil' do
      post :upload_files

      response.response_code.should == 500
    end
  end

  context 'item clean-up actions' do
    describe 'POST #fix_trash_drops' do
      it 'calls Item.fix_trash_drops' do
        trash = LootType.find_by_name('Trash')
        item = FactoryGirl.create(:item, loot_type: trash)
        FactoryGirl.create(:drop, item: item, loot_method: 'n')

        Resque.should_receive(:enqueue).with(TrashDropFixer)

        post :fix_trash_drops
      end

      it 'redirects to /admin when done' do
        post :fix_trash_drops

        response.should redirect_to '/admin'
      end
    end

    describe 'POST #resolve_duplicate_items' do
      it 'calls SonyDataService.resolve_duplicate_items' do
        SonyDataService.any_instance.
            should_receive(:resolve_duplicate_items).
            and_return(true)

        post :resolve_duplicate_items
      end

      it 'redirects to /admin when done' do
        SonyDataService.any_instance.
            should_receive(:resolve_duplicate_items).
            and_return(false)

        post :resolve_duplicate_items

        response.should redirect_to '/admin'
      end
    end
  end

  context 'Sony Data API action' do
    describe 'POST #update_character_list' do
      it 'calls SonyDataService.new.update_character_list' do
        SonyDataService.any_instance.
            should_receive(:update_character_list).
            and_return(0)

        post :update_character_list
      end

      it 'redirects to /admin when done' do
        SonyDataService.any_instance.
            should_receive(:update_character_list).
            and_return(-1)

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
        SonyDataService.any_instance.
            should_receive(:update_player_list).and_return(0)

        post :update_player_list
      end

      it 'redirects to /admin when done' do
        SonyDataService.any_instance.
            should_receive(:update_player_list).and_return(-1)

        post :update_player_list

        response.should redirect_to '/admin'
      end
    end
  end
end
