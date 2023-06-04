class OntologyRulesController < ApplicationController
  layout false

  def index
    respond_to do |format|
      format.html
      format.json { render json: OntologyRule.all.as_json }
    end
  end

  def criterias
    respond_to do |format|
      format.html
      format.json {
        all_criterias = [IsBushVertex, IsStudied, IsProblemArea, ProblemAreaCluster, ProblemAreaDynamics]
        cs = all_criterias.map do |c|
          c = c.new.as_hash(all_criterias.index(c) + 1)
        end
        render json: cs
      }
    end
  end

  def evaluate_criteria
    all_criterias = [IsBushVertex, IsStudied, IsProblemArea, ProblemAreaCluster, ProblemAreaDynamics]
    criteria = all_criterias[params[:id].to_i - 1].new
    ps = symbolize_keys(params)
    render json: criteria.get_active_value(**ps)
  end

  def create
  end

  def update
  end

  def delete
  end

  def execute
  end

  private

  def symbolize_keys(hash)
    hash.each_with_object({}) do |(k, v), h|
      new_key = k.is_a?(String) ? k.to_sym : k
      new_val = v.is_a?(Hash) ? symbolize_keys(v) : v
      h[new_key] = new_val
    end
  end
end

class Parameter
  attr_reader :name, :label, :required, :meta, :has_default, :default

  def initialize(name, label, required, meta = nil, has_default = false, default = nil)
    @name = name
    @label = label
    @required = required
    @meta = meta
    @has_default = has_default
    @default = default
  end

  def get_value(data = nil)
    return data.nil? ? self.has_default ? [self.default] : nil : data.is_a?(Array) ? data : [data]
  end

  def type
    return "parameter"
  end

  def as_hash
    res = {
      name: self.name,
      label: self.label,
      type: self.type(),
      required: self.required,
    }
    if self.has_default
      res[:default] = self.default
    end
    return res
  end

  def formate(instance)
    instance
  end
end

class NumberParameter < Parameter
  def type
    return "number"
  end
end

class ThresholdParameter < NumberParameter
  def initialize
    super("threshold", "Порог", false, nil, true, 0.67)
  end
end

class ModelParameter < Parameter
  attr_reader :name, :label, :meta, :model

  def initialize(name, label, required, meta)
    super(name, label, required, meta)
    @model = meta[:model]
  end

  def type
    return "model"
  end

  def get_value(data)
    if data.is_a?(Hash)
      if self.model.primary_key.nil? || !data.has_key?(self.model.primary_key.to_sym)
        return self.model.where(**data)
      else
        res = self.model.find(data[self.model.primary_key.to_sym])
        return res.respond_to?(:count) ? res : [res]
      end
    elsif self.model.primary_key.nil?
      return nil
    else
      res = self.model.find(data)
      return res.respond_to?(:count) ? res : [res]
    end
  end

  def formate(instance)
    return instance.attributes
  end
end

class VertexParameter < ModelParameter
  def initialize(required = true)
    super("vertex", "Вершина - элемент курса/дисциплины", required, { model: KaTopic })
  end
end

class StudentParameter < ModelParameter
  def initialize(required = true)
    super("student", "Обучаемый", required, { model: Student })
  end

  def formate(instance)
    return super(instance).merge({group: instance.group.attributes})
  end
end

class GroupParameter < ModelParameter
  def initialize(required = true)
    super("group", "Учебная группа", required, { model: Group })
  end
end

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

  def values # must return an object like [{id: 1, label: "value"}, ...]
    raise NotImplementedError
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

  def values
    return [
             { id: 1, label: "Вершина является кустовой" },
             { id: 2, label: "Вершина не является кустовой" },
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

  def values
    return [
             { id: 1, label: "Тема вершины затрагивалась обучаемым" },
             { id: 2, label: "Тема вершины не затрагивалась обучаемым" },
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

  def values
    return [
             { id: 1, label: "Вершина является проблемной зоной для обучаемого" },
             { id: 2, label: "Вершина не является проблемной зоной для обучаемого" },
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

  def values
    return [
             { id: 1, label: "Вершина не отнесена ни к одному кластеру проблемных зон" },
             { id: 2, label: "Вершина отнесена к кластеру очень сложных тем" },
             { id: 3, label: "Вершина отнесена к кластеру сложных тем" },
             { id: 4, label: "Вершина отнесена к кластеру почти усваиваемых тем" },
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

  def values
    return [
             { id: 1, label: "Тема не отнесена ни к одному варианту динамики" },
             { id: 2, label: "Тема вершины имеет положительную динамику" },
             { id: 3, label: "Тема вершины имеет отрицательную динамику" },
           ]
  end
end
