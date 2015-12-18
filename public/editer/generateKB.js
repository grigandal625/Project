/**
 * @author Victor Potapov
 * @date 2014
 * @version 4.0.1
 */

 var KB = {
		 count: 0,
		 randomVal: 3,
                 depth: 0,
		 data: [
		        	["Покупка эконом", "Покупка бизнес", "C"],["D", "E", "F", "G", "H"], ["I", "J", "K", "L", "M", "N", "O"],
                                ["P", "Q", "R", "S", "T", "U"], ["Y", "W", "X", "Z", "AA", "AB", "AC"],
		        	["AD", "AF", "AE", "AG", "AH", "AI"]
		        ],
		 rules: new Object,
                 memoryStep: [],
                 fullMemory: [],
                 counterSteps: 0,
                 activeRuleSVG: new Object,
                 editNow: false,
                 editPosition: 0,
                 powers:[],
                 ruleNumberCounter:0,
                 nowEditRule: false,
                 nowEditRuleNum: -1,
                 nowEditRuleChildren: [],
		 generate: function(id) {
			 var output = '';
			 var counter = 0;
                         /*
                          *  Считывание параметров базы
                          */
			 this.depth = parseInt(document.getElementById('level_style').value);
                          this.maxElements();
                         this.powers = [];
                         document.getElementById(id).value = '';
			 for (var i=0;i<this.depth;i++)
				 {
				 	for (var k=0;k<this.data[i].length;k++)
				 		{
                                                    counter++;
                                                    var now_val = this.data[i][k];
                                                    this.rules[counter] = new Object;
                                                    this.rules[counter].node = now_val;
                                                    this.rules[counter].children = this.getChildrenWithoutRepeat(i,k);
                                                    this.rules[counter].startPower = functions.randomFloatNotRepeat(0.0,1.0);
                                                }
				 	
				 }
                             
                         for ( var t in this.rules)
                            {
                                var rule = this.rules[t];
                                
                                var and = '';
                                for (var _t=0;_t<rule.children.length;_t++)
                                {
                                    if (_t==rule.children.length-1)
                                    {
                                        and+=rule.children[_t];
                                    } else {
                                        and+=rule.children[_t]+' and ';
                                    }
                                }
                                
                               
                                output+='if '+and+' then '+rule.node+' : ['+rule.startPower+'];\n';
                            }
                           
			 document.getElementById(id).value = output;
		 },
                 save: function(id,svgid) {
                     var s = $('#'+id).val().split(';');
                     var refactorRules = []; 
                     for (var i=0;i<s.length-1;i++)
                     {
                         var _then = s[i].split('if')[1];
                         var and = _then.split('then')[0].split(' and ').toString().replace(' ','','gi').replace(' ','','gi').split(',');
                         var then = _then.split('then ')[1].split(' : ')[0];
                         var power = _then.split('then ')[1].split(' : ')[1].slice(1,-1);
                         refactorRules.push({node: then, children:[], startPower: power});
                         
                     }
                     for ( var t in this.rules)
                     {
                         this.rules[t].node = refactorRules[t-1].node;
                         this.rules[t].children = refactorRules[t-1].children;
                         this.rules[t].startPower = parseFloat(refactorRules[t-1].startPower);
                         this.rules[t].number = parseInt(t);
                         this.rules.length = t;
                     }
                     
                     draw.tree(svgid);
                     
                 },
                 getChildrenWithoutRepeat: function(numberArray,numberInArray) {
                     var a = numberArray;
                     var b = numberInArray;
                     var c = functions.random(2,this.randomVal);
                     var g = [];
                     for (var n=0;n<c;n++)
                     {
                         
                         var h = this.data[a+1][functions.random(0,this.data[a+1].length-1)];
                         if (g.length==0) {
                              g.push(h);
                         } else {
                         var element = h;
                        var idx = g.indexOf(element);
                        while (idx != -1) {
                          h = this.data[a+1][functions.random(0,this.data[a+1].length-1)];
                          element = h;
                          idx = g.indexOf(element);
                        }
                         
                         g.push(h);
                     }
                     }
                     return g;
                 },
                 maxElements: function() {
                     var max = this.data[0].length;
                     var lvl;
                     for (var kk=0;kk<this.data.length-1;kk++) {
                         if (max<this.data[kk+1].length) {
                             max = this.data[kk+1].length;
                             lvl = kk+1;
                         }
                     }
                     this.maxElement = max;
                     this.maxElementLvl = lvl;
                 },
                 reloadMemory: function() {
                     this.ruleNumberCounter = 0;
                     KB.nowEditRule = false;
                     this.maxElements();
                     this.reloadRulesValue();
                     
                    
                 },
                 reloadRulesValue: function() {
                     var newRule = new Object;
                     for (var i=0;i<(KB.depth);i++)
                        {
                           
                            for (var k=0;k<KB.data[i].length;k++) {
                                 KB.ruleNumberCounter+=1;
                                 var check = this.findRuleByNode(KB.data[i][k]);
                                        if (check.flag) {
                                            newRule[KB.ruleNumberCounter] = check.rule;
                                        } else {
                                            newRule[KB.ruleNumberCounter] = new Object;
                                            newRule[KB.ruleNumberCounter].notCreate = true;
                                            newRule[KB.ruleNumberCounter].node = KB.data[i][k];
                                            newRule[KB.ruleNumberCounter].startPower = 0.0;
                                            newRule[KB.ruleNumberCounter].number = parseInt(KB.ruleNumberCounter);
                                            newRule[KB.ruleNumberCounter].children = [];
                                            
                                        }
                                }
                        }
                     newRule.length = KB.ruleNumberCounter;
                     this.rules = newRule;
                     draw.tree('holder');
                     
                 },
                 findRuleByNode: function(node) {
                     for (var key in this.rules) {
                         if (this.rules[key].node==node) {
                             return {rule:this.rules[key],flag:true} ;break;
                         }
                     }
                     return {rule:undefined,flag:false};
                 },
                 buildKB: function(obj) {
                     this.depth = obj.depth;
                     for (var i=0;i<obj.data.length;i++)
                     {
                         this.data[i] = obj.data[i].concat();
                     }
                     for (var k=0;k<obj.rules.length;k++)
                     {
                         this.rules[k+1] = obj.rules[k];
                     }
                     this.maxElements();
                     draw.tree('holder');
                 }
                 
 }
