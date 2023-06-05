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
        all_criterias = ::Tools::OntologyRulesTools::Criterias.all
        cs = all_criterias.map do |c|
          c = c.new.as_hash(all_criterias.index(c) + 1)
        end
        render json: cs
      }
    end
  end

  def evaluate_criteria
    all_criterias = ::Tools::OntologyRulesTools::Criterias.all
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