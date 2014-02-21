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

function onMouseOver(e)
{
	if(dragging.state && (e.target.tagName == 'DIV'))
	{
		e.target.className = "BNFline BNFlineHighlighted";
	}
}

function onMouseOut(e)
{
	if((e.target.tagName == 'DIV'))
		e.target.className = "BNFline";
}

function onMouseMove(e)
{
	e = fixEvent(e);
	if(dragging.state)
	{
		dragging.div.style.left = e.pageX + 10;
		dragging.div.style.top = e.pageY + 10;
	}
	document.getElementById('debug').innerHTML = JSON.stringify({x : e.pageX, y : e.pageY});
}

function deleteLine(id)
{
	document.getElementById("BNFconstruct").removeChild(document.getElementById(id));
	//document.getElementById(id).hidden = true;
	bnfContent.lines[id].state = "deleted";
}

function dropElement(e)
{
	if(!dragging.state)
		return;
	var line = e.target;
	if(!line.id.match(/\d/))
	{
		return false;
	}
	var flag = false;
	if(bnfContent.lines[line.id].left == null)
	{
		flag = true;
		line.innerHTML = '<img alt="Удалить" title="Удалить строку" src="cross-icon.png" class="deleteIcon" onclick="deleteLine(' + line.id + ')" />';
		bnfContent.lines[line.id].left = dragging.element;
		bnfContent.lines[line.id].rules.push([]);
		bnfContent.lines[line.id].state = "filled";
		addBNFLine();
	}
	else
	{
		bnfContent.lines[line.id].rules[0].push(dragging.element);
	}
	var newEl = document.createElement('span');
	newEl.className = "BNFelement";
	newEl.innerHTML = dragging.element;
	line.appendChild(newEl);
	dragging.state = false;
	bnfDiv.removeChild(dragging.div);
	if(flag)
	{
		line.innerHTML += " ::= ";
	}
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
	bnfContent.lines.push({left : null, state : "empty", rules : []});
	newLine.innerHTML = '<span class="newLine" >Перетащите элемент сюда для создания нового правила</span>';
}

function initBNF(elementsList, bnfOuterDiv)
{
	bnfDiv = bnfOuterDiv;
	bnfDiv.className = "BNFeditor";
	var elementsDiv = document.createElement('div');
	elementsDiv.innerHTML = '<span>Выберите элемент из списка</span><br/>';
	var bnfConstructDiv = document.createElement('div');
	for(var el in elementsList)
	{
		elementsDiv.innerHTML += '<span class="BNFelement" style="float: left;" onmousedown="startDragElement(this)">' + elementsList[el] + '</span>';
	}
	bnfConstructDiv.id = "BNFconstruct";
	elementsDiv.id = "elements";
	bnfDiv.appendChild(elementsDiv);
	bnfDiv.appendChild(bnfConstructDiv);
	addBNFLine();
}
