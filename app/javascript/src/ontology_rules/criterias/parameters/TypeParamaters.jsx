import React from "react";
import TreeSelect from "rc-tree-select";
import "rc-tree-select/assets/index.css";

const NumberParameter = ({ value, setter }) => (
    <Form.Control
        type="number"
        value={value}
        onChange={(e) => setter(e.target.value)}
    />
);

const StringParameter = ({ value, setter }) => (
    <Form.Control value={value} onChange={(e) => setter(e.target.value)} />
);

const EnumParameter = ({ value, setter, parameter }) => {
    const treeData = parameter.values.map((v) =>
        Object({ value: v.id, label: v.value })
    );
    const multiple = parameter.multiple;
    return (
        <TreeSelect
            value={value}
            multiple={multiple}
            allowClear
            treeData={treeData}
            onChange={setter}
            style={{ width: "100%" }}
            transitionName="rc-tree-select-dropdown-slide-up"
            choiceTransitionName="rc-tree-select-selection__choice-zoom"
            dropdownStyle={{ maxHeight: 200, overflow: "auto", zIndex: 500 }}
            treeNodeFilterProp="label"
        />
    );
};

const Types = {
    number: NumberParameter,
    string: StringParameter,
    enum: EnumParameter,
};

export { NumberParameter, StringParameter, EnumParameter, Types };
