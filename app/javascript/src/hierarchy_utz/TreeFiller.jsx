import React, { useState } from "react";
import { Form, Button, InputGroup } from "react-bootstrap";

const getLinnear = (nodes = []) => {
    debugger;
    let linnear = nodes.map((e) => e);
    nodes.forEach((node) => {
        linnear = node.children
            ? linnear.concat(getLinnear(node.children))
            : linnear;
    });
    return linnear;
};

const TreeSelectNode = ({
    nodeData,
    options,
    selected,
    setSelected,
    handleAddChild,
    handleDelete,
}) => {
    const handleDeleteNode = () => {
        handleDelete(nodeData.id);
    };

    return (
        <div>
            <InputGroup className="mb-3">
                <Form.Select placeholder="Выберите новый элемент иерархии">
                    {options
                        .filter((e) => !selected.includes(e.id))
                        .map((v) => (
                            <option value={v.id}>{v.text}</option>
                        ))}
                </Form.Select>
                <Button
                    variant="outline-primary"
                    onClick={() => handleAddChild(nodeData.id)}
                >
                    Добавить дочерний элемент
                </Button>
                <Button
                    variant="outline-danger"
                    onClick={() => handleDeleteNode(nodeData.id)}
                >
                    Удалить элемент
                </Button>
            </InputGroup>
            <div style={{ paddingLeft: 50 }}>
                {nodeData.children.map((child) => (
                    <TreeSelectNode
                        options={options}
                        selected={selected}
                        setSelected={setSelected}
                        nodeData={child}
                        handleAddChild={handleAddChild}
                        handleDelete={handleDelete}
                    />
                ))}
            </div>
        </div>
    );
};

const TreeFiller = ({ actualNodes }) => {
    const [nodes, setNodes] = useState([
        {
            children: [],
            id: new Date().valueOf(),
        },
    ]);

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

    const options = getLinnear(actualNodes);
    console.log(options);

    const [selected, setSelected] = useState([]);

    return (
        <TreeSelectNode
            options={options}
            selected={selected}
            setSelected={setSelected}
            nodeData={nodes[0]}
            handleAddChild={handleAddChild}
            handleDelete={handleDelete}
        />
    );
};

export default TreeFiller;
