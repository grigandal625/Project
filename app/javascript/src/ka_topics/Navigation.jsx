import Cookies from "universal-cookie";
import { Breadcrumb, Skeleton } from "antd";
import React, { useEffect, useState } from "react";

const loadParents = async (ka_topic_id, setParents) => {
    let cookies = new Cookies();
    let response = await fetch(`/ka_topics/${ka_topic_id}/parents`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setParents(data);
};

const Navigation = ({ ka_topic_id }) => {
    const [parents, setParents] = useState();

    useEffect(() => {
        loadParents(ka_topic_id, setParents);
    }, [ka_topic_id]);

    const collectParentNames = () => {
        if (parents) {
            const result = [{ title: parents.text }];
            let p = parents;
            while (p.parent) {
                result.unshift({ title: <a href={`/ka_topics/edit/${p.parent.id}`}>{p.parent.text}</a> });
                p = p.parent;
            }
            result.unshift({ title: <a href={`/ka_topics`}>Редактор</a> });
            return result;
        }
    };

    return parents ? <Breadcrumb items={collectParentNames()} /> : <Skeleton.Node style={{ width: "100%" }} active />;
};

export default Navigation;
