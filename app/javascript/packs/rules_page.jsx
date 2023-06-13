import ReactDOM from "react-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import Rules from "../src/ontology_rules/rules/Rules";
import React from "react";

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    ReactDOM.render(<Rules />, document.body.appendChild(document.createElement("div")));
});
