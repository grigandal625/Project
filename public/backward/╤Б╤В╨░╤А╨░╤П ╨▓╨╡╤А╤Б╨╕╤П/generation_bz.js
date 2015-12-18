/**
 * @author Victor
 * @version 1.8.1
 * @data 14.07.13
 * @data last Change 11.12.13
 */
var br = "<br />";
var sortRuleMem = [];
var createRuleMem = [];
function Node(name) {
	this.name = name;
	this.children = new Array();
	this.tag = 0;
}

function nodeToString(node) {
	var r = new String();
	r += "if ";

	for (var i = 0; i < node.children.length; ++i) {
		if (i > 0)
			r += " and ";

		r += node.children[i].name;
	}

	r += " then " + node.name;

	return r;
}
function nodeFromRoot(root,num) {
  for (m=0;m<num-1;m++) {
	  if (root==nodeToDraw(window["root" + m],2)) {
		 return m;
	  }
  }
}

function nodeToDraw(node, op) {
	if (op == 1) {
		var r = [];
		for (var i = 0; i < node.children.length; ++i) {
			r.push(node.children[i].name);
		}
		return r;
	} else {
		return node.name;
	}
}

function cleanNode(node) {
	node.children = '';
	node.name = '';
}

//Для оповещаний счетчик
function generate() {

	var level_style = document.getElementById('level_style').value;
	createRule(level_style);
	count_generate++;
	$.jGrowl('База знаний <b>№' + count_generate + '</b> сгенерирована', {
		life : 3000,
		header : 'Оповещание эксперта'
	});
}

function getRandom(l, h) {
	var rnd = Math.round(Math.random() * (h - l)) + l;
	return rnd;
}

// PARAMETRS
var str1 = ["A", "B", "C"];
var str2 = ["D", "E", "F", "G", "H"];
var str3 = ["I", "J", "K", "L", "M", "N", "O"];
var str4 = ["P", "Q", "R", "S", "T", "U"];
var str5 = ["Y", "W", "X", "Z", "AA", "AB", "AC"];
var str6 = ["AD", "AF", "AE", "AG", "AH", "AI"];
var j = 0;
var outPutNode = "";
var alfabet = "";
var global_level = 0;
var count_all_el = 0;
var count_not_el = 0;
var max_elem = str1.length;
var global_memory = []; // Массив состояния памяти
var steps = 0; // Кол-во шагов правил
var check_scroll_left = 0; // check для плаванья блока
var check_scrool_top = 0;
var firstMemory = []; // Хранит в себе начально состояние памяти
var JSONstep = ""; // Хранит в себе всю трассу вывода в формате json
var out_trace_mem = ''; //Хранит изменения памяти на текущем шаге!!!
var jsonThisStep = ""; // хранит JSON текущего шага!!!
var goals =[]; // Стек текущих целей
var sub_goal = []; // Стек текущих ПОДЦЕЛЕЙ
var last_sub_goal = ""; // Последняя подцель

function createRule(numstr) {//numstr - Глубина дерева + 1 нижний уровень
	global_level = numstr;
	count_not_el = 0;
	count_all_el = 0;
	// Для постоянной генерации обнуляем счетчики элементов и узлов
	for ( k = 1; k < numstr; k++) {
		for ( i = 0; i < window["str" + k].length; i++) {
			if (k == 1) {
				window["root" + i] = new Node(window["str" + k][i]);
			} else {
				window["root" + j] = new Node(window["str" + k][i]);
			}

			var count = getRandom(2, 3);
			var mem = [];
			for ( n = 1; n <= count; n++) {
				mem[n] = window["str" + (k+1)][getRandom((window["str" + (k + 1)].length - 1), 0)];
				if (n == 1) {
					window["c" + n] = new Node(mem[n]);
					if (k == 1) {
						window["root" + i].children.push(window["c" + n]);
					} else {
						window["root" + j].children.push(window["c" + n]);
					}
				} else {
					while (mem[n - 1] == mem[n] || mem[n - 2] == mem[n] || mem[n - 3] == mem[n] || mem[n - 4] == mem[n]) {
						mem[n] = window["str" + (k+1)][getRandom((window["str" + (k + 1)].length - 1), 0)];
					}
					window["c" + n] = new Node(mem[n]);
					if (k == 1) {
						window["root" + i].children.push(window["c" + n]);
					} else {
						window["root" + j].children.push(window["c" + n]);
					}
				}

			}
			mem = [];
			j++;

		}

	}
	outPutNode = "";
	alfabet = "";
	// ---------------------------- Вывод правил на экран ---------------------------------------
	for ( i = 0; i < j; i++) {
		outPutNode = outPutNode + nodeToString(window["root" + i]) + ';\n';
	}

	$('#baza_text').text(outPutNode);
	for ( mn = 1; mn <= numstr; mn++) {
		count_all_el = count_all_el + window["str" + mn].length;
	}
	for ( mnn = 1; mnn <= numstr; mnn++) {
		if (window["str" + mnn].length > max_elem) {
			max_elem = window["str" + mnn].length;
		}
	}
	count_not_el = count_all_el - window["str" + numstr].length + 1;
	j = 0;
	//Стираем счетчик нодов
}

