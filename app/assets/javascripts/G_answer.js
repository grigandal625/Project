var currentTask;

function getTask(){
  currentTask = {
	"sentences" : document.getElementById("sentences").value.split('\n')
  }
}

function GloadTask(GInitFlag){
	initG(GInitFlag);
	initButtons();
	fillgroups();
	refreshGroups();
	setActiveButtons();
	return false;
}

function changeStatus(id){
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
		}else{
			if ( selected.sentence != wordTable[id].sentence )
				return;
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
				if ( wordTable[tmp].type == "group" )
					return;
				tmp++;
			}
			while ( from <= to ){
				wordTable[from].status = 1;
				document.getElementById("span"+from).className = "end-select";
				from++;
			}
			selected.status = true;
		}
	}else{
		if ( wordTable[id].status != 0 ){
			clearSelected();
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
		}
	}else{
		groupFlag.status = true;
		groupFlag.id = id;
		document.getElementById("group" + id).style.color = "red";
		document.getElementById("crossPlace" + id).innerHTML += '<img id="cross' + groupFlag.id + '" class="cross" src="/cross-icon.png" onclick="deleteGroup(' + groupFlag.id + ')"/>'
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
	setActiveButtons();
}

function sendAnswer()
{
	var hid = document.getElementById('Ganswer_content');
	hid.value = generateAnswer();
	$("#Sanswer_content").val(JSON.stringify(getSAnswer()));
}

function componentGInit(GInitFlag){
	document.getElementById("Gglobal").innerHTML = '<div id="GGroups" width="70%"></div>';
	document.getElementById("Gglobal").innerHTML += '<div id="buttons" width="30%"></div></br>';
	document.getElementById("Gglobal").innerHTML += '<div id="GBNF"></div>';
	loadBNFEditor();
	GloadTask(GInitFlag);  
}

function pageInit(GInitFlag){
  componentGInit(GInitFlag);
  initS();
  if(GInitFlag) fillData();
}

window.onload = pageInit;
