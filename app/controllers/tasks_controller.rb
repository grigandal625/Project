class TasksController < ApplicationController
  layout 'task'

  def get_v
    @task = Task.find_by(variant: 1)
  end
end