function edit_save() {
	var rules = $("#baza_text").val().split(';\n');
	for ( k = 0; k < rules.length - 1; k++) {
		var rules_then = rules[k].split(' then ');
		window["root" + k] = new Node(rules_then[1]);
		sortRuleMem[k] = rules_then[1];
		var rules_child_if = rules_then[0].split('if ');
		var rules_child = rules_child_if[1].split(' and ');

		for ( i = 0; i < rules_child.length; i++) {
			sortRuleMem[k] = sortRuleMem[k] + '-' + rules_child[i];
			window["c" + i] = new Node(rules_child[i]);
			window["root" + k].children.push(window["c" + i]);
		}
	}
	$('#first_step').slideUp('300');
	drawTree(global_level, count_not_el, count_all_el, max_elem);
	openFirstWindow();
	$.jGrowl('База знаний отредактированна', {
		life : 3000,
		header : 'Оповещание эксперта'
	});
	//alert(sortRuleMem);
}

function openFirstWindow() {
	var heightBody = $("body").height();
	var widthBody = $("body").width();
	var cleanLeftForModal = (widthBody / 2) - ($('#select_div_msg').width() / 2);
	var cleanTopForModal = $(window).height() / 2 - $('#select_div_msg').height() +200;
	$('#select_div').css({
		"height" : heightBody + 'px'
	});
	$('#select_div_msg').css({
		"left" : cleanLeftForModal + 'px',
		"top" : cleanTopForModal + 'px'
	});
	createFactOut(global_level);
	showModalBear();
}

function showModalBear() {
	$('#select_div').fadeIn();
	$('#select_div_msg').slideDown();
}

function closeModalBear() {
	$('#select_div').fadeOut();
	$('#select_div_msg').slideUp();
}


$(document).ready(function() {
	$("#show_set").click(function() {
		if ($("#show_set").val() == "Показать дополнительную информацию") {
			$("#show_set").val('Скрыть дополнительную информацию');
		} else {
			$("#show_set").val('Показать дополнительную информацию');
		}
		$(".panel").toggle("fast");
		$(this).toggleClass("active");
		return false;
	});
	
	$("#select_div_msg").draggable(); // для перетаскивания TODO: DRAG MSG DIV;
});
function sortRule(len) {
	for ( ner = 0; ner < len; ner++) {

	}
}

function endSteps() {
	

}

