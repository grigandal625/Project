import React, { useState } from "react";
import ReactDOM from "react-dom";
import VertexParameter from "../src/ontology_rules/criterias/parameters/VertexParameter";
import { createRoot } from "react-dom/client";

const TopicTreeSingle = () => {
    const urlParams = new URLSearchParams(window.location.search);
    let initial = urlParams.get("ka_topic_id");
    if (initial !== null) {
        initial = parseInt(initial);
    }
    debugger;
    const [ka_topic_id, setKaTopicId] = useState(initial);
    return (
        <>
            <input hidden name="ka_topic_id" value={ka_topic_id}></input>
            <VertexParameter
                value={ka_topic_id}
                single
                setter={setKaTopicId}
            ></VertexParameter>
        </>
    );
};

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    createRoot(document.getElementById("topic-tree-single")).render(
        <TopicTreeSingle />
    );
    const urlParams = new URLSearchParams(window.location.search);
    const minWeight =
        urlParams.get("min_weight") !== null
            ? parseInt(urlParams.get("min_weight"))
            : 0;
    document.querySelector('input[name="min_weight"]').value = minWeight;
});
