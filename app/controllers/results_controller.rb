class ResultsController < AdminToolsController
  skip_before_action :check_admin, only: [:show]

  def show
    if @user.role == 'admin' || @user.student.id == @result.student.id
      @showmenu = false
    else
      redirect_to :back
    end
    @result = Result.find(params[:id])
  end

  def edit
    @result = Result.find(params[:id])
  end

  def update
    result = Result.find(params[:id])
    result.v_result.log.data = params[:v_log]
    result.v_result.mark = params[:v_mark]
    result.g_result.log.data = params[:g_log]
    result.g_result.mark = params[:g_mark]
    result.save
    redirect_to :back
  end

  def index
    if params[:date] == nil
      @date_from = 1.year.ago
      @date_to = Date.today
    else
      @date_from = params[:date][:from].to_date || 1.year.ago
      @date_to = params[:date][:to].to_date || Date.today
    end
    @groups = Group.all
    groups_ids = params[:group] || ""
    groups_ids = (groups_ids == "" ? @groups.ids : groups_ids)
    selected_groups = @groups.where(id: groups_ids)
    @results = []
    selected_groups.each do |group|
      group.students.each do |student|
        res = student.results.where("updated_at >= ? AND updated_at <= ?",
                                    @date_from.beginning_of_day,
                                    @date_to.end_of_day)
        if res == nil
          @results << {"group" => group.number,
                       "fio" => student.fio,
                       "G" => "-",
                       "V" => "-",
                       "S" => "-",
                       "avr" => 0}
        else
          res.each do |cur_res|
            @results << {"group" => group.number,
                         "fio" =>
              "<a href=\"#{@user.role == 'admin' ? edit_result_path(cur_res) : result_path(cur_res)}\">" +
              student.fio + "</a>",
              "G" => cur_res.g_result.mark,
              "V" => cur_res.v_result.mark,
              "S" => 100,
              "avr" => cur_res.mark}
          end
        end
      end
    end
  end

end