function lightThisFact(s,goals) {

	
	if (s == "") {
		$.jGrowl('Начальное состояние не может быть пустым.<br /><br />Выбирайте правильно начальное состояние памяти. Этот шаг вернуть <b>невозможно</b>', {
			life : 5000,
			header : 'Оповещание эксперта'
		});
	} else {
		
		for ( i = 0; i < s.length; i++) {
			targets[searchFact(s[i])].attr({
				fill : "#50b74d",
				stroke : "#50b74d",
				"stroke-dasharray" : ".",
				opacity : 0.9
			});
		}
		for ( kn = 0; kn < goals.length; kn++) {

			targets[searchFact(goals[kn])].attr({
				fill : "#000",
				stroke : "#FFF",
				"stroke-dasharray" : ".",
				opacity : 0.9
			});
		}
		$('#start_info').text(s.toString());
		$('#depth_info').text(global_level);
		$('#goal_info').text(goals.toString());
		//funti
		//$('#rule_info').html($('#baza_text').html().replace(/\n/g, "<br />"));
		
		closeModalBear();
	}
}
function lightNowFact() {

	var s = [];
	out_trace_mem = '';
	$('#select_fact input:checked').each(function(indx, element) {
		s.push($(this).val());
	});
	
	var g = [];
	var out_trace_sub = '';
	$('#goal_select input:checked').each(function(indx, element) {
		g.push($(this).val());
	});
 /*
  * Убираем выбранные подцели
  */
	for ( kn = 0; kn < g.length; kn++) {
		
		targets[searchFact(g[kn])].attr({
			fill : "#000",
			stroke : "#fff",
			"stroke-dasharray" : ".",
			opacity : .2
		});
		
	}

		for ( i = 0; i < s.length; i++) {
			targets[searchFact(s[i])].attr({
				fill : "#50b74d",
				stroke : "#50b74d",
				"stroke-dasharray" : ".",
				opacity : 0.9
			});
		}
		

	if (s.toString()=='') {
		out_trace_mem = 'Не изменилась';
	} else {
		out_trace_mem = '+'+s.toString();
		$('#start_info').text($('#start_info').text()+','+s.toString());
	}
	
	if (g.toString()=='') {
		out_trace_sub = 'Нет выполненных подцелей';
	} else {
		
	}
	if (sub_goal[sub_goal.length-1]==undefined) {} else {
	 sub_goal.pop();
	if (sub_goal.length==0) {} else {
	$('#sub_goal_info').html(sub_goal.toString());
	targets[searchFact(sub_goal[sub_goal.length-1])].attr({
		fill : "#ee2700",
		stroke : "#ee2700",
		"stroke-dasharray" : ".",
		opacity : 0.9
	});
	}
	}
	$('#change_memory-step'+steps).html('<b>'+out_trace_mem+'</b>');
	$('#change_stack-step'+steps).html('<b>- '+g.toString()+'</b>');
	$('#depth_info').text(global_level);
	if (out_trace_mem=='Не изменилась') {out_trace_mem=' Not change'}
	jsonThisStep+='M-'+out_trace_mem.slice(1)+',DEL-'+g.pop();
	JSONstep+='"RULE='+jsonThisStep+'",';
	$('#step_second').slideDown();
	closeModalBear();
}

function createFactOut(level) {
	var s = "";
	var levelq = level;
	var counter = 0;
	for ( j = 1; j <= level; j++) {
		for ( i = 0; i < window["str" + levelq].length; i++) {
			$("#select_fact").append($('<input type="checkbox" value="' + window["str" + levelq][i] + '">' + window["str" + levelq][i] + '<br />'));
			$("#goal_select").append($('<input name="goal" type="radio" value="' + window["str" + levelq][i] + '" id="general_goal_'+i+'"> <label for="general_goal_'+i+'">' + window["str" + levelq][i] + '</label><br />'));
		}
		levelq = levelq - 1;
	}
}

function createStepsTable(step_rule,topFact,nameFact) {

	jsonThisStep = "";
	var exitCode = '';
	var width = cnt_rule_fact*40+210;
	if (step_rule==1) {
		for (a=0;a<cnt_rule_fact;a++)
		{
		 exitCode = exitCode + '<td class="name_rule_trace" width="40" align="center"><div style="display:block; width:40px;">R'+a+'</div></td>';
		}
		exitCode = '<table border="0" cellspacing="3" width="'+width+'" align="center"><tr><td><div style="display:block; width:50px;"><div id="check_scroll_me" style="position:absolute"></div></div></td>'+exitCode+'<td class="name_rule_trace">'+
		'<div style="display:block; width:100px;">Изменение РП</div></td><td><div style="display:block; width:100px;"><b>Изменение подцели</b></div></td></tr></table>';
		$('#top_tbl').html(exitCode);
		$('#trace_output').css({"display":""}); // Показываем трассу при первом проходе 
		// Для скрола title на трассе
		check_scroll_left = $('#check_scroll_me').css("left").slice(0,-2)-4;
		check_scroll_top = $('#check_scroll_me').css("top").slice(0,-2)-15;
	}
	JSONstep+='"s'+step_rule+'":';
	exitCode = '';
	cnt_rule_fact;
	if(topFact!==true) {
	for (a=0;a<cnt_rule_fact;a++)
		{
		var rtn = $("#out-R"+a+" input:checked").attr("class");
		 exitCode = exitCode + '<td class="make_'+rtn+'" width="40"><div style="display:block; width:40px;"></div></td>';
		 jsonThisStep+='R'+a+'-'+rtn+',';
		}
	
	exitCode = '<table class="tbl_step_rule" id="tbl_step_'+step_rule+'" cellspacing="3" border="0" width="'+width+'" align="center"><tr><td width="50" class="name_rule_trace"><div style="display:block; width:50px;">Шаг '+step_rule+'</div></td>'+exitCode+
	'<td><div style="display:block; width:100px;" id="change_memory-step'+step_rule+'"></div></td><td class="function_trace_step"><div style="display:block; width:100px;" id="change_stack-step'+step_rule+'"></div></td></tr></table><br id="br_'+step_rule+'" />';
	} else {
		JSONstep+='"subGoal='+nameFact+'",';
		exitCode = '<table class="tbl_step_rule" id="tbl_step_'
				+ step_rule
				+ '" cellspacing="3" border="0" width="'
				+ width
				+ '" align="center"><tr><td width="50" class="name_rule_trace"><div style="display:block; width:50px;">Шаг '
				+ step_rule
				+ '</div></td><td colspan="'
				+ cnt_rule_fact
				+ '"><div style="display:block; width:'+(40*cnt_rule_fact+5*cnt_rule_fact)+'px;">Изменение текущей подцели</div></td><td><div style="display:block; width:100px;" id="change_memory-step'
				+ step_rule
				+ '"></div></td><td class="function_trace_step"><div style="display:block; width:100px;">+'+nameFact+'</div></td></tr></table><br id="br_'
				+ step_rule + '" />';
	}
	$('.del_btn').css({"display":"none"});
	$('#step_tbl').html($('#step_tbl').html()+exitCode);
} 
function deleteStep(id) {

	JSONstep = JSONstep.slice(0,JSONstep.indexOf('"s'+id+'"'));

	$('#tbl_step_'+id).remove();
	$('#br_'+id).remove();
	steps--;
	$('.del_btn:last').css({"display":""});
}

