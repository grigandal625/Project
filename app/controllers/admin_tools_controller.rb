class AdminToolsController < ApplicationController
  layout 'admin'
  helper :all
  before_action :check_admin

  private
  def check_admin
    if @user.role != 'admin'
      render status: :forbidden, text: "You aren't allowed to see this page"
    end
  end

end
