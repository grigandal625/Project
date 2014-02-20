function loadTask()
{
	getTask();

	var taskDiv = document.getElementById("sentence1DivS");
	taskDiv.innerHTML =  currentTask.sentences[0];
	


}

window.onload = loadTask;