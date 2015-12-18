/**
 * @author Victor 
 * @version 1.1.1
 * @data 14.07.13
 * @data last Change 19.07.13
 */

function Node(name)
{
	this.name = name;
	this.children = new Array();
	this.tag = 0;
} 
	
function nodeToString(node)
{
	var r = new String();
	r += "IF ";
	
	for(var i = 0; i < node.children.length; ++i)
	{
		if(i > 0)
			r += " AND ";
			
		r += node.children[i].name;
	}
	
	r += " THEN " + node.name;
	
	return r;
} 

var count_generate = 1; //Для оповещаний счетчик
function generate() {
	createRule(4);
	$.jGrowl('База знаний <b>№'+count_generate+'</b> сгенерирована', { life:3000, header: 'Оповещание эксперта'});
	count_generate++;
}
function getRandom(h,l){
	var rnd = Math.round(Math.random()*(h - l)) + l;
	return rnd;
}
// PARAMETRS
	var str1 = ["A","B","C"];
	var str2 = ["D","E","F","G","H"];
	var str3 = ["I","J","K","L","M","N","O"];
	var str4 = ["P","Q","R","S","T","U"];
	var j = 0;
	
function createRule(numstr){ //numstr - Глубина дерева + 1 нижний уровень
	for (k=1;k<numstr;k++){
		if (k==1) {
			for (i=0;i<window["str" + k].length;i++){
					 window["root" + i] = new Node(window["str" + k][i]);
					var count = getRandom(3,2);
				if (count==2) {
					var c1 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					var c2 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					window["root" + i].children.push(c1);window["root" + i].children.push(c2);
					
				} else {
					var c1 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					var c2 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					var c3 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					window["root" + i].children.push(c1);window["root" + i].children.push(c2);window["root" + i].children.push(c3);
				}
				j++;
	}
	} else { 
			for (i=0;i<window["str" + k].length;i++){
					 window["root" + j] = new Node(window["str" + k][i]);
					var count = getRandom(3,2);
				if (count==2) {
					var c1 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					var c2 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					window["root" + j].children.push(c1);window["root" + j].children.push(c2);
					
				} else {
					var c1 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					var c2 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					var c3 = new Node(window["str" + (k+1)][getRandom((window["str" + (k+1)].length-1),0)]);
					window["root" + j].children.push(c1);window["root" + j].children.push(c2);window["root" + j].children.push(c3);
				}
				j++;
	}
	}
	}
	//Вывод правил
		var br = "<br />";
		var outPutNode = "";
		for (i=0;i<j;i++) {
			outPutNode = outPutNode+nodeToString(window["root" + i])+br;
		}
		var alfabet = str1+" "+str2+" "+str3;
	$('#data_bz').html("Корни: "+alfabet+br+"Нижний уровень(не корни): "+str4+br+"Сгенерированные правила: "+br+outPutNode);
	j=0; //Стираем счетчик нодов
}


