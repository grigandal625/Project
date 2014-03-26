sentenceS = [];
function deleteAdminS(th){
	var dragNum = $(th).attr("dragNum");
	var sentNum = $(th).parent().parent().parent().attr("sent");
	if($(th).parent().children().first().html() =="Вставьте слово") return;
	if($(th).parent().children().first().html() =="Вставьте слово") return;
	var curLevel = parseInt($(th).prev().children().first().next().html());
	th = $(th).parent();
	
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
function initS(){
	$("#DraggingContainerS").css("top", -500);
	var strS = "";
  for(var j = 0; j < 3; j++){
    if (kolichestvoStrokS[j+1] != null){
      deleteAdminS($("#resultTable"+(j+1)+"S").children().first().children().first().next().children().last());
    } 
    
    strS = "<br /><br />";		
	  sentenceS[j] = currentTask.sentences[j].split(' ');
	  for (var i = 0; i < sentenceS[j].length; i++) {
		  strS += '<div class="RedS" onMouseDown="dragS(this)" q="'+i+'" dragNum="'+(j+1)+'">' +" "+ sentenceS[j][i] +"</div>";	
	  }
	  strS += "<br /><br />";
	  $("#sentenceDrag" + (j+1) + "S").html(strS);
	}
}
function selectWordGreen(i, j){
  var th = $("#sentenceDrag"+(i+1)+"S").children().first().next().next();
  for (var k = 0; k < j; k++){
    th = $(th).next();
  }
  $(th).removeClass("RedS").addClass("GreenS");
}

function fillData(){
  var addStr;
  var currentTr;
  for(var i = 0; i < 3; i++){
    addStr = '<tr q="no"><td class="firstTRS" width="220px">слово</td><td class="firstTRS">разбор</td><td class="firstTRS" width="80px">уровень</td><td class="firstTRS" width="80px">&nbsp;</td></tr>';
    $("#resultTable"+(i+1)+"S").children().first().html(addStr);
    if (SAnswerData[i].length >  0){
      addStr = '<tr q="'+SAnswerData[i][0].num+'"><td class="td1S">'+sentenceS[i][SAnswerData[i][0].num]+'</td><td class="td2S class0S">(<input type="text" rows="1" value="'+SAnswerData[i][0].word+'">)(MOD(<select name="time" title="время"><option value="0"></option><option value="1">пр</option><option value="2">наст</option><option value="3">буд</option></select>)(<select name="vid" title="вид"><option value="0"></option><option value="1">сов</option><option value="2">несов</option></select>))</td><td class="td3S"><div></div><div>0</div><div></div></td><td class="td4S" onclick="deleteS(this)" dragnum="'+(i+1)+'">удалить</td></tr>'
      $("#resultTable"+(i+1)+"S").children().first().append(addStr);
      selectWordGreen(i, SAnswerData[i][0].num); 
      currentTr = $("#resultTable"+(i+1)+"S").children().first().children().first().next();
      $(currentTr).children().first().next().children().first().next().val((SAnswerData[i][0].param/10>>0)).next().val(SAnswerData[i][0].param -(SAnswerData[i][0].param/10>>0)*10);
      kolichestvoStrokS[i+1] = 1;
    }
    var j = 1;
    while (j < SAnswerData[i].length){
      addStr = '<tr q="'+SAnswerData[i][j].num+'"><td class="td1S">'+sentenceS[i][SAnswerData[i][j].num]+'</td><td class="td2S class'+SAnswerData[i][j].level+'S">(<select name="sType"><option value="0"></option><option value="1">A</option><option value="2">B</option><option value="3">C</option><option value="4">D</option><option value="5">E</option><option value="6">F</option><option value="7">G</option><option value="8">H</option><option value="9">I</option><option value="10">K</option><option value="11">K</option><option value="12">M</option><option value="13">O</option><option value="14">P</option><option value="15">R</option><option value="16">S</option><option value="17">T</option><option value="18">U</option><option value="19">W</option></select>(<input type="text" name="word" rows="1" value="'+SAnswerData[i][j].word+'">)(ССК)<div class="inline">)</div></td><td class="td3S"><div class="ChangeLevel" onclick="levelDownS(this)"> &lt; </div><div class="inline">'+SAnswerData[i][j].level+'</div><div class="ChangeLevel" onclick="levelUpS(this)"> &gt; </div></td><td class="td4S" onclick="deleteS(this)" dragnum="'+(i+1)+'">удалить</td></tr>';
      $("#resultTable"+(i+1)+"S").children().first().append(addStr);
      selectWordGreen(i, SAnswerData[i][j].num); 
      currentTr = $(currentTr).next();
      $(currentTr).children().first().next().children().first().val(SAnswerData[i][j].param);
      j = j + 1;
      kolichestvoStrokS[i+1] += 1;
    }
    addStr = '<tr><td class="dragHere'+(i+1)+'S">Вставьте слово</td><td class="td2S">&nbsp;</td><td class="td3S">&nbsp;</td><td class="td4S" onclick="deleteS(this)">&nbsp;</td></tr>';
    $("#resultTable"+(i+1)+"S").children().first().append(addStr);
  }
}
