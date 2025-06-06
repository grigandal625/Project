module Tools
  module OntologyRulesTools
    module Parameters
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

      class StringParameter < Parameter
        def type
          return "string"
        end
      end

      class ThresholdParameter < NumberParameter
        def initialize
          super("threshold", "Порог", false, nil, true, 0.67)
        end
      end

      class EnumParameter < Parameter
        attr_reader :name, :label, :required, :meta, :has_default, :default, :multiple

        def initialize(name, label, required, meta, has_default = false, default = nil)
          super(name, label, required, meta, has_default, default)
          @_values = meta[:values]
          if @_values.is_a?(Array)
            @_values = @_values.map.with_index { |value, index| [index, value] }.to_h
          end
          @multiple = meta[:multiple].nil? ? false : meta[:multiple]
        end

        def type
          "enum"
        end

        def get_value(data)
          if @_values.keys.include?(data) or @_values.keys.map do |k| k.to_s end.include?(data)
            return [data]
          elsif data.is_a?(Integer)
            return [@_values.keys[data - 1]]
          elsif data.is_a?(Array)
            res = []
            data.each do |d|
              res += self.get_value(d)
            end
            return res.count ? res : nil
          end
        end

        def values
          @_values.keys.map do |v|
            { value: v, label: @_values[v] }
          end
        end

        def as_hash
          super.merge({
            values: self.values,
            multiple: self.multiple,
          })
        end
      end

      class ETTTypeParameter < EnumParameter
        def initialize
          super("ett_type", "Тип УТЗ", false, { values: TestUtzTopic.ett_types_mapping.transform_values { |value| value[:label] }, multiple: true })
        end

        def values
          return TestUtzTopic.ett_types_mapping.keys.map do |key|
                   { value: key, label: TestUtzTopic.ett_types_mapping[key][:label] }
                 end
        end
      end

      class ETTDifficultyParameter < EnumParameter
        def initialize
          super("ett_difficulty", "Сложность УТЗ", false, { values: ["1", "2", "3"], multiple: true })
        end
      end

      class HTBContainsParameter < EnumParameter
        def initialize
          super("htb_contains", "Наличие узлов модели гипертекста в главе ГТ-учебника", false, { values: ["текст", "изображение", "звук", "видео", "HTML-страница", "исполняемый файл"], multiple: true })
        end
      end

      class RelationTypeParameter < EnumParameter
        def initialize
          super("relation_type", "Тип связи", false, { values: ["R1 - \"Часть-целое\" (Агрегация)", "R2 - \"Ассоциация\"", "R3 - \"Слабая\"", "С - \"Иерархическая\""], multiple: true })
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

      class ParentVertexParameter < VertexParameter
        def initialize(required = true)
          super(required)
          @name = "parent_vertex"
          @label = "Родительская вершина - элемент курса/дисциплины"
        end
      end

      class ChildVertexParameter < VertexParameter
        def initialize(required = true)
          super(required)
          @name = "child_vertex"
          @label = "Дочерняя вершина - элемент курса/дисциплины"
        end
      end

      class StudentParameter < ModelParameter
        def initialize(required = true)
          super("student", "Текущая модель обучаемого", required, { model: Student })
        end

        def formate(instance)
          return super(instance).merge({ group: instance.group.attributes })
        end
      end

      class GroupParameter < ModelParameter
        def initialize(required = true)
          super("group", "Учебная группа", required, { model: Group })
        end
      end

      class CompetenceParameter < ModelParameter
        def initialize(required = true)
          super("competence", "Компетенция", required, { model: Competence })
        end
      end
    end
  end
end
