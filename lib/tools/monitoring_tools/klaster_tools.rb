require "csv"

module Tools
  module MonitoringTools
    class KlasterTools
      def group_ka_results(group_id)
        group = Group.find(group_id)
        group.students.map { |student| student.user.ka_results }
      end

      def problem_areas(group_id, abs_mark, max_mark, min_mark, root_topic_id = nil)
        ka_results = []
        group_id.each { |id| ka_results += group_ka_results(id).to_a }
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
        result["Кластеризация"] = klaster_problem_areas(x_arr, y_arr, abs_mark, max_mark, min_mark, root_topic_id)
        result["Динамика"] = dynamic_problem_areas(x_arr, y_arr)
        result
      end

      def klaster_problem_areas(x_arr, y_arr, abs_mark, max_mark, min_mark, root_topic_id)
        x_arr = x_arr.select { |area| area.mark <= abs_mark.to_f }
        y_arr = y_arr.select { |area| area.mark <= abs_mark.to_f }
        x_with_theme = {}
        y_with_theme = {}
        x_arr.each do |x|
          theme = KaTopic.find(x.ka_topic_id)
          x_with_theme[theme] ||= []
          x_with_theme[theme].push(x.mark)
        end

        y_arr.each do |y|
          theme = KaTopic.find(y.ka_topic_id)
          y_with_theme[theme] ||= []
          y_with_theme[theme].push(y.mark)
        end

        w_arr = x_with_theme.merge(y_with_theme) { |key, old_value, new_value| old_value + new_value }

        w_arr = w_arr.each { |k, v| w_arr[k] = v.reduce(:+) / v.size.to_f }

        klaster = { "Очень сложные темы" => [], "Сложные темы" => [], "Почти усваемые темы" => [] }
        w_arr.each do |k, v|
          if (!root_topic_id.nil? && k.root.id == root_topic_id || root_topic_id.nil?)
            if v <= min_mark.to_f
              klaster["Очень сложные темы"].push(k)
            elsif v >= max_mark.to_f
              klaster["Почти усваемые темы"].push(k)
            else
              klaster["Сложные темы"].push(k)
            end
          end
        end
        klaster
      end

      def dynamic_problem_areas(x_arr, y_arr, root_topic_id = nil)
        x_with_theme = {}
        y_with_theme = {}
        x_arr.each do |x|
          theme = KaTopic.find(x.ka_topic_id)
          x_with_theme[theme] ||= []
          x_with_theme[theme].push(x.mark)
        end

        y_arr.each do |y|
          theme = KaTopic.find(y.ka_topic_id)
          y_with_theme[theme] ||= []
          y_with_theme[theme].push(y.mark)
        end

        y_with_theme = y_with_theme.each { |k, v| y_with_theme[k] = v.reduce(:+) / v.size.to_f }
        x_with_theme = x_with_theme.each { |k, v| x_with_theme[k] = v.reduce(:+) / v.size.to_f }

        w_arr = x_with_theme.merge(y_with_theme) { |key, old_value, new_value| new_value - old_value }

        klaster = { "Динамика положительная" => [], "Динамика отрицательная" => [] }
        w_arr.each do |k, v|
          if (!root_topic_id.nil? && k.root.id == root_topic_id || root_topic_id.nil?)
            if v <= 0
              klaster["Динамика отрицательная"].push(k)
            else
              klaster["Динамика положительная"].push(k)
            end
          end
        end
        klaster
      end

      def marks_prognosis(group_id)
        ka_results = []
        group = Group.find(group_id.first)
        ka_results += group_ka_results(group_id.first).to_a

        y_arr = {}
        ka_results.each do |results|
          results_arr = results.to_a
          y = results_arr.pop
          x = results_arr.pop
          next unless y
          user_name = y.user.student.fio
          y_arr[user_name] ||= [0, 0, 0, 0]
          frame_result = y.user.student.studentframes.pluck(:result).map(&:to_i).max
          y.assessment ? y_arr[user_name][0] = y.assessment : y_arr[user_name][0] = 0
          frame_result ? y_arr[user_name][1] = frame_result : y_arr[user_name][1] = 0
        end

        Fbresult.where(group: group.number, fb: "Прямой").group(:fio).each do |e|
          y_arr[e.fio] ||= [0, 0, 0, 0]
          e.result ? y_arr[e.fio][2] = e.result : y_arr[e.fio][2] = 0
        end

        Fbresult.where(group: group.number, fb: "Обратный").group(:fio).each do |e|
          y_arr[e.fio] ||= [0, 0, 0, 0]
          e.result ? y_arr[e.fio][3] = e.result : y_arr[e.fio][3] = 0
        end

        return {} if y_arr.blank?
        klusters = KMeans.new(y_arr.values.map(&:compact), :centroids => 5).view
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
        group = Group.find(group_id.first)
        ka_results += group_ka_results(group_id.first).to_a
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
        Fbresult.where(group: group.number, fb: "Прямой").group(:fio).each { |e| forward_arr[e.fio] = e.result }
        Fbresult.where(group: group.number, fb: "Обратный").group(:fio).each { |e| backward_arr[e.fio] = e.result }
        fb_arr = forward_arr.merge(backward_arr) { |key, old_value, new_value| (new_value + old_value) / 2 }

        pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(avg_arr.values&.compact&.map { |el| (el * 100).round }, fb_arr.values&.compact&.map { |el| (el * 100).round })
        [avg_arr.values, [fb_arr.values, pirson]]
      end

      def study_skill(group_id, skill_component_id)
        ka_topic_ids = Component.find(skill_component_id).ka_topics.pluck(:id)
        ka_results = []
        group = Group.find(group_id.first)
        ka_results += group_ka_results(group_id.first).to_a
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
        case skill_component_id
        when 1
          frame_result = group.students.map do |st|
            st.studentframes.pluck(:result)&.map(&:to_i)&.max
          end
          f_pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(x_arr&.compact&.map { |el| (el * 100).round }, frame_result&.compact&.map { |el| (el * 100).round })
          return [x_arr, [frame_result, f_pirson]]
        when 2
          semantic_result = group.students.map do |st|
            Semanticnetwork.where(student_id: st.id).order(rating: :desc).first&.rating
          end
          f_pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(x_arr&.compact&.map { |el| (el * 100).round }, semantic_result&.compact&.map { |el| (el * 100).round })
          return [x_arr, [semantic_result, f_pirson]]
        when 3
          forward_arr = []
          backward_arr = []
          Fbresult.where(group: group.number, fb: "Прямой").group(:fio).each { |e| forward_arr.push(e.result) }
          Fbresult.where(group: group.number, fb: "Обратный").group(:fio).each { |e| backward_arr.push(e.result) }

          f_pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(x_arr&.compact&.map { |el| (el * 100).round }, forward_arr&.compact&.map { |el| (el * 100).round })
          b_pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(x_arr&.compact&.map { |el| (el * 100).round }, backward_arr&.compact&.map { |el| (el * 100).round })
          return [x_arr, [forward_arr, f_pirson], [backward_arr, b_pirson]]
        when 5
          result = group.students.map do |st|
            st.results.order(results_mask: :desc).first&.results_mask
          end
          f_pirson = Tools::MathTools::CommonTools.new.pearson_coefficient(x_arr&.compact&.map { |el| (el * 100).round }, result&.compact&.map { |el| (el * 100).round })
          return [x_arr, [result, f_pirson]]
        end
      end

      def klaster_psyho(group_id, file, max_mark, min_mark)
        opened_file = File.open(file)
        options = { :row_sep => :auto, :col_sep => ";" }
        marks = {}
        marks_psyhotype = {
          "Холерик-Аудиал" => [],
          "Холерик-Визуал" => [],
          "Холерик-Кинестетик" => [],
          "Меланхолик-Аудиал" => [],
          "Меланхолик-Визуал" => [],
          "Меланхолик-Кинестетик" => [],
          "Флегматик-Аудиал" => [],
          "Флегматик-Визуал" => [],
          "Флегматик-Кинестетик" => [],
          "Сангвиник-Аудиал" => [],
          "Сангвиник-Визуал" => [],
          "Сангвиник-Кинестетик" => [],
        }
        students = Student.where(group_id: group_id)
        ::CSV.foreach(opened_file, **options) do |row|
          next unless row.first.to_i.in? (1..100)

          student = students.where("fio LIKE '%#{row[1].split.first}%'").first
          next unless student
          student_personalities = student.personalities
          personality_modality = student.personalities.uniq.map(&:personality_traits).flatten.uniq.map(&:name).select { |pt| pt.in? ["Аудиал", "Визуал", "Кинестетик"] }.first
          personality_type = student.personalities.uniq.map(&:name).select { |pt| pt.in? ["Холерик", "Меланхолик", "Флегматик", "Сангвиник"] }.first
          psyhotype = personality_type + "-" + personality_modality rescue ""
          marks_psyhotype[psyhotype].push(row[-7].to_i) unless row[-7].nil? || marks_psyhotype.keys.exclude?(psyhotype)
          student_personalities.each do |pers|
            marks[pers.name] ||= []
            marks[pers.name].append(row[-7].to_i) unless row[-7].nil?
          end
        end

        result = {}
        marks.each { |k, v| result[k] = v.reduce(:+) / v.size rescue result[k] = 0 }
        result_psyho = {}
        marks_psyhotype.each { |k, v| result_psyho[k] = v.reduce(:+) / v.size rescue result_psyho[k] = 0 }
        kluster = { "Психотипы с высокой успеваемостью" => [], "Психотипы со средней успеваемостью" => [], "Психотипы с низкой успеваемостью" => [] }
        result.each do |k, v|
          if v <= min_mark.to_f
            kluster["Психотипы с низкой успеваемостью"].push(k)
          elsif v >= max_mark.to_f
            kluster["Психотипы с высокой успеваемостью"].push(k)
          else
            kluster["Психотипы со средней успеваемостью"].push(k)
          end
        end
        return [kluster, result_psyho]
      end

      def kluster_plan(group_id)
        group = Group.find(group_id)
        ka_results = group_ka_results(group_id).to_a

        plan_array = []
      end

      def tutor_actions(group_id)
        tutor_actions_students = []
        students = Group.find(group_id).students
        group_number = Group.find(group_id).number
        students.each do |student|
          problem_areas = student.user.ka_results.order(created_at: :desc).limit(2).first&.problem_areas
          if problem_areas
            topic_marks = problem_areas.pluck(:ka_topic_id, :mark)
            tutor_actions_priorities = {}

            topic_marks.each do |id, t|
              topic_components = TopicComponent.where(ka_topic_id: id)
              topic_components.each do |tc|
                action_id = "component@%d" % tc.component_id
                if not tutor_actions_priorities.has_key?(action_id)
                  tutor_actions_priorities[action_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0.0 }
                end
                tutor_actions_priorities[action_id][:sum_score] += t * tc.weight
                tutor_actions_priorities[action_id][:sum_weight] += tc.weight
              end

              test_utz = TestUtzTopic.where(ka_topic_id: id)
              test_utz.each do |topic_utz|
                action_id = "test_utz@%d" % topic_utz.test_utz_question_id
                if not tutor_actions_priorities.has_key?(action_id)
                  tutor_actions_priorities[action_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0 }
                end
                tutor_actions_priorities[action_id][:sum_score] += topic_utz.weight * t
                tutor_actions_priorities[action_id][:sum_weight] += topic_utz.weight
              end

              [MatchingUtz, FillingUtz, TextCorrectionUtz, ImagesSortUtz].each do |klass|
                utz = klass.where(ka_topic_id: id)
                utz.each do |topic_utz|
                  action_id = klass.to_s + "@%d" % topic_utz.id
                  if not tutor_actions_priorities.has_key?(action_id)
                    tutor_actions_priorities[action_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0 }
                  end
                  tutor_actions_priorities[action_id][:sum_score] += (topic_utz.try(:weight) || 100) * t
                  tutor_actions_priorities[action_id][:sum_weight] += (topic_utz.try(:weight) || 100)
                end
              end
            end

            @tutor_actions = []
            tutor_actions_priorities.each do |action_id, p|
              id = action_id.split("@")[1].to_i
              type = action_id.split("@")[0]

              link = get_link(type, id)
              name = get_name(type, id)

              p[:score] = p[:sum_score] / p[:sum_weight] * 100

              if 100 - p[:score] < 30
                @tutor_actions.push({
                  :cmp => id,
                  :type => type,
                  :name => name,
                  :link => link,
                  :priority => 100 - p[:score],
                  :sum_weight => p[:sum_weight],
                })
              end
            end

            @tutor_actions.sort { |a, b| compare_actions(a, b) }
          end
          tutor_actions_students.push({ fio: student.fio, group: group_number, tutor_actions: @tutor_actions })
        end
        tutor_actions_students
      end

      def tutor_actions1(group_id)
        tutor_actions_students = []
        students = Group.find(group_id).students
        group_number = Group.find(group_id).number
        students.each do |student|
          tutor_actions = ::Tools::MonitoringTools::PsyhoTools.make_individual_plan_with_psyho(student)
          tutor_actions_students.push({ fio: student.fio, group: group_number, tutor_actions: tutor_actions })
        end
        tutor_actions_students
      end

      def compare_actions(action_1, action_2)
        return action_1[:priority] <=> action_2[:priority]
      end

      def get_link(type, id)
        case type
        when "component"
          cmp = Component.find(id)
          return JSON.parse(cmp.additional)["link"]
        when "test_utz"
          return "/test_utz_questions/#{id}"
        when "MatchingUtz"
          return "/matching_utz/#{id}"
        when "FillingUtz"
          return "/filling_utz/#{id}"
        when "TextCorrectionUtz"
          return "/text_correction_utz/#{id}"
        when "ImagesSortUtz"
          return "/images_sort_utz/#{id}"
        end
      end

      def get_name(type, id)
        case type
        when "component"
          cmp = Component.find(id)
          return cmp.name
        when "test_utz"
          return TestUtzQuestion.find(id).text
        when "MatchingUtz"
          return MatchingUtz.find(id).name
        when "FillingUtz"
          return FillingUtz.find(id).name
        when "TextCorrectionUtz"
          return TextCorrectionUtz.find(id).name
        when "ImagesSortUtz"
          return ImagesSortUtz.find(id).theme
        end
      end
    end
  end
end
