class KaResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :ka_variant
  belongs_to :ka_test
  has_many   :ka_answer_logs

  has_many :problem_areas,      dependent: :delete_all
  has_many :ka_topics,          through: :problem_areas

  has_many :competence_coverages, dependent: :delete_all
  has_many :competences,          through: :competence_coverages
end
