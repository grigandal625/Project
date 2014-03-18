#coding: utf-8
class GroupsController < AdminToolsController

  def index
    @groups = []
    Group.find_each do |group|
      @groups << {"number" => group.number,
                  "show_ref" => "<a href=\"#{group_path(group)}\">Просмотр</a>",
                  "edit_ref" => "<a href=\"#{edit_group_path(group)}\">Редактировать</a>"}
    end
  end

  def new
  end

  def create
    group = Group.create(number: params[:number])
    redirect_to edit_group_path(group)
  end

  def edit
    @group = Group.find(params[:id])
    @students = []
    Student.where(group: @group).each do |student|
      @students << {"fio" => student.fio,
                    "login" => student.user.login}
    end
    @students << {"fio" =>'<input type="textbox" name="fio" placeholder="ФИО" />',
      "login" => '<input type="submit" value="Добавить">'}
  end

  def update
    redirect_to groups_path(group)
  end

end
