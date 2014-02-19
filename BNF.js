function startDragElement()
{
}

function initBNF(elementsList, bnfDiv)
{
	var elementsDiv = document.createElement('div');
	var bnfConstructDiv = document.createElement('div');
	for(var el in elementsList)
	{
		elementsDiv.innerHTML += '<div onmousedown="startDragElement">' + elementsList[el] + '</div>';
	}
	bnfConstructDiv.id = "BNFconstruct";
	elementsDiv.id = "elements";
	bnfDiv.appendChild(elementsDiv);
	bnfDiv.appendChild(bnfConstructDiv);
}
