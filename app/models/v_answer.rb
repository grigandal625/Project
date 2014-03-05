class VAnswer < ActiveRecord::Base
  belongs_to :task
  has_one :bnf, as :component
end
