/**
 * @author Victor Potapov
 * @version 1.8
 * @data 20.07.13
 * @last_change 11.12.13
 * @modified 11.12.13
 * TODO: Библиотека для прорисовки и работы с деревом
 */

var width_holder = 0;
var height_holder = 0;
var r = "";
var targets = "";
var labels = "";
var cnt_rule_fact = 0;
var memoryOfRule = [];
var cnt_create_pos = 0;
var global_title = [];

function drawTree(level, count_str, count_all_el, max_elem) {
	/* Параметры для прорисовки */
	var padding_st = 70;
	//const отступа
	var padding = 70;
	//Отступ между объекатми сверху
	var lvl_left = 50;
	//Отступ от объектов слева
	var lvl_change = 300;
	//Отступ между уровнями
	var out_rule = 70;
	// Отступ вилки с правилом от уровня
	var radius_fact = 20;
	var quest = true;
	// для проверки вывода первого уровня
	var count = level;
	//Дублируем уровни
	var ing = 0;
	//Счетчик для нодов
	var memory_for_line = [];
	//Сохраняем все координаты всех вершин
	var m4fc = 0;
	var fact_count = 0;
	var ar_line = [];
	var color_rule = "";
	var color_line = "#FFF";
	var color_line_hover = "#eedc00";
	var color_var = "";
	var color_glow = "#eedc00";
	// COLOR RULE'S AND LINE mouseover()
	var color_glow_click = "#000";
	var color_line_click = "#000";
	// COLOR RULE'S AND LINE click()
	width_holder = level * lvl_change - 200;
	// Ширина рабочего полотна
	height_holder = max_elem * padding_st + padding_st;
	// Высота рабочего полотна
	// Рисуем холст - рабочую область
	document.getElementById("holder").style.width = width_holder + 'px';
	document.getElementById("holder").innerHTML = '';
	r = Raphael("holder", width_holder, height_holder);
	targets = r.set();
	for ( j = 1; j <= count; j++) {
		if (quest) {
			lvl_left = lvl_left;
		} else {
			padding = padding_st;
			lvl_left = lvl_left + lvl_change;
		}
		for ( i = 0; i < window["str" + level].length; i++) {
			
			targets.push(r.circle(lvl_left, padding, radius_fact));
		
			
			ing++;
			padding += padding_st;
		}

		targets.attr({
			fill : "#000",
			stroke : "#fff",
			"stroke-dasharray" : ".",
			opacity : .2,
			cursor: "pointer"
		});

		//Пишем лэйбел каждому кругу
		labels = r.set();
		var padding = padding_st;
		for ( i = 0; i < window["str" + level].length; i++) {
			var lbl = window["str" + level][i].substr(0, 2);
			// 		Делаем длину факта не более 2-х символов
			if (quest == false) {
				createRuleMem[cnt_create_pos] = cnt_create_pos + '-' + window["str" + level][i];
				cnt_create_pos = cnt_create_pos + 1;
			}
			labels.push(r.text(lvl_left - 4, padding + 1, lbl));
			memory_for_line[m4fc] = lvl_left + '-' + padding + '-' + window["str" + level][i];
			m4fc++;
			padding += padding_st;
			labels[i].attr({
				title : window["str" + level][i]
			});
			global_title.push(window["str" + level][i]);
			//	Вешаем на подсказку полное название факта без ограничений
		}
		labels.attr({
			font : "12px Fontin-Sans, Arial",
			fill : "#fff",
			"text-anchor" : "start"
		});

		quest = false;
		level = level - 1;
	}
	// r.path("M50 10L90 90").attr({fill: "#000", stroke: "#000"}).glow();
	j = 0;
	var memNodeArr = [];
	//Храним корни
	for ( jk = 0; jk < (count_str - 1); jk++) {
		memNodeArr[jk] = nodeToDraw(window["root" + jk], 2) + "-" + nodeToDraw(window["root" + jk], 1);
	}
	JSONstep+='"num":"'+(count_str-1)+'",';
	var count_line = 0;
	var fact = r.set();
	var line = r.set();
	var nameFact = r.set();
	var count_down_level_element = window["str" + count].length;
	for ( n = count_down_level_element; n < m4fc; n++)//Рисуем связи m4fc = 21 - кол-во элем-ов
	{
		

		var ar = memory_for_line[n].split('-');
		// Разбиваем каждый элемент масивы и находим лейбл в ар(2)
		for ( kk = 0; kk < (count_str - 1); kk++) {
			
			var nodeToEq = memNodeArr[kk].split('-');
			if (nodeToEq[0] == ar[2])// Нашли корень
			{
				var ar_new = nodeToEq[1].split(',');
				// Тащим его детей
				var mem_XY = [""];
				
				for ( nn = 0; nn < ar_new.length; nn++)// Для каждого чаилда вытаскиваем координаты начала и рисуем линии
				{

					for ( nnn = 0; nnn < m4fc; nnn++) {
						var ar_new_town = memory_for_line[nnn].split('-');
						if (ar_new[nn] == ar_new_town[2])//Находим координаты каждого чаилда
						{
							mem_XY[nn] = ar_new_town[0] + '-' + ar_new_town[1];

						}
					}

				}

				var x_to_rule = ar[0] - out_rule;
				var x_from_rule = ar[0] - radius_fact;
				line.push(r.path("M" + x_to_rule + " " + ar[1] + "L" + x_from_rule + " " + ar[1] + "").attr({
					fill : color_line,
					stroke : color_line,
					"arrow-end" : "block-wide-long",
					"stroke-width" : 2
				}));
				for ( ijk = 0; ijk < mem_XY.length; ijk++) {

					var ArDraw = mem_XY[ijk].split('-');
					var fr_x = parseInt(ArDraw[0]) + radius_fact;
					line.push(r.path("M" + fr_x + " " + ArDraw[1] + "L" + x_to_rule + " " + ar[1] + "").attr({
						fill : color_line,
						stroke : color_line
					}));
					if (ijk == (mem_XY.length - 1)) {
						nameFact.push(r.text(x_to_rule + 20, ar[1] - 10, "R" + cnt_rule_fact)); // Пишем название правила R0 ...
						fact.push(r.circle(x_to_rule, ar[1], 9).attr({
							title : "R" + cnt_rule_fact
						}));
						//Рисуем правило
						
						// СОРТИРОВКА ПРАВИЛ ПО НОМЕРУ R0-R1...
						$('#rule_info').html($('#rule_info').html()+"<b>R"+cnt_rule_fact+'</b> - '+nodeToString(window["root" + nodeFromRoot(ar[2],count_str)])+'<br />');
						
						// Запись в JSON начальных правил
						
						JSONstep+='"SR'+cnt_rule_fact+'":"'+nodeToDraw(window["root" + nodeFromRoot(ar[2],count_str)],2)+'-'+nodeToDraw(window["root" + nodeFromRoot(ar[2],count_str)],1)+'",';
						
						
						
						cnt_rule_fact++;
						
						// ---------------------------------- Обработчики правил ---------------------------------------------
						fact[(n - count_down_level_element)].click(function() {//Обработчик правил
							steps++; // увеличиваем новый шаг
							var pos_fact = in_array(this.id, ar_line); // NUMBER OF RULE TODO: RETURN NUMBER OF RULE
							openWindow(pos_fact);
							this.glow();
							//Подсвечиваем правило
							
							//Ищем сколько линий нужно подсветить у этого правила
							var clear_ar = ar_line[pos_fact].split(',');
							for ( lin = 2; lin <= clear_ar[0]; lin++) {
								r.getById((this.id - lin)).glow({
									color : color_glow_click,
									width : "1",
									opacity : "0.99"
								});
								//Подсвечиваем каждую линию этого правила
								r.getById((this.id - lin)).attr({
									fill : color_line_click,
									stroke : color_line_click
								});
							}
							
							//doStep(pos_fact); // - подсветка конечного факта ->
						});
						fact[(n - count_down_level_element)].mouseover(function() {//Обработчик правил
							this.glow({
								width : "0px"
							});
							//Подсвечиваем правило
							var pos_fact = in_array(this.id, ar_line);
							//Ищем сколько линий нужно подсветить у этого правила
							var clear_ar = ar_line[pos_fact].split(',');
							for ( lin = 2; lin <= clear_ar[0]; lin++) {
								//Подсвечиваем каждую линию этого правила
								if (lin == clear_ar[0]) {//ARROW RULES
									r.getById((this.id - lin)).attr({
										fill : color_line_hover,
										stroke : color_line_hover,
										"arrow-end" : "block-wide-long",
										"stroke-width" : 3
									});
								} else {

									r.getById((this.id - lin)).attr({
										fill : color_line_hover,
										stroke : color_line_hover,
										"stroke-width" : 4
									});
								}
							}
						});
						fact[(n - count_down_level_element)].mouseout(function() {//Обработчик правил
							this.glow({
								width : "0px"
							});
							//Подсвечиваем правило
							var pos_fact = in_array(this.id, ar_line);
							//Ищем сколько линий нужно подсветить у этого правила
							var clear_ar = ar_line[pos_fact].split(',');
							for ( lin = 2; lin <= clear_ar[0]; lin++) {
								if (lin == clear_ar[0]) {//ARROW RULES
									r.getById((this.id - lin)).attr({
										fill : color_line,
										stroke : color_line,
										"arrow-end" : "block-wide-long",
										"stroke-width" : 2
									});
								} else {
									// Убираем подсветку с правила и линий
									r.getById((this.id - lin)).attr({
										fill : color_line,
										stroke : color_line,
										"stroke-width" : 1
									});
								}
							}
						});

						if (fact_count == 0) {
							ar_line[fact_count] = 2 + mem_XY.length + ',' + (fact[0].id);
							// Запоминаем ID первого правила
						} else {
							lineR = ar_line[fact_count - 1].split(',');

							ar_line[fact_count] = 2 + mem_XY.length + ',' + (parseInt(lineR[1]) + (2 + mem_XY.length) + 1);
							// Остальные ID увеличиваем
						}
						fact_count++;
					}

				}
				fact.attr({
					fill : "#FF0",
					stroke : "#fff",
					"stroke-dasharray" : ".",
					opacity : .95,
					cursor : "pointer"
				});
				nameFact.attr({
					font : "11px Fontin-Sans, Arial",
					fill : "#FFF",
					"stroke-width" : 1
				});
			}

		}

	}
	for (count_target=0;count_target<count_all_el;count_target++) {
	targets[count_target].attr({title: global_title[count_target]});
	targets[count_target].click(function() {
		goalDone(this.attr("title"));
	});
	}
}
// TODO: Функция возвращает номер переменной WHAT в массиве WHERE
function in_array(what, where) {
	for (var i = 0, length_array = where.length; i < length_array; i++) {
		var time_ar_ff = where[i].split(',');
		if (what == time_ar_ff[1]) {
			return i;
		}
	}
}

