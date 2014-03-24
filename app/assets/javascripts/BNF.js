var dragging = {state : false, element : "", div : null};
var bnfDiv;
var bnfContent = {lines : []};

function fixEvent(e)
{
	// получить объект событие для IE
	e = e || window.event;

	// добавить pageX/pageY для IE
	if ( e.pageX == null && e.clientX != null ) {
		var html = document.documentElement;
		var body = document.body;
		e.pageX = e.clientX + (html && html.scrollLeft || body && body.scrollLeft || 0) - (html.clientLeft || 0);
		e.pageY = e.clientY + (html && html.scrollTop || body && body.scrollTop || 0) - (html.clientTop || 0);
	}

	// добавить which для IE
	if (!e.which && e.button) {
		e.which = e.button & 1 ? 1 : ( e.button & 2 ? 3 : ( e.button & 4 ? 2 : 0 ) );
	}

	return e
}

function startDragElement(el)
{
	if(dragging.state)
	{
		bnfDiv.removeChild(dragging.div);
	}
	dragging.state = true;
	dragging.element = el.innerHTML;
	dragging.div = document.createElement('div');
	dragging.div.innerHTML = el.innerHTML;
	dragging.div.className = 'dragging';
	bnfDiv.appendChild(dragging.div);
	dragging.div.style.left = el.style.left;
	dragging.div.style.top = el.style.top;

	bnfDiv.onmousemove = onMouseMove;
}

function showNewRuleSpan(parentDiv)
{
	for(var rule in parentDiv.childNodes)
	{
		if(parentDiv.childNodes[rule].className == 'BNFnewRule')
		{
			parentDiv.childNodes[rule].hidden = false;
			parentDiv.childNodes[rule].style.opacity = 0.4;
		}
	}
}

function hideNewLineText(parentDiv, flag)
{
	for(var rule in parentDiv.childNodes)
	{
		if(parentDiv.childNodes[rule].className == 'newLine')
		{
			parentDiv.childNodes[rule].hidden = flag;
		}
	}
}

function onMouseOver(e)
{
	if(e.target.className == 'BNFeditor')
	{
		var lines = e.target.lastChild.childNodes;
		for(var line in lines)
		{
			lines[line].className = "BNFline";
			for(var rule in lines[line].childNodes)
			{
				if(lines[line].childNodes[rule].className == 'BNFnewRule')
				{
					lines[line].childNodes[rule].hidden = true;
				}
			}
		}
	}
	else if(dragging.state && 
			(e.target.className == 'BNFline' || e.target.className == 'BNFline BNFlineHighlighted'))
	{
		e.target.className = "BNFline BNFlineHighlighted";
		showNewRuleSpan(e.target);
		hideNewLineText(e.target, true);
	}
	else if(dragging.state && (e.target.className == 'BNFnewRule'))
	{
		e.target.hidden = false;
		e.target.style.opacity = 1;
		e.target.parentNode.className = "BNFline BNFlineHighlighted";
	}
	else if(dragging.state && e.target.className == 'BNFrule')
	{
		e.target.parentNode.className = "BNFline BNFlineHighlighted";
		e.target.className = 'BNFrule BNFruleHighlighted';
		showNewRuleSpan(e.target.parentNode);
	}
	else if(dragging.state &&
			e.target.className == 'BNFaddElement' &&
			e.target.parentNode.className == 'BNFrule')
	{
		showNewRuleSpan(e.target.parentNode.parentNode);
		e.target.parentNode.parentNode.className = "BNFline BNFlineHighlighted";
		e.target.parentNode.className = 'BNFrule BNFruleHighlighted';
	}
}

function onMouseOut(e)
{
	if((e.target.tagName == 'DIV'))
	{
		e.target.className = "BNFline";
		for(var rule in e.target.childNodes)
		{
			if(e.target.childNodes[rule].className == 'BNFnewRule')
			{
				e.target.childNodes[rule].hidden = true;
			}
		}
		hideNewLineText(e.target, false);
	}
	else if(e.target.className == 'BNFrule BNFruleHighlighted')
	{
		e.target.className = 'BNFrule';
	}
	else if(e.target.parentNode.className == 'BNFrule BNFruleHighlighted')
	{
		e.target.parentNode.className = 'BNFrule';
	}

}

function onMouseMove(e)
{
	e = fixEvent(e);
	if(dragging.state)
	{
		dragging.div.style.left = e.pageX + 10 + 'px';
		dragging.div.style.top = e.pageY + 10 + 'px';
	}
	//document.getElementById('debug').innerHTML = JSON.stringify({x : e.pageX, y : e.pageY});
}

function deleteLine(id)
{
	document.getElementById("BNFconstruct").removeChild(document.getElementById(id));
	//document.getElementById(id).hidden = true;
	//bnfContent.lines[id].state = "deleted";
	delete bnfContent.lines[id];
}

