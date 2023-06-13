module Tools
  module OntologyRulesTools
    include Expressions
    include Actions

    module Rules
      class Rule
        attr_reader :condition, :actions

        def initialize(condition, actions)
          @condition = condition
          @actions = actions
        end

        def scan(**data)
          if @condition.evaluate(**data)
            @actions.each do |action|
              action.perform(**data)
            end
          end
        end

        def as_hash
          {
            condition: @condition.as_hash,
            actions: @actions.map do |action|
              Actions::get_action_class_id(action.class)
            end,
          }
        end

        def self.from_hash(data)
          Rule.new(
            Expressions::Expression.from_hash(data[:condition]),
            data[:actions].map do |type|
              Actions::mapping[type.to_sym][:class].new
            end
          )
        end
      end
    end
  end
end
