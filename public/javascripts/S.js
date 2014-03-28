var CHChar = '<select name="sType"><option value="0"></option><option value="1">A</option><option value="2">B</option><option value="3">C</option><option value="4">D</option><option value="5">E</option><option value="6">F</option><option value="7">G</option><option value="8">H</option><option value="9">I</option><option value="10">K</option><option value="11">K</option><option value="12">M</option><option value="13">O</option><option value="14">P</option><option value="15">R</option><option value="16">S</option><option value="17">T</option><option value="18">U</option><option value="19">W</option></select>';
var GLVid = '<select name="vid" title="вид"><option value="0"></option><option value="1">сов</option><option value="2">несов</option></select>';
var GLTime = '<select name="time" title="время"><option value="0"></option><option value="1">пр</option><option value="2">наст</option><option value="3">буд</option></select>';
var CHLevel = '<div class="ChangeLevel" onclick="levelDownS(this)"> &lt; </div><div class="inline">1</div><div class="ChangeLevel" onclick="levelUpS(this)"> &gt; </div>';
var kolichestvoStrokS=[];
var sentenceS = {};
var startCordX, startClickX, currentCordsX;
var startCordY, startClickY, currentCordsY;
var selectedObjectS, selectetAttrS, selectedDragNum;
var x,y, xw,yh;
var td2sy = '';
var td2skaz  = '(<input type="text" rows="1" >)(MOD(' + GLTime + ')(' + GLVid + '))';
var td2Usual = '('+CHChar+ '(<input type="text" name="word" rows="1" ></input>)(ССК)<div class="inline">)</div>';
var td2 = td2skaz;
var td3 = '';
var td4 = 'удалить';
var skobki = [')', '))', ')))', '))))', ')))))'];
var check;

function getSAnswer(){
	var SObject = new Array(3);
	var j;
	for(var i = 0; i < 3; i++){
		var th = $("#resultTable"+(i+1)+"S").children().first().children().first().next();
		
		var thChd = $(th).children().first().next();
		if($(th).children().first().html() != "Вставьте слово"){
			SObject[i] = [];
			SObject[i][0] = {
				"num":$(th).attr("q"),
				"word":$(thChd).children().first().val(), 					
				"param":($(thChd).children().first().next().val() + $(thChd).children().first().next().next().val()),
				"level":"0"
			};	
			j = 1;
			th = $(th).next();
		}
		while( $(th).children().first().html() != "Вставьте слово"){
			thChd = $(th).children().first().next();
			SObject[i][j] = {
				"num":$(th).attr("q"),
				"word":$(thChd).children().first().next().val(), 				
				"param":$(thChd).children().first().val(),
				"level":$(thChd).next().children().first().next().html()
			};
			++j;
			th = $(th).next();	
		}
	}

	return SObject;
}

function recountSkobki(sentNum){
	var th = $("#resultTable" + sentNum + "S").children().first().children().first().next();
	var lastLevel = 1;
	var currentLevel;	
	if($(th).children().first().html() == "Вставьте слово") return;
	th = $(th).next();
	if($(th).children().first().html() == "Вставьте слово") return;
	var lastTh = $(th);
	th = $(th).next();
	while($(th).children().first().html() != "Вставьте слово"){
		currentLevel = parseInt($(th).children().last().prev().children().first().next().html());
		if(lastLevel - currentLevel >= 0)
			$(lastTh).children().first().next().children().last().html(skobki[lastLevel - currentLevel]);
		else $(lastTh).children().first().next().children().last().html('&nbsp;');
		lastTh = th;
		lastLevel = currentLevel;
		th = $(th).next();
	}
	$(lastTh).children().first().next().children().last().html(skobki[lastLevel - 1]);
	
}




function levelUpS(th){
	var curLevel = parseInt($(th).prev().html());
	var maxLevel = 5;
	var lastLevel = parseInt($(th).parent().parent().prev().children().last().prev().children().first().next().html());
	if (lastLevel < maxLevel) maxLevel = lastLevel + 1;
	if (curLevel < maxLevel){	
		$(th).prev().html(curLevel+1);
		$(th).parent().prev().removeClass("class" + curLevel+"S").addClass("class" + (curLevel+1) + "S");	
	}
	recountSkobki($(th).parent().parent().parent().parent().attr("sent")); 
}

