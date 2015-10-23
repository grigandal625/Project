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
    @right_count = 0
    @wrong_count = 0
    @mark_right_count = 0
    @mark_wrong_count = 0
  end

  def mark_right_count
    @mark_right_count
  end

  def mark_right_count=(x)
    @mark_right_count = x
  end

  def mark_wrong_count=(x)
    @mark_wrong_count = x
  end

  def mark_wrong_count
    @mark_wrong_count
  end

  def right_count
    @right_count
  end

  def right_count=(x)
    @right_count = x
  end

  def wrong_count=(x)
    @wrong_count = x
  end

  def wrong_count
    @wrong_count
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
    @right_count = 0
    @wrong_count = 0

    @problem_areas = {}
    @competence_coverages = {}

    question_marks = {}
    questions = variant.ka_question.each

    questions.each do |q|
      question_marks[q.id] = {right_ans_count: 0.0, wrong_ans_count: 0.0, score: 0.0}
      question_marks[q.id][:right_ans_count] = q.ka_answer.where(correct: 1).count
      question_marks[q.id][:wrong_ans_count] = q.ka_answer.where(correct: 0).count

      @detail_questions[q.id] = DetailQuestionResult.new(q)
      q.ka_answer.each do |ans|
        @detail_questions[q.id].detail_answers[ans.id] = DetailAnswer.new(ans)
        if ans.correct != 0
          @detail_questions[q.id].right_count += 1
        else
          @detail_questions[q.id].wrong_count += 1
        end
      end
    end

    answers.each do |a, _buf|
      ans = KaAnswer.find(a)
      if ans
        if ans.correct != 0
          question_marks[ans.ka_question_id][:score] += 1.0 / question_marks[ans.ka_question_id][:right_ans_count]
          @detail_questions[ans.ka_question_id].mark_right_count += 1
        else
          question_marks[ans.ka_question_id][:score] -= 1.0 / question_marks[ans.ka_question_id][:wrong_ans_count]
          @detail_questions[ans.ka_question_id].mark_wrong_count += 1
        end
        @detail_questions[ans.ka_question_id].detail_answers[ans.id].student_correct = 1
      end
    end

    sum_score = 0
    sum_diff = 0

    topic_marks = {}

    questions.each do |q|
      topic_marks[q.ka_topic_id] = {sum_score: 0.0, sum_diff: 0.0}
    end

    questions.each do |q|
      sum_score += q.difficulty * question_marks[q.id][:score]
      sum_diff += q.difficulty
      @detail_questions[q.id].assessment = q.difficulty * question_marks[q.id][:score]

      topic_marks[q.ka_topic_id][:sum_score] += @detail_questions[q.id].assessment
      topic_marks[q.ka_topic_id][:sum_diff] += q.difficulty
    end

    @assessment = sum_score / sum_diff
    if @assessment < 0
      @assessment = 0
    end
    @assessment *= 100.0
    @assessment = @assessment.to_i

    competence_marks = {}

    topic_marks.each do |id, t|
      @problem_areas[id] = t[:sum_score] / t[:sum_diff]
      @problem_areas[id] = 0 if @problem_areas[id] < 0

      top = KaTopic.find(id)
      top.topic_competences.each do |c|
        if not competence_marks.has_key?(c.competence_id)
          competence_marks[c.competence_id] = {sum_score: 0.0, sum_weight: 0.0}
        end
        competence_marks[c.competence_id][:sum_score] += @problem_areas[id] * c.weight
        competence_marks[c.competence_id][:sum_weight] += c.weight
      end
    end

    competence_marks.each do |id, c|
      @competence_coverages[id] = c[:sum_score] / c[:sum_weight]
    end
  end

  def detail_questions
    @detail_questions
  end

  def assessment
    @assessment
  end

  def problem_areas
    @problem_areas
  end

  def competence_coverages
    @competence_coverages
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
