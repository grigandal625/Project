/**
 * @author Victor Potapov
 * @date 2014
 * @version 4.0.1
 */
window.onbeforeunload = function() {
  return "Данные не сохранены. Точно закрыть страницу?";
};
var solverR = {
    memOnStep: [],
    memStartRule:[],
    conflictStek: [],
    solver: new Object,
    solverCount: 0,
    steckGoals: [],
    steckRule: [],
    checkRule: [],
    
    plus: {
        Rule:0.5,
        Memory:0.3,
        UsedRules:0.2,
        Goal:1.0
    },
    start: false,
    check: function() {
    	if (!this.start) {
    		functions.timer(480);
    		this.start=true;
    	}
        var s = [],g=[];
	$('#select_fact input:checked').each(function(indx, element) {
		s.push($(this).val());
	});
        $('#goal_select input:checked').each(function(indx, element) {
		g.push($(this).val());
	});
        if (s.length==0) {
		$.jGrowl('Начальное состояние не может быть пустым.<br /><br />Выбирайте правильно начальное состояние памяти. Этот шаг вернуть <b>невозможно</b>', {
			life : 5000,
			header : 'Оповещание эксперта'
		});
	} else {
            if (g.length==0) {
                $.jGrowl('Выберите основную цель', {
			life : 3000,
			header : 'Оповещание эксперта'
		});
            } else {
                KB.steckSubGoal = g.concat();
                KB.firstGoal = g.concat();
		KB.firstMemory = s.concat();
                KB.fullMemory = s;
                var ss =this.solve();
                 if (ss.badGoal) {
                    $.jGrowl('Данная цель не достижима');
                } else {
                    if (ss.length<7) {
                        $.jGrowl('Слишком мало шагов');
                    }
                    else {
                
               
                        draw.facts.redraw(KB.firstMemory);
                        draw.facts.goalDraw(KB.steckSubGoal);
                        $('#step_second').fadeIn();
                        $('#first_step').fadeOut();
                        $('#select_div').fadeOut();
                        $('#select_div_msg').slideUp();

                        $('#fact_select').text('Выберите изменение РП');
                        $('#rule_select').text('Выберите состояние правил');

                        $("#button_div").html('<input type="button" class="button_generate" style="margin:20px;" value="Отмена" onClick="functions.cancelSituation();" /> <input type="button" class="button_generate" style="margin:20px;" value="Готово" onClick="functions.selectSituation();" />');
                        }
                }
		}
            }
	
    },
    estimate: function() {
        var solution = this.solve();
        var userTrace = KB.memoryStep;
        var estimate = 0;
        
        if (solution.badGoal) {
            $.jGrowl('Данная цель недостижима',3000);
        } else {
        for (var k=1;k<=solution.length;k++)
        {
            if (userTrace[k-1]){
                if (solution[k].selectGoal) {
                    if (userTrace[k-1].subGoal) {
                        if (solution[k].selectGoal==userTrace[k-1].subGoal)
                            {
                                estimate+=this.plus.Goal;
                            }
                     }
                } else {
                        if (solution[k].selectrule==userTrace[k-1].activeRules[0]) {
                            estimate+=this.plus.Rule;
                        }
                        if (functions.equalArray(userTrace[k-1].checkRules,solution[k].selectedRules)) {
                            estimate+=this.plus.UsedRules;
                        }
                        if (userTrace[k-1].memory[0]==solution[k].selectrule.node) {
                            estimate+=this.plus.Memory;
                        }
                    }
            } else {
                break;
            }
        
        }
        var count = (estimate/solution.length)*100;
        return {e:count,obj:solution};
        //alert(Math.round(count));
    }
    },
    solve: function() {
        /*
         * 
         */
        this.solveInit();
        
        this.memOnStep =  KB.firstMemory.concat();
        this.steckSubGoal = KB.firstGoal.concat();
        this.nowNeedRule = this.findRuleFromGoal(this.steckSubGoal);
        this.steckGoals = KB.firstGoal.concat();
        this.steckRule.push(this.nowNeedRule);
        this.solver = new Object;
        this.solveReverse(this.nowNeedRule);
        
       
        return this.solver;
    },
    solveInit: function() {
       
        this.steckRule=[];
        this.checkRule=[];
        this.solverCount = 0;
    },
    solveReverse: function(rule) {
         this.solverCount++;
         var r = rule;
         if ($.inArray(r,this.steckRule)==-1) {
         this.steckRule.push(rule);
     }
         if (this.ruleCanUsed(rule)) {
            
                this.solver[this.solverCount] = {
                    selectrule: rule,
                    selectedRules: this.checkRule.concat()
                    
                }
                this.memOnStep.push(rule.node);
                this.steckGoals.pop();
                this.steckRule.pop();
                this.steckRule.pop();
                this.checkRule.push(rule);
                this.solver.length=this.solverCount;
                if (this.steckGoals.length!=0) {
                    if (this.steckRule.length!=0)
                this.solveReverse(this.steckRule[this.steckRule.length-1]);
                else {this.solveReverse(this.nowNeedRule)}
            } else {return;}
          } else {
              var n = this.getMaxPowerRule(this.conflictRule(rule));
              if (n==undefined) {
                  /*
                   * Если недостижима цель
                   */
                  this.solver.badGoal = true;
                  return;
              }
              
              if ($.inArray(n.node,this.steckGoals)==(-1)) {
//              if (this.solver[this.solverCount-1].selectGoal==n.node)
              this.solver[this.solverCount] = {
                    selectGoal: n.node,
                    steck: this.steckGoals.concat(),
                    
                  }
                this.steckGoals.push(n.node);
            } else {this.solverCount--;}
            
              this.solver.length=this.solverCount;
              this.solveReverse(n);
          }
      
    },
    ruleCanUsed: function(rule) {
        if (functions.checkTwoArray(rule.children,this.memOnStep)) {
            return true;
        } else {
            return false;
        }
    },
    conflictRule: function(rule) {
        var c = [];
        for (var key in KB.rules) {
            if (KB.rules[key]!='length') {
                if ($.inArray(KB.rules[key].node,rule.children)!==-1) {
                    if ($.inArray(KB.rules[key].node,this.memOnStep)==(-1)) {
                        c.push(KB.rules[key]);
                    } else {
                         
                 }
                }
            }
        }
        return c;
    },
    getMaxPowerRule: function(arRules) {
        var need=arRules[0];
        for (var k=0;k<arRules.length-1;k++)
        {
            if (arRules[k].weakening<arRules[k+1].weakening) {
                need = arRules[k+1];
            }
        }
        return need;
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
            checkedRule: functions.refactorArray(this.memStartRule)
            
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
        if (functions.checkTwoArray(rule.children,this.memOnStep)) {
            this.conflictStek.push(rule); return true;
        }
        return false;
    },
    findRuleFromGoal: function(goal) {
        for (var key in KB.rules) {
            if (key!='length') {
                if (KB.rules[key].node==goal) {
                    return KB.rules[key];break;
                }
            }
        }
    }
}

