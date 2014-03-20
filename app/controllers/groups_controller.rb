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

  def show
    @group = Group.find(params[:id])
    @students = []
    Student.where(group: @group).each do |student|
      @students << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">#{student.fio}</a>",
                    "login" => student.user.login}
    end
  end

  def new
  end

  def generate_report
    @group = Group.find(params[:id])
    @date = (params[:date]|| [Date.today.to_s]).last.to_date
    @results = []
    @group.students.each do |student|
      cur_res = student.results.where("updated_at >= ? AND updated_at <= ?",
                               @date, @date.advance(days: 1)).last
      if cur_res == nil
        @results << {"fio" => student.fio,
                     "G" => "-",
                     "V" => "-",
                     "S" => "-",
                     "avr" => 0}
      else
        @results << {"fio" => student.fio,
                    "G" => cur_res.g_result.mark,
                    "V" => cur_res.v_result.mark,
                    "S" => 100,
                    "avr" => cur_res.mark}
      end
    end
  end

  def generate_pass
    group = Group.find(params[:id])
    ans = ""
    group.students.each do |student|
      pass = rand(36**10).to_s(36)
      ans << "#{student.fio}\t#{student.user.login}\t#{pass}\n"
      student.user.pass = Digest::MD5.hexdigest(pass)
      student.user.save
    end
    render text: ans, content_type: "text/plain; charset=utf-8" 
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
    group = Group.find(params[:id])
    group.number = params[:number]
    group.save
    redirect_to groups_path(group)
  end

end
