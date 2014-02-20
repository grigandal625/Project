var sentenceS = {};
var canDragS=0;
var startCordX, startClickX, currentCordsX;
var startCordY, startClickY, currentCordsY;
var x,y, xw,yh;
$(document).mousemove(function(e) {
          currentCordsX = e.pageX;
          currentCordsY = e.pageY;
     });
$(document).ready(function(){
	$("#DraggingContainerS").css("top", -200);
	
	getTask();
	var strS=" ";
		
	sentenceS.sent1 = currentTask.sentences[0].split(' ');
	sentenceS.sent2 = currentTask.sentences[1].split(' ');
	sentenceS.sent3 = currentTask.sentences[2].split(' ');
	for (var i = 0; i < sentenceS.sent1.length; i++) {
		strS += '<div class="RedS" onMouseDown="dragS(this)">' +" "+ sentenceS.sent1[i] +"</div>";	
	}
	$("#sentenceDrag1S").html(strS);
});

function dragS(th){
	startClickY = currentCordsY;
	startClickX = currentCordsX;
	startCordY= $(th).offset().top-50;
	startCordX = $(th).offset().left-50;
	$("#DraggingContainerS").css("top", startCordY);
	$("#DraggingContainerS").css("left", startCordX);
	$("#DraggingContainerS").html($(th).html());
}

function moveDragS(){
	$("#DraggingContainerS").css("top", startCordY+ currentCordsY - startClickY);
	$("#DraggingContainerS").css("left", startCordX+ currentCordsX - startClickX);
}
function checkDragUpS(){
	$("#DraggingContainerS").css("top", -200);
	x = $(".dragHereS").offset().left;	
	xw = x + $(".dragHereS").width();
	y = $(".dragHereS").offset().top;	
	yh = y + $(".dragHereS").height();
	if((currentCordsX>x) && (currentCordsX<xw) && (currentCordsY >y)&&
	(currentCordsY < yh)){ $(".dragHereS").html($("#DraggingContainerS").html());
	var addStrS = $("#resultTable1S tbody").html()+'<tr ><td class="dragHereS">Вставьте следующее слово</td><td class="firstTRS">&nbsp;</td><td class="firstTRS">&nbsp;</td><td class="firstTRS">&nbsp;</td></tr>';
	$("#resultTable1S").html(addStrS);
	$(".dragHereS").first().removeClass("dragHereS").addClass("firstTRS");}
	x=1;
	xw=0;
	y=1;
	yw=0;
}
