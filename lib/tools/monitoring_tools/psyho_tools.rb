module Tools
  module MonitoringTools
    class PsyhoTools
      def get_list(extra_introversion_score, emotional_excitability_score, personality_modality)
        utz_distribution = {
          'Холерик' => {
            'default' => [TestUtzTopic, MatchingUtz, FillingUtz, TextCorrectionUtz, ImagesSortUtz, TopicComponent],
            'Аудиал' => [TestUtzTopic, MatchingUtz, FillingUtz, TextCorrectionUtz, ImagesSortUtz, TopicComponent],
            'Визуал' => [MatchingUtz, ImagesSortUtz, TopicComponent],
            'Кинестетик' => [TestUtzTopic, FillingUtz, TopicComponent]
          },
          'Меланхолик' => {
            'default' => [MatchingUtz, ImagesSortUtz, TopicComponent],
            'Аудиал' => [MatchingUtz, TopicComponent],
            'Визуал' => [ImagesSortUtz, TopicComponent],
            'Кинестетик' => [TestUtzTopic, TopicComponent]
          },
          'Флегматик' => {
            'default' => [TextCorrectionUtz, ImagesSortUtz, TopicComponent],
            'Аудиал' => [MatchingUtz, TextCorrectionUtz],
            'Визуал' => [ImagesSortUtz, TopicComponent],
            'Кинестетик' => [MatchingUtz, TopicComponent]
          },
          'Сангвиник' => {
            'default' => [TestUtzTopic, FillingUtz, TopicComponent],
            'Аудиал' => [TextCorrectionUtz, TestUtzTopic],
            'Визуал' => [ImagesSortUtz, FillingUtz],
            'Кинестетик' => [TestUtzTopic, TopicComponent]
          },
          'default' => [TestUtzTopic, MatchingUtz, FillingUtz, TextCorrectionUtz, ImagesSortUtz, TopicComponent]
        }
        personality_modality = personality_modality.blank? ? 'default' : personality_modality
        list_utz = []
        personality_types = get_student_personality_type(extra_introversion_score, emotional_excitability_score)
        list_utz = utz_distribution['default'] if personality_types.blank?
        personality_types.each do |personality_type|
          list_utz += utz_distribution[personality_type][personality_modality]
        end
        list_utz.uniq
      end

      def get_student_personality_type(extra_introversion_score, emotional_excitability_score)
        personality_types = []
        if extra_introversion_score.between?(0.0, 14.0) && emotional_excitability_score.between?(10.1, 20.0)
          personality_types.push('Меланхолик')

          personality_types.push('Холерик') if 14.0 - extra_introversion_score <= 1.0
          personality_types.push('Флегматик') if emotional_excitability_score - 10.0 <= 1.0
          personality_types.push('Сангвиник') if (emotional_excitability_score - 10.0 <= 0.3) && (14.0 - extra_introversion_score <= 0.3)
        elsif extra_introversion_score.between?(14.1, 26.0) && emotional_excitability_score.between?(10.1, 20.0)
          personality_types.push('Холерик')

          personality_types.push('Меланхолик') if extra_introversion_score - 14.0 <= 1.0
          personality_types.push('Сангвиник') if emotional_excitability_score - 10.0 <= 1.0
          personality_types.push('Флегматик') if (emotional_excitability_score - 10.0 <= 0.3) && (extra_introversion_score - 14.0 <= 0.3)
        elsif extra_introversion_score.between?(0.0, 14.0) && emotional_excitability_score.between?(0.0, 10.0)
          personality_types.push('Флегматик')

          personality_types.push('Сангвиник') if 14.0 - extra_introversion_score <= 1.0
          personality_types.push('Меланхолик') if 10.0 - emotional_excitability_score <= 1.0
          personality_types.push('Холерик') if (10.0 - emotional_excitability_score <= 0.3) && (14.0 - extra_introversion_score <= 0.3)
        elsif extra_introversion_score.between?(14.1, 26.0) && emotional_excitability_score.between?(0.0, 10.0)
          personality_types.push('Сангвиник')

          personality_types.push('Флегматик') if extra_introversion_score - 14.0 <= 1.0
          personality_types.push('Холерик') if 10.0 - emotional_excitability_score <= 1.0
          personality_types.push('Меланхолик') if (10.0 - emotional_excitability_score <= 0.3) && (extra_introversion_score - 14.0 <= 0.3)
        end
        personality_types
      end

      def self.get_utz_list(student)
        if student.extra_introversion_score.nil? && student.emotional_excitability_score.nil?
          student.extra_introversion_score = rand(0.0..26.0).round(2)
          student.emotional_excitability_score = rand(0.0..20.0).round(2)
          student.save
        end

        personality_modality = student.personalities.uniq.map(&:personality_traits).flatten.uniq.map(&:name).select {|pt| pt.in? ['Аудиал', 'Визуал', 'Кинестетик']}.first
        list_utz = PsyhoTools.new.get_list(student.extra_introversion_score, student.emotional_excitability_score, personality_modality)
        return list_utz
      end

      def self.make_individual_plan_with_psyho(student)
        # byebug
        problem_areas = student.user.ka_results.order(created_at: :desc).limit(2).first&.problem_areas
        if problem_areas
          topic_marks = problem_areas.pluck(:ka_topic_id, :mark)
          tutor_actions_priorities = {}
          utz_list = get_utz_list(student)
          has_topic_component = utz_list.delete(TopicComponent)
          has_test_utz = utz_list.delete(TestUtzTopic)

          topic_marks.each do |id, t|
            # byebug
            if has_topic_component
              topic_components = TopicComponent.where(ka_topic_id: id)
              topic_components.each do |tc|
                action_id = "component@%d" % tc.component_id
                if not tutor_actions_priorities.has_key?(action_id)
                  tutor_actions_priorities[action_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0.0 }
                end
                tutor_actions_priorities[action_id][:sum_score] += t * tc.weight
                tutor_actions_priorities[action_id][:sum_weight] += tc.weight
              end
            end

            if has_test_utz
              test_utz = TestUtzTopic.where(ka_topic_id: id)
              test_utz.each do |topic_utz|
                action_id = "test_utz@%d" % topic_utz.test_utz_question_id
                if not tutor_actions_priorities.has_key?(action_id)
                  tutor_actions_priorities[action_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0 }
                end
                tutor_actions_priorities[action_id][:sum_score] += topic_utz.weight * t
                tutor_actions_priorities[action_id][:sum_weight] += topic_utz.weight
              end
            end

            utz_list.each do |klass|
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

          tutor_actions = []
          tutor_actions_priorities.each do |action_id, p|
            id = action_id.split("@")[1].to_i
            type = action_id.split("@")[0]

            link = get_link(type, id)
            name = get_name(type, id)

            p[:score] = (p[:sum_score] / p[:sum_weight] * 100).nan? ? 0 : (p[:sum_score] / p[:sum_weight] * 100)

            if 100 - p[:score] > 30
            tutor_actions.push({
              :cmp => id,
              :type => type,
              :name => name,
              :link => link,
              :priority => (100 - p[:score]).round,
              :sum_weight => p[:sum_weight],
            })
            end
          end
          # tutor_actions.sort { |a, b| compare_actions(a, b) }
          return tutor_actions
        end
      end

      def self.compare_actions(action_1, action_2)
        return action_1[:priority] <=> action_2[:priority]
      end
    
      def self.get_link(type, id)
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
    
      def self.get_name(type, id)
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