function loadTask()
{
	getTask();

	var taskDiv = document.getElementById("task");
	taskDiv.innerHTML = "<span>" + currentTask.sentences[0] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[1] + "</span><br/>";
	taskDiv.innerHTML += "<span>" + currentTask.sentences[2] + "</span><br/>";

	var list = ["&lt;A&gt;", "&lt;B&gt;", "&lt;C&gt;"];
	initBNF(list, document.getElementById("BNF"));
}

window.onload = loadTask;
