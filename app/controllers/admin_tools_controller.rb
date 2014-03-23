class AdminToolsController < ApplicationController
  helper :all
  before_action :check_admin
  before_action :set_show_menu
  layout 'admin'

  private
  def check_admin
    if @user.role != 'admin'
      #render status: :forbidden, text: "You aren't allowed to see this page"
      redirect_to get_task_path
    end
  end

  def set_show_menu
    @showmenu = params[:showmenu] || true
    @for_print = request.fullpath
    if @for_print.include?('?')
      @for_print << "&showmenu=false"
    else
      @for_print << "?showmenu=false"
    end
  end

end
