#coding: utf-8
module TasksHelper
  Padezh_list = ["Именительный", "Родительный", "Винительный", "Дательный",
                 "Творительный", "Предложный"]
  Gender_list = ["Мужской", "Женский", "Средний"]
  Number_list = ["Единственное", "Множественное"]
  Odush_list = ["Одушевленное", "Неодушевленное"]
  Vid_list = ["Совершенный", "Несовершенный"]
  Tense_list = ["Прошедшее", "Настоящее", "Будущее"]
  Sem_val_list = ["A", "D", "R", "F", "T"]
  Pred_list = ["по", "на", "в", "от", "к", "у", "за", "из"]
  Sem_prizn_list = ["Одушевленный предмет", "Неодушевленный предмет",
                    "Пункт назначения", "Результат", "Время"]
  Codificator_list = ["Местоимение", "Наречие", "Предлог", "прилагательное",
                      "Союз", "Числительное", "Существительное", "Аббревиатура"]
  Bnf_list = ["<описание словаря>", "<имя словаря>", "{<тело словаря>}",
		"<тело словаря>", "<словарная статья>", "<словарная статья понятий>",
		"<словарная статья вопросительных слов>", "<словарная статья предлогов>",
		"<словарная статья предикатов>", "<словарная статья характеристик>",
		"<словарная статья неизменяемых словоформ>", "<кодификатор части речи>", "{<падеж>}",
		"<падеж>", "<номер п/п>", "<словоформа>", "<род>", "<одушевленность>",
		"<число>", "<семантическая категория>", "<семантический признак>",
		"<имя семантической валентности>", "<синтаксический компонент МУ>",
    "<семантический компонент МУ>", "[<предлог>]",
		"<тип вопроса>", "<предлог>", "<лицо>", "<время>",
		"<наклонение>", "<вид>", "<образец>",
		"{<образец>}"]

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
