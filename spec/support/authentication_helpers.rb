module AuthenticationHelpers

  def sign_out_user
    get destroy_user_session_path
  end

  def sign_in_user
    sign_out_user
    @user ||= Factory(:user)
    post user_session_path, :user => {
      :email => @user.email, :password => @user.password
    }
  end
end
