class TasksController < ApplicationController
  layout 'task'

  def get_v
    @taskType = 'V'
  end
end
