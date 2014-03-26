$(document).ready(function(){
	$("#DraggingContainerS").css("top", -500);
	
	for(var i = 1; i < 4; i++) kolichestvoStrokS[i] = 0;
	
  getTask();
	var strS="<br /><br />";	
  $.trim(currentTask.sentences[0]);	
  $.trim(currentTask.sentences[1]);
  $.trim(currentTask.sentences[2]);
	sentenceS.sent1 = currentTask.sentences[0].split(' ');
	sentenceS.sent2 = currentTask.sentences[1].split(' ');
	sentenceS.sent3 = currentTask.sentences[2].split(' ');
	for (var i = 1; i < sentenceS.sent1.length; i++) {
		strS += '<div class="RedS" onMouseDown="dragS(this)" q="'+(i-1)+'" dragNum="1">' +" "+ sentenceS.sent1[i] +"</div>";	
	}
	strS += "<br /><br />";
	$("#sentenceDrag1S").html(strS);
	
	strS="<br /><br />";
	for (var i = 1; i < sentenceS.sent2.length; i++) {
		strS += '<div class="RedS" onMouseDown="dragS(this)" q="'+(i-1)+'" dragNum="2">' +" "+ sentenceS.sent2[i] +"</div>";	
	}
	strS += "<br /><br />";
	$("#sentenceDrag2S").html(strS);
	
	strS="<br /><br />";
	for (var i = 1; i < sentenceS.sent3.length; i++) {
		strS += '<div class="RedS" onMouseDown="dragS(this)" q="'+(i-1)+'" dragNum="3">' +" "+ sentenceS.sent3[i] +"</div>";	
	}
	strS += "<br /><br />";
	$("#sentenceDrag3S").html(strS);
});

function sendAnswer(){
	$("#answer_content").val(JSON.stringify(getSAnswer()));
}


