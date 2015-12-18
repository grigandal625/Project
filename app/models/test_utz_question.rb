class TestUtzQuestion < ActiveRecord::Base
  has_many :test_utz_answers, dependent: :destroy
  belongs_to :ka_topic

  def answers
    test_utz_answers
  end

  def name
    text
  end
end
