#coding: utf-8
module TasksHelper

  def bnf_elements_lists
    return {["<падеж>", "padezh"] => Padezh_list,
            ["<род>", "gender"] => Gender_list,
            ["<число>", "number"] => Number_list,
            ["<одушевленность>", "odush"] => Odush_list,
            ["<вид>", "vid"] => Vid_list,
            ["<время>", "tense"] => Tense_list,
            ["<имя семантической валентности>", "sem_val"] => Sem_val_list,
            ["<предлог>", "pred"] => Pred_list,
            ["<семантический признак>", "sem_prizn"] => Sem_prizn_list,
            ["<кодификатор части речи>", "codificator"] => Codificator_list}
  end

  def display_standard_table(columns, collection = {})

    thead = content_tag :thead do
      content_tag :tr do
        columns.collect {|column|  concat content_tag(:th,column[:display_name])}.join().html_safe
      end
    end

    tbody = content_tag :tbody do
      collection.collect { |elem|
        content_tag :tr do
          columns.collect { |column|
            concat content_tag(:td, elem[column[:name]].to_s.html_safe)
          }.to_s.html_safe
        end

      }.join().html_safe
    end

    content_tag :table, thead.concat(tbody)

  end

end
