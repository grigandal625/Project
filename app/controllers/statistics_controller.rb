class StatisticsController < AdminToolsController

  def index
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


  private

  def problem_areas
    @result_data = ::Tools::MonitoringTools::KlasterTools.new().problem_areas([58,59,60])
    klasters = @result_data['Кластеризация'].values
    @klaster_rows = {}
    klasters.each_with_index do |klaster, klaster_index|
      klaster.each_with_index do |el, index|
        @klaster_rows[index] ||= [nil, nil, nil]
        @klaster_rows[index][klaster_index] = el
      end
    end

    dynamics = @result_data['Динамика'].values
    @dynamic_rows = {}
    dynamics.each_with_index do |dynamic, dynamic_index|
      dynamic.each_with_index do |el, index|
        @dynamic_rows[index] ||= [nil, nil]
        @dynamic_rows[index][dynamic_index] = el
      end
    end
  end

  def marks_prognosis
    @result = ::Tools::MonitoringTools::KlasterTools.new().marks_prognosis([58, 59,50])
    @rows = []
    @result.each { |k,v| @rows.push([k, v]) }
  end

  def competence_study
    @result = ::Tools::MonitoringTools::KlasterTools.new().competence_study([58, 59,50])
    @rows1 = {}
    @result[0].each_with_index do |el, index|
      @rows1[index] ||= [nil, nil]
      @rows1[index][0] = el
    end
    @result[1][0].each_with_index do |el, index|
      @rows1[index] ||= [nil, nil]
      @rows1[index][1] = el
    end
    @rows1[0].push(@result[1][1])
  end

  def study_skill
    @result = ::Tools::MonitoringTools::KlasterTools.new().study_skill([58, 59,50], 3)
    @rows1 = {}
    @rows2 = {}
    @result[0].each_with_index do |el, index|
      @rows1[index] ||= [nil, nil]
      @rows1[index][0] = el
      @rows2[index] ||= [nil, nil]
      @rows2[index][0] = el
    end
    @result[1][0].each_with_index do |el, index|
      @rows1[index] ||= [nil, nil]
      @rows1[index][1] = el
    end
    @rows1[0].push(@result[1][1])
    @result[2][0].each_with_index do |el, index|
      @rows2[index] ||= [nil, nil]
      @rows2[index][1] = el
    end
    @rows2[0].push(@result[2][1])
  end
end