function addElementToRule(rule)
{
	var newEl = document.createElement('span');
	var lineN = rule.id.split(':')[0];
	var ruleN = rule.id.split(':')[1];
	var elN = bnfContent.lines[lineN].rules[ruleN].length;
	bnfContent.lines[lineN].rules[ruleN].push(dragging.element);
	newEl.innerHTML = dragging.element;
	newEl.className = 'BNFelement';
	newEl.id = lineN + ':' + ruleN + ':' + elN;
	var nextNewEl = document.createElement('span');
	nextNewEl.className = 'BNFaddElement';
	nextNewEl.innerHTML = '...';
	rule.removeChild(rule.lastChild);
	rule.appendChild(newEl);
	rule.appendChild(nextNewEl);
}

function fillNewLine(line)
{
	bnfContent.lines[line.id].left = dragging.element;
	bnfContent.lines[line.id].rules.push([]);
	//bnfContent.lines[line.id].state = "filled";

	line.innerHTML = '<span class="BNFelement" >' + dragging.element + '</span>';
	line.innerHTML += ' ::= ';
	line.innerHTML += '<span class="BNFrule" id="' + line.id + ':' + '0" >...</span><span class="BNFnewRule" >| + Вариант </span>';
	line.innerHTML += '<img alt="Удалить" title="Удалить строку" class="deleteIcon" onclick="deleteLine(' + line.id + ')" src="/cross-icon.png" />';

	addBNFLine();
}

function addNewRule(line, newRuleSpan)
{
	line.removeChild(newRuleSpan);
	var newRule = document.createElement('span');
	newRule.className = 'BNFrule';
	var ruleN = bnfContent.lines[line.id].rules.length;
	newRule.id = line.id + ':' + ruleN;
	newRule.innerHTML = '...';
	bnfContent.lines[line.id].rules.push([]);
	var stick = document.createElement('span');
	stick.className = 'BNFstick';
	stick.innerHTML = ' | ';
	line.appendChild(stick);
	line.appendChild(newRule);
	line.appendChild(newRuleSpan);
	addElementToRule(newRule);
}

function dropElement(e)
{
	if(!dragging.state)
		return;
	if(e.target.className == 'BNFelement')
	{
		var lineN = e.target.id.split(':')[0];
		var ruleN = e.target.id.split(':')[1];
		var elN = e.target.id.split(':')[2];
		bnfContent.lines[lineN].rules[ruleN][elN] = dragging.element;
		e.target.innerHTML = dragging.element;
	}
	else if(/(\d):(\d)/.test(e.target.id))
		addElementToRule(e.target);
	else if(/(\d)/.test(e.target.id) && (bnfContent.lines[e.target.id].left == null))
		fillNewLine(e.target);
	else if(e.target.className == 'BNFaddElement')
		addElementToRule(e.target.parentNode);
	else if(e.target.className == 'BNFnewRule')
		addNewRule(e.target.parentNode, e.target);
	else
		return;
	dragging.state = false;
	bnfDiv.removeChild(dragging.div);
}

function addBNFLine()
{
	var bnfConstruct = document.getElementById('BNFconstruct');
	var newLine = document.createElement('div');
	newLine.className = "BNFline";
	newLine.id = bnfContent.lines.length;
	newLine.onmouseup = dropElement;
	newLine.onmouseover = onMouseOver;
	newLine.onmouseout = onMouseOut;
	bnfConstruct.appendChild(newLine);
	bnfContent.lines[newLine.id] = {left : null, /*state : "empty",*/ rules : []};
	newLine.innerHTML = '<span class="newLine" >Перетащите элемент сюда для создания нового правила</span>';
}

function initBNF(elementsList, bnfOuterDiv)
{
	bnfDiv = bnfOuterDiv;
	var elementsDiv = document.createElement('div');
	elementsDiv.innerHTML = '<span>Выберите элемент из списка</span><br/>';
	var bnfConstructDiv = document.createElement('div');
	for(var group in elementsList)
	{
		var newDiv = document.createElement('div');
		newDiv.className = 'elementsSubDiv';
		for(var el in elementsList[group])
		{
			newDiv.innerHTML += '<span class="BNFelement" style="float: left;" onmousedown="startDragElement(this)">' + elementsList[group][el] + '</span>';
		}
		elementsDiv.appendChild(newDiv);
		elementsDiv.innerHTML += '<br/>';
	}
	bnfConstructDiv.id = "BNFconstruct";
	elementsDiv.id = "elements";
	bnfDiv.appendChild(elementsDiv);
	bnfDiv.appendChild(bnfConstructDiv);
	bnfDiv.className = 'BNFeditor';
	bnfDiv.onmouseover = onMouseOver;
	addBNFLine();
}
