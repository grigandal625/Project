import React, { useEffect, useState } from "react";
import Cookies from "universal-cookie";
import ReactDOM from "react-dom";

const getTopicsTree = async (setTree) => {
    let cookies = new Cookies();
    let response = await fetch("/ka_topics/full_tree", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        credentials: "include",
    });
    let tree = await response.json();
    setTree(tree);
};

const TopicSelect = ({ topic, changeSelected }) => {
    const [expanded, setExpanded] = useState(false);
    const switchExpanded = () => setExpanded(!expanded);
    return (
        <div>
            <div style={{ whiteSpace: "nowrap" }}>
                <a
                    title={expanded ? "Свернуть" : "Развернуть"}
                    onClick={topic.children && topic.children.length ? switchExpanded : () => {}}
                    style={{ marginRight: expanded ? 0 : 15, cursor: "pointer", fontSize: 28 }}
                >
                    {topic.children && topic.children.length ? <b>{expanded ? "⌄" : "›"}</b> : <b>-</b>}
                </a>
                <input
                    checked={Boolean(topic.checked)}
                    value={Boolean(topic.checked)}
                    onChange={(e) => {
                        changeSelected(topic.id, e.target.checked);
                        console.log(e.target);
                        console.log(topic.checked);
                    }}
                    id={`box${topic.id}`}
                    name={`topic_id:${topic.id}`}
                    type="checkbox"
                />
                <label htmlFor={`box${topic.id}`}>{topic.text}</label>
            </div>
            {topic.children && topic.children.length ? (
                <div style={{ display: expanded ? "block" : "none", paddingLeft: 25 }}>
                    {topic.children.map((child) => (
                        <TopicSelect topic={child} changeSelected={changeSelected} />
                    ))}
                </div>
            ) : (
                <></>
            )}
        </div>
    );
};

const TopicTree = () => {
    const [tree, setTree] = useState(null);
    const [duplicateChildren, setDuplicateChildren] = useState(true);
    const [duplicateChildrenFalse, setDuplicateChildrenFalse] = useState(false);
    const [duplicateParent, setDuplicateParent] = useState(false);
    const [show, setShow] = useState(false);
    useEffect(() => {
        getTopicsTree(setTree);
    }, []);

    const _findTopic = (topicId, topic) => {
        if (topic.id == topicId) {
            return topic;
        }
        if (topic.children && topic.children.length) {
            for (let i in topic.children) {
                let t = _findTopic(topicId, topic.children[i]);
                if (t) {
                    return t;
                }
            }
        }
    };

    const findTopic = (topicId) => {
        for (let i in tree) {
            let t = _findTopic(topicId, tree[i]);
            if (t) {
                return t;
            }
        }
    };

    const _findParent = (topicId, topic) => {
        if (topic.children.map((t) => t.id).includes(topicId)) {
            return topic;
        }
        if (topic.children && topic.children.length) {
            for (let i in topic.children) {
                let t = _findParent(topicId, topic.children[i]);
                if (t) {
                    return t;
                }
            }
        }
    };

    const findParent = (topicId) => {
        for (let i in tree) {
            let t = _findParent(topicId, tree[i]);
            if (t) {
                return t;
            }
        }
    };

    const updateChecked = (topic, checked, updateParent = false) => {
        topic.checked = checked;
        if (
            topic.children &&
            topic.children.length &&
            ((checked && duplicateChildren) || (!checked && duplicateChildrenFalse))
        ) {
            for (let i in topic.children) {
                updateChecked(topic.children[i], checked);
            }
        }
        if (!checked && updateParent && duplicateParent) {
            let t = findParent(topic.id);
            while (t) {
                t.checked = false;
                t = findParent(t.id);
            }
        }
    };

    const changeSelected = (topicId, value) => {
        let t = findTopic(topicId);
        updateChecked(t, value, !value);
        setTree(tree.map((e) => e));
    };

    return tree ? (
        <div style={{ padding: 25, paddingTop: 0 }}>
            <div>
                <a onClick={() => setShow(!show)}>Настройки. ({show ? "скрыть" : "показать"})</a>
                {show ? (
                    <div className="row">
                        <div className="large-4 column">
                            <input
                                checked={duplicateChildren}
                                onChange={(e) => setDuplicateChildren(e.target.checked)}
                                type="checkbox"
                            />
                            <label>
                                Дублировать <b>выделение</b> для дочерних тем
                            </label>
                        </div>
                        <div className="large-4 column">
                            <input
                                checked={duplicateChildrenFalse}
                                onChange={(e) => setDuplicateChildrenFalse(e.target.checked)}
                                type="checkbox"
                            />
                            <label>
                                Дублировать <b>снятие</b> для дочерних тем
                            </label>
                        </div>
                        <div className="large-4 column">
                            <input
                                checked={duplicateParent}
                                onChange={(e) => setDuplicateParent(e.target.checked)}
                                type="checkbox"
                            />
                            <label>
                                Дублировать <b>снятие</b> для дочерних тем
                            </label>
                        </div>
                    </div>
                ) : (
                    <></>
                )}
            </div>
            {tree.map((topic) => (
                <TopicSelect topic={topic} changeSelected={changeSelected} />
            ))}
        </div>
    ) : (
        <div>Загрузка...</div>
    );
};

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    ReactDOM.render(<TopicTree />, document.getElementById("topic-tree"));
});
