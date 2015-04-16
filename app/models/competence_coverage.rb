class CompetenceCoverage < ActiveRecord::Base
  belongs_to :ka_result
  belongs_to :competence
end
