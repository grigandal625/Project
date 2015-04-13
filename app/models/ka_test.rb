class KaTest < ActiveRecord::Base
  has_many :ka_variant, dependent: :destroy
  has_many :ka_results, dependent: :destroy
end
