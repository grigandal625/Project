function loadTask()
{
	getTask();

	var taskDiv = document.getElementById("task");
	taskDiv.innerHTML = "<span>" + currentTask.sentences[0] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[1] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[2] + "</span><br/>";

	var list = [["&lt;описание словаря&gt;", "&lt;имя словаря&gt;", "{&lt;тело словаря&gt;}",
		"&lt;тело словаря&gt;", "&lt;словарная статья&gt;", "&lt;словарная статья понятий&gt;",
		"&lt;словарная статья вопросительных слов&gt;", "&lt;словарная статья предлогов&gt;",
		"&lt;словарная статья предикатов&gt;", "&lt;словарная статья характеристик&gt;",
		"&lt;словарная статья неизменяемых словоформ&gt;", "{&lt;падеж&gt;}",
		"&lt;падеж&gt;", "&lt;номер п/п&gt;", "&lt;словоформа&gt;", "&lt;род&gt;",
		"&lt;число&gt;", "&lt;семантическая категория&gt;", "&lt;семантический признак&gt;",
		"{&lt;сем. категория&gt;&lt;сем. признак&gt;}", "&lt;НКФ&gt;",
		"&lt;тип вопроса&gt;", "&lt;смысл предлога&gt;", "&lt;лицо&gt;", "&lt;время&gt;",
		"&lt;наклонение&gt;", "&lt;вид&gt;", "&lt;образец&gt;",
		"{&lt;образец&gt;}", "&lt;предлог&gt;+&lt;падеж&gt;", "&lt;глубинный падеж&gt;"],
		["Мужской", "Женский", "Средний"],
		["Именительный", "Родительный", "Дательный", "Винительный",
		"Творительный", "Предложный", "Единственное", "Множественное"],
		["Единственное", "Множественное"],
		["словарь вопросительных слов", "словарь неизменяемых словоформ",
		"словарь предикатов", "словарь характеристик", "словарь предлогов"]];

	list[0].sort();
	initBNF(list, document.getElementById("BNF"));
}

function sendAnswer()
{
	var hid = document.getElementById('answer_content');
	var ans = [];
	for(var line in bnfContent.lines)
	{
		var ans_line = {left : '', right : ''};
		ans_line.left = bnfContent.lines[line].left;
		for(var rule in bnfContent.lines[line].rules)
		{
			for(var el in bnfContent.lines[line].rules[rule])
				ans_line.right += bnfContent.lines[line].rules[rule][el];
			ans_line.right += '|';
		}
		ans_line = ans_line.substr(0, ans_line.length - 1)
		ans.push(ans_line);
	}
	hid.value = JSON.stringify(ans);
}

window.onload = loadTask;
