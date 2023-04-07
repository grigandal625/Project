import React, { useState } from "react";
import { Form, Button, InputGroup } from "react-bootstrap";

const TreeNode = ({ nodeData, handleAddChild, handleDelete }) => {
    const [text, setText] = useState(nodeData.text);

    const handleTextChange = (e) => {
        setText(e.target.value);
        nodeData.text = e.target.value;
        setText(nodeData.text);
    };

    const handleDeleteNode = () => {
        handleDelete(nodeData.id);
    };

    return (
        <div>
            <InputGroup className="mb-3">
                <Form.Control value={text} placeholder={nodeData.placeholder ? nodeData.placeholder : "Введите новый элемент иерархии"} onChange={handleTextChange} />
                <Button variant="outline-primary" onClick={() => handleAddChild(nodeData.id)}>
                    Добавить дочерний элемент
                </Button>
                <Button variant="outline-danger" onClick={() => handleDeleteNode(nodeData.id)}>
                    Удалить элемент
                </Button>
            </InputGroup>
            <div style={{ paddingLeft: 50 }}>
                {nodeData.children.map((child) => (
                    <TreeNode key={child.id} nodeData={child} handleAddChild={handleAddChild} handleDelete={handleDelete} />
                ))}
            </div>
        </div>
    );
};

const TreeEditor = ({nodes, setNodes}) => {

    const findNodeById = (id, current = nodes[0]) => {
        if (current.id == id) {
            return current;
        } else {
            for (let i in current.children) {
                let child = current.children[i];
                let res = findNodeById(id, child);
                if (res) {
                    return res;
                }
            }
        }
    };

    const getParentByChildId = (id, current = nodes[0]) => {
        for (let i in current.children) {
            if (current.children.map((n) => n.id).includes(id)) {
                return current;
            }
            for (let i in current.children) {
                let res = getParentByChildId(id, current.children[i]);
                if (res) {
                    return res;
                }
            }
        }
    };

    const handleAddChild = (id = null) => {
        const nodeId = new Date().valueOf();
        const newNode = {
            id: nodeId,
            text: "",
            children: [],
        };

        if (id) {
            const node = findNodeById(id);
            node.children.push(newNode);
        } else {
            nodes[0].children.push(newNode);
        }

        setNodes([...nodes]);
    };

    const handleDelete = (id) => {
        let parent = getParentByChildId(id);
        if (parent) {
            parent.children = parent.children.filter((n) => n.id != id);
        }
        setNodes([...nodes]);
    };

    return <TreeNode nodeData={nodes[0]} handleAddChild={handleAddChild} handleDelete={handleDelete} />;
};

export default TreeEditor;
