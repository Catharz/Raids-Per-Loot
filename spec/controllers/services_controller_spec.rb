require 'spec_helper'
require 'authentication_spec_helper'

describe ServicesController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  describe 'GET index' do
    it 'requires the user to be logged in' do
      get :index
      response.should redirect_to '/services/signin'
    end

    it 'sets the page title' do
      login_as :admin
      get :index
      assigns(:pagetitle).should eq 'Authentication Services'
    end

    it 'assigns the users services to @services' do
      login_as :admin
      get :index
      assigns(:services).should match_array users(:admin).services
    end
  end

  describe 'POST destroy' do
    before(:each) do
      login_as(:admin)
      @admin = users(:admin)
    end

    it 'deletes the service' do
      other_service = @admin.services.create!(FactoryGirl.attributes_for(:service))
      expect {
        delete :destroy, id: other_service
      }.to change(Service, :count).by(-1)
    end

    it 'redirects to services#index' do
      delete :destroy, id: @admin
      response.should redirect_to services_url
    end

    it 'displays an error message if logged in with that account' do
      session[:service_id] = @admin.services.first.id
      delete :destroy, id: @admin.services.first
      response.should redirect_to services_url
      flash[:error].should match 'You are currently signed in with this account!'
    end
  end

  describe 'POST newaccount' do
    context 'when cancelling creation' do
      it 'clears the authorisation hash' do
        session[:authhash] = {foo: 'bar'}
        post :newaccount, commit: 'Cancel'
        session[:authhash].should be_nil
      end

      it 'redirects to the home page' do
        post :newaccount, commit: 'Cancel'
        response.should redirect_to root_url
      end
    end

    context 'when confirming creation' do
      it 'creates a user using the session auth hash' do
        session[:authhash] = {name: 'Fred', email: 'fred@example.com', provider: 'provider', uid: 'fred'}
        expect {
          post :newaccount
        }.to change(User, :count).by(1)
      end

      it 'creates a service using the session auth hash' do
        session[:authhash] = {name: 'Fred', email: 'fred@example.com', provider: 'provider', uid: 'fred'}
        expect {
          post :newaccount
        }.to change(Service, :count).by(1)
      end

      context 'with errors' do
        it 'redirects to the home page' do
          session[:authhash] = {name: 'Fred', email: 'fred@example.com', provider: 'provider', uid: 'fred'}
          User.any_instance.should_receive(:save!).and_return(false)
          post :newaccount
          response.should redirect_to root_url
        end

        it 'displays an appropriate error message' do
          session[:authhash] = {name: 'Fred', email: 'fred@example.com', provider: 'provider', uid: 'fred'}
          User.any_instance.should_receive(:save!).and_return(false)
          post :newaccount
          flash[:error].should match 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
        end
      end
    end
  end

  describe 'GET signout' do
    it 'clears out the session details' do
      login_as(:admin)
      session[:user_id].should eq users(:admin).id
      session[:service_id].should eq users(:admin).services.first.id
      get :signout
      session.has_key?(:user_id).should be_false
      session.has_key?(:service_id).should be_false
    end

    it 'displays a signed out message' do
      login_as(:admin)
      get :signout
      flash[:notice].should match 'You have been signed out!'
    end

    it 'redirects to the home page' do
      login_as(:admin)
      get :signout
      response.should redirect_to root_url
    end
  end

  describe 'GET create' do
    context 'facebook' do
      before(:each) do
        @env = {
            'provider' => 'facebook',
            'extra' => {'user_hash' => {'email' => 'fred@example.com', 'name' => 'Fred', 'id' => '001'}}
        }
      end

      it 'assigns the provider to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'facebook'
        assigns(:authhash)[:provider].should eq 'facebook'
      end

      it 'assigns the users email address to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'facebook'
        assigns(:authhash)[:email].should eq 'fred@example.com'
      end

      it 'assigns the users name to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'facebook'
        assigns(:authhash)[:name].should eq 'Fred'
      end

      it 'assigns the users id to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'facebook'
        assigns(:authhash)[:uid].should eq '001'
      end
    end

    context 'github' do
      before(:each) do
        @env = {
            'provider' => 'github',
            'user_info' => {'email' => 'fred@example.com', 'name' => 'Fred'},
            'extra' => {'user_hash' => {'id' => '001'}}
        }
      end

      it 'assigns the provider to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'github'
        assigns(:authhash)[:provider].should eq 'github'
      end

      it 'assigns the users email address to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'github'
        assigns(:authhash)[:email].should eq 'fred@example.com'
      end

      it 'assigns the users name to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'github'
        assigns(:authhash)[:name].should eq 'Fred'
      end

      it 'assigns the users id to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'github'
        assigns(:authhash)[:uid].should eq '001'
      end
    end

    context 'google' do
      before(:each) do
        @env = {
            'provider' => 'google',
            'uid' => '001',
            'info' => {'email' => 'fred@example.com', 'name' => 'Fred'}
        }
      end

      it 'assigns the provider to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'google'
        assigns(:authhash)[:provider].should eq 'google'
      end

      it 'assigns the users email address to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'google'
        assigns(:authhash)[:email].should eq 'fred@example.com'
      end

      it 'assigns the users name to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'google'
        assigns(:authhash)[:name].should eq 'Fred'
      end

      it 'assigns the users id to the auth hash' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'google'
        assigns(:authhash)[:uid].should eq '001'
      end
    end

    context 'twitter, myopenid and open_id' do
      before(:each) do
        @env = {
            'provider' => 'twitter',
            'uid' => '001',
            'user_info' => {'email' => 'fred@example.com', 'name' => 'Fred'}
        }
      end

      it 'assigns the provider to the auth hash' do
        %w{twitter myopenid open_id}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:provider].should eq provider
        end
      end

      it 'assigns the users email address to the auth hash' do
        %w{twitter myopenid open_id}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:email].should eq 'fred@example.com'
        end
      end

      it 'assigns the users name to the auth hash' do
        %w{twitter myopenid open_id}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:name].should eq 'Fred'
        end
      end

      it 'assigns the users id to the auth hash' do
        %w{twitter myopenid open_id}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:uid].should eq '001'
        end
      end
    end

    context 'yahoo and developer' do
      before(:each) do
        @env = {
            'provider' => 'yahoo',
            'uid' => '001',
            'info' => {'email' => 'fred@example.com', 'name' => 'Fred'}
        }
      end

      it 'assigns the provider to the auth hash' do
        %w{yahoo developer}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:provider].should eq provider
        end
      end

      it 'assigns the users email address to the auth hash' do
        %w{yahoo developer}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:email].should eq 'fred@example.com'
        end
      end

      it 'assigns the users name to the auth hash' do
        %w{yahoo developer}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:name].should eq 'Fred'
        end
      end

      it 'assigns the users id to the auth hash' do
        %w{yahoo developer}.each do |provider|
          request.env['omniauth.auth'] = @env.merge!('provider' => provider)
          get :create, service: provider
          assigns(:authhash)[:uid].should eq '001'
        end
      end
    end

    context 'unknown services' do
      before(:each) do
        @env = {
            'provider' => 'myspace',
            'uid' => '001',
            'user_info' => {'email' => 'fred@example.com', 'name' => 'Fred'}
        }
      end

      it 'display the response as yaml' do
        request.env['omniauth.auth'] = @env
        get :create, service: 'myspace'
        response.body.should eq "---\nprovider: myspace\nuid: '001'\nuser_info:\n  email: fred@example.com\n  name: Fred\n"
      end
    end

    context 'with an account' do
      before(:each) do
        @env = {
            'provider' => 'developer',
            'uid' => '001',
            'info' => {'email' => 'fred@example.com', 'name' => 'Fred'}
        }
        FactoryGirl.create(:service,
                           provider: 'developer',
                           uid: '001',
                           uname: 'Fred',
                           uemail: 'fred@example.com')
      end

      context 'when logged in' do
        it 'tells you that you have an account' do
          login_as(:admin)
          request.env['omniauth.auth'] = @env
          get :create, service: 'developer'
          flash[:notice].should match 'Your account at Developer is already connected with this site.'
        end

        it 'redirects to the list of services' do
          login_as(:admin)
          request.env['omniauth.auth'] = @env
          get :create, service: 'developer'
          response.should redirect_to services_path
        end
      end

      context 'when not logged in' do
        it 'logs you in if you have an account' do
          request.env['omniauth.auth'] = @env
          get :create, service: 'developer'
          flash[:notice].should match 'Signed in successfully via Developer.'
        end

        it 'redirects you to the home page' do
          request.env['omniauth.auth'] = @env
          get :create, service: 'developer'
          response.should redirect_to root_url
        end
      end
    end

    context 'without an account' do
      before(:each) do
        @env = {
            'provider' => 'developer',
            'uid' => '001',
            'info' => {'email' => 'fred@example.com', 'name' => 'Fred'}
        }
      end

      context 'when the service returns invalid data' do
        it 'displays an error message' do
          request.env['omniauth.auth'] = @env.merge!('uid' => '')
          get :create, service: 'developer'
          flash[:error].should match 'Error while authenticating via developer/Developer. The service returned invalid data for the user id.'
        end

        it 'redirects to the signin path' do
          request.env['omniauth.auth'] = @env.merge!('uid' => '')
          get :create, service: 'developer'
          response.should redirect_to signin_path
        end
      end

      context 'when logged in' do
        it 'adds the new service' do
          login_as(:admin)
          request.env['omniauth.auth'] = @env
          services_list = double(ActiveRecord::Relation)
          User.any_instance.should_receive(:services).and_return(services_list)
          services_list.should_receive(:create!).with({:provider => 'developer', :uid => '001', :uname => 'Fred', :uemail => 'fred@example.com'})
          get :create, service: 'developer'
        end

        it 'tells you that it added the new service' do
          login_as(:admin)
          request.env['omniauth.auth'] = @env
          get :create, service: 'developer'
          flash[:notice].should match 'Your Developer account has been added for signing in at this site.'
        end

        it 'redirects you to the services list' do
          login_as(:admin)
          request.env['omniauth.auth'] = @env
          get :create, service: 'developer'
          response.should redirect_to services_path
        end
      end
    end

    context 'invalid service' do
      it 'displays an error message' do
        request.env['omniauth.auth'] = nil
        get :create, service: 'my service'
        flash[:error].should match 'Error while authenticating via My service. The service did not return valid data.'
      end

      it 'redirects to the signin path' do
        request.env['omniauth.auth'] = {}
        get :create, service: nil
        response.should redirect_to signin_path
      end
    end
  end

  describe 'GET failure' do
    it 'displays an error message' do
      get :failure
      flash[:error].should match 'There was an error at the remote authentication service. You have not been signed in.'
    end

    it 'redirects to the home page' do
      get :failure
      response.should redirect_to root_url
    end
  end
end
