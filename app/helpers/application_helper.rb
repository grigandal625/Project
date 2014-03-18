#coding: utf-8
module ApplicationHelper
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

end
