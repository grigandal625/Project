import React from "react";
import "rc-tree-select/assets/index.css";
import TreeSelect from "rc-tree-select";
import Cookies from "universal-cookie";
import { useState, useEffect } from "react";
import { Spinner } from "react-bootstrap";

const prepareData = (node) => {
    node.label = node.text;
    node.value = node.id;
    node.children ? node.children.forEach((child) => prepareData(child)) : null;
};

const loadVertexes = async (setVertexes) => {
    let cookies = new Cookies();
    let response = await fetch("/ka_topics/full_tree", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setVertexes(data);
};

export default ({ value, setter }) => {
    const [vertexes, setVertexes] = useState(null);
    useEffect(() => {
        loadVertexes(setVertexes);
    }, []);
    const data = vertexes;
    if (data) {
        data.forEach((v) => prepareData(v));
    }
    return (
        <div>
            {data ? (
                <TreeSelect
                    multiple
                    allowClear
                    treeData={data}
                    onChange={(e) => setter(e)}
                    selectionMode="multiple"
                    style={{ width: "100%" }}
                    transitionName="rc-tree-select-dropdown-slide-up"
                    choiceTransitionName="rc-tree-select-selection__choice-zoom"
                    dropdownStyle={{ maxHeight: 200, overflow: "auto", zIndex: 500 }}
                    treeNodeFilterProp="label"
                />
            ) : (
                <Spinner />
            )}
        </div>
    );
};
