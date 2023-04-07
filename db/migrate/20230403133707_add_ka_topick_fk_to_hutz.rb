class AddKaTopickFkToHutz < ActiveRecord::Migration[5.0]
  def change
    add_reference :hierarchy_utzs, :ka_topics, index: true
  end
end
