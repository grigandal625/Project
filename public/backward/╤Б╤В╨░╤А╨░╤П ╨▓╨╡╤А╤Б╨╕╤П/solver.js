/**
 * @author Victor Potapov
 * @version 1.0
 * @date 16.02.14
 */



function checkTwoArray(arr1,arr2) {
	//TODO: Сравнивает два массива. Если второй содержит все элементы первого возвращает true иначе false
	for (n=0;n<arr1.length;n++) {
		if ($.inArray(arr1[n], arr2)==(-1)) {
			return false; break;
		}
	}
	return true;
}
var global_estimate = 0;
function solveBAST() {
	JSONstep+='"endUserStepCount":"'+steps+'"';
	inicilization();
	console.log('Сделанно на'+Math.floor(stepTrueCount));
	console.log('Правильное число шагов'+(SOLVER.stepsSolverBack-1));
	var estimateReverse=Math.ceil(((100/(SOLVER.stepsSolverBack-1))*Math.floor(stepTrueCount)));
	global_estimate=estimateReverse;
	JSONstep+=',"estimate":"'+global_estimate+'","stepUserCnt":"'+steps+'"';
	postDataReverse($('#user_id_now').val(),'yes',estimateReverse);
	userWantMiss=false;
	$('#set_block').fadeIn(200);
	$('#step_second').fadeOut('100');
	alert('Ваша оценка '+global_estimate);
}

