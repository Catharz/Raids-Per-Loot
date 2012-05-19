class AdminController < ApplicationController
  before_filter :login_required

  def show

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end