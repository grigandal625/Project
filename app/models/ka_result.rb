class KaResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :ka_variant
end
