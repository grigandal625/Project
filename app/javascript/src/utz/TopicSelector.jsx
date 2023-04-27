import React from "react";
import { Spinner } from "react-bootstrap";
import DropdownTreeSelect from "react-dropdown-tree-select";
import Cookies from "universal-cookie";
import "react-dropdown-tree-select/dist/styles.css";

const prepareData = (node, selectedValues = []) => {
    node.label = node.text;
    node.value = node.id;
    node.checked = selectedValues.includes(node.value);
    node.children.forEach((child) => prepareData(child, selectedValues));
};

export default class TopicSelector extends React.Component {
    constructor(props) {
        super(props);
        this.state = { selectedValues: [] };
    }

    componentDidMount = async () => {
        let cookies = new Cookies();
        let response = await fetch("/ka_topics/full_tree", {
            headers: {
                Authorization: `Token ${cookies.get("auth_token")}`,
                "Content-Type": "application/json",
                "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
            },
        });
        switch (response.status) {
            case 200:
                let data = await response.json();
                this.setState((state) => {
                    state.data = data;
                    return state;
                });
                break;
            default:
                break;
        }
    };

    onChange = (currentNode, selectedNodes) => {
        this.setState((state) => {
            state.selectedValues = [currentNode.value];
            return state;
        });
        this.props.onChange ? this.props.onChange(currentNode.value) : true;
    };

    get data() {
        const data = this.state.data;
        data.forEach((root) => prepareData(root, this.state.selectedValues));
        return data;
    }

    render() {
        if (!this.state.data) {
            return (
                <>
                    <br />
                    <Spinner></Spinner>
                </>
            );
        } else {
            return <DropdownTreeSelect mode="radioSelect" data={this.data} onChange={this.onChange.bind(this)}></DropdownTreeSelect>;
        }
    }
}
