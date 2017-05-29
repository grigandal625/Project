class CreateSemanticNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :semantic_nodes do |t|

      t.timestamps
    end
  end
end
