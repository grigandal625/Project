class KaQuestionsVariants < ActiveRecord::Base
  belongs_to :ka_variant
  belongs_to :ka_questions
end