function levelDownS(th){
	var curLevel = parseInt($(th).next().html());
	var minLevel = 1;
	var nextLevel = parseInt($(th).parent().parent().next().children().last().prev().children().first().next().html());
	if (nextLevel > minLevel) minLevel = nextLevel-1;
	if (curLevel > minLevel){		
		$(th).next().html(curLevel-1);
		$(th).parent().prev().removeClass("class" + curLevel+"S").addClass("class" + (curLevel-1) + "S");	
	} 
	recountSkobki($(th).parent().parent().parent().parent().attr("sent")); 
}

$(document).mousemove(function(e) {
          currentCordsX = e.pageX;
          currentCordsY = e.pageY;
});



function dragS(th){
	if(th.className == "GreenS") return 0;
	selectedObjectS = th;
	selectetAttrS = $(th).attr("q");
	selectedDragNum = $(th).attr("dragNum");
	startClickY = currentCordsY;
	startClickX = currentCordsX;
	startCordY= $(th).offset().top-150;
	startCordX = $(th).offset().left-150;
	$("#DraggingContainerS").css("top", startCordY);
	$("#DraggingContainerS").css("left", startCordX);
	$("#DraggingContainerS").html($(th).html());
}

function moveDragS(){
	$("#DraggingContainerS").css("top", startCordY+ currentCordsY - startClickY);
	$("#DraggingContainerS").css("left", startCordX+ currentCordsX - startClickX);
}
function putTd2(){
	if (kolichestvoStrokS[selectedDragNum]==0){
		return td2skaz;
	} else {
		return td2Usual;
	}
}

function putTd2class(){
	if (kolichestvoStrokS[selectedDragNum]==0){
		return "class0S";
	} else {
		return "class1S";
	}
}

function putTd3(){
	if (kolichestvoStrokS[selectedDragNum]==0){
		return "<div></div><div>0</div><div></div>";
	} else {
		return CHLevel;
	}
}

function returnRedClass(q, num){
	var chd = $("#sentenceDrag"+num+"S").children().first();
	while(q != chd.attr("q")) chd = chd.next();	
	chd.removeClass("GreenS").addClass("RedS");	
}

function deleteS(th){
	var dragNum = $(th).attr("dragNum");
	var sentNum = $(th).parent().parent().parent().attr("sent");
	if($(th).parent().children().first().html() =="Вставьте слово") return;
	if($(th).parent().children().first().html() =="Вставьте слово") return;
	var curLevel = parseInt($(th).prev().children().first().next().html());
	th = $(th).parent();
	
	if (confirm("Вы действительно хотите удалить эту ветвь?"))
  	{
		while(true){
			var nextS = $(th).next();
			returnRedClass($(th).attr("q"), dragNum);
			$(th).remove();
			kolichestvoStrokS[dragNum] -= 1;
			if($(nextS).children().first().html() =="Вставьте слово") break;
			if(parseInt($(nextS).children().last().prev().children().first().next().html()) <= curLevel) break; 
			else th = nextS;		
		}
		recountSkobki(sentNum);
  	} 
}

function checkDragUpS(){	
	$("#DraggingContainerS").css("top", -500);
	var dragStr = ".dragHere"+selectedDragNum+"S";
	x = $(dragStr).offset().left;	
	xw = x + $(dragStr).width();
	y = $(dragStr).offset().top;	
	yh = y + $(dragStr).height();
	if((currentCordsX>x) && (currentCordsX<xw) && (currentCordsY >y)&&
	(currentCordsY < yh)){ 
		$(".dragHere"+selectedDragNum+"S").html($("#DraggingContainerS").html());
		var addStrS = '<tr ><td class="dragHere'+selectedDragNum+'S">Вставьте слово</td><td class="td2S">&nbsp;</td><td class="td3S">&nbsp;</td><td class="td4S" onclick="deleteS(this)">&nbsp;</td></tr>';
		$("#resultTable"+selectedDragNum+"S").append(addStrS);
		$(dragStr).first().removeClass("dragHere"+selectedDragNum+"S").addClass("td1S").next().html(putTd2()).addClass(putTd2class()).next().html(putTd3()).next().html(td4).attr("dragNum", selectedDragNum).parent().attr("q", selectetAttrS);
		$(selectedObjectS).removeClass("RedS").addClass("GreenS");
		kolichestvoStrokS[selectedDragNum] += 1;
	}
}
