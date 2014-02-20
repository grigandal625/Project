var wordTable = {};
var constGroups = 4;
var newGroup = 5;
var maxGroups = 20;

var Colors = ["white","black","red","blue","orange","gray","cyan","yellow","#007FFF","#E75480","#00A86B","#DA70D6","#AF4035","#CC8899","#704214","#D53E07","#FFCC99","#77DD77","#5D8AA8","#C7FCEC","#FF7518"];

function loadTask(){
	var Gdiv = document.getElementById("task");
	var buttonDiv = document.getElementById("buttons");
	var task = ["Зимой 2014 года в красивый курортный город Сочи впервые смогут приехать спортсмены из раличных стран мира на Олимпийские игры.",
			"Сколько спортсменов и тренеров из разных стран мира хотят приехать в город Сочи с 1 февраля 2014 года по 28 февраля 2014 года на Олимпийские игры?",
			"1-го мая 2010 года необходимо срочно отправить в командировку в город Сочи на олимпийские объекты членов олимпийского комитета РФ."];
			//currentTask.sentences
	
	var id = 0;
	for ( var i in task ){
		var sentence = task[i].split(" ");
		for ( var y in sentence ){
			if ( y != 0 )
				Gdiv.innerHTML += " ";
			Gdiv.innerHTML += '<span id="span' + id + '" class="normal" onclick="changeStatus(this)">' + sentence[y];
			Gdiv.innerHTML += "</span>";
			wordTable["span"+id] = {
				status : 0,
				group : 0
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
}

function addNounGroup(){
	document.getElementById("buttons").innerHTML += '<button class="button" id="but' + newGroup + '" onclick="setGroup(' + newGroup + ')">ИГ ' + (newGroup - constGroups) + '</button>';
	document.getElementById("but" + newGroup).style.borderColor = Colors[newGroup];
	newGroup++;
	if ( newGroup > maxGroups )
		document.getElementById("creator").disabled = true;
}

function changeStatus(span){
	if ( wordTable[span.id].status == 0 ){
		wordTable[span.id].status = 1;
		span.className = "selected"
	}else{
		//зависит от номера группы
		wordTable[span.id].status = 0;
		span.className = "normal";
	}
}

function setGroup(idGroup){
	for ( var word in wordTable ){
		if ( wordTable[word].status == 1 ){
			wordTable[word].status = 0;
			wordTable.group = idGroup;
			document.getElementById(word).className = "bunched";
			document.getElementById(word).style.borderBottomColor = Colors[idGroup];
		}
	}
}

window.onload = loadTask;

