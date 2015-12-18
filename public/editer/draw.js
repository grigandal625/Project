/**
 * @author Victor Potapov
 * @date 2014
 * @version 4.0.1
 */

var draw = {
    setsTree: {
        "paddingst": 80,
        "padding": 80,
        "lvlleft": 50,
        "lvlchange": 470,
        "outrule": 70,
        "radiusfactx": 190,
        "radiusfacty": 40,
        "paddingCircle":40,
        "radiusCircle":18
    },
    tree: function (id) {
        	/* Параметры для прорисовки */
	var padding_st = this.setsTree.paddingst;
	//const отступа
	var padding = this.setsTree.padding;
	//Отступ между объекатми сверху
	var lvl_left = this.setsTree.lvlleft;
	//Отступ от объектов слева
	var lvl_change = this.setsTree.lvlchange;
	//Отступ между уровнями
	var out_rule = this.setsTree.outrule;
	// Отступ вилки с правилом от уровня
	var radius_facty = this.setsTree.radiusfacty;
	
	var width_holder = (KB.depth+1) * lvl_change - 200;
	// Ширина рабочего полотна
	var countStr = 1; // Находим наибольшее количество строк в элементах(ширина элемента = 25 символов)
	            for (var k=0;k<KB.data[KB.maxElementLvl].length;k++) {
	            	var c = 1;
	            	while (KB.data[KB.maxElementLvl][k].length/25>c) {
	            	    c++;
	            	}
	            	if (c>countStr) {
	                    countStr = c;
	                }
	            }
	var height_holder = KB.maxElement * padding_st * (countStr/8 + 7/8) + padding_st;
	// Высота рабочего полотна
	// Рисуем холст - рабочую область
	document.getElementById(id).style.width = width_holder + 'px';
        document.getElementById(id).style.height = height_holder + 'px';
	document.getElementById(id).innerHTML = '';
	r = Raphael(id, width_holder, height_holder);
        
        /*
         * 
         *  Отрисовка фактов и подписей
         */
        var facts = r.set();
        var labels = r.set();
        this.facts.cacheName = [];
        for (var i=KB.depth;i!==-1;i--)
        {
            if (i<KB.depth) {
                lvl_left+= lvl_change;
                padding = padding_st;
                KB.ruleNumberCounter+=1;
            } 
             
            // Определяем высоту прямоугольника(на сколько строк)
	            var countStr = 1;
	            for (var k=0;k<KB.data[i].length;k++) {
	            	var c = 1;
	            	while (KB.data[i][k].length/25>c) {
	            	    c++;
	            	}
	            	if (c>countStr) {
	                    countStr = c;
	                }
	            }
				
	            padding = height_holder/2 - (KB.data[i].length * padding_st * (countStr/8 + 7/8)+ padding_st)/2 + padding_st/2 ;
	                
	            for (var k=0;k<KB.data[i].length;k++) {
                                var name = KB.data[i][k];
	                        this.facts.style.title = KB.data[i][k];

	                        this.facts.labelStyle.title = KB.data[i][k];
				facts.push(r.rect(lvl_left, padding, this.setsTree.radiusfactx + 40,radius_facty*(countStr/3+2/3), 5).attr(this.facts.style));
				var sepText = '0';
				sepText = KB.data[i][k];
				// Расстановка переносов строк
				var c = 0;
				var cc =sepText.length/25;
				while (cc>c+1) {
	            	            sepText= sepText.substring(0,(c+1)*25+c*3) +'- \n' + sepText.substring((c+1)*25+c*3,sepText.length);
	            	            c++;
	            	        }
	                        labels.push(r.text(lvl_left+this.setsTree.radiusfactx/2 , padding + this.setsTree.radiusfacty*(countStr/3+2/3)/2, sepText).attr(this.facts.labelStyle));
	                        
                                this.facts.cacheName.push(KB.data[i][k]);
				
                                padding += padding_st*(countStr/8+7/8);
			}
	        }
	        this.facts.cache = facts;
	        
	        this.facts.cacheL = labels;
        
        
        
        /*
         * 
         * Отрисовка линий
         */
        var line = r.set();
        var circleLine = r.set();
        for (var key in KB.rules) {
            if (key!=='length')
            {
            var rule = KB.rules[key];
            rule.raphael = new Object;
            
            rule.raphael = [];
            var rnode = this.facts.findOnPaper(rule.node);
            var xStart,yStart,xFinish,yFinish = 0;
            xFinish = rnode.attrs.x -this.setsTree.paddingCircle;
	        yFinish = rnode.attrs.y+rnode.attrs.height/2;
            var allLineThisRule = r.set();
            if (rule.notCreate) {
                
            } else {
               
                
                
                



                for (var _i=0;_i<rule.children.length;_i++) {
                    var s = rule.children[_i];
                    var rchild = this.facts.findOnPaper(rule.children[_i]);
                    xStart = rchild.attrs.x+this.setsTree.radiusfactx+40;
	            	yStart = rchild.attrs.y+rchild.attrs.height/2;
                    var lr = r.path("M" + xStart + " " + yStart + "L" + xFinish + " " + yFinish).attr(this.line.style);
                    line.push(lr);
                    rule.raphael.push(lr);
                    allLineThisRule.push(lr);
                }
            }
            
            /*
             * Рисуем стрелку с указателем и кружок
             */
            var lrpoint = r.path("M" + xFinish + " " + yFinish + "L" + (xFinish+this.setsTree.paddingCircle) + " " + yFinish).attr(this.line.stylePointed);
	            line.push(lrpoint);
	             allLineThisRule.push(lrpoint);
	             rule.raphael.push(lrpoint);
	             var circle = r.circle(xFinish, yFinish, this.setsTree.radiusCircle).attr(this.line.circleStyle);
	             labels.push(r.text(xFinish, yFinish, "R"+key+'\n'+KB.rules[key].startPower.toString()).attr(this.facts.labelStyle));
	             var circ = r.circle(xFinish, yFinish, this.setsTree.radiusCircle).attr(this.line.circStyle); //Прозрачный кружок, на него навешиваются обработчики действий. Таким образом нельзя навести курсор на надпись
	             circ._allLine = allLineThisRule;
	             circ._rule = rule;
	             circ._type = 'circle';
	             rule.raphael.push(circ);
	             rule.raphael.push(circle);
	             allLineThisRule = [];
	             allLineThisRule = r.set();
	            circleLine.push(circ);
	            circleLine.push(circle);
	            }
        }
        
        this.line.handlers(circleLine);
        this.facts.handlers(facts);
        $.jGrowl('Модель построена',3000);
        $('#first_step').fadeOut();
        $('#step_second').fadeIn();
        
    },
    facts: {
        style: {

                fill : "#3b3b3b",
                stroke : "none",
                //"stroke-dasharray" : ".",
                //opacity : 0.2
        },
        styleSelect: {
            fill : "#669933",
                stroke : "none",
                //"stroke-dasharray" : ".",
                //opacity : 0.2
        },
        labelStyle: {
                'font-size' : "13px",
                'font-family': "DINPro Regular",
                fill : "#fff"
        },
        handlers: function(factSet) {
            factSet.click(function() {
                if (KB.nowEditRule) {
                    if (this.attrs.fill==draw.facts.styleSelect.fill) {
                      
                            var t = this.attrs.title;
                            draw.facts.style.title = t;
                            functions.deleteValFromArray(t,KB.nowEditRuleChildren);

                            this.attr(draw.facts.style);
                        
                    } else {
                    
                            var t = this.attrs.title;
                            draw.facts.styleSelect.title = t;
                            KB.nowEditRuleChildren.push(t);

                            this.attr(draw.facts.styleSelect);
                            
                        
                    }
                }
            });
            factSet.hover(
                    function() {
                         if (KB.nowEditRule) {
                             this.attr({cursor:"pointer"});
                         }
                    },
                    function() {
                    if (KB.nowEditRule) {
                             this.attr({cursor:""});
                         }
                    });
        },
        findOnPaper: function(factName) {
            var a = factName;
            for (var l=0;l<draw.facts.cache.items.length;l++)
            {
                var need = draw.facts.cache.items[l];
                if (a==need.attrs.title) {
                    return need; break;
                }
            }
        },
        redraw: function(factName) {
            if (!factName.splice)
                this.redraw([factName]);
            for(var _k=0;_k<factName.length;_k++)
            {
                var a = draw.facts.findOnPaper(factName[_k]);
                draw.facts.styleSelect.title = a.attrs.title;
                a.attr(draw.facts.styleSelect);
                
            }
            
        },
        redrawStart: function(factName) {
            if (!factName.splice)
                this.redraw([factName]);
            for(var _k=0;_k<factName.length;_k++)
            {
                var a = draw.facts.findOnPaper(factName[_k]);
                draw.facts.styleSelect.title = a.attrs.title;
                a.attr(draw.facts.style);
                
            }
        },
        setStandart: function(factsNames) {
            var factName = factsNames;
            if (!factName.splice)
                this.setStandart([factName]);
            for(var _k=0;_k<factName.length;_k++)
            {
                var a = draw.facts.findOnPaper(factName[_k]);
                draw.facts.style.title = a.attrs.title;
                a.attr(draw.facts.style);
            }
        }
    },
    
    line: {
       style : {
                fill : '#3b3b3b',
                stroke : '#3b3b3b',

                "stroke-width" : 2
        },
        activeStyle: {
            'fill' : "#669933",
            'stroke':'#669933','stroke-width':4
        },
        canStartStyle: {
            'fill' : "#d1d100",
            'stroke':'#d1d100','stroke-width':3
        },
        stylePointed: {
            fill : '#3b3b3b',
                stroke : '#3b3b3b',
                "arrow-end" : "block-medium-medium",
                "stroke-width" : 2
        },
        circleStyle : {
            fill : "#3b3b3b",
            stroke : '#3b3b3b'
            //stroke : "#fff",
            //"stroke-dasharray" : ".",
           // opacity : .95,
        },
        circStyle : {
            fill : "#cccccc",
            opacity : .01,
            cursor : "pointer"
        },
        circleStyleActive : {
            fill : "#FF0000",
            stroke : "#fff",
            "stroke-dasharray" : ".",
            opacity : .95,
            cursor : "pointer"
        },
        setActiveAttr: function(rObj){
            
            for (var _k=0;_k<rObj.length;_k++){
                var need = rObj[_k];
                need._saveRoute = true;
                need.attr(this.activeStyle);
            }
            return rObj;
            
        },
        setStandartAttr: function (r) {
            for (var _k=0;_k<r.length;_k++){
                var need = r[_k];
                for (var i=0;i<need.length;i++)
                {
                    if (need[i]._type!=='circle') {
                        
                        need[i].attr(this.style);
                    } 
                     else {
                         need[i]._clickActive = false;
                         need[i]._saveRoute = false;
                         need[i].attr(this.circleStyle);
                     }
                }
                
            }
        },
        handlers: function(circleSet) {
            var c = circleSet;
            
            c.hover(function() {
                this._clickActive = false;
                var need = this._allLine;
                for (var m = 0;m<need.items.length;m++)
                {
                    need.items[m].stop().animate({'stroke':'#d1d100','stroke-width':5},200,"<");
                }
               
            },
            function() {
               if (this._clickActive) return;
                var need = this._allLine;
                for (var m = 0;m<need.items.length;m++)
                {
                    if (this._saveRoute)
                        need.items[m].stop().animate(draw.line.activeStyle,200,">");
                        else if (this._canStart)
                        need.items[m].stop().animate(draw.line.canStartStyle,200,">");
                        else
                    need.items[m].stop().animate({'stroke':'#3b3b3b','stroke-width':2},200,">");
                }
            });
            
            c.click(function() {
//                console.log(this);
                if (KB.nowEditRule) {
                    if (this._rule.number==KB.nowEditRuleNum) {
                        $.jGrowl("Редактирование правила R"+KB.nowEditRuleNum+" завершено",3000);
                        var newF=prompt('Коэффициент определенности для правой части правила R'+KB.nowEditRuleNum,this._rule.startPower);
                            if (newF==null||newF=='') {

                            } else {
                                this._rule.startPower = newF;
                            }
                        KB.nowEditRule = false;
                        KB.nowEditRuleNum = -1;
                        this.attr(draw.line.circleStyle);
                        this._rule.children = KB.nowEditRuleChildren.concat();
                        this._rule.notCreate = false;
                        draw.facts.redrawStart(draw.facts.cacheName);
                        
                        draw.tree('holder');
                        
                    } else {
                       $.jGrowl("Вначале закончите редактирование правила R"+KB.nowEditRuleNum,3000);
                     
                    }
                } 
                else {
                    this.attr(draw.line.canStartStyle);
                    $.jGrowl("Редактирование правила.<br/><b>Нажимайте на факты, которые принадлежат левой части правила</b>",4900);
                    this._clickActive = true;
                    KB.activeRuleSVG = this;
                    
                    /*var need = this._allLine;
                    for (var m = 0;m<need.items.length;m++)
                    {
                        need.items[m].attr({'stroke':'#FF0000','stroke-width':8});
                    }*/
                    KB.nowEditRule = true;
                    KB.nowEditRuleNum = this._rule.number;
                    KB.nowEditRuleChildren = this._rule.children.concat();
                    if (KB.nowEditRuleChildren.length!==0) {
                        draw.facts.redraw(KB.nowEditRuleChildren);
                    }
                }
                
            });
            
            
        }
    }
    
}


