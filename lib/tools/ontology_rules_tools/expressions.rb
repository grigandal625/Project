module Tools
  module OntologyRulesTools
    include Criterias

    module Expressions
      class Expression
        def evaluate(**data)
          raise NotImplementedError
        end

        def self.type
          self.name.demodulize.underscore
        end

        def self.label
          "Абстрактное выражение"
        end

        def type
          self.class.type
        end

        def label
          self.class.label
        end

        def as_hash
          {
            type: self.type,
            label: self.label,
          }.merge(self.hash_data)
        end

        def hash_data
          raise NotImplementedError
        end

        def self.all
          [ValueExpression, CriteriaExpression, SignedExpression]
        end
  
        def self.mapping
          res = {}
          Expression.all().each do |expr|
            res[expr.type.to_sym] = {
              label: expr.label,
              class: expr,
            }
          end
          return res
        end

        def self.from_hash(data)
          expr = Expression.mapping()[data[:type].to_sym][:class]
          return expr.from_hash(data)
        end
      end

      class ValueExpression < Expression
        attr_reader :value

        def initialize(value)
          @value = value
        end

        def evaluate(**data)
          @value
        end

        def self.label
          "Значение"
        end

        def hash_data
          {
            value: @value,
          }
        end

        def self.from_hash(data)
          return ValueExpression.new(data[:value])
        end
      end

      class CriteriaExpression < Expression
        attr_reader :criteria_instance

        def initialize(criteria_instance)
          @criteria_instance = criteria_instance
        end

        def evaluate(**data)
          result = self.criteria_instance.get_active_value(**data)
          result = result[:many] ? result[:data][0][:value] : result[:data][:value]
          return result
        end

        def self.type
          self.name.demodulize.underscore
        end

        def self.label
          "Критерий"
        end

        def hash_data
          {
            criteria: Criterias::get_criteria_instance_id(self),
          }
        end

        def self.from_hash(data)
          return CriteriaExpression.new(Criterias::all[data[:criteria] - 1].new)
        end
      end

      class SignedExpression < Expression
        attr_reader :sign, :left, :right

        def initialize(sign, left, right)
          @sign = sign
          @left = left
          @right = right
        end

        def evaluate(**data)
          eval("def eval_signed(a, b) a " + self.sign + " b end") # дыра для код-инъекции, но кому надо тут что-то взламывать
          return eval_signed(self.left.evaluate(**data), self.right.evaluate(**data))
        end

        def self.label
          "Выражение"
        end

        def hash_data
          {
            sign: self.sign,
            left: self.left.as_hash,
            right: self.right.as_hash,
          }
        end

        def self.from_hash(data)
          return SignedExpression.new(
                   data[:sign],
                   Expression.from_hash(data[:left]),
                   Expression.from_hash(data[:right]),
                 )
        end
      end

      def self.all
        [ValueExpression, CriteriaExpression, SignedExpression]
      end

      def self.mapping
        res = {}
        all().each do |expr|
          res[expr.type.to_sym] = {
            label: expr.label,
            class: expr,
          }
        end
        return res
      end
    end
  end
end
