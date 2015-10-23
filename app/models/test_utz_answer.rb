class TestUtzAnswer < ActiveRecord::Base
  belongs_to :test_utz_question

  def question
    test_utz_question
  end
end
