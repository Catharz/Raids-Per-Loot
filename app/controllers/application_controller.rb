# @author Craig Read
#
# Application controller.
#
# Most of the code here is related to authentication,
# authorization or using paper_trail as an audit trail.
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :user_signed_in?

  def user_for_paper_trail
    user_signed_in? ? current_user.name : 'Anonymous'
  end

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    1 if current_user
  end

  def authenticate_user!
    unless current_user
      flash[:error] = 'You need to sign in before accessing this page!'
      redirect_to signin_services_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Access denied!'
    redirect_to root_url
  end
end
