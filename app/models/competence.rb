class Competence < ActiveRecord::Base
  has_many :topic_competences, dependent: :delete_all #Использую delete_all т.к. у TopicsCompetences нет ключа (соответственно, не работает destroy метод)
  has_many :ka_topics, through: :topic_competences

  has_many :competence_coverages, dependent: :delete_all
  has_many :ka_results, through: :competence_coverages
end
