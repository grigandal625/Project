var CHChar = '<form><select name="vid" title="вид"><option value="0"></option><option value="1">A</option><option value="2">B</option><option value="3">C</option><option value="4">D</option><option value="5">E</option><option value="6">F</option><option value="7">G</option><option value="8">H</option><option value="9">I</option><option value="10">K</option><option value="11">K</option><option value="12">M</option><option value="13">O</option><option value="14">P</option><option value="15">R</option><option value="16">S</option><option value="17">T</option><option value="18">U</option><option value="19">W</option></select></form>';
var GLVid = '<form><select name="vid" title="вид"><option value="0"></option><option value="1">сов</option><option value="2">несов</option></select></form>';
var GLTime = '<form><select name="time" title="вид"><option value="0"></option><option value="1">пр</option><option value="2">наст</option><option value="3">буд</option></select></form>';
var CHLevel = '<div class="ChangeLevel" onclick="levelDownS(this)"> &lt; </div><div class="inline">1</div><div class="ChangeLevel" onclick="levelUpS(this)"> &gt; </div>';
var kolichestvoStrokS = 0;
var sentenceS = {};
var startCordX, startClickX, currentCordsX;
var startCordY, startClickY, currentCordsY;
var selectedObjectS, selectetAttrS;
var x,y, xw,yh;
var td2sy = '';
var td2skaz  = '(<textarea rows="1" ></textarea>)(<div style="display: inline; ">MOD(' + GLTime + ')(' + GLVid + ')</div>)';
var td2Usual = '('+CHChar+ '(<textarea rows="1" ></textarea>)(ССК))';
var td2 = td2skaz;
var td3 = '';
var td4 = 'удалить';



function levelUpS(th){
	var curLevel = parseInt($(th).prev().html());
	var maxLevel = 5;
	var lastLevel = parseInt($(th).parent().parent().prev().children().last().prev().children().first().next().html());
	if (lastLevel < maxLevel) maxLevel = lastLevel + 1;
	if (curLevel < maxLevel){	
		$(th).prev().html(curLevel+1);
		$(th).parent().prev().removeClass("class" + curLevel+"S").addClass("class" + (curLevel+1) + "S");	
	} 
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
}

$(document).mousemove(function(e) {
          currentCordsX = e.pageX;
          currentCordsY = e.pageY;
});

$(document).ready(function(){
	$("#DraggingContainerS").css("top", -2000);
	
	getTask();
	var strS=" ";
		
	sentenceS.sent1 = currentTask.sentences[0].split(' ');
	sentenceS.sent2 = currentTask.sentences[1].split(' ');
	sentenceS.sent3 = currentTask.sentences[2].split(' ');
	for (var i = 0; i < sentenceS.sent1.length; i++) {
		strS += '<div class="RedS" onMouseDown="dragS(this)" q="'+i+'">' +" "+ sentenceS.sent1[i] +"</div>";	
	}
	$("#sentenceDrag1S").html(strS);
});

function dragS(th){
	if(th.className == "GreenS") return 0;
	selectedObjectS = th;
	selectetAttrS = $(th).attr("q");
	startClickY = currentCordsY;
	startClickX = currentCordsX;
	startCordY= $(th).offset().top-500;
	startCordX = $(th).offset().left-500;
	$("#DraggingContainerS").css("top", startCordY);
	$("#DraggingContainerS").css("left", startCordX);
	$("#DraggingContainerS").html($(th).html());
}

function moveDragS(){
	$("#DraggingContainerS").css("top", startCordY+ currentCordsY - startClickY);
	$("#DraggingContainerS").css("left", startCordX+ currentCordsX - startClickX);
}
function putTd2(){
	if (kolichestvoStrokS==0){
		return td2skaz;
	} else {
		return td2Usual;
	}
}

function putTd2class(){
	if (kolichestvoStrokS==0){
		return "class0S";
	} else {
		return "class1S";
	}
}

function putTd3(){
	if (kolichestvoStrokS==0){
		return "<div></div><div>0</div><div></div>";
	} else {
		return CHLevel;
	}
}

function returnRedClass(q){
	var chd = $("#sentenceDrag1S").children().first();
	while(q != chd.attr("q")) chd = chd.next();	
	chd.removeClass("GreenS").addClass("RedS");	
}

function deleteS(th){
	if($(th).parent().children().first().html() =="Вставьте следующее слово") return;
	if($(th).parent().children().first().html() =="Перетащите первое слово") return;
	var curLevel = parseInt($(th).prev().children().first().next().html());
	th = $(th).parent();
	
	if (confirm("Вы действительно хотите удалить эту ветвь?"))
  	{
		while(true){
			var nextS = $(th).next();
			returnRedClass($(th).attr("q"));
			$(th).remove();
			kolichestvoStrokS -= 1;
			if($(nextS).children().first().html() =="Вставьте следующее слово") return;
			if(parseInt($(nextS).children().last().prev().children().first().next().html()) <= curLevel) return; 
			else th = nextS;		
		}
  	}
}

function checkDragUpS(){	
	$("#DraggingContainerS").css("top", -2000);
	x = $(".dragHereS").offset().left;	
	xw = x + $(".dragHereS").width();
	y = $(".dragHereS").offset().top;	
	yh = y + $(".dragHereS").height();
	if((currentCordsX>x) && (currentCordsX<xw) && (currentCordsY >y)&&
	(currentCordsY < yh)){ 
		$(".dragHereS").html($("#DraggingContainerS").html());
		var addStrS = '<tr ><td class="dragHereS">Вставьте следующее слово</td><td class="td2S">&nbsp;</td><td class="td3S">&nbsp;</td><td class="td4S" onclick="deleteS(this)">&nbsp;</td></tr>';
		$("#resultTable1S").append(addStrS);
		$(".dragHereS").first().removeClass("dragHereS").addClass("td1S").next().html(putTd2()).addClass(putTd2class()).next().html(putTd3()).next().html(td4).parent().attr("q", selectetAttrS);
		$(selectedObjectS).removeClass("RedS").addClass("GreenS");
		kolichestvoStrokS += 1;
	}
}


