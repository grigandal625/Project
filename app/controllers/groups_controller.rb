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
    @date = (params[:date] || [""]).last.to_date
    @date ||= Date.today
    @results = []
    @group.students.each do |student|
      cur_res = student.results.where("updated_at >= ? AND updated_at <= ?",
                                      @date.beginning_of_day,
                                      @date.end_of_day).last
      if cur_res == nil
        @results << {"fio" => student.fio,
                     "G" => "-",
                     "V" => "-",
                     "S" => "-",
                     "avr" => 0}
      else
        @results << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">" +
          student.fio + "</a>",
                    "G" => cur_res.g_result.mark,
                    "V" => cur_res.v_result.mark,
                    "S" => cur_res.s_result.mark,
                    "avr" => cur_res.mark}
      end
    end
  end

  def generate_pass
    group = Group.find(params[:id])
    ans = "<style>td{border: 1px solid; padding: 5px;}</style>"
    ans << "Группа #{group.number}<br/>"
    ans << "<table style='border-collapse: collapse; font-family: sans-serif;' ><tr><th>ФИО</th><th>Логин</th><th>Пароль</th></tr>"
    group.students.each do |student|
      pass = rand(36**10).to_s(36)
      ans << "<tr><td>#{student.fio}</td><td>#{student.user.login}</td><td>#{pass}</td></tr>"
      student.user.pass = Digest::MD5.hexdigest(pass)
      student.user.save
    end
    ans << "</table>"
    render text: ans#, content_type: "text/html; charset=utf-8"
  end

  def create
    group = Group.create(number: params[:number])
    group.create_timetable
    redirect_to edit_group_path(group)
  end

  def edit
    @group = Group.find(params[:id])
    @students = []
    Student.where(group: @group).each do |student|
      @students << {"fio" => student.fio,
                    "login" => student.user.login,
                    "delete" => "<a data-method=\"delete\" href=\"#{group_student_path(@group, student)}\">Удалить</a>"}
    end
    @students << {"fio" =>'<input type="textbox" name="fio" placeholder="ФИО" />',
      "login" => '<input type="submit" value="Добавить">',
      "delete" => ""}
  end

  def update
    group = Group.find(params[:id])
    group.number = params[:number]
    group.save
    redirect_to groups_path(group)
  end

end