var stepTrueCount = 0;
var TRUEJSON,SOLVER,STEPuser,memTrueStep;
var memStackSub = [];
var StackTrueRules = [];
var estimateAr = [0.5,0.15,0.15,0.2];
function inicilization() {
	/*
	 * Иницилизаця решателя
	 */
	parseBackRule(1);
	
	/*
	 * Объявление переменных для оценивания
	 */
	
	TRUEJSON = '{'+JSONreverse+'}';
	SOLVER = jQuery.parseJSON(TRUEJSON);
	STEPuser =  jQuery.parseJSON(getJSONformat());
	memTrueStep = STEPuser.firstMem.split(',');
	estimateBAST('first');
}
function estimateBAST(variant,subGoal,actionCheck,stepCheck) {
	switch (variant) {
		case 'first': {
			var action='searchSubGoal';
			var stepAction=1;
			var searchGoal = SOLVER.targetRule;
			memStackSub.push(STEPuser.generalGoal);
			break;
		}
		case 'second': {
			var searchGoal = subGoal;
			var stepAction = parseInt(stepCheck);
			var action = actionCheck;
			break;
		}
	}
	switch (action) {
		case 'searchSubGoal': {
			
			for (sol=stepAction;sol<STEPuser.endUserStepCount;sol++) {
				/*
				 * Если выбрал правильно подцель
				 */
				console.log('SEE '+sol+' and node'+searchGoal);
				if ($.inArray(eval('STEPuser.s'+sol).split('=')[1],eval('STEPuser.SR'+searchGoal).split('-')[1].split(','))>=0) {
					
					stepTrueCount+=1;
					memStackSub.push(eval('STEPuser.s'+sol).split('=')[1]);
					console.log('Правильно указал подцель '+eval('STEPuser.s'+sol).split('=')[1]+' на '+sol+' шаге');
					estimateBAST('second',eval('STEPuser.s'+sol).split('=')[1],'checkAction',sol);
					break;
				} 
				
			}
			break;
		}
		case 'checkAction': {
			/*
			 * Если правило может выполнится у подцели, оно должно быть выполнено
			 */
			
			 if (checkTwoArray(eval('STEPuser.SR'+searchNumberRule(searchGoal)).split('-')[1].split(','),memTrueStep)) {
				 estimateBAST('second',searchGoal,'searchRule',stepAction);
			 } else {
				 estimateBAST('second',searchNumberRule(searchGoal),'searchSubGoal',parseInt(stepAction)+1);
				 
			 }
			break;
		}
		case 'searchRule': {
			for (sol=(stepAction+1);sol<=STEPuser.endUserStepCount;sol++) {
				 /*
				  * Если sol является правилом, возможно все хорошо
				  */
				 if (eval('STEPuser.s'+sol).split('=')[0]=='RULE') {
					 var thisTrueRules = [];
					 var thisNumberTrue = '';
					 for (cv=0;cv<STEPuser.num;cv++) {
						 
						 if (eval('STEPuser.s'+sol).split('=')[1].split(',')[cv].split('-')[1]=='P') {
							 thisTrueRules.push(eval('STEPuser.s'+sol).split('=')[1].split(',')[cv].split('-')[0].slice(1));
							 
						 }
						
						if (eval('STEPuser.s'+sol).split('=')[1].split(',')[cv].split('-')[1]=='S') {
							/*
							 * Если выбрал правильное  правило
							 */
							console.log(eval('STEPuser.s'+sol).split('=')[1].split(',')[cv].split('-')[0].slice(1)+' '+searchNumberRule(searchGoal));
							if (eval('STEPuser.s'+sol).split('=')[1].split(',')[cv].split('-')[0].slice(1)==searchNumberRule(searchGoal)) {
								stepTrueCount+=estimateAr[0];
								thisNumberTrue = eval('STEPuser.s'+sol).split('=')[1].split(',')[cv].split('-')[0].slice(1);
								
								
									
								/*
								 * Если выбрал правильно РП
								 */
								if (eval('STEPuser.s'+sol).split('=')[1].split(',')[STEPuser.num].split('-')[1]==searchGoal) {
									memTrueStep.push(searchGoal);
									stepTrueCount+=estimateAr[1];
								
									/*
									 * Если правильно выбрал сработанную подцель
									 */
									if  (eval('STEPuser.s'+sol).split('=')[1].split(',')[(parseInt(STEPuser.num)+1)].split('-')[1]==searchGoal) {
										
										stepTrueCount+=estimateAr[2];
									
										
										
										
									}
								}
								 
							}
							
						}
						
					 }
					 /*
					  * Если правильно указал сработанные правила
					  */
					 if (checkTwoArray(StackTrueRules,thisTrueRules)) {
						 console.log(thisTrueRules+' in '+StackTrueRules+' + 0.2');
						 stepTrueCount+=estimateAr[3];
					 }
					 StackTrueRules.push(thisNumberTrue);
					 if (sol==STEPuser.endUserStepCount) {} else {
							memStackSub.pop();
						estimateBAST('second',memStackSub[memStackSub.length-1],'checkAction',sol);
						}
					 break;
				 }  else {
					 /*
					  * А вот если subGoal, уходим
					  */
					 
					 
				 }
				 
			 }
			break;
		}
	}
	
}
var superGeneralGoal = '';
var JSONreverse = '';
function parseBackRule(first,memoryStack,memoryM,trueRules,stepsSolver,stepercount,generalGoal,ender,checkDBL,deleteTrueRules,checkV) {
	

	var max_connection = 3;
	var now_connection = 0;
	if (first==1) {
	var solver = jQuery.parseJSON(getJSONformat());
	var stepsSolverBack = '';
	var memStepsSolver = solver.firstMem.split(',');
	var numOfRule = [solver.num];
	var newMemSteps = [];
	var stepCounter = 0;
	var stack_sub_goals = [];
	
	} else {
		var solver = jQuery.parseJSON(getJSONformat());
		var stepsSolverBack = stepsSolver;
		var memStepsSolver = memoryM.split(',');
		var numOfRule = [solver.num];
		var stack_sub_goals = memoryStack.split(',');
		var newMemSteps = [];
		var stepCounter = stepercount;
		var general_Goal = generalGoal;
		var stackTrueRules = trueRules;
		var not_true_rules = notTrueRules;
	}
	
	if (first==2) {
		superGeneralGoal = general_Goal;
	}
	
	if (first==1) {
	for (m=0;m<solver.num;m++) {
		/*
		 * Находим правильное правило
		 */
		if (eval('solver.SR'+m).split('-')[0]==solver.generalGoal) {
			notTrueRules.push(m);
			parseBackRule(2,eval('solver.SR'+m).split('-')[0],memStepsSolver.toString(),'','',0,m,false,false); break; // чтобы не создавать проблем оперативке
		}
		
	}
	} else {

		if (checkTwoArray(eval('solver.SR'+general_Goal).split('-')[1].split(','),memStepsSolver)) {
			/*
			 * Если правило может выполнится сразу
			 */
			stepCounter++;
			
		if (checkDBL!==true) {} else {	
				memStepsSolver.push(eval('solver.SR'+general_Goal).split('-')[0]);searchRuleToNode(eval('solver.SR'+general_Goal).split('-')[0],0); if (deleteTrueRules==true) {trueRulesBack.pop();}
			}
			if (ender!==true) {
			stepsSolverBack+='"sB'+stepCounter+'":"R-'+general_Goal+'->M-'+eval('solver.SR'+general_Goal).split('-')[0]+'->stackTrueRule-'+trueRulesBack.toString();
			
				stepsSolverBack+='->delete_sub_goal-'+stack_sub_goals[stack_sub_goals.length-1]+'",';
			} else {
				stepsSolverBack=stepsSolverBack.slice(0,-2)+eval('solver.SR'+superGeneralGoal).split('-')[0]+'",';
				stepsSolverBack+='"badGoal":"false","stepsSolverBack":"'+stepCounter+'", "targetRule":"'+superGeneralGoal+'"';
				}
			stack_sub_goals[stack_sub_goals.length-1]='';
			//searchRuleToNode(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni],0);
			//console.log('Сработаные правила: '+trueRulesBack.toString());
			
			
			if (ender==true) {
				 //console.log('Конечный список правил: '+trueRulesBack.toString());
				 JSONreverse+=stepsSolverBack;
				return JSONreverse;
			} else {
			//console.log('Stack subGoal before '+notTrueRules.toString());
			
			
				if (notTrueRules.length==1) {
					
					//console.log('Срабатывание последнего правила');
					
					parseBackRule(3,stack_sub_goals.toString(),memStepsSolver.toString(),'',stepsSolverBack,stepCounter,notTrueRules[notTrueRules.length-1],true);
					
				} else {
					lastRuleBLYA.push(general_Goal);
					notTrueRules.pop();
					/*console.log('Stack subGoal  after'+notTrueRules.toString());
					console.log('Смотрим '+general_Goal);
					console.log('Текущая память: '+memStepsSolver.toString());
					*/
					searchRuleToNode((eval('solver.SR'+lastRuleBLYA.pop())).split('-')[0],0);
					parseBackRule(3,stack_sub_goals.toString(),memStepsSolver.toString(),'',stepsSolverBack,stepCounter,notTrueRules[notTrueRules.length-1],false,true,true);
					
				}
			}
			
		} else {
			/*
			 * Если правило не может сработать, смотрим факты правильного правила
			 */
			for (ni=0;ni<eval('solver.SR'+general_Goal).split('-')[1].split(',').length;ni++) {
				/*
				 * Если факта NI нет в памяти, создаем подцель и это является первым шагом
				 */
				
				if ($.inArray(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni],memStepsSolver)==-1) {
					if ($.inArray(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni],eval('str'+global_level))>=0) {
						/*
						 * последнее привило всех уровней. 
						 */
						//console.log('Это конечная вершина правила '+general_Goal);
						stepsSolverBack+='"badGoal":"true"';
						JSONreverse+=stepsSolverBack;
						return JSONreverse; break;
					} else {
					//console.log('Смотрим '+eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni]);
					stepCounter++;
					//console.log('Создадим подцель '+eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni]);
					stack_sub_goals.push(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni]);
					stepsSolverBack+='"sB'+stepCounter+'":"newSubGoal-'+eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni]+'",';
					
					/*
					 * Если правило у подцели может сработать, оно срабатывает
					 */
					if (checkTwoArray(searchRuleToNode(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni],1).split(','),memStepsSolver))
							{
								stepCounter++;
								memStepsSolver.push(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni]);
								searchRuleToNode(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni],0);
								var statRule = [];
								lastRuleBLYA.push(trueRulesBack[trueRulesBack.length-1]);
								stepsSolverBack+='"sB'+stepCounter+'":"R-'+trueRulesBack[trueRulesBack.length-1]+'->stackTrueRule-'+trueRulesBack.toString().slice(0,(trueRulesBack.toString()).lastIndexOf(','));
								stepsSolverBack+='->delete_sub_goal-'+stack_sub_goals.pop()+'",';
								
							/*
								console.log('Сработаные правила: '+trueRulesBack.toString());
								console.log('Предлагается вернуться и выполнить правило '+not_true_rules[not_true_rules.length-1]);
								console.log('Текущая память: '+memStepsSolver.toString());
								*/
								parseBackRule(3,stack_sub_goals.toString(),memStepsSolver.toString(),'',stepsSolverBack,stepCounter,not_true_rules[not_true_rules.length-1],false,true,true);break;
							} else {
								
								/*
								 * Иначе
								 */
								var out_num_rule = searchNumberRule(stack_sub_goals[stack_sub_goals.length-1]);
								if (out_num_rule!==false) {
								parseBackRule(3,stack_sub_goals.toString(),memStepsSolver.toString(),'',stepsSolverBack,stepCounter,out_num_rule);break;
								} else {
									
									if (searchRuleToNode(eval('solver.SR'+general_Goal).split('-')[1].split(',')[ni],1)=='n,m') {
										//console.log('По ходу дела конец дерева и конечное правило ' +out_num_rule);
									}
								}
							}
					
					}
				}
				
			}
			
		}
	}
}

