#coding: utf-8
class MenuController < ApplicationController
  layout 'menu'

  def index
    redirect_to groups_path if @user.role == "admin"
  end



end
