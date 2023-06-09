module Tools
  module OntologyRulesTools
    module Actions
      class Action
        def self.type
          self.name.demodulize.underscore
        end

        def type
          self.class.type
        end

        def self.label
          "Абстрактное действие"
        end

        def label
          self.class.label
        end

        def perform(**data)
          raise NotImplementedError
        end
      end

      class ScanVertexRelatedRules < Action
        def self.label
          "Выполнить частные правила, привязанные к вершине"
        end
      end

      class ScanETTRelatedRules < Action
        def self.label
          "Выполнить частные правила, привязанные к УТЗ"
        end
      end

      class ScanHTBRelatedRules < Action
        def self.label
          "Выполнить частные правила, привязанные к главе ГТ-учебника"
        end
      end

      class AddETTToStrategy < Action
        def self.label
          "Добавить УТЗ в стратегию обучения для текущего обучаемого"
        end
      end

      class AddHTBToStrategy < Action
        def self.label
          "Добавить главу ГТ-учебника в стратегию обучения для текущего обучаемого"
        end
      end

      def all
        [ScanVertexRelatedRules, ScanETTRelatedRules, ScanHTBRelatedRules, AddETTToStrategy, AddHTBToStrategy]
      end

      def mapping
        res = {}
        all().each do |action|
          res[action.type.to_sym] = {
            label: action.label,
            class: action,
          }
        end
        return res
      end

      def get_action_class_id(action)
        a = action
        if a.is_a?(Action)
          a = a.class
        end
        return all().index(a) + 1
      end

      def get_action_class_by_id(id)
        return all()[id - 1]
      end
    end
  end
end