function searchFact(name) {
	var counterr = global_level;
	var levelerr = global_level;
	var return_const = 0;
	var cnt = 0;
	for ( j = 1; j <= counterr; j++) {
		for ( k = 0; k < window["str" + levelerr].length; k++) {
			if (window["str" + levelerr][k] == name) {
				return_const = cnt;
				break;
			}
			cnt++;
		}
		levelerr = levelerr - 1;
	}
	return return_const;
}

function doStep(id) {
	for ( kent = 0; kent < createRuleMem.length; kent++) {
		var checkDatar = createRuleMem[kent].split('-');
		if (id == checkDatar[0]) {
			light(checkDatar[1]);
			break;
		}
	}
}

function light(pos) {
	targets[searchFact(pos)].attr({
		fill : "#50b74d",
		stroke : "#50b74d",
		"stroke-dasharray" : ".",
		opacity : 0.9
	});
}
// функция с модальным окном для обработки при нажатии на ПРАВИЛО
function createFactNow(level,num) {

	var exitCode = "";
	var levelq = level;
	var flag_check = false;
	$("#select_fact").html('');
	$('#select_goal span').text('Укажите сработанную подцель');
	$('#goal_select').html('');
	$("#select_div_title").text('Выберите новое состояние');
	var counter = 0;
	var array_global_memory = $('#start_info').text().split(',');
	for ( j = 1; j <= level; j++) {
		for ( i = 0; i < window["str" + levelq].length; i++) {
			
			for (l=0;l<array_global_memory.length;l++) 
				{
				if (array_global_memory[l]==window["str" + levelq][i]) {flag_check=true; break;}
				}
			if (flag_check==false) {
			 $("#select_fact").append($('<input type="checkbox" value="' + window["str" + levelq][i] + '">' + window["str" + levelq][i] + '<br />'));
			} 
				flag_check=false;
				$("#goal_select").append($('<input name="sub_goal" type="radio" value="' + window["str" + levelq][i] + '" id="sub_goal_'+i+'"> <label for="sub_goal_'+i+'">' + window["str" + levelq][i] + '</label><br />'));
		}
		levelq = levelq - 1;
	}
	
	
	
	exitCode = '<tr><td width="30"></td><td class="title_tbl_rule" width="100" align="center">Подходит</td><td class="title_tbl_rule" width="100" align="center">Не подходит</td><td class="title_tbl_rule" width="130" align="center">Уже используется</td></tr>';
	for (o=0;o<cnt_rule_fact;o++) {
		if (num==o) {
			exitCode = exitCode + '<tr id="out-R'+o+'" class="tr_tbl_rule"><td class="name_tbl_rule">R'+o+'</td><td class="easy_val" align="center"><input type="radio" checked="cheched" class="S" name="R'+o+'" id="R'+o+'-S" /></td>' +
			 '<td class="easy_val" align="center"><input type="radio"  class="H" name="R'+o+'" id="R'+o+'-H" /></td>' +
			 '<td class="easy_val" align="center"><input type="radio" class="P" name="R'+o+'" id="R'+o+'-P" /></td></tr>';
		} else {
	 exitCode = exitCode + '<tr id="out-R'+o+'" class="tr_tbl_rule"><td class="name_tbl_rule">R'+o+'</td><td class="easy_val" align="center"><input type="radio" class="S" name="R'+o+'" id="R'+o+'-S" /></td>' +
	 '<td class="easy_val" align="center"><input type="radio" checked="cheched" class="H" name="R'+o+'" id="R'+o+'-H" /></td>' +
	 '<td class="easy_val" align="center"><input type="radio" class="P" name="R'+o+'" id="R'+o+'-P" /></td></tr>';
	}
	}
	exitCode = '<table class="radio_rule" border="0">'+exitCode+'</table>';
	$("#table_check").html(exitCode);
	$(".tr_tbl_rule:even").css("background-color", "#efeff0");
	$(" .tr_tbl_rule:odd").css("background-color", "#b3b3b3");
	
}

