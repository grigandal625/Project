class DetailAnswer
  def initialize(answer)
    @student_correct = 0
    @answer = answer
    @real_correct = answer.correct
  end

  def answer
    @answer
  end

  def student_correct
    @student_correct
  end

  def student_correct=(x)
    @student_correct = x
  end

  def real_correct
    @real_correct
  end
end

class DetailQuestionResult
  def initialize(question)
    @assessment = 0
    @question = question
    @detail_answers = {}
  end

  def detail_answers
    @detail_answers
  end

  def assessment=(x)
    @assessment = x
  end

  def assessment
    @assessment
  end

  def question
    @question
  end
end

class KaDetailResult
  def initialize(variant, answers)
    @assessment = 0
    @detail_questions = {}

    question_marks = {}
    questions = variant.ka_question.each

    questions.each do |q|
      question_marks[q.id] = {right_ans_count: 0.0, wrong_ans_count: 0.0, score: 0.0}
      question_marks[q.id][:right_ans_count] = q.ka_answer.where(correct: 1).count
      question_marks[q.id][:wrong_ans_count] = q.ka_answer.where(correct: 0).count

      @detail_questions[q.id] = DetailQuestionResult.new(q)
      q.ka_answer.each do |ans|
        @detail_questions[q.id].detail_answers[ans.id] = DetailAnswer.new(ans)
      end
    end

    answers.each do |a, _buf|
      ans = KaAnswer.find(a)
      if ans.correct != 0
        question_marks[ans.ka_question_id][:score] += 1.0 / question_marks[ans.ka_question_id][:right_ans_count]
      else
        question_marks[ans.ka_question_id][:score] -= 1.0 / question_marks[ans.ka_question_id][:wrong_ans_count]
      end
      @detail_questions[ans.ka_question_id].detail_answers[ans.id].student_correct = 1
    end

    sum_score = 0
    sum_diff = 0

    questions.each do |q|
      sum_score += q.difficulty * question_marks[q.id][:score]
      sum_diff += q.difficulty
      @detail_questions[q.id].assessment = q.difficulty * question_marks[q.id][:score]
     end

    @assessment = sum_score / sum_diff
    if @assessment < 0
      @assessment = 0
    end
    @assessment = @assessment.to_i
  end

  def detail_questions
    @detail_questions
  end

  def assessment
    @assessment
  end
end

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
