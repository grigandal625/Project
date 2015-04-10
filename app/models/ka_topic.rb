class KaTopic < ActiveRecord::Base
  belongs_to :parent, class_name: "KaTopic"
  has_many :children, class_name: "KaTopic", foreign_key: "parent_id", dependent: :destroy
  has_many :ka_question, dependent: :destroy
end
