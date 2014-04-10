function loadTask(){
	var dynamicHelp = document.getElementById("dynamicHelp");
	document.getElementById("error").style.color = "red";
	dynamicHelp.innerHTML = helpStrings["start"];
	
	initG(false);
	initButtons();
	fillgroups();
	refreshGroups();

	setActiveButtons();
}

function changeStatus(id){
	var dynamicHelp = document.getElementById("dynamicHelp");
	var error = document.getElementById("error");
	
	if ( groupFlag.status == true ){
		error.innerHTML = errors["group"];
		return;
	}
	
	if ( selected.status == false ){
		if ( selected.id == -1 ){
			wordTable[id].status = 1;
			document.getElementById("span"+id).className = "start-select";
			selected.id = id;
			selected.sentence = wordTable[id].sentence;
			dynamicHelp.innerHTML = helpStrings["selection"];
			error.innerHTML = "";
		}else{
			if ( selected.sentence != wordTable[id].sentence ){
				error.innerHTML = errors["sentence"];
				return;
			}
			var from;
			var to;
			if ( id < selected.id ){
				from = id;
				to = selected.id;
			}else{
				from = selected.id;
				to = id;
			}
			var tmp = from;
			while ( tmp <= to ){
				if ( wordTable[tmp].type == "group" ){
					error.innerHTML = errors["solidselection"];
					return;
				}
				tmp++;
			}
			while ( from <= to ){
				wordTable[from].status = 1;
				document.getElementById("span"+from).className = "end-select";
				from++;
			}
			selected.status = true;
			dynamicHelp.innerHTML = helpStrings["groupcreation"];
			error.innerHTML = "";
		}
	}else{
		if ( wordTable[id].status == 0 )
			error.innerHTML = errors["words"];
		else{
			clearSelected();
			error.innerHTML = "";
			dynamicHelp.innerHTML = helpStrings["start"];
			if ( groupCnt > 0 )
				dynamicHelp.innerHTML += helpStrings["groupexists"];
		}
	}
	setActiveButtons();
}

function setGroup(idGroup){
	groupCnt++;
	var added = false;
	var newWordTable = {};
	var currentSentence = -1;
	var newId = 0;
	for ( var id in wordTable ){
		if ( currentSentence != wordTable[id].sentence ){
			currentSentence = wordTable[id].sentence;
		}
		if ( wordTable[id].type == "group" ){
			newWordTable[newId] = {
				status : 0,
				type : "group",
				data : wordTable[id].data,
				sentence : currentSentence,
				groupId : wordTable[id].groupId
			}
			newId++;
		}else{
			if ( wordTable[id].status == 0 ){
				newWordTable[newId] = {
					status : 0,
					type : "span",
					data : wordTable[id].data,
					sentence : currentSentence
				}
				newId++;
			}else{
				var newData = "";
				if ( added == true )
					continue;
				added = true;
				var tmp = id;
				while ( tmp in wordTable && wordTable[tmp].status == 1 ){
					if ( newData == "" )
						newData = wordTable[tmp].data;
					else
						newData += " " + wordTable[tmp].data;
					tmp++;
				}
				newWordTable[newId] = {
					status : 0,
					type : "group",
					data : newData,
					sentence : currentSentence,
					groupId : idGroup
				}
				newId++;
			}
		}
	}
	wordTable = newWordTable;
	selected.id = -1;
	selected.sentence = -1;
	selected.status = false;
	
	refreshGroups();
	setActiveButtons();
	document.getElementById("dynamicHelp").innerHTML = helpStrings["start"] + helpStrings["groupexists"];
	document.getElementById("error").innerHTML = "";
}

function selectGroup(id){
	if ( selected.id != -1 ){
		document.getElementById("error").innerHTML = errors["words"];
		return;
	}
	if ( groupFlag.status == true ){
		if ( groupFlag.id != id )
			document.getElementById("error").innerHTML = errors["group"];
		else{
			document.getElementById("group" + id).style.color = "black";
			document.getElementById("crossPlace" + id).removeChild(document.getElementById("cross" + id));
			groupFlag.status = false;
			groupFlag.id = -1;
			document.getElementById("dynamicHelp").innerHTML = helpStrings["start"];
			if ( groupCnt > 0 )
				document.getElementById("dynamicHelp").innerHTML += helpStrings["groupexists"];
			document.getElementById("error").innerHTML = "";
		}
	}else{
		groupFlag.status = true;
		groupFlag.id = id;
		document.getElementById("group" + id).style.color = "red";
		document.getElementById("crossPlace" + id).innerHTML += '<img id="cross' + groupFlag.id + '" class="cross" src="/cross-icon.png" onclick="deleteGroup(' + groupFlag.id + ')"/>'
		document.getElementById("dynamicHelp").innerHTML = helpStrings["groupwork"];
		document.getElementById("error").innerHTML = "";
	}
}

function deleteGroup(){
	groupCnt--;
	var newWordTable = {};
	var currentSentence = -1;
	var newId = 0;
	for ( var id in wordTable ){
		if ( wordTable[id].sentence != currentSentence ){
			currentSentence = wordTable[id].sentence;
		}
		if ( wordTable[id].type == "span" ){
			newWordTable[newId] = {
				status : 0,
				type : "span",
				data : wordTable[id].data,
				sentence : currentSentence
			}
			newId++;
		}else{
			if ( groupFlag.id == id ){
				var newSpans = wordTable[id].data.split(" ");
				for ( var spanNum in newSpans ){
					newWordTable[newId] = {
						status : 0,
						type : "span",
						data : newSpans[spanNum],
						sentence : currentSentence
					}
					newId++;
				}
			}else{
				newWordTable[newId] = {
					status : 0,
					type : "group",
					data : wordTable[id].data,
					sentence : currentSentence,
					groupId : wordTable[id].groupId
				}
				newId++;
			}
		}
	}
	wordTable = newWordTable;
	groupFlag.id = -1;
	groupFlag.status = false;
	
	refreshGroups();
	document.getElementById("errors").innerHTML = "";
	setActiveButtons();
}

function sendAnswer()
{
	var hid = document.getElementById('answer_content');
	hid.value = generateAnswer();
	return confirm('Вы точно уверены?');
}

function componentGInit(){
	loadTask();
	loadBNFEditor();
}

function showHelp(){
	var help = 'Краткое руководство.<br/>' + 
		'Выделять группу: нажатие на первое и последнее слово ( порядок не важен ), если группа из одного слова, то 2 нажатия на него, следом необходимо выбрать группу справа.<br/>' +
		'Очистка выделения справа.<br/>' + 
		'Выделять можно сплошной участок ( не разделённый какой-либо группой ) в одном предложении.<br/>' +
		'При выделении группы становится активной кнопка удаления группы ( временно, будет заменено крестиком в углу ), повторное нажатие снимает выделение.<br/>' +
		'При выделении какого-либо объекта ( слово - группа ) другой нельзя выделить.';
	document.getElementById("help").innerHTML += '<div id="helpdiv" class="help">' + help + '</div>';
}

function hideHelp(){
	document.getElementById("help").removeChild(document.getElementById("helpdiv"));
}

window.onload = componentGInit;
