#coding: utf-8
class StudentsController < ApplicationController
  layout 'menu'
  def create
    student = Student.create(group_id: params[:group_id], fio: params[:fio])
    student.create_user(make_user_data(student))
    student.save
    redirect_to edit_group_path(id: params[:group_id])
  end

  def plan
    @student = @user.student
    topic = KaTopic.find(@student.group.timetable.events.last.ka_topic_id)
    if topic
      @topics = topic.get_tree
    end
  end

  def list
    render json: Student.all
  end

  def show
    user = User.find_by(id: session[:user_id])
    @student = Student.find(params[:id])
    if user.role != 'admin' && @student.id != user.id
    	redirect_to root_url
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    redirect_to edit_group_path(params[:group_id])
  end

  def passupdate
    st = User.where("student_id" => params[:id])[0]
    st.pass = Digest::MD5.hexdigest(params[:newpass])
    st.save
    redirect_to :back
  end
  private
  def make_user_data(student)
    return {login: student.group.number[-3..-1] +
            I18n::transliterate(student.fio, locale: :ru).gsub(' ', '_') +
            Random.rand(10..100000).to_s,
      pass: Digest::MD5.hexdigest(rand(36**10).to_s(36)),
      role: 'student'}
  end



end
