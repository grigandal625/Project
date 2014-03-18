class GroupsController < AdminToolsController

  def index
  end

  def new
  end

  def create
    group = Group.create(params[:number])
    redirect_to edit_group_path(group)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    redirect_to groups_path(group)
  end

end
