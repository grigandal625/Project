import ReactDOM from "react-dom";
import 'bootstrap/dist/css/bootstrap.min.css';
import UTZConstructor from "src/hierarchy_utz/UTZConstructor";
import React from "react";
import { createRoot } from "react-dom/client";


document.addEventListener("DOMContentLoaded", () => {
    createRoot(document.body.appendChild(document.createElement("div"))).render(<UTZConstructor />);
});
