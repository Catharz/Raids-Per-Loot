require 'spec_helper'
require 'authentication_spec_helper'

describe UsersController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
  end

  describe 'route recognition and generation' do
    it 'should generate params for users index action from GET /users' do
      {get: '/users'}.should route_to(controller: 'users', action: 'index')
      {get: '/users.xml'}.should route_to(controller: 'users', action: 'index', format: 'xml')
      {get: '/users.json'}.should route_to(controller: 'users', action: 'index', format: 'json')
    end
    
    it 'should generate params for users new action from GET /users' do
      {get: '/users/new'}.should route_to(controller: 'users', action: 'new')
      {get: '/users/new.xml'}.should route_to(controller: 'users', action: 'new', format: 'xml')
      {get: '/users/new.json'}.should route_to(controller: 'users', action: 'new', format: 'json')
    end
    
    it 'should generate params for users create action from POST /users' do
      {post: '/users'}.should route_to(controller: 'users', action: 'create')
      {post: '/users.xml'}.should route_to(controller: 'users', action: 'create', format: 'xml')
      {post: '/users.json'}.should route_to(controller: 'users', action: 'create', format: 'json')
    end
    
    it 'should generate params for users show action from GET /users/1' do
      {get: '/users/1'}.should route_to(controller: 'users', action: 'show', id: '1')
      {get: '/users/1.xml'}.should route_to(controller: 'users', action: 'show', id: '1', format: 'xml')
      {get: '/users/1.json'}.should route_to(controller: 'users', action: 'show', id: '1', format: 'json')
    end
    
    it 'should generate params for users edit action from GET /users/1/edit' do
      {get: '/users/1/edit'}.should route_to(controller: 'users', action: 'edit', id: '1')
    end
    
    it "should generate params {controller: 'users', action: update', id: '1'} from PUT /users/1" do
      {put: '/users/1'}.should route_to(controller: 'users', action: 'update', id: '1')
      {put: '/users/1.xml'}.should route_to(controller: 'users', action: 'update', id: '1', format: 'xml')
      {put: '/users/1.json'}.should route_to(controller: 'users', action: 'update', id: '1', format: 'json')
    end
    
    it 'should generate params for users destroy action from DELETE /users/1' do
      {delete: '/users/1'}.should route_to(controller: 'users', action: 'destroy', id: '1')
      {delete: '/users/1.xml'}.should route_to(controller: 'users', action: 'destroy', id: '1', format: 'xml')
      {delete: '/users/1.json'}.should route_to(controller: 'users', action: 'destroy', id: '1', format: 'json')
    end
  end
  
  describe 'named routing' do
    before(:each) do
      get :new
    end
    
    it "should route users_path() to /users" do
      users_path().should == '/users'
      controller.users_path(format: 'xml').should == '/users.xml'
      controller.users_path(format: 'json').should == '/users.json'
    end
    
    it "should route new_user_path() to /users/new" do
      new_user_path().should == '/users/new'
      controller.new_user_path(format: 'xml').should == '/users/new.xml'
      controller.new_user_path(format: 'json').should == '/users/new.json'
    end
    
    it "should route user_(id: '1') to /users/1" do
      user_path(id: '1').should == '/users/1'
      controller.user_path(id: '1', format: 'xml').should == '/users/1.xml'
      controller.user_path(id: '1', format: 'json').should == '/users/1.json'
    end
    
    it "should route edit_user_path(id: '1') to /users/1/edit" do
      controller.edit_user_path(id: '1').should == '/users/1/edit'
    end
  end

  describe 'controller actions' do
    describe 'GET index' do
      it 'assigns all users as @users' do
        user = User.create! FactoryGirl.attributes_for(:user)

        get :index

        assigns(:users).should include(user)
      end
    end

    describe 'GET show' do
      it 'assigns the requested user as @user' do
        user = User.create! FactoryGirl.attributes_for(:user)
        get :show, id: user.id.to_s
        assigns(:user).should eq(user)
      end
    end

    describe 'GET new' do
      it 'assigns a new user as @user' do
        get :new
        assigns(:user).should be_a_new(User)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested user as @user' do
        user = User.create! FactoryGirl.attributes_for(:user)
        get :edit, id: user.id.to_s
        assigns(:user).should eq(user)
      end
    end

    describe 'POST create' do
      describe 'with valid params' do
        it 'creates a new User' do
          expect {
            post :create, user: FactoryGirl.attributes_for(:user)
          }.to change(User, :count).by(1)
        end

        it 'assigns a newly created user as @user' do
          post :create, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should be_a(User)
          assigns(:user).should be_persisted
        end

        it 'redirects to the created user' do
          post :create, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to(User.last)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved user as @user' do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          post :create, user: {}
          assigns(:user).should be_a_new(User)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          post :create, user: {}
          response.should render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested user' do
          user = User.create! FactoryGirl.attributes_for(:user)
          # Assuming there are no other users in the database, this
          # specifies that the User created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          User.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, id: user.id, user: {'these' => 'params'}
        end

        it "assigns the requested user as @user" do
          user = User.create! FactoryGirl.attributes_for(:user)
          put :update, id: user.id, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should eq(user)
        end

        it 'redirects to the user' do
          user = User.create! FactoryGirl.attributes_for(:user)
          put :update, id: user.id, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to(user)
        end
      end

      describe 'with invalid params' do
        it 'assigns the user as @user' do
          user = User.create! FactoryGirl.attributes_for(:user)
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          put :update, id: user.id.to_s, user: {}
          assigns(:user).should eq(user)
        end

        it "re-renders the 'edit' template" do
          user = User.create! FactoryGirl.attributes_for(:user)
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          put :update, id: user.id.to_s, user: {}
          response.should render_template('edit')
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested user' do
        user = User.create! FactoryGirl.attributes_for(:user)
        expect {
          delete :destroy, id: user.id.to_s
        }.to change(User, :count).by(-1)
      end

      it 'redirects to the users list' do
        user = User.create! FactoryGirl.attributes_for(:user)
        delete :destroy, id: user.id.to_s
        response.should redirect_to(users_url)
      end
    end
  end
end
