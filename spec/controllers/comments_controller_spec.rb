require 'spec_helper'
require 'authentication_spec_helper'

describe CommentsController do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    # Need to be logged in
    login_as :admin
  end

  describe 'GET index' do
    it 'assigns all comments as @comments' do
      player = FactoryGirl.create(:player)
      comment =
          Comment.create! FactoryGirl.attributes_for(:comment,
                                                     commented: player)
      get :index, {}
      assigns(:comments).should eq([comment])
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end
  end

  describe 'GET show' do
    it 'assigns the requested comment as @comment' do
      player = FactoryGirl.create(:player)
      comment = Comment.create! FactoryGirl.attributes_for(:comment,
                                                           commented: player)
      get :show, {id: comment.to_param}
      assigns(:comment).should eq(comment)
    end

    it 'renders the :show template' do
      get :show, id: FactoryGirl.create(:comment)
      response.should render_template :show
    end
  end

  describe 'GET new' do
    it 'assigns a new comment as @comment' do
      get :new, {}
      assigns(:comment).should be_a_new(Comment)
    end

    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'GET edit' do
    it 'assigns the requested comment as @comment' do
      comment = FactoryGirl.create(:comment)
      get :edit, {id: comment.to_param}
      assigns(:comment).should eq(comment)
    end

    it 'renders the edit template' do
      comment = FactoryGirl.create(:comment)
      get :edit, {id: comment.to_param}
      response.should render_template 'edit'
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comment' do
        expect {
          player = FactoryGirl.create(:player)
          post :create,
               {comment: FactoryGirl.attributes_for(:comment,
                                                    commented_id: player.id)}
        }.to change(Comment, :count).by(1)
      end

      it 'assigns a newly created comment as @comment' do
        player = FactoryGirl.create(:player)
        post :create,
             {comment: FactoryGirl.attributes_for(:comment,
                                                  commented_id: player.id)}
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end

      it 'redirects to the created comment' do
        player = FactoryGirl.create(:player)
        post :create,
             {comment: FactoryGirl.attributes_for(:comment,
                                                  commented_id: player.id)}
        response.should redirect_to(Comment.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved comment as @comment' do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {comment: {'comment_date' => 'invalid value'}}
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {comment: {'comment_date' => 'invalid value'}}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      @player = FactoryGirl.create(:player)
      @comment = FactoryGirl.create(:comment, commented: @player)
    end

    describe 'with valid params' do
      it 'located the requested @comment' do
        put :update, id: @comment,
            comment: FactoryGirl.attributes_for(:comment,
                                                commented_id: @player.id)
        assigns(:comment).should eq (@comment)
      end

      it 'updates the requested comment' do
        Comment.any_instance.
            should_receive(:update_attributes).
            with({'comment_date' => '2013-07-16'})
        put :update, id: @comment,
            comment: {'comment_date' => '2013-07-16'}
      end

      it 'assigns the requested comment as @comment' do
        put :update, id: @comment,
            comment: FactoryGirl.attributes_for(:comment)
        assigns(:comment).should eq(@comment)
      end

      it 'redirects to the comment' do
        put :update, id: @comment,
            comment: FactoryGirl.attributes_for(:comment,
                                                commented_id: @player.id)
        response.should redirect_to(@comment)
      end
    end

    describe 'with invalid params' do
      it 'assigns the comment as @comment' do
        Comment.any_instance.stub(:save).and_return(false)
        put :update, id: @comment, comment: {'comment_date' => nil}
        assigns(:comment).should eq(@comment)
      end

      it "re-renders the 'edit' template" do
        Comment.any_instance.stub(:save).and_return(false)
        put :update, id: @comment, comment: {'comment_date' => 'invalid value'}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested comment' do
      player = FactoryGirl.create(:player)
      comment =
          Comment.create! FactoryGirl.attributes_for(:comment,
                                                     commented: player)
      expect {
        delete :destroy, {id: comment.to_param}
      }.to change(Comment, :count).by(-1)
    end

    it 'redirects to the comments list' do
      player = FactoryGirl.create(:player)
      comment =
          Comment.create! FactoryGirl.attributes_for(:comment,
                                                     commented: player)
      delete :destroy, {id: comment.to_param}
      response.should redirect_to(comments_url)
    end
  end
end
