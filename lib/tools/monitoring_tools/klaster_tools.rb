module Tools
  module MonitoringTools
    class KlasterTools
      def group_ka_results(group_id)
        group = Group.find(group_id)
        group.students.map { |student| student.user.ka_results}
      end
      def problem_areas(group_id, abs_mark, max_mark, min_mark)
        ka_results = []
        group_id.each{ |id| ka_results += group_ka_results(id).to_a }
        x_arr = []
        y_arr = []
        ka_results.each do |results|
          results.each_with_index do |result, index|
            index.even? ? x_arr.push(result.problem_areas) : y_arr.push(result.problem_areas)
          end
        end
        x_arr = x_arr.reduce(:+)
        y_arr = y_arr.reduce(:+)
        result = {}
        result['Кластеризация'] = klaster_problem_areas(x_arr, y_arr, abs_mark, max_mark, min_mark)
        result['Динамика'] = dynamic_problem_areas(x_arr, y_arr)
        result
      end

      def klaster_problem_areas(x_arr, y_arr, abs_mark, max_mark, min_mark)
        x_arr = x_arr.select{ |area| area.mark <= abs_mark.to_f}
        y_arr = y_arr.select{ |area| area.mark <= abs_mark.to_f}
        x_with_theme = {}
        y_with_theme = {}
        x_arr.each do |x|
          theme = KaTopic.find(x.ka_topic_id).text
          x_with_theme[theme] ||= []
          x_with_theme[theme].push(x.mark)
        end

        y_arr.each do |y|
          theme = KaTopic.find(y.ka_topic_id).text
          y_with_theme[theme] ||= []
          y_with_theme[theme].push(y.mark)
        end
        
        w_arr = x_with_theme.merge(y_with_theme) { |key, old_value, new_value| old_value + new_value }

        w_arr = w_arr.each { |k,v| w_arr[k] = v.reduce(:+) / v.size.to_f }

        klaster = {'Очень сложные темы' => [], 'Сложные темы' => [], 'Почти усваемые темы' => []}
        w_arr.each do |k,v|
          if v <= min_mark.to_f
            klaster['Очень сложные темы'].push(k)
          elsif v >= max_mark.to_f
            klaster['Почти усваемые темы'].push(k)
          else
            klaster['Сложные темы'].push(k)
          end
        end
        klaster
      end

      def dynamic_problem_areas(x_arr, y_arr)
        x_with_theme = {}
        y_with_theme = {}
        x_arr.each do |x|
          theme = KaTopic.find(x.ka_topic_id).text
          x_with_theme[theme] ||= []
          x_with_theme[theme].push(x.mark)
        end

        y_arr.each do |y|
          theme = KaTopic.find(y.ka_topic_id).text
          y_with_theme[theme] ||= []
          y_with_theme[theme].push(y.mark)
        end

        y_with_theme = y_with_theme.each { |k,v| y_with_theme[k] = v.reduce(:+) / v.size.to_f }
        x_with_theme = x_with_theme.each { |k,v| x_with_theme[k] = v.reduce(:+) / v.size.to_f }
        
        w_arr = x_with_theme.merge(y_with_theme) { |key, old_value, new_value| new_value - old_value }

        klaster = {'Динамика положительная' => [], 'Динамика отрицательная' => []}
        w_arr.each do |k,v|
          if v <= 0
            klaster['Динамика отрицательная'].push(k)
          else
            klaster['Динамика положительная'].push(k)
          end
        end
        klaster
      end

      def marks_prognosis(group_id)
        ka_results = []
        group_id.each{ |id| ka_results += group_ka_results(id).to_a }
  
        y_arr = {}
        ka_results.each do |results|
          results_arr = results.to_a
          y = results_arr.pop
          x = results_arr.pop
          next unless y
          user_name = y.user.student.fio
          y_arr[user_name] ||= []
          frame_result = y.user.student.studentframes.pluck(:result).map(&:to_i).max
          y.assessment ? y_arr[user_name].push(y.assessment) : y_arr[user_name].push(0)
          frame_result ? y_arr[user_name].push(frame_result) : y_arr[user_name].push(0)
        end

        Fbresult.where(group: 'Б19-514', fb: "Прямой").or(Fbresult.where(group: 'Б19-504', fb: "Прямой")).group(:fio).each do |e|
          y_arr[e.fio] ||= [0]
          e.result ? y_arr[e.fio].push(e.result) : y_arr[e.fio].push(0)
        end

        Fbresult.where(group: 'Б19-504', fb: "Обратный").or(Fbresult.where(group: 'Б19-504', fb: "Обратный")).group(:fio).each do |e|
          y_arr[e.fio] ||= [0, 0]
          e.result ? y_arr[e.fio].push(e.result) : y_arr[e.fio].push(0)
        end

        klusters = KMeans.new(y_arr.values, :centroids => 5).view
        result = {}
        res_arr = y_arr.to_a
        klusters.each do |kluster|
          fio_arr = []
          marks_arr = []
          kluster.each do |res_id|
            fio_arr.push(res_arr[res_id][0])
            marks_arr += res_arr[res_id][1]
          end
          marks_arr = [0] if marks_arr.blank?
          avg_mark = marks_arr.reduce(:+) / marks_arr.size
          fio_arr.each { |fio| result[fio] = avg_mark }
        end
        result
      end

      def competence_study(group_id)
        ka_results = []
        group_id.each{ |id| ka_results += group_ka_results(id).to_a }
        x_arr = {}
        y_arr = {}
        ka_results.each do |results|
          results_arr = results.to_a
          x = results_arr.shift
          y = results_arr.shift
          next unless x && y
          user_name = x.user.student.fio

          y_arr[user_name] = y.assessment
          x_arr[user_name] = x.assessment
        end
        avg_arr = x_arr.merge(y_arr) { |key, old_value, new_value| (new_value + old_value) / 2 }
        forward_arr = {}
        backward_arr = {}
        Fbresult.where(group: 'Б19-514', fb: "Прямой").or(Fbresult.where(group: 'Б19-504', fb: "Прямой")).group(:fio).each { |e| forward_arr[e.fio] = e.result }
        Fbresult.where(group: 'Б19-514', fb: "Обратный").or(Fbresult.where(group: 'Б19-504', fb: "Обратный")).group(:fio).each { |e| backward_arr[e.fio] = e.result }
        fb_arr = forward_arr.merge(backward_arr) { |key, old_value, new_value| (new_value + old_value) / 2 }

        pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(avg_arr.values.map{|el| (el*100).round}, fb_arr.values.map{|el| (el*100).round})
        [avg_arr.values, [fb_arr.values, pirson]]
      end

      def study_skill(group_id, skill_component_id)
        ka_topic_ids = Component.find(skill_component_id).ka_topics.pluck(:id)
        ka_results = []
        group_id.each{ |id| ka_results += group_ka_results(id).to_a }
        x_arr = []
        ka_results.each do |results|
          results.each_with_index do |result, index|
            if index.odd?
              prob_areas = result.problem_areas.select { |area| ka_topic_ids.include? area.ka_topic_id }
              prob_areas.map! { |area| (area.mark * 100).round }
              x_arr.push(prob_areas)
            end
          end
        end
        x_arr = x_arr.reduce(:+)
        forward_arr = []
        backward_arr = []
        Fbresult.where(group: 'Б19-514', fb: "Прямой").or(Fbresult.where(group: 'Б19-504', fb: "Прямой")).group(:fio).each { |e| forward_arr.push(e.result) }
        Fbresult.where(group: 'Б19-514', fb: "Обратный").or(Fbresult.where(group: 'Б19-504', fb: "Обратный")).group(:fio).each { |e| backward_arr.push(e.result) }

        f_pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(x_arr.map{|el| (el*100).round}, forward_arr.map{|el| (el*100).round})
        b_pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(x_arr.map{|el| (el*100).round}, backward_arr.map{|el| (el*100).round})
        [x_arr, [forward_arr, f_pirson], [backward_arr, b_pirson]]
      end

      def klaster_psyho(group_id, file)
        opened_file = File.open(file)
        options = { :row_sep => :auto, :col_sep => ';' }
        marks = {}
        students = Student.where(group_id: group_id)
        CSV.foreach(opened_file, **options) do |row|
          while row.first != "1"
            next
          end
          student_personalities = students.where("fio LIKE '%#{row[1].split.first}%'").first.personalities
          student_personalities.each do |pers|
            marks[pers.name] ||= []
            marks[pers.name].append([row[-7].to_i]) unless row[-7].nil?
          end
        end
        result = {}
        marks.each { |k, v| result[k] = v.reduce(:+) / v.size }
        kluster = {'Психотипы с высокой успеваемостью' => [], 'Психотипы со средней успеваемостью' => [], 'Психотипы с низкой успеваемостью' => []}
        result.each do |k, v|
          if v <= result.values.min + (result.values.max - result.values.min)/3
            kluster['Психотипы с низкой успеваемостью'].push(k)
          elsif v >= result.values.max - (result.values.max - result.values.min)/3
            kluster['Психотипы с высокой успеваемостью'].push(k)
          else
            kluster['Психотипы со средней успеваемостью'].push(k)
          end
        end
        return kluster
      end
    end
  end
end