function openWindow(number) {
	$('#fact_select').text('Выберите изменение РП');
	$('#rule_select').text('Выберите состояние правил');
	createFactNow(global_level,number);
	$("#button_div").html('<input type="button" class="button_generate" style="margin:20px;" value="Готово" onClick="createStepsTable(\''+steps+'\');lightNowFact();" />');
	showModalBear();
}
//targets[6].attr({fill: "#50b74d", stroke: "#50b74d", "stroke-dasharray": ".", opacity: 0.9});

function goalDone(name) {
	
	if (targets[searchFact(name)].attr("fill")=='#50b74d') {
		$.jGrowl('Вы не можете выбрать факт <b>' + name + '</b> как подцель, так как он находится в РП.', {
			life : 3000,
			header : 'Оповещание эксперта'
		});
	} else {
		if (targets[searchFact(name)].attr("fill")=='#ee2700') {
			$.jGrowl('Факт <b>' + name + '</b> сейчас является подцелью.', {
				life : 3000,
				header : 'Оповещание эксперта'
			});
		} else {
					if (confirm("Выбрать текущую подцель")) {
						/*
						 * Убираем предыдущую цель
						 */
						
						
						if (sub_goal.length==0) {} else {
						targets[searchFact(sub_goal[sub_goal.length-1])].attr({
							fill : "#000",
							stroke : "#fff",
							"stroke-dasharray" : ".",
							opacity : .2
						});
						}
						
						/*
						 * Добавляем новую
						 */
						sub_goal.push(name);
						$('#step_second').slideDown();
						steps=steps+1;
						createStepsTable(steps,true,name);
						targets[searchFact(name)].attr({
							fill : "#ee2700",
							stroke : "#ee2700",
							"stroke-dasharray" : ".",
							opacity : 0.9
						});
						$('#sub_goal_info').html(sub_goal.toString());
						}
		}
	
		}
}
