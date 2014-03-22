class VResult < ActiveRecord::Base
  belongs_to :result
  has_one :bnf, as: :component, dependent: :destroy
end
