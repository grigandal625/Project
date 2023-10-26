import ReactDOM from "react-dom";
import PrintCriterias from "../src/ontology_rules/criterias/PrintCriterias";
import React from "react";

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    ReactDOM.render(
        <PrintCriterias />,
        document.body.appendChild(document.createElement("div"))
    );
});