var trueRulesBack = [];
var notTrueRules = [];
var lastRuleBLYA = [];
function searchNumberRule(node) {
	var solver = jQuery.parseJSON(getJSONformat());
	var out = '';
	for (mn=0;mn<solver.num;mn++) {
		
		if (node==eval('solver.SR'+mn).split('-')[0]) {
			
			
			out = mn;
			notTrueRules.push(out);
			
			
			return out; break;
		}
				
		}
	if (out=='') {
		return false;
	}
}
function searchRuleToNode(node,op) {
	var solver = jQuery.parseJSON(getJSONformat());
	var out = '';
	for (mn=0;mn<solver.num;mn++) {
		
		if (node==eval('solver.SR'+mn).split('-')[0]) {
			
			
			out = eval('solver.SR'+mn).split('-')[1];
			if (op!==1) {
			trueRulesBack.push(mn);
			}
			console.log(out);
			return out; 
		}
				
		}
	if (out=='') {
		return 'n,m';
	}
	}
	

function checkThisStep() {
	// TODO: Оценивание
	var solver = jQuery.parseJSON(getJSONformat());
	var estimate=100;
	var minus = [20,10,10,10];
	//console.log(solver);
	
	var firstMem = solver.firstMem.split(',');
	var k = 1;
	var stepUserVal = 0;
	while(eval('solver.s'+k)!==undefined) {
		
		var solveThisStep = eval('solver.s'+k).split(',');
		
		for (i=0;i<solver.num;i++) {
			switch (solveThisStep[i].split('-')[1]) {
			
			case 'S' : {
				var trueStep = eval('solver.SR'+i).split('-');
				// если есть все факты
				if (checkTwoArray(trueStep[1].split(','),firstMem)) {
					//если вершина указана правильно
					if (trueStep[0]==solveThisStep[solver.num].split('-')[1]) {
					
					} else {
						estimate-=minus[1];
					}
					
				} else {
					estimate-=minus[0];
				}
				stepUserVal++;
				break;}

			case 'H' : {break;}
			
			case 'P' : {break;}
			
			}
		}
		if(solveThisStep[solver.num].split('-')[1]=='Not change') {} else {
			firstMem.push(solveThisStep[solver.num].split('-')[1]);
		}
		
			k++;
	}
	solve(stepUserVal,estimate);
}

