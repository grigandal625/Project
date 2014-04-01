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

var Colors = ["white","black","red","blue","orange","gray","cyan","#DDDD00","#007FFF","#E75480","#00A86B","#DA70D6","#AF4035","#CC8899","#704214","#D53E07","#FFCC99","#77DD77","#5D8AA8","#C7FCEC","#FF7518"];
var Labels = ["-", "label_P", "label_C", "label_N", "label_VS", "label_IG_one", "label_IG_one", "label_IG_one", "label_IG_one", "label_IG_one", "label_IG_one", "label_IG_one", "label_IG_one", "label_IG_one", "label_IG_two", "label_IG_two", "label_IG_two", "label_IG_two", "label_IG_two", "label_IG_two"];

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

function addLabel(id){
	var data = '<span class="label ';
	data += Labels[id];
	data += '" style="color : ' + Colors[id] + '"><sup>' + groups[id] + '</sup></span>';
	return data;
}

function addNounGroup(){
	document.getElementById("buttons").innerHTML += '<button class="button" id="but' + newGroup + '" onclick="setGroup(' + newGroup + ')" type="button">ИГ ' + (newGroup - constGroups) + '</button>';
	document.getElementById("but" + newGroup).style.borderColor = Colors[newGroup];
	buttonTable["but" + newGroup] = {status : true};
	newGroup++;
	if ( newGroup > maxGroups )
		document.getElementById("creator").disabled = true;
	setActiveButtons();
}

function fillgroups(){
	groups[1] = "П";
	groups[2] = "С";
	groups[3] = "Н";
	groups[4] = "ВС";
	var _newGroup = newGroup;
	while ( _newGroup < maxGroups ){
		groups[_newGroup] = "ИГ " + (_newGroup - constGroups);
		_newGroup++;
	}
}

function refreshGroups(){
	var newTask = "";
	var currentSentence = -1;
	for ( var id in wordTable ){
		if ( currentSentence != wordTable[id].sentence ){
			if ( currentSentence != -1 )
				newTask += "<br/>";
			currentSentence = wordTable[id].sentence;
			newTask += ( parseInt(currentSentence,10) + 1 ) + ". ";
		}
		if ( wordTable[id].type == "group" )
			newTask += '<span id="crossPlace' + id +'"><span id="group' + id +'" class="group" onclick="selectGroup(' + id + ')">' + wordTable[id].data + addLabel(wordTable[id].groupId) + ' </span></span>';
		else
			newTask += '<span id="span' + id + '" class="normal" onclick="changeStatus(' + id + ')">' + wordTable[id].data + ' </span>';
	}
	document.getElementById("GGroups").innerHTML = newTask;
	
	for ( var id in wordTable )
		if ( wordTable[id].type == "group" )
			document.getElementById("group"+id).style.borderColor = Colors[wordTable[id].groupId];
    
	setActiveButtons();
}

function initButtons(){
	var buttonDiv = document.getElementById("buttons");
	buttonDiv.innerHTML += "Основные группы</br>";
	buttonDiv.innerHTML += '<button class="button" id="but1" onclick="setGroup(1)" type="button">Предикат</button>';
	document.getElementById("but1").style.borderColor = Colors[1];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += '<button class="button" id="but2" onclick="setGroup(2)" type="button">Союз</button>';
	document.getElementById("but2").style.borderColor = Colors[2];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += '<button class="button" id="but3" onclick="setGroup(3)" type="button">Наречие</button>';
	document.getElementById("but3").style.borderColor = Colors[3];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += '<button class="button" id="but4" onclick="setGroup(4)" type="button">Вопросительное слово</button>';
	document.getElementById("but4").style.borderColor = Colors[4];
	buttonDiv.innerHTML += '<br/>';
	buttonDiv.innerHTML += "Именные группы</br>";
	buttonDiv.innerHTML += '<button class="button" id="creator" onclick="addNounGroup()" type="button">Добавить ИГ</button>';
	document.getElementById("creator").style.borderColor = Colors[0];
	buttonTable["but1"] = {status : true};
	buttonTable["but2"] = {status : true};
	buttonTable["but3"] = {status : true};
	buttonTable["but4"] = {status : true};
}

function initG(GInitFlag){
	wordTable = {};
	buttonTable = {};
	constGroups = 4;
	newGroup = 5;
	maxGroups = 19;
	groupCnt = 0;
	selected = {
		id : -1,
		sentence : -1,
		status : false
	}
	groupFlag = {
		id : -1,
		status : false
	}
	groups = {};
	document.getElementById("GGroups").innerHTML = "";
	document.getElementById("buttons").innerHTML = "";
	if (!GInitFlag){
		var Gdiv = document.getElementById("GGroups");
		getTask();
        var task = currentTask["sentences"];
		var id = 0;
		for ( var i in task ){
			var sentence = task[i].split(" ");
			Gdiv.innerHTML +=  parseInt(i, 10) + 1 + ". ";
			for ( var y in sentence ){
				if ( sentence[y] == "" ){
					continue;
				}
				Gdiv.innerHTML += '<span id="span' + id + '" class="normal" onclick="changeStatus(' + id + ')">' + ' ' + sentence[y];
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
	}else{
		getGAnswer();
		wordTable = eval('(' + JSON.stringify(currentGAnswer["groups"]) + ')');
		var bnf = {
			"lines" : eval('(' + JSON.stringify(currentGAnswer["bnf"]) + ')')
		}
		bnfContent = bnf;
		refreshBnf();
	}
}

function clearSelected(){
	for ( var i in wordTable ){
		if ( wordTable[i].type == "span" ){
			document.getElementById("span" + i).className = "normal";
		}
		wordTable[i].status = 0;
	}
	selected.id = -1;
	selected.sentence = -1;
	selected.status = false;
	setActiveButtons();
}

function generateAnswer(){
	var bnf = eval('(' + JSON.stringify(bnfContent["lines"]) + ')');
	var tmpTable = eval('(' + JSON.stringify(wordTable) + ')');
	for ( var id in tmpTable )
		if ( tmpTable[id].type == "group" )
			tmpTable[id].groupName = groups[tmpTable[id].groupId];
	var ans = '{"bnf":' + JSON.stringify(bnf) + ', "groups":' + JSON.stringify(tmpTable) + '}';
	return ans;
}

function loadBNFEditor(){
	var BNFdata = [["G", "Предложение типа вопрос", "Предложение типа сообщение", "Предложение типа команда", "Существительное","Глагол","Местоимение","Предлог","Союз","Прилагательное", "Причастие", "Деепричастие", "Аббр.",
	"Наречие","Числительное","Предикат","Наречие","Вопросительное слово"]];
	var numIG = 1;
	while ( numIG < ( maxGroups - constGroups ) ){
		BNFdata[0].push("ИГ " + numIG);
		numIG++;
	}
	for ( var i in BNFdata[0] ){
		BNFdata[0][i] = '&lt;' + BNFdata[0][i] + '&gt;';
	}
	initBNF(BNFdata, document.getElementById("GBNF"));
	document.getElementById("GBNF").style.background = "#FFFFFF";
}
