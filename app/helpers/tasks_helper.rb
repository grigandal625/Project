#coding: utf-8
module TasksHelper
  
  def bnf_elements_lists
    padezh_list = ["Именительный", "Родительный", "Винительный", "Дательный",
                   "Творительный", "Предложный"]
    gender_list = ["Мужской", "Женский", "Средний"]
    return {["<падеж>", "padezh"] => padezh_list, ["<род>", "gender"] => gender_list}
  end

end