function parseStartRule() {
	// TODO: Создает эталон 
	var solver = jQuery.parseJSON(getJSONformat());
	var stepsSolver = ''; // JSON Решателя
	var memStepsSolver = solver.firstMem.split(',');
	var newStepStatus = [solver.num];
	var newStepMem = []; // Хранит память на текущем шаге решателя
	var stepCounter = 0; // счетчик шагов
	var stringToOut = ''; // JSON на выход 
	var flagAboutDbl = false;
	var arrayTrueStep = [];
	var cntSteps = 0;
	
	for (m=0;m<solver.num;m++) {
		stepCounter++; stringToOut = ''; flagAboutDbl = false;
		for (v=0;v<solver.num;v++) {
			
			// Костыль от повторов
			if (flagAboutDbl==false) {
				
				
			// Если правило уже используется
			if (newStepStatus[v] == 'S' || newStepStatus[v]=='P') {
				newStepStatus[v] = 'P'
			} else {
				
			var childThisRule = eval("solver.SR"+v).split('-')[1].split(',');
			var checkCountThisStep = childThisRule.length; // Создаем массив для проверки наличия всех фактов из правила
			
				for (k=0;k<memStepsSolver.length;k++) {
					
					if ($.inArray(memStepsSolver[k],childThisRule)!==(-1)) {
						checkCountThisStep--;
					}
						
				}
				
			if (checkCountThisStep==0) {
				
				newStepStatus[v] = 'S';					// Говорим что подоходит номер правила если все состовляющие факты есть в памяти
				newStepMem[stepCounter-1] = eval("solver.SR"+v).split('-')[0];
				if ($.inArray(eval("solver.SR"+v).split('-')[0],memStepsSolver)==(-1)) {
				memStepsSolver.push(eval("solver.SR"+v).split('-')[0]);
				}
				flagAboutDbl = true; 
				
				/*
				 * Подсветка правильных ходов TODO: LIGHT FOR TRUE FACT
				 */
				
			//	targets[searchFact(eval("solver.SR"+v).split('-')[0])].glow();
				arrayTrueStep.push(v);
				cntSteps++;
				
			} else {
				newStepStatus[v] = 'H';					// Говорим что не подоходит номер правила 
				
			}
			
			}
			
		}
			else {
				newStepStatus[v] = 'H';
			}
		}
		
		if (newStepMem[stepCounter-1]==undefined) {
			//break;
		} else {
		
		
		for (t=0;t<solver.num;t++) {
			
			stringToOut+='R'+t+'-'+newStepStatus[t]+',';
			
		}
		
		stringToOut+='M-'+newStepMem[stepCounter-1];
		
		stepsSolver+= '"s'+stepCounter+'":"'+stringToOut+'",';
		}
		
		
	}
	
	stepsSolver+='"stepsSolver":"'+cntSteps+'","cntRule":"'+solver.num+'","arrayTrueStep":"'+arrayTrueStep.toString()+'"';
	
	return stepsSolver;
	
}

