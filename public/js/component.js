function buildNode(node) {
    let nodeElem = document.createElement("div");
    let nodeLabel = document.createElement("span");
    nodeLabel.innerText = node.name + " (" + node.tag + ")";
    nodeElem.appendChild(nodeLabel);

    node.children.forEach((child) => {
        nodeElem.appendChild(buildNode(child));
    });

    return nodeElem;
}

tree.forEach((n) => document.getElementById("description").appendChild(buildNode(n)));
