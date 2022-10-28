class KaWelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  def index
  end

  def personality_klaster
    personalities = Personality.all.map {|p| p.students.map{|e| e.results.map(&:mark)}.reduce(:+)}.select {|o| o.values != [nil] && o.values != [[]]}
    personalities = personalities.map{|e| {e.keys.first => e.values.first.instance_eval { reduce(:+) / size.to_f }}}
    personalities_hash = {}
    personalities.each{|e| personalities_hash.merge!(e)}
    personalities_hash.sort!
    dist = (personalities_hash.last - personalities_hash.first)/3
    klaster = {'Психотипы с высокой успеваемостью' => [], 'Психотипы со средней успеваемостью' => [], 'Психотипы с низкой успеваемостью' => []}
    personalities_hash.each do |k,v|
      if v < (personalities_hash.first + dist)
        klaster['Психотипы с низкой успеваемостью'].push(k)
      elsif v > (personalities_hash.last - dist)
        klaster['Психотипы с высокой успеваемостью'].push(k)
      else
        klaster['Психотипы со средней успеваемостью'].push(k)
      end
      render json: klaster
  end

  def personality_klaster_by_group
    personalities = Personality.all.map {|p| {p.name => p.students.where(group_id: params[:group_id]).map{|e| e.results.map(&:mark)}.reduce(:+)}}.select {|o| o.values != [nil] && o.values != [[]]}
    personalities = personalities.map{|e| {e.keys.first => e.values.first.instance_eval { reduce(:+) / size.to_f }}}
    personalities_hash = {}
    personalities.each{|e| personalities_hash.merge!(e)}
    personalities_hash_values = personalities_hash.values
    personalities_hash_values.sort!
    dist = (personalities_hash_values.last - personalities_hash_values.first)/3
    klaster1 = {'Психотипы с высокой успеваемостью' => [], 'Психотипы со средней успеваемостью' => [], 'Психотипы с низкой успеваемостью' => []}
    personalities_hash.each do |k,v|
      if v < (personalities_hash_values.first + dist)
        klaster1['Психотипы с низкой успеваемостью'].push(k)
      elsif v > (personalities_hash_values.last - dist)
        klaster1['Психотипы с высокой успеваемостью'].push(k)
      else
        klaster1['Психотипы со средней успеваемостью'].push(k)
      end
    end
      render json: klaster1
  end

end
