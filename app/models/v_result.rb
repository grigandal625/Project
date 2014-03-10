class VResult < ActiveRecord::Base
  belongs_to :task
  belongs_to :student
  has_one :bnf, as: :component

end
