module Tools
  module OntologyRulesTools
    include Parameters

    module Criterias
      class Criteria
        attr_reader :name, :label, :parameters

        def initialize(name, label, parameters = [])
          @name = name
          @label = label
          @parameters = parameters
        end

        def _check_parameters(data)
          self.parameters.each do |p|
            if p.required
              if !data.has_key?(p.name.to_sym)
                raise "Parameter " + p.name + " expected"
              end
            end
          end
          return true
        end

        def get_active_value(**data)
          self._check_parameters(data)
          combs = self.parameter_values(data, method(:get_value_with_params))
          return {
                   many: combs.count > 1,
                   data: combs.count == 1 ? combs[0] : combs,
                 }
        end

        def get_value_with_params(**data)
          return {
                   value: _get_active_value(**data),
                   parameters: data.keys.map do |key|
                     [key, self.get_parameter(key.to_s).formate(data[key])]
                   end.to_h,
                 }
        end

        def _values
          raise NotImplementedError
        end

        def values # must return an object like [{id: 1, label: "value"}, ...]
          vs = self._values
          return vs.map do |v|
                   { id: vs.index(v) + 1, label: v }
                 end
        end

        def as_hash(id = nil)
          return {
                   id: id,
                   name: self.name,
                   label: self.label,
                   values: self.values,
                   parameters: self.parameters.map do |p|
                     p = p.as_hash()
                   end,
                 }
        end

        def get_parameter(name)
          self.parameters.each do |p|
            if p.name == name
              return p
            end
          end
        end

        def has_parameter(name)
          return !self.get_parameter(name).nil?
        end

        def parameter_names()
          return self.parameters.map do |p|
                   p = p.name()
                 end
        end

        def parameter_values(data, callback = nil)
          attrs = {}
          self.parameters.each do |p|
            attrs[p.name.to_sym] = p.get_value(data[p.name.to_sym])
          end
          return self.combinations(attrs, callback)
        end

        def _combinations(attributes, callback = nil)
          return [{}] if attributes.empty?
          first_attr, *rest_attrs = attributes
          rest_combinations = _combinations(rest_attrs)

          first_attr_values = first_attr.last
          first_attr_values.flat_map do |value|
            rest_combinations.map do |combination|
              res = { "#{first_attr.first}": value, **combination }
              callback.nil? ? res : callback.call(**res)
            end
          end
        end

        def combinations(attrs, callback = nil)
          attributes = attrs.keys.map do |key|
            res = [key, attrs[key]]
            key = res
          end
          return _combinations(attributes, callback)
        end
      end

      class IsBushVertex < Criteria
        def initialize
          super("is_bush_vertex", "Является ли вершина кустовой", [Parameters::VertexParameter.new])
        end

        def _get_active_value(vertex:, **args)
          return self.values[ 
            KaQuestion.where(ka_topic: vertex, difficulty: 3).empty? ? 1 : 0
          ]
        end

        def _values
          return [
                   "Вершина является кустовой",
                   "Вершина не является кустовой",
                 ]
        end
      end

      class IsStudied < Criteria
        def initialize
          super("is_studied", "Затрагивалась ли тема вершины обучаемым в тестировании", [Parameters::VertexParameter.new, Parameters::StudentParameter.new])
        end

        def _get_active_value(vertex:, student:, **args)
          results = KaResult.where(user_id: student.user.id)
          areas = ProblemArea.where(ka_topic: vertex, ka_result: results).order(created_at: :desc)
          return self.values()[areas.count > 0 ? 0 : 1]
        end

        def _values
          return [
                   "Тема вершины затрагивалась обучаемым",
                   "Тема вершины не затрагивалась обучаемым",
                 ]
        end
      end

      class IsProblemArea < Criteria
        def initialize
          super("is_problem_area", "Является ли вершина проблемной зоной для обучаемого", [Parameters::VertexParameter.new, Parameters::StudentParameter.new, Parameters::ThresholdParameter.new])
        end

        def _get_active_value(vertex:, student:, threshold:, **args)
          results = KaResult.where(user_id: student.user.id)
          areas = ProblemArea.where(ka_topic: vertex, ka_result: results).order(created_at: :desc)
          if areas.count > 0
            return self.values()[areas[0].mark < threshold ? 0 : 1]
          end
          return { id: nil, label: "Не определено" }
        end

        def _values
          return [
                   "Вершина является проблемной зоной для обучаемого",
                   "Вершина не является проблемной зоной для обучаемого",
                 ]
        end
      end

      class ProblemAreaCluster < Criteria
        def initialize
          super("problem_area_cluster", "Кластер проблемной зоны", [
            Parameters::VertexParameter.new,
            Parameters::GroupParameter.new,
            Parameters::NumberParameter.new("max_good", "Максимальный балл для почти усваиваемых тем", false, nil, true, 0.67),
            Parameters::NumberParameter.new("min_good", "Минимальный балл для почти усваиваемых тем", false, nil, true, 0.55),
            Parameters::NumberParameter.new("min_hard", "Максимальный балл для сложных тем", false, nil, true, 0.1),
          ])
          @groups = {}
        end

        def _get_active_value(vertex:, group:, max_good:, min_good:, min_hard:, **args)
          k = [group.id, max_good, min_good, min_hard]
          if @groups[k].nil?
            @groups[k] = ::Tools::MonitoringTools::KlasterTools.new().problem_areas([group.id], max_good, min_good, min_hard)["Кластеризация"]
          end
          problem_areas = @groups[k]
          if !problem_areas["Очень сложные темы"].include?(vertex) && !problem_areas["Почти усваемые темы"].include?(vertex) && !problem_areas["Сложные темы"].include?(vertex)
            return self.values()[0]
          elsif problem_areas["Очень сложные темы"].include?(vertex)
            return self.values()[1]
          elsif problem_areas["Сложные темы"].include?(vertex)
            return self.values()[2]
          elsif problem_areas["Почти усваемые темы"].include?(vertex)
            return self.values()[3]
          end
          return { id: nil, label: "Не определено" }
        end

        def _values
          return [
                   "Вершина не отнесена ни к одному кластеру проблемных зон",
                   "Вершина отнесена к кластеру очень сложных тем",
                   "Вершина отнесена к кластеру сложных тем",
                   "Вершина отнесена к кластеру почти усваиваемых тем",
                 ]
        end
      end

      class ProblemAreaDynamics < Criteria
        def initialize
          super("problem_area_dynamics", "Динамика проблемной зоны", [Parameters::VertexParameter.new, Parameters::GroupParameter.new])
          @groups = {}
        end

        def _get_active_value(vertex:, group:, **args)
          if @groups[group.id].nil?
            @groups[group.id] = ::Tools::MonitoringTools::KlasterTools.new().problem_areas([group.id], 0.69, 0.55, 0.1, vertex.root.id)["Динамика"]
          end
          problem_areas = @groups[group.id]
          if !problem_areas["Динамика отрицательная"].include?(vertex) && !problem_areas["Динамика положительная"].include?(vertex)
            return self.values()[0]
          elsif problem_areas["Динамика положительная"].include?(vertex)
            return self.values()[1]
          elsif problem_areas["Динамика отрицательная"].include?(vertex)
            return self.values()[2]
          end
          return { id: nil, label: "Не определено" }
        end

        def _values
          return [
                   "Тема не отнесена ни к одному варианту динамики",
                   "Тема вершины имеет положительную динамику",
                   "Тема вершины имеет отрицательную динамику",
                 ]
        end
      end

      class ETTRelationsCriteria < Criteria
        def initialize
          super("ett_relations", "Наличие связей между вершиной и УТЗ", [
            Parameters::VertexParameter.new,
            Parameters::ETTTypeParameter.new,
            Parameters::ETTDifficultyParameter.new,
          ])
        end

        def _get_active_value(vertex:, ett_type:, ett_difficulty:, **args)
          etts_by_difficulty = TestUtzTopic.ett_types_mapping[ett_type.to_sym][:model].all # .all заменить на .where(difficulty: ett_difficulty)
          attrs = { ka_topic: vertex, ett_type.to_sym => etts_by_difficulty }
          ett_relations = TestUtzTopic.where(**attrs)
          return ett_relations.count == 0 ? self.values[1] : self.values[0]
        end

        def _values
          return [
                   "Связь присутствует",
                   "Связь отсутствует",
                 ]
        end
      end

      class HTBRelationsCriteria < Criteria
        def initialize
          super("htb_relations", "Наличие связей между вершиной и главами ГТ-учебника", [
            Parameters::VertexParameter.new,
            Parameters::HTBContainsParameter.new,
          ])
        end

        def _get_active_value(vertex:, htb_contains:)
          return { id: nil, label: "Не реализовано" }
        end

        def _values
          return [
                   "Связь присутствует",
                   "Связь отсутствует",
                 ]
        end
      end

      class VertexRelationsCriteria < Criteria
        def initialize
          super("vertex_relations", "Наличие связей между вершинами - элементами курса/дисциплины", [
            Parameters::VertexParameter.new,
            Parameters::ChildVertexParameter.new,
            Parameters::RelationTypeParameter.new,
          ])
        end

        def _get_active_value(vertex:, child_vertex:, relation_type:)
          if relation_type == 3
            return child_vertex.parent_id == vertex.id ? self.values[1] : self.values[0]
          end
          return TopicRelation.where(ka_topic: vertex, related_topic: child_vertex, rel_type: relation_type).empty? ? self.values[0] : self.values[1]
        end

        def _values
          return [
                   "Связь отсутствует",
                   "Связь присутствует",
                 ]
        end
      end

      class CompetenceRelationsCriteria < Criteria
        def initialize
          super("competence_relations", "Наличие связей между вершиной и компетенциями", [
            Parameters::VertexParameter.new,
            Parameters::CompetenceParameter.new,
          ])
        end

        def _get_active_value(vertex:, competence:)
          return TopicCompetence.where(ka_topic: vertex, competence: competence).empty? ? self.values[0] : self.values[1]
        end

        def _values
          return [
                   "Связь отсутствует",
                   "Связь присутствует",
                 ]
        end
      end

      def self.all
        [IsBushVertex, IsStudied, IsProblemArea, ProblemAreaCluster, ProblemAreaDynamics, ETTRelationsCriteria, HTBRelationsCriteria, VertexRelationsCriteria, CompetenceRelationsCriteria]
      end

      def self.get_criteria_instance_id(instance)
        all().each do |criteria|
          if instance.is_a?(criteria)
            return all().index(criteria) + 1
          end
        end
      end
    end
  end
end
