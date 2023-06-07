import React from "react";
import Cookies from "universal-cookie";
import "rc-tree-select/assets/index.css";
import TreeSelect from "rc-tree-select";
import { useState, useEffect } from "react";
import { Spinner, Form } from "react-bootstrap";
import GroupParameter from "./GroupParameter";

const prepareData = (node) => {
    node.label = node.text;
    node.value = node.id;
    node.children ? node.children.forEach((child) => prepareData(child)) : null;
};

const loadStudets = async (setStudents) => {
    let cookies = new Cookies();
    let response = await fetch("/students/list", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setStudents(data);
};

const StudentSelect = ({ value, setter }) => {
    const [students, setStudents] = useState(null);
    useEffect(() => {
        loadStudets(setStudents);
    }, []);

    return (
        <div>
            {students ? (
                <TreeSelect
                    multiple
                    allowClear
                    treeData={students.map((s) => Object({ value: s.id, label: `${s.fio} - ${s.group.number}` }))}
                    onChange={(e) => setter({ id: e })}
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

export default ({ value, setter }) => {
    const [mode, setMode] = useState(true);

    return (
        <div>
            <div>
                <Form.Check
                    onChange={() => setMode(!mode)}
                    type="switch"
                    label={`Режим: ${mode ? "студенты" : "группы"}`}
                />
            </div>
            <div>
                {mode ? (
                    <StudentSelect value={value} setter={setter} />
                ) : (
                    <GroupParameter value={value} setter={(v) => setter({ group: v })} />
                )}
            </div>
        </div>
    );
};
