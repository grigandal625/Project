class AddRecommendationIdToSemanticnetworks < ActiveRecord::Migration
  def change
    add_column :semanticnetworks, :recommendation_id, :text
  end
end
