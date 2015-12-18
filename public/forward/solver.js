/**
 * @author Victor Potapov
 * @date 2014
 * @version 4.0.1
 */
window.onbeforeunload = function() {
  return "Данные не сохранены. Точно закрыть страницу?";
};
var solverF = {
    memOnStep: [],
    memStartRule:[],
    conflictStek: [],
    solver: new Object,
    solverCount: 0,
    plus: {
        Rule:0.5,
        Memory:0.3,
        UsedRules:0.2
    },
    start:false,
    check: function() {
    	if (!this.start) {
    		functions.timer(420);
    		this.start=true;
    	}
        var s = [];
	$('#select_fact input:checked').each(function(indx, element) {
		s.push($(this).val());
	});
        if (s.length==0) {
		$.jGrowl('Начальное состояние не может быть пустым.<br /><br />Выбирайте правильно начальное состояние памяти. Этот шаг вернуть <b>невозможно</b>', {
			life : 5000,
			header : 'Оповещание эксперта'
		});
	} else {
		KB.firstMemory = s.toString().split(',');
                KB.fullMemory = s;
                var s = this.solve();
                if (s.length<7) {
                    $.jGrowl('Мало шагов вывода. Должно быть не меньше 7',3000);
                    KB.firstMemory = [];
                    KB.fullMemory = [];
                } else {
                draw.facts.redraw(KB.firstMemory);
                $('#step_second').fadeIn();
                $('#first_step').fadeOut();
                $('#select_div').fadeOut();
                $('#select_div_msg').slideUp();
               
                $('#fact_select').text('Выберите изменение РП');
                $('#rule_select').text('Выберите состояние правил');
               
                $("#button_div").html('<input type="button" class="button_generate" style="margin:20px;" value="Отмена" onClick="functions.cancelSituation();" /> <input type="button" class="button_generate" style="margin:20px;" value="Готово" onClick="functions.selectSituation();" />');
            }
		}
	
    },
    estimate: function() {
        var solution = this.solve();
        var userTrace = KB.memoryStep;
        var estimate = 0;
        
        for (var k=1;k<=solution.length;k++)
        {
            if (userTrace[k-1]){
                if (solution[k].selectrule==userTrace[k-1].activeRules[0]) {
                    estimate+=this.plus.Rule;
                }
                if (functions.equalArray(userTrace[k-1].checkRules,solution[k].checkedRule)) {
                    estimate+=this.plus.UsedRules;
                }
                if (userTrace[k-1].memory[0]==solution[k].selectrule.node) {
                    estimate+=this.plus.Memory;
                }
            } else {
                break;
            }
        }
        var count = (estimate/solution.length)*100;
        return {e:count,obj:solution};
        alert(Math.round(count));
    },
    solve: function() {
        /*
         * 
         */
        this.memOnStep =  KB.firstMemory.concat();
        this.solverCount = 0;
        this.memStartRule = [];
        for (var i=KB.rules.length;i>0;i--)
        {
            this.solverCount++;
            var conflict = this.searchTrueRule();
            if (conflict==false) {
                if (this.solverCount==1) {
                    this.solver.length = 0;
                }
                break;
            } else 
            this.solveConflict(conflict);
            this.solver.length = this.solverCount;
        }
        return this.solver;
    },
    solveConflict:function(confSituation) {
        var c = confSituation;
        var needRule = c[0];
        for (var t=0;t<c.length;t++)
        {
            if (needRule.weakening<c[t].weakening)
            {
                needRule = c[t];
            }
        }
        
        this.memOnStep.push(needRule.node);
        this.solver[this.solverCount] = {
            selectrule: needRule,
            checkedRule: this.memStartRule.concat()
            
        }
        this.memStartRule.push(needRule);
        
    },
    searchTrueRule: function() {
        var conf = [];
        for (var j=KB.rules.length;j>0;j--)
        {
            
            if (this.ruleCanStart(KB.rules[j]) && $.inArray(KB.rules[j],this.memStartRule)==-1)
            {
                conf.push(KB.rules[j]);
            }
        }
       if (conf.length==0) {
           return false;
       } else  
        return conf;
    },
    ruleCanStart: function(rule) {
        var obj = new Object;
        this.conflictStek = [];
        if (functions.checkTwoArray(rule.children,this.memOnStep)) {
            this.conflictStek.push(rule); return true;
        }
        return false;
    }
}