function getJSONformat() {
	var postJSON = '';
	if (JSONstep.substr(-1)==',') {
		postJSON = '{'+JSONstep.slice(0,-1)+'}';
	} else {
		postJSON = '{'+JSONstep+'}';
	}
	return postJSON;
}

function checkLengthSteps() {
	var s = [];
	var goals= [];
	$('#select_fact input:checked').each(function(indx, element) {
		s.push($(this).val());
	});
	firstMemory = s.toString();
	JSONstep+='"firstMem":"'+firstMemory+'",';
	$('#goal_select input:checked').each(function(indx, element) {
		goals.push($(this).val());
	});
	var general_goal = goals.toString();
	if (general_goal=='') {
		$.jGrowl('<br />Вы не указали основную <b>цель</b>', {
			life : 5000,
			header : 'Оповещание эксперта'
		});
	} else {
	JSONstep+='"generalGoal":"'+general_goal+'",';
	JSONreverse='';
	memStackSub = [];
	superGeneralGoal = '';
	trueRulesBack = [];
	notTrueRules = [];
	lastRuleBLYA = [];
	parseBackRule(1);
	TRUEJSON = '{'+JSONreverse+'}';
	Steper = jQuery.parseJSON(TRUEJSON);
	if (Steper.badGoal=='true') {

		JSONstep=JSONstep.slice(0,JSONstep.indexOf('"first'));
		$.jGrowl('<br />Выбранная цель <b>недостижима</b>, с текущей РП', {
			life : 5000,
			header : 'Оповещание эксперта'
		});
	
		
	} else {
		if (parseInt(Steper.stepsSolverBack)<5) {
			JSONreverse='';
			memStackSub = [];
			superGeneralGoal = '';
			trueRulesBack = [];
			notTrueRules = [];
			lastRuleBLYA = [];
			JSONstep=JSONstep.slice(0,JSONstep.indexOf('"first'));
			$.jGrowl('<br />Слишком мало шагов. Выберите другое состояние РП', {
				life : 5000,
				header : 'Оповещание эксперта'
			});
		} else {
			JSONreverse='';
			memStackSub = [];
			superGeneralGoal = '';
			trueRulesBack = [];
			notTrueRules = [];
			lastRuleBLYA = [];
			postDataReverse($('#user_id_now').val());
			userWantMiss=true;
			lightThisFact(s,goals);
		}
	
	}
	}
}
function postDataReverse(ids,flag,estimate) {

	if (flag==undefined) {flag='no';}
	$.post(
			'/reverse/getfile',
			  {
			   id: ids,
			    JSON: getJSONformat(),
			    end: flag,
			    result: estimate
			  },
			  onAjaxSuccess
			);
			 
			function onAjaxSuccess(data)
			{
				if (data=='Конфигурация сохранена') {
						$.jGrowl('<br />Ваша БЗ и начальное состояние РП <b>успешно сохранены</b>', {
							life : 2500,
							header : 'Оповещание эксперта'
						});
				}
				if (data=="Тестирование закончено") {
					$.jGrowl('<br />Вы закончили тестирование. Ваш результат: '+global_estimate, {
						life : 25000,
						header : 'Оповещание эксперта'
					});
				}
			}
			
}
 
