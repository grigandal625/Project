class AddBnfJsonToBnf < ActiveRecord::Migration
  def change
    add_column :bnfs, :bnf_json, :text
  end
end
