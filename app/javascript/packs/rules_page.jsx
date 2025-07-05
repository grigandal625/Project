import ReactDOM from "react-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import Rules from "../src/ontology_rules/rules/Rules";
import React from "react";
import { createRoot } from "react-dom/client";

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    createRoot(document.body.appendChild(document.createElement("div"))).render(<Rules />);
});
