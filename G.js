var wordTable = {};
var buttonTable = {};
var constGroups = 4;
var newGroup = 5;
var maxGroups = 19;
var groupCnt = 0;
var selected = {
	id : -1,
	sentence : -1,
	status : false
}
var groupFlag = {
	id : -1,
	status : false
}
var groups = {};

var Colors = ["white","black","red","blue","orange","gray","cyan","yellow","#007FFF","#E75480","#00A86B","#DA70D6","#AF4035","#CC8899","#704214","#D53E07","#FFCC99","#77DD77","#5D8AA8","#C7FCEC","#FF7518"];

var helpStrings = { "start" : "Чтобы начать выделение слов, нажмите на первое или последнее слово будущей группы.<br/>",
					"selection" : "Нажмите на другое слово в этом предложении, чтобы выделить все слова между ними. При повторном нажатии на первое слово будет выделено только оно.<br/>",
					"groupwork" : "Для удаления созданной группы вопользуйтесь крестиком.<br/>Чтобы снять выделение, нажмите на любое слово выделенной группы.<br/>",
					"groupcreation" : "Выберите категорию у выделенной группы справа.<br/> При необходимости добавьте новую Именную Группу кнопкой справа.<br/>Для снятия выделения нажмите на любое из выделенных слов.<br/>",
					"groupexists" : "Чтобы выделить созданную группу, нажмите на любое слово.<br/>"
};

var errors = { "sentence" : "Выделяйте строго в пределах одного предложения.",
				"group" : "Вы уже начали работу с группой.",
				"words" : "Вы уже начали работу со словами.",
				"solidselection" : "Выделяйте таким образом, чтобы между словами не было уже сформированной группы."
}

function setActiveButtons(){
	if ( selected.status == true )
		for ( var i in buttonTable )
			document.getElementById(i).disabled = false;
	else
		for ( var i in buttonTable )
			document.getElementById(i).disabled = true;
}

function loadTask(){
	var dynamicHelp = document.getElementById("dynamicHelp");
	var Gdiv = document.getElementById("task");
	var buttonDiv = document.getElementById("buttons");
	
	document.getElementById("error").style.color = "red";
	
	dynamicHelp.innerHTML = helpStrings["start"];
	
	var task = ["Зимой 2014 года в красивый курортный город Сочи впервые смогут приехать спортсмены из раличных стран мира на Олимпийские игры.",
			"Сколько спортсменов и тренеров из разных стран мира хотят приехать в город Сочи с 1 февраля 2014 года по 28 февраля 2014 года на Олимпийские игры?",
			"1-го мая 2010 года необходимо срочно отправить в командировку в город Сочи на олимпийские объекты членов олимпийского комитета РФ."];
			//currentTask.sentences
	
	var id = 0;
	for ( var i in task ){
		var sentence = task[i].split(" ");
		Gdiv.innerHTML +=  parseInt(i, 10) + 1 + ". ";
		for ( var y in sentence ){
			if ( y != 0 )
				Gdiv.innerHTML += " ";
			Gdiv.innerHTML += '<span id="span' + id + '" class="normal" onclick="changeStatus(' + id + ')">' + sentence[y];
			Gdiv.innerHTML += "</span>";
			wordTable[id] = {
				type : "span",
				status : 0,
				sentence : i,
				data : sentence[y]
			};
			id++;
		}
		Gdiv.innerHTML += "<br/>";
	}
	buttonDiv.innerHTML += "Основные группы</br>";
	buttonDiv.innerHTML += '<button class="button" id="but1" onclick="setGroup(1)">Предикат</button>';
	document.getElementById("but1").style.borderColor = Colors[1];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += '<button class="button" id="but2" onclick="setGroup(2)">Союз</button>';
	document.getElementById("but2").style.borderColor = Colors[2];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += '<button class="button" id="but3" onclick="setGroup(3)">Наречие</button>';
	document.getElementById("but3").style.borderColor = Colors[3];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += '<button class="button" id="but4" onclick="setGroup(4)">Вопросительное слово</button>';
	document.getElementById("but4").style.borderColor = Colors[4];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += "Именные группы</br>";
	buttonDiv.innerHTML += '<button class="button" id="creator" onclick="addNounGroup()">Добавить ИГ</button>';
	document.getElementById("creator").style.borderColor = Colors[0];
	//this is special button. // buttonTable["creator"] = {status : true};
	buttonTable["but1"] = {status : true};
	buttonTable["but2"] = {status : true};
	buttonTable["but3"] = {status : true};
	buttonTable["but4"] = {status : true};
	groups[1] = "Предикат";
	groups[2] = "Союз";
	groups[3] = "Наречие";
	groups[4] = "Вопросительное слово";
	setActiveButtons();
}

