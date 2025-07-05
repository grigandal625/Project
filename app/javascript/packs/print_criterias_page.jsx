import ReactDOM from "react-dom";
import PrintCriterias from "../src/ontology_rules/criterias/PrintCriterias";
import React from "react";
import { createRoot } from "react-dom/client";

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    createRoot(document.body.appendChild(document.createElement("div"))).render(
        <PrintCriterias />,
        
    );
});
