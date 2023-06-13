class OntologyRulesController < ApplicationController
  include ::Tools::OntologyRulesTools::Criterias # see lib/tools/ontology_rules_tools/criterias.rb
  include ::Tools::OntologyRulesTools::Expressions
  include ::Tools::OntologyRulesTools::Actions
  include ::Tools::OntologyRulesTools::Rules

  layout false

  def index
    respond_to do |format|
      format.html
      format.json { render json: OntologyRule.all }
    end
  end

  def criterias
    respond_to do |format|
      format.html
      format.json {
        all_criterias = ::Tools::OntologyRulesTools::Criterias::all # see lib/tools/ontology_rules_tools/criterias.rb
        cs = all_criterias.map do |c|
          c = c.new.as_hash(all_criterias.index(c) + 1)
        end
        render json: cs
      }
    end
  end

  def evaluate_criteria
    all_criterias = ::Tools::OntologyRulesTools::Criterias::all # see lib/tools/ontology_rules_tools/criterias.rb
    criteria = all_criterias[params[:id].to_i - 1].new
    ps = symbolize_keys(params)
    render json: criteria.get_active_value(**ps)
  end

  def expressions
    all_expressions = ::Tools::OntologyRulesTools::Expressions::all
    es = all_expressions.map do |expr|
      {
        type: expr.type,
        label: expr.label,
      }
    end
    render json: es
  end

  def actions
    all_actions = ::Tools::OntologyRulesTools::Actions::all
    as = all_actions.map do |action|
      {
        type: action.type,
        label: action.label,
      }
    end
    render json: as
  end

  def create
    r = ::Tools::OntologyRulesTools::Rules::Rule.from_hash(symbolize_keys(params))
    rule = OntologyRule.create(condition: params[:condition].to_json, actions: params[:actions].to_json, cf: params[:cf], description: params[:description])
    rule.save!
    render json: rule
  end

  def update
  end

  def delete
    rule = OntologyRule.find(params[:id])
    rule.destroy
    render json: { success: true }
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
