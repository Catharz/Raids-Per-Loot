# @author Craig Read
#
# Controller for the User views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
class UsersController < ApplicationController
  authorize_resource
  before_filter :set_pagetitle
  before_filter :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /user/new
  # GET /user/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
  end


  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.json  { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => 'new' }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  private

  def set_pagetitle
    @pagetitle = 'Users'
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :roles_mask)
  end
end
