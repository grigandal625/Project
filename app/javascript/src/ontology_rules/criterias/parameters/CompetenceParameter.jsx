import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import "rc-tree-select/assets/index.css";
import TreeSelect from "rc-tree-select";
import { Spinner } from "react-bootstrap";

const prepareData = (node) => {
    node.label = node.text;
    node.value = node.id;
    node.children ? node.children.forEach((child) => prepareData(child)) : null;
};

const loadCompetences = async (setCompetences) => {
    let cookies = new Cookies();
    let response = await fetch("/competences.json", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
    });

    let data = await response.json();
    setCompetences(data);
};

export default ({ value, setter }) => {
    const [competences, setCompetences] = useState(null);
    useEffect(() => {
        loadCompetences(setCompetences);
    }, []);

    return (
        <div>
            {competences ? (
                <TreeSelect
                    multiple
                    allowClear
                    treeData={competences.map((c) =>
                        Object({ value: c.id, label: c.code })
                    )}
                    onChange={setter}
                    style={{ width: "100%" }}
                    transitionName="rc-tree-select-dropdown-slide-up"
                    choiceTransitionName="rc-tree-select-selection__choice-zoom"
                    dropdownStyle={{
                        maxHeight: 200,
                        overflow: "auto",
                        zIndex: 500,
                    }}
                    treeNodeFilterProp="label"
                />
            ) : (
                <Spinner />
            )}
        </div>
    );
};
