# @author Craig Read
#
# Controller for the Comment views.
#
# json and js formatting options are available on actions
# where ajax is used via jQueryUI popups.
class CommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :set_pagetitle
  before_filter :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
      format.js
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
      format.js
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment.to_json(methods: [:commented_name]), status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render json: @comment.to_json(methods: [:commented_name]),
                             notice: 'Comment was successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :ok }
      format.js
    end
  end

  private

  def set_pagetitle
    @pagetitle = 'Comments'
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment_date, :commented_id, :commented_type, :comment)
  end
end
