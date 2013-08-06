module AuthenticationSpecHelper
  def login_as(user)
    if user
      @request.session[:user_id] = user.is_a?(User) ? user.id : users(user).id
      @request.session[:service_id] = user.is_a?(User) ? user.services.first.id : users(user).services.first.id
    else
      @request.session[:user_id] = nil
      @request.session[:service_id] = nil
    end
  end
end