function addNounGroup(){
	document.getElementById("buttons").innerHTML += '<button class="button" id="but' + newGroup + '" onclick="setGroup(' + newGroup + ')">ИГ ' + (newGroup - constGroups) + '</button>';
	document.getElementById("but" + newGroup).style.borderColor = Colors[newGroup];
	buttonTable["but" + newGroup] = {status : true};
	groups[newGroup] = "Именная группа " + newGroup;
	newGroup++;
	if ( newGroup > maxGroups )
		document.getElementById("creator").disabled = true;
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

function clearSelected(){
	for ( var i in wordTable ){
		if ( wordTable[i].type == "span" ){
			document.getElementById("span"+i).className = "normal";
		}
		wordTable[i].status = 0;
	}
	selected.id = -1;
	selected.sentence = -1;
	selected.status = false;
	setActiveButtons();
}

function setGroup(idGroup){
	groupCnt++;
	var added = false;
	var newTask = "";
	var newWordTable = {};
	var currentSentence = -1;
	var newId = 0;
	for ( var id in wordTable ){
		if ( currentSentence != wordTable[id].sentence ){
			if ( currentSentence != -1 )
				newTask += "<br/>";
			currentSentence = wordTable[id].sentence;
			newTask += ( parseInt(currentSentence,10) + 1 ) + ". ";
		}
		if ( wordTable[id].type == "group" ){
			newWordTable[newId] = {
				status : 0,
				type : "group",
				data : wordTable[id].data,
				sentence : currentSentence,
				groupId : wordTable[id].groupId
			}
			newTask += '<span id="crossPlace' + newId +'"><span id="group' + newId +'" class="group" onclick="selectGroup(' + newId + ')">' + wordTable[id].data + '</span></span> ';
			newId++;
		}else{
			if ( wordTable[id].status == 0 ){
				newWordTable[newId] = {
					status : 0,
					type : "span",
					data : wordTable[id].data,
					sentence : currentSentence
				}
				newTask += '<span id="span' + newId + '" class="normal" onclick="changeStatus(' + newId + ')">' + wordTable[id].data + '</span> ';
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
				newTask += '<span id="crossPlace' + newId +'"><span id="group' + newId + '" class="group" onclick="selectGroup(' + newId + ')">' + newData + '</span></span> ';
				newId++;
			}
		}
	}
	document.getElementById("task").innerHTML = newTask;
	wordTable = newWordTable;
	for ( var id in wordTable )
		if ( wordTable[id].type == "group" )
			document.getElementById("group"+id).style.borderColor = Colors[wordTable[id].groupId];
	selected.id = -1;
	selected.sentence = -1;
	selected.status = false;
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
		document.getElementById("crossPlace" + id).innerHTML += '<img id="cross' + groupFlag.id + '" class="cross" src="cross-icon.png" onclick="deleteGroup(' + groupFlag.id + ')"/>'
		document.getElementById("dynamicHelp").innerHTML = helpStrings["groupwork"];
		document.getElementById("error").innerHTML = "";
	}
}

function deleteGroup(){
	groupCnt--;
	var newWordTable = {};
	var newTask = "";
	var currentSentence = -1;
	var newId = 0;
	for ( var id in wordTable ){
		if ( wordTable[id].sentence != currentSentence ){
			if ( currentSentence != -1 )
				newTask += "<br/>";
			currentSentence = wordTable[id].sentence;
			newTask += parseInt(currentSentence, 10) + 1;
			newTask += ". ";
		}
		if ( wordTable[id].type == "span" ){
			newWordTable[newId] = {
				status : 0,
				type : "span",
				data : wordTable[id].data,
				sentence : currentSentence
			}
			newTask += '<span id="span' + newId + '" class="normal" onclick="changeStatus(' + newId + ')">' + wordTable[id].data + '</span> ';
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
					newTask += '<span id="span' + newId + '" class="normal" onclick="changeStatus(' + newId + ')">' + newSpans[spanNum] + '</span> ';
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
				newTask += '<span id="crossPlace' + newId +'"><span id="group' + newId +'" class="group" onclick="selectGroup(' + newId + ')">' + wordTable[id].data + '</span></span> ';
				newId++;
			}
		}
	}
	wordTable = newWordTable;
	document.getElementById("task").innerHTML = newTask;
	groupFlag.id = -1;
	groupFlag.status = false;
	for ( var id in wordTable )
		if ( wordTable[id].type == "group" )
			document.getElementById("group"+id).style.borderColor = Colors[wordTable[id].groupId];
	document.getElementById("cleanerG").disabled = true;
	setActiveButtons();
}

function generateAnswer(){
	var answer = "";
	for ( var id in wordTable ){
		answer += '<span>' + wordTable[id].type;
		if ( wordTable[id].type == "group" )
			answer += " " + groups[wordTable[id].groupId];
		answer += ' : ' + wordTable[id].data + '</span><br/>';
	}
	return answer;
}

function showAnswer(){
	var ans = generateAnswer();
	document.getElementById("youranswer").innerHTML = ans;
}

function loadBNFEditor(){
	var BNFdata = [["G", "Предложение типа вопрос", "Предложение типа сообщение", "Предложение типа команда", "Существительное","Глагол","Местоимение","Предлог","Союз","Прилагательное",
	"Наречие","Числительное","Предикат","Наречие","Вопросительное слово"]];
	var numIG = 1;
	while ( numIG < ( maxGroups - constGroups ) ){
		BNFdata[0].push("ИГ " + numIG);
		numIG++;
	}
	for ( var i in BNFdata[0] ){
		BNFdata[0][i] = '&lt;' + BNFdata[0][i] + '&gt;';
	}
	initBNF(BNFdata, document.getElementById("secondTask"));
	document.getElementById("secondTask").style.background = "#FFFFFF";
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
