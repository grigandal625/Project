class StudentsController < ApplicationController

  def create
    student = Student.create(group_id: params[:group_id], fio: params[:fio])
    student.create_user(make_user_data(student))
    student.save
    redirect_to edit_group_path(id: params[:group_id])
  end

  private
  def make_user_data(student)
    return {login: student.group.number + student.fio.gsub(' ', '_') +
            Random.rand(10..100000).to_s,
      pass: Digest::MD5.hexdigest(rand(36**10).to_s(36))}
  end

end
