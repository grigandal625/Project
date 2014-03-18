class AuthController < ApplicationController
  skip_before_filter :check_auth, only: [:login, :authentificate]

  def authentificate
    user = User.find_by(login: params[:login],
                        pass: Digest::MD5.hexdigest(params[:pass]))
    if(user == nil)
      render text: 'Login failed!!!' #tmp shit
    else
      session[:user_id] = user.id
      redirect_to params[:path]
    end
  end

  def login
    @path = params[:path] || root_path
  end

  def logout
    reset_session
    redirect_to params[:path] || login_path
  end

end
