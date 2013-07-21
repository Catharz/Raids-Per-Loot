module AuthenticationSpecHelper
  def login_as(user)
    @request.session[:user_id] =
        if user
          user.is_a?(User) ? user.id : users(user).id
        else
          nil
        end
  end
end