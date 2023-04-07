import ReactDOM from "react-dom";
import 'bootstrap/dist/css/bootstrap.min.css';
import UTZConstructor from "src/hierarchy_utz/UTZConstructor";
import React from "react";


document.addEventListener("DOMContentLoaded", () => {
    ReactDOM.render(<UTZConstructor />, document.body.appendChild(document.createElement("div")));
});
