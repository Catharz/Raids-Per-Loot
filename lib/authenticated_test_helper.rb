module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    @request.session[:user_id] =
        if user
          user.is_a?(User) ? user.id : users(user).id
        else
          nil
        end
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'monkey') : nil
  end

  def mock_user
    mock_model(User, :id => 1,
               :login => 'user_name',
               :name => 'U. Surname',
               :to_xml => "User-in-XML", :to_json => "User-in-JSON",
               :errors => [])
  end
end
