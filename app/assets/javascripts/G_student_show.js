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

function addLabel(id){
	var data = '<span class="label ';
	data += Labels[id];
	data += '" style="color : ' + Colors[id] + '"><sup>' + groups[id] + '</sup></span>';
	return data;
}

function fillgroups(){
	groups[1] = "П";
	groups[2] = "С";
	groups[3] = "Н";
	groups[4] = "ВС";
	var _newGroup = newGroup;
	while ( _newGroup <= maxGroups ){
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
			newTask += '<span id="crossPlace' + id +'"><span id="group' + id +'" class="group">' + wordTable[id].data + addLabel(wordTable[id].groupId) + ' </span></span>';
		else
			newTask += '<span id="span' + id + '" class="normal">' + wordTable[id].data + ' </span>';
	}
	document.getElementById("GGroups").innerHTML = newTask;
	
	for ( var id in wordTable )
		if ( wordTable[id].type == "group" )
			document.getElementById("group"+id).style.borderColor = Colors[wordTable[id].groupId];
}

function initG(){
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
	getGAnswer();
	if (currentGAnswer == '()'){
		initG(false);
		return;
	}
	currentGAnswer = eval(currentGAnswer);
	wordTable = eval('(' + JSON.stringify(currentGAnswer["groups"]) + ')');
	var bnf = eval('(' + JSON.stringify(currentGAnswer["bnf"]) + ')')
	document.getElementById("GBNF").style.width = "100%";
	showBNFAsText(bnf);
}

function showBNFAsText(bnf){
	GBNF = document.getElementById("GBNF")
	GBNF.style.background = "#FFFFFF";
	for ( line_id in bnf ){
		if ( bnf[line_id]["left"] != null ){
			GBNF.innerHTML += bnf[line_id]["left"];
			GBNF.innerHTML += ' = '
			right_part = bnf[line_id]["rules"];
			is_printed_any_line = false;
			for ( rule_id in right_part ){
				rule = ""
				for ( id in right_part[rule_id] ){
					if ( right_part[rule_id][id] != null )
						rule += right_part[rule_id][id];
				}
				if ( rule != "" ){
					if ( is_printed_any_line )
						GBNF.innerHTML += ' | ';
					is_printed_any_line = true;
					GBNF.innerHTML += rule;
				}
			}
			GBNF.innerHTML += "</br>";
		}
	}
}

var currentTask;

function getTask(){
  currentTask = {
	"sentences" : document.getElementById("sentences").value.split('\n')
  }
}

function GloadTask(){
	initG();
	fillgroups();
	refreshGroups();
	return false;
}

function componentGInit(){
	document.getElementById("Gglobal").innerHTML = '<div id="GGroups" width="100%" style="float: None; border-bottom-color: #00F; border-bottom-style : solid; border-bottom-width: 2px;"></div></br>';
	document.getElementById("Gglobal").innerHTML += '<div id="GBNF"></div>';
	GloadTask();
}

function pageInit(){
  componentGInit();
}

window.onload = pageInit;
