class StatisticsController < AdminToolsController
  before_filter :find_groups
  before_filter :find_kurs, only: [:index, :statements]
  def index
    @components = Component.all
    render params[:operation]
  end

  def find_groups
    @groups = Group.all
  end

  def find_kurs
    @kurss = KaTopic.where(parent_id: nil)
  end

  def operation
    # render :json => send(params[:operation])
    response.headers['Content-Disposition'] = "attachment; filename='#{params[:operation]}.xlsx'"
    send(params[:operation])
    render xlsx: "app/views/statistics/#{params[:operation]}.xlsx.axlsx"
  end

  def personality_klaster
    personalities = Personality.all.map {|p| {p.name => p.students.map{|e| e.results.map(&:mark)}.reduce(:+)}}.select {|o| o.values != [nil] && o.values != [[]]}
    personalities = personalities.map{|e| {e.keys.first => e.values.first.instance_eval { reduce(:+) / size.to_f }}}
    personalities_hash = {}
    personalities.each{|e| personalities_hash.merge!(e)}
    sort_values = personalities_hash.values.sort
    dist = (sort_values.last - sort_values.first)/3
    klaster = {'Психотипы с высокой успеваемостью' => [], 'Психотипы со средней успеваемостью' => [], 'Психотипы с низкой успеваемостью' => []}
    personalities_hash.each do |k,v|
      if v < (sort_values.first + dist)
        klaster['Психотипы с низкой успеваемостью'].push(k)
      elsif v > (sort_values.last - dist)
        klaster['Психотипы с высокой успеваемостью'].push(k)
      else
        klaster['Психотипы со средней успеваемостью'].push(k)
      end
    end
      render json: klaster
  end

  def personality_klaster_by_group
    personalities = Personality.all.map {|p| {p.name => p.students.where(group_id: params[:group_id]).map{|e| e.results.map(&:mark)}.reduce(:+)}}.select {|o| o.values != [nil] && o.values != [[]]}
    personalities = personalities.map{|e| {e.keys.first => e.values.first.instance_eval { reduce(:+) / size.to_f }}}
    personalities_hash = {}
    personalities.each{|e| personalities_hash.merge!(e)}
    personalities_hash_values = personalities_hash.values
    personalities_hash_values.sort!
    dist = (personalities_hash_values.last - personalities_hash_values.first)/3
    klaster1 = {'Психотипы с высокой успеваемостью' => [], 'Психотипы со средней успеваемостью' => [], 'Психотипы с низкой успеваемостью' => []}
    personalities_hash.each do |k,v|
      if v < (personalities_hash_values.first + dist)
        klaster1['Психотипы с низкой успеваемостью'].push(k)
      elsif v > (personalities_hash_values.last - dist)
        klaster1['Психотипы с высокой успеваемостью'].push(k)
      else
        klaster1['Психотипы со средней успеваемостью'].push(k)
      end
    end
      render json: klaster1
  end


  def problem_areas
    @result_data = ::Tools::MonitoringTools::KlasterTools.new().problem_areas([params[:group].to_i], params[:abs_mark], params[:max_mark], params[:min_mark])
    klasters = @result_data['Кластеризация'].values
    @klaster_rows = {}
    klasters.each_with_index do |klaster, klaster_index|
      klaster.each_with_index do |el, index|
        @klaster_rows[index] ||= [nil, nil, nil]
        @klaster_rows[index][klaster_index] = el.text
      end
    end

    dynamics = @result_data['Динамика'].values
    @dynamic_rows = {}
    dynamics.each_with_index do |dynamic, dynamic_index|
      dynamic.each_with_index do |el, index|
        @dynamic_rows[index] ||= [nil, nil]
        @dynamic_rows[index][dynamic_index] = el.text
      end
    end
    render xlsx: 'problem_areas', formats: :xlsx if params[:file_g]
  end

  def marks_prognosis
    @result = ::Tools::MonitoringTools::KlasterTools.new().marks_prognosis([params[:group].to_i])
    @rows = []
    @result.each { |k,v| @rows.push([k, v]) }
    render xlsx: 'marks_prognosis', formats: :xlsx if params[:file_g]
  end

  def competence_study
    @result = ::Tools::MonitoringTools::KlasterTools.new().competence_study([params[:group].to_i])
    @rows1 = {}
    @result[0].each_with_index do |el, index|
      @rows1[index] ||= [nil, nil]
      @rows1[index][0] = el
    end
    @result[1][0].each_with_index do |el, index|
      @rows1[index] ||= [nil, nil]
      @rows1[index][1] = el
    end
    @rows1[0] ||= [nil, nil]
    @rows1[0].push(@result[1][1])
    render xlsx: 'competence_study', formats: :xlsx if params[:file_g]
  end

  def study_skill
    @result = ::Tools::MonitoringTools::KlasterTools.new().study_skill([params[:group].to_i], params[:skill_component_id].to_i)
    @rows1 = {}
    @rows2 = @result[2].present? ? {} : nil
    @components = Component.all
    @component_name = Component.find(params[:skill_component_id].to_i).name
    if @result[0].present?
      @result[0].each_with_index do |el, index|
        @rows1[index] ||= [nil, nil]
        @rows1[index][0] = el
        if @result[2].present?
          @rows2[index] ||= [nil, nil]
          @rows2[index][0] = el
        end
      end
      @result[1][0].each_with_index do |el, index|
        @rows1[index] ||= [nil, nil]
        @rows1[index][1] = el
      end
      @rows1[0] ||= [nil, nil]
      @rows1[0].push(@result[1][1])
      if @result[2].present?
        @rows2 = {}
        @result[2][0].each_with_index do |el, index|
          @rows2[index] ||= [nil, nil]
          @rows2[index][1] = el
        end
        @rows2[0] ||= [nil, nil]
        @rows2[0].push(@result[2][1])
      end
    end
    render xlsx: 'study_skill', formats: :xlsx if params[:file_g]
  end

  def klaster_psyho
    data = ::Tools::MonitoringTools::KlasterTools.new().klaster_psyho(params[:group].to_i, params[:file].path, params[:max_mark], params[:min_mark])
    @result_data = data.first
    @psyho_data = data.last.sort_by{|k, v| -v} rescue nil
    @klaster_rows = []
    @result_data.values.each_with_index do |klaster, klaster_index|
      klaster.each_with_index do |el, index|
        @klaster_rows[index] ||= [nil, nil, nil]
        @klaster_rows[index][klaster_index] = el
      end
    end
    render xlsx: 'klaster_psyho', formats: :xlsx if params[:file_g]
  end

  def statements
    group = Group.find(params[:group_ved].to_i)
    @students = []
    @kurs = KaTopic.find(params[:kurs_id].to_i)
    ka_topic_ids = @kurs.get_tree.map(&:id) << params[:kurs_id].to_i
    marks_prognosis = ::Tools::MonitoringTools::KlasterTools.new().marks_prognosis([params[:group_ved].to_i])
    Student.where(group: group).each do |student|
      s = {
        "fio" => student.fio,
        "group" => group.number,
        "id" => student.id,
        "mark_prognosis" => marks_prognosis[student.fio]
      }
      test_results = KaResult.where(user_id: student.user.id).order(created_at: :desc).select do |result| 
          topic_ids = result.ka_topics.map(&:id)
          topic_ids.count == (topic_ids & ka_topic_ids).count
        end
      problem_areas = []
      tests = []
      competence_coverages = []
      areas_done = false
      test_results.each do |res|
        tests.prepend({
          "test_id" => res.ka_test.id,
          "text" => res.ka_test.text,
          "mark" => res.assessment,
          "year" => res.created_at.year
        })
        res.problem_areas.each do |p|
          area = problem_areas.find {|pa| pa["topic_id"] == p.ka_topic.id}
          if area == nil
            if areas_done == false
              problem_areas << {
                "topic_id" => p.ka_topic.id,
                "text" => p.ka_topic.text,
                "mark" => p.mark.round(2)
              }
            end
          else
            if area["mark"] < p.mark
              index = problem_areas.find_index(area)
              problem_areas[index]["mark"] = p.mark
            end
          end
        end

        res.competence_coverages.each do |p|
          area = competence_coverages.find {|pa| pa["competence_id"] == p.competence.id}
          if area == nil
            if areas_done == false
              competence_coverages << {
                "competence_id" => p.competence.id,
                "text" => p.competence.code,
                "mark" => p.mark.round(2)
              }
            end
          else
            if area["mark"] < p.mark
              index = competence_coverages.find_index(area)
              competence_coverages[index]["mark"] = p.mark
            end
          end
        end
        areas_done = true

      end

      s["tests"] = tests
      s["problem_areas"] = problem_areas
      s["competence_coverages"] = competence_coverages

      f_results = Fbresult.where(fio: student.fio, group: student.group.number, fb: "Прямой").order(result: :desc)
      if f_results.count != 0
        s["forward"] = f_results[0].result
      else
        s["forward"] = "-"
      end

      b_results = Fbresult.where(fio: student.fio, group: student.group.number, fb: "Обратный").order(result: :desc)
      if b_results.count != 0
        s["backward"] = b_results[0].result
      else
        s["backward"] = "-"
      end

      semantic_results = Semanticnetwork.where(student_id: student.id).order(rating: :desc)
      if semantic_results.count != 0
        s["semantics"] = semantic_results[0].rating
      else
        s["semantics"] = "-"
      end

      frame_results = Studentframe.where(student_id: student.id).order(result: :desc)
      if frame_results.count != 0
        s["frames"] = frame_results[0].result.to_i
      else
        s["frames"] = "-"
      end

      @students << s
    end
    @max_year = @students.map{|e| e['tests'].map{|e|e['year']}}.flatten.max
    @competences_codes = @students.map{|el| el["competence_coverages"].map{|e| e['text']}}.flatten.uniq
    render :statements
  end

  def tutor_actions
    @result_data = ::Tools::MonitoringTools::KlasterTools.new().tutor_actions1(params[:group].to_i)
    render :tutor_actions
  end
end
