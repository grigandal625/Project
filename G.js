var wordTable = {};

function loadTask(){
	var task = ["Зимой 2014 года в красивый курортный город Сочи впервые смогут приехать спортсмены из раличных стран мира на Олимпийские игры.",
			"Сколько спортсменов и тренеров из разных стран мира хотят приехать в город Сочи с 1 февраля 2014 года по 28 февраля 2014 года на Олимпийские игры?",
			"1-го мая 2010 года необходимо срочно отправить в командировку в город Сочи на олимпийские объекты членов олимпийского комитета РФ."];
			//getTask().sentences
	
	var id = 0;
	for ( var i in task ){
		var sentence = task[i].split(" ");
		for ( var y in sentence ){
			if ( y != 0 )
				document.getElementById("task").innerHTML += " ";
			document.getElementById("task").innerHTML += "<span id=\"span" + id + "\" class=\"letter\" onclick=\"changeStatus(this)\">" + sentence[y];
			document.getElementById("task").innerHTML += "</span>";
			wordTable["span"+id] = {status:0};
			id++;
		}
		document.getElementById("task").innerHTML += "<br/>";
	}
}

function changeStatus(span){
	if ( wordTable[span.id].status == 0 ){
		wordTable[span.id].status = 1;
		span.style.background = "green";
	}else{
		wordTable[span.id].status = 0;
		span.style.background = "white";
	}
}

window.onload = loadTask;

