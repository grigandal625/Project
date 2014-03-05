class Bnf < ActiveRecord::Base
  belongs_to :component, polymorphic: true
  has_many :bnf_rules
end
