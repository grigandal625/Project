import React from "react";
import Cookies from "universal-cookie";
import "rc-tree-select/assets/index.css";
import TreeSelect from "rc-tree-select";
import { useState, useEffect } from "react";
import { Spinner, Form } from "react-bootstrap";

const prepareData = (node) => {
    node.label = node.text;
    node.value = node.id;
    node.children ? node.children.forEach((child) => prepareData(child)) : null;
};

const loadGroups = async (setGroups) => {
    let cookies = new Cookies();
    let response = await fetch("/groups/list", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setGroups(data);
};

export default ({ value, setter }) => {
    const [groups, setGroups] = useState(null);
    useEffect(() => {
        loadGroups(setGroups);
    }, []);

    return (
        <div>
            {groups ? (
                <TreeSelect
                    multiple
                    allowClear
                    treeData={groups.map((g) => Object({ value: g.id, label: g.number }))}
                    onChange={setter}
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