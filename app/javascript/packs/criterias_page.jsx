import ReactDOM from "react-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import Criterias from "../src/ontology_rules/criterias/Criterias";
import React from "react";

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    ReactDOM.render(<Criterias></Criterias>, document.body.appendChild(document.createElement("div")));
});
