require_relative "parameters"

module Tools
  module OntologyRulesTools
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
        return combs.count == 1 ? combs[0] : combs
      end

      def get_value_with_params(**data)
        return {
                 value: _get_active_value(**data),
                 parameters: data.keys.map do |key|
                   [key, self.get_parameter(key.to_s).formate(data[key])]
                 end.to_h,
               }
      end

      def check(data, selected_value_id = nil)
        active_value = self.get_active_value(**data)
        if !active_value.is_a?(Array) && !selected_value_id.is_a?(Array)
          return selected_value_id == active_value[:value][:id]
        elsif !selected_value_id.is_a?(Array)
          return active_value.map do |v|
                   v[:value][:id] == selected_value_id
                 end
        elsif active_value.is_a?(Array) && selected_value_id.is_a?(Array)
          return active_value.map do |v|
                   v[:value][:id] == selected_value_id[active_value.index(v)]
                 end
        end
      end

      def _values
        raise NotImplementedError
      end

      def values # must return an object like [{id: 1, label: "value"}, ...]
        vs = self._values
        return vs.map do |v|
                 { id: vs.index(v), label: v }
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
        super("is_bush_vertex", "Является ли вершина кустовой", [VertexParameter.new])
      end

      def _get_active_value(vertex:)
        return self.values[vertex.is_bush_vertex ? 0 : 1]
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
        super("is_studied", "Затрагивалась ли тема вершины обучаемым в тестировании", [VertexParameter.new, StudentParameter.new])
      end

      def _get_active_value(vertex:, student:)
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
        super("is_problem_area", "Является ли вершина проблемной зоной для обучаемого", [VertexParameter.new, StudentParameter.new, ThresholdParameter.new])
      end

      def _get_active_value(vertex:, student:, threshold:)
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
        super("problem_area_cluster", "Кластер проблемной зоны", [VertexParameter.new, GroupParameter.new])
      end

      def _get_active_value(vertex:, group:)
        problem_areas = ::Tools::MonitoringTools::KlasterTools.new().problem_areas([group.id], 0.69, 0.55, 0.1, vertex.root.id)["Кластеризация"]

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
        super("problem_area_dynamics", "Динамика проблемной зоны", [VertexParameter.new, GroupParameter.new])
      end

      def _get_active_value(vertex:, group:)
        problem_areas = ::Tools::MonitoringTools::KlasterTools.new().problem_areas([group.id], 0.69, 0.55, 0.1, vertex.root.id)["Динамика"]
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

    class Criterias
      def self.all
        return [IsBushVertex, IsStudied, IsProblemArea, ProblemAreaCluster, ProblemAreaDynamics]
      end
    end
  end
end
