class VResult < ActiveRecord::Base
  belongs_to :result
  has_one :bnf, as: :component
  has_one :log, as: :component
end
