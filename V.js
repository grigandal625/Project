function loadTask()
{
	getTask();

	var taskDiv = document.getElementById("task");
	taskDiv.innerHTML = "<span>" + currentTask.sentences[0] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[1] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[2] + "</span><br/>";

	var list = ["&lt;описание словаря&gt;", "&lt;имя словаря&gt;", "{&lt;тело словаря&gt;}",
		"&lt;тело словаря&gt;", "&lt;словарная статья&gt;", "&lt;словарная статья понятий(сущ.)&gt;",
		"&lt;падеж&gt;", "&lt;номер п/п&gt;", "&lt;словоформа&gt;", "&lt;словарная статья вопр. слов&gt;",
		"&lt;словарная статья предикатов&gt;", "&lt;род&gt;", "&lt;число&gt;", "&lt;семантическая категория&gt;",
		"&lt;семантический признак&gt;"];
	initBNF(list, document.getElementById("BNF"));
}

window.onload = loadTask;
