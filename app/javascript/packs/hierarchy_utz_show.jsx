import ReactDOM from "react-dom";
import 'bootstrap/dist/css/bootstrap.min.css';
import UTZSolving from "../src/hierarchy_utz/UTZSolving";
import React from "react";


document.addEventListener("DOMContentLoaded", () => {
    ReactDOM.render(<UTZSolving />, document.body.appendChild(document.createElement("div")));
});
