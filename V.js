function loadTask()
{
	getTask();

	var taskDiv = document.getElementById("task");
	taskDiv.innerHTML = "<span>" + currentTask.sentences[0] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[1] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[2] + "</span><br/>";

	var list = ["&lt;Словарь&gt;", "&lt;Название словаря&gt;", "{&lt;Тело словаря&gt;}",
		"&lt;Тело словаря&gt;", "&lt;Словарная статья&gt;", "&lt;Словарная статья понятий(сущ.)&gt;", "&lt;Падеж&gt;"];
	initBNF(list, document.getElementById("BNF"));
}

window.onload = loadTask;
