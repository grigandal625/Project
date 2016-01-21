class KaVariant < ActiveRecord::Base
  belongs_to :ka_test
  has_and_belongs_to_many :ka_question
end
