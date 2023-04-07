#coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_auth

  def initialize
    super
    @ext_db = ExtensionDatabase.new
    @ext_db.add("frames", DummyController)
    @ext_db.add("lingvo", TestController)
    #ext_db.add("reasoner", DummyController)
    #ext_db.add("tester", DummyController)
    @ext_db.add("psycho", PersonalityTestsController)
    @ext_db.add("onthology", KaTopicsController)
    @ext_db.add("competences", CompetencesController)
    @ext_db.add("groups", GroupsController)
    @ext_db.add("timetables", TimetablesController)
    @ext_db.add("development", DevelopmentController)
  end

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
      cookies[:auth_token] = @user.auth_token
    end
  end

end
