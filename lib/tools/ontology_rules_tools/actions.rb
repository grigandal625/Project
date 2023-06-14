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

        def as_hash(*args)
          puts "ACTION"
          {
            type: type,
            label: label,
          }
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
          "Запустить УТЗ"
        end
      end

      class AddHTBToStrategy < Action
        def self.label
          "Открыть главу ГТ-учебника"
        end
      end

      def self.all
        [ScanVertexRelatedRules, ScanETTRelatedRules, ScanHTBRelatedRules, AddETTToStrategy, AddHTBToStrategy]
      end

      def self.mapping
        res = {}
        all().each do |action|
          res[action.type.to_sym] = {
            label: action.label,
            class: action,
          }
        end
        return res
      end

      def self.get_action_class_id(action)
        a = action
        if a.is_a?(Action)
          a = a.class
        end
        return all().index(a) + 1
      end

      def self.get_action_class_by_id(id)
        return all()[id - 1]
      end
    end
  end
end
