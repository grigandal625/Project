/**
 * @author Victor Potapov
 * @version 1.0
 * @date 16.02.14
 */

var global_estimate = 0;

function checkTwoArray(arr1,arr2) {
	//TODO: Сравнивает два массива. Если второй содержит все элементы первого возвращает true иначе false
	for (n=0;n<arr1.length;n++) {
		if ($.inArray(arr1[n], arr2)==(-1)) {
			return false; break;
		}
	}
	return true;
}
function solveFAST() {
	var solver = jQuery.parseJSON(getJSONformat());
	var trueJSON = '{'+parseStartRule()+'}';
	var solverJSON=  jQuery.parseJSON(trueJSON);
	
	var estimate = 0;
	var stepEstimate = 100/solverJSON.stepsSolver;
	var plusEstimate = [0.33,0.33,0.34];
	
	var firstMem = solver.firstMem.split(',');
	var k = 1;
	var stepUserVal = 0;
	var flagDontTrue = false; // если не правльное правило
	
	var trueStepJSON = solverJSON.arrayTrueStep.split(',');
	
	while(eval('solver.s'+k)!==undefined) {
			
			var solveThisStep = eval('solver.s'+k).split(',');
			var flagP = true;
			var mas = [];
			for (i=0;i<solver.num;i++) {
				switch (solveThisStep[i].split('-')[1]) {
				
				case 'S' : {
					var trueStep = eval('solver.SR'+i).split('-');
					if ($.inArray(i.toString(), trueStepJSON)==-1) {
						
						flagDontTrue = false;
					} else {
						 // если правило вообще может быть правильным
						
						// если есть все факты
						if (checkTwoArray(trueStep[1].split(','),firstMem)) {
							estimate+=stepEstimate*plusEstimate[0];
							//если вершина указана правильно
							if (trueStep[0]==solveThisStep[solver.num].split('-')[1]) {
								estimate+=stepEstimate*plusEstimate[1];
							} else {
								
							}
							
						} else {
							
						}
						flagDontTrue = true;
					}
					stepUserVal++;
					mas.push(i); // Костыль надо заключить в if если считается правильным что выбрал правильное правило и указал правильно факт, когда было рано, а потом выбрал его снова.
					
					break;
				}
	
				case 'H' : {
					
					break;
					}
				
				case 'P' : {
					if ($.inArray(i, mas)==(-1)) {
						flagP = false;
					}
					
					break;
					}
				
				}
			}
			if (k==1) {flagP = false;}
			if (flagP==false) {
			 if (flagDontTrue) {
				estimate+=stepEstimate*plusEstimate[2];
			 }
			}
			
			if(solveThisStep[solver.num].split('-')[1]=='Not change') {} else {
				firstMem.push(solveThisStep[solver.num].split('-')[1]);
			}
		
				k++;
		}
	 global_estimate = Math.ceil(estimate);
 if(global_estimate>100) {global_estimate=100;}
	JSONstep+='"estimate":"'+global_estimate+'","stepUserCnt":"'+steps+'"';
	postToServer($('#user_id_now').val(),'','yes', global_estimate);
	userWantMiss=false;
	$('#set_block').fadeIn(200);
	alert('Ваша оценка  '+ global_estimate);
	
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

