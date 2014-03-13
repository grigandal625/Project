#coding: utf-8
module TasksHelper
  
  def bnf_elements_lists
    padezh_list = ["Именительный", "Родительный", "Винительный", "Дательный",
                   "Творительный", "Предложный"]
    gender_list = ["Мужской", "Женский", "Средний"]
    number_list = ["Единственное", "Множественное"]
    return {["<падеж>", "padezh"] => padezh_list,
            ["<род>", "gender"] => gender_list,
            ["<число>", "number"] => number_list}
  end

end
