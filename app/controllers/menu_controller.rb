class MenuController < ApplicationController
  layout 'test'

  def index
    redirect_to groups_path if @user.role == "admin"
  end

  def results
    @semantic = Semanticnetwork.all
  end

end
