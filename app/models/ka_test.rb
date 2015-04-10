class KaTest < ActiveRecord::Base
  has_many :ka_variant, dependent: :destroy
end
