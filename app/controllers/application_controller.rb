#coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_auth

  def check_admin
    if @user.role != 'admin'
      redirect_to :root
    end
  end

  def is_admin
    if not @user or @user.role != "admin"
      return false
    else
      return true
    end
  end

  private
  def check_auth
    if session[:user_id] == nil
      redirect_to login_url(path: request.fullpath)
    else
      @user = User.find(session[:user_id])
    end
  end

end
