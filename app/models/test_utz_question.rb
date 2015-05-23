class TestUtzQuestion < ActiveRecord::Base
  has_many :test_utz_answers, dependent: :destroy

  def answers
    test_utz_answers
  end

  def name
    text
  end
end