function showStepsTrace() {
	// TODO: Вывод трассы для эталона
	var trueJSON = '{'+parseStartRule()+'}';
	var Steper =  jQuery.parseJSON(trueJSON);
	var exitCode = '';
	var width = Steper.cntRule*40+180;
	var rtn_s ;

		for (i=0;i<Steper.cntRule;i++) 
			{
				 exitCode = exitCode + '<td class="name_rule_trace" width="40" align="center"><div style="display:block; width:40px;">R'+i+'</div></td>';
				}
				exitCode = '<table border="0" cellspacing="3" width="'+width+'" align="center"><tr><td><div style="display:block; width:50px;"><div id="check_scroll_me" style="position:absolute"></div></div></td>'+exitCode+'<td class="name_rule_trace">'+
				'<div style="display:block; width:100px;">Изменение РП</div></td><td><div style="display:block; width:70px;"><b>Функции</b></div></td></tr></table>';
				$('#top_tbl').html(exitCode);
				$('#trace_output').css({"display":""}); 
				check_scroll_left = $('#check_scroll_me').css("left").slice(0,-2)-4;
				check_scroll_top = $('#check_scroll_me').css("top").slice(0,-2)-15;
				
				

	for (i=0;i<Steper.stepsSolver;i++) {
		exitCode = '';
		var rtn = eval('Steper.s'+(i+1));
		rtn_s=rtn.toString().split(',');
		for (j=0;j<Steper.cntRule;j++) {
			
			var out=rtn_s[j].split('-')[1];
			 exitCode = exitCode + '<td class="make_'+out+'" width="40"><div style="display:block; width:40px;"></div></td>';
			
		}
		var memStep = rtn_s[Steper.cntRule].split('-')[1];
		exitCode = '<table class="tbl_step_rule" id="tbl_step_'+i+'" cellspacing="3" border="0" width="'+width+'" align="center"><tr><td width="50" class="name_rule_trace"><div style="display:block; width:50px;">Шаг '+i+'</div></td>'+exitCode+
		'<td><div style="display:block; width:100px;" id="change_memory-step"><b>+'+memStep+'</b></div></td><td class="function_trace_step"><div style="display:block; width:70px;"><a href="javascript://" onClick="openWindow('+i+');" title="Редактировать"><img src="src/edit.png" border="0" /></a> <a href="javascript://" onClick="deleteStep('+i+');" title="Удаление шага" class="del_btn"><img src="src/delete.png" border="0" /></a></div></td></tr></table><br id="br_'+i+'" />';
		$('.del_btn').css({"display":"none"});
		$('#step_tbl').html($('#step_tbl').html()+exitCode);
		
	}
	
	
}

