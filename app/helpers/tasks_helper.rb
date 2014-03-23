#coding: utf-8
module TasksHelper

  def check_bnf_element(v_answer, left, elem)
    rule = v_answer.bnf.bnf_rules.where(left: left)
    if rule.first == nil
      return false
    else
      rule.first.right.include?(elem)
    end
  end

  def display_standard_table(columns, collection = {})

    thead = content_tag :thead, style: "background-color: wheat;" do
      content_tag :tr do
        columns.collect {|column|  concat content_tag(:th,column[:display_name])}.join().html_safe
      end
    end

    col = '#E0E0E0'
    tbody = content_tag :tbody do
      collection.collect { |elem|
        col = (col == '#E0E0E0' ? 'white' : '#E0E0E0')
        content_tag :tr, style: "background-color: #{col}" do
          columns.collect { |column|
            concat content_tag(:td, elem[column[:name]].to_s.html_safe)
          }.to_s.html_safe
        end

      }.join().html_safe
    end

    content_tag :table, thead.concat(tbody)

  end

end
