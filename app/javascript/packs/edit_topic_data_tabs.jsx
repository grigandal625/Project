import React, { useState } from "react";
import ReactDOM from "react-dom";
import "bootstrap/dist/css/bootstrap.min.css";

import Tab from "react-bootstrap/Tab";
import Tabs from "react-bootstrap/Tabs";
import Questions from "../src/ka_topics/Questions";
import SubTopics from "../src/ka_topics/SubTopics";
import Competences from "../src/ka_topics/Competences";

const TabSetGenerator = ({
    params,
    activeKeyStack,
    parents,
    onSelect,
    ...tabs
}) => (
    <Tabs
        defaultActiveKey={
            Object.keys(tabs).includes(activeKeyStack[0])
                ? activeKeyStack[0]
                : Object.keys(tabs)[0]
        }
        {...params}
        onSelect={(key) => onSelect(key, parents)}
    >
        {Object.entries(tabs).map(([eventKey, tab]) => (
            <Tab eventKey={eventKey} {...tab.params}>
                {tab.content ? (
                    tab.content
                ) : tab.subtabs ? (
                    <TabSetGenerator
                        parents={(parents || []).concat([eventKey])}
                        onSelect={onSelect}
                        activeKeyStack={activeKeyStack.slice(1)}
                        {...tab.subtabs}
                    ></TabSetGenerator>
                ) : (
                    <></>
                )}
            </Tab>
        ))}
    </Tabs>
);

const TopicDataTabs = ({ ka_topic_id, opened_tab }) => {
    const tabs = {
        params: { className: "border-bottom-0" },
        questions: {
            params: { className: "border rounded", title: "Вопросы" },
            content: <Questions ka_topic_id={ka_topic_id} />,
        },
        children: {
            params: { className: "border rounded", title: "Подтемы" },
            content: <SubTopics ka_topic_id={ka_topic_id} />,
        },
        competences: {
            params: { className: "border rounded", title: "Компетенции" },
            content: <Competences ka_topic_id={ka_topic_id} />,
        },
        relations: {
            params: {
                className: "border rounded pt-4",
                title: "Связи",
            },
            subtabs: {
                params: {
                    className: "border-bottom-0",
                },
                constructs: {
                    params: {
                        className: "border rounded",
                        title: "Конструкты (АМРР)",
                    },
                    content: <>Конструкты</>,
                },
                calculated: {
                    params: {
                        className: "border rounded",
                        title: "Построенные связи",
                    },
                    content: <>Построенные связи</>,
                },
            },
        },
        skills: {
            params: {
                className: "border rounded pt-4",
                title: "Умения/Обучающие воздействия",
            },
            subtabs: {
                htbook: {
                    params: {
                        className: "border rounded",
                        title: "Главы ГТ-учебника",
                    },
                    content: <>Главы ГТ-учебника</>,
                },
                ett: {
                    params: {
                        className: "border rounded",
                        title: "УТЗ",
                    },
                    content: <>УТЗ</>,
                },
                components: {
                    params: {
                        className: "border rounded",
                        title: "Компоненты",
                    },
                    content: <>Компоненты</>,
                },
                training: {
                    params: {
                        className: "border rounded",
                        title: "Тренинг с ЭС/ИЭС",
                    },
                    content: <>Тренинг с ЭС/ИЭС</>,
                },
                visual: {
                    params: {
                        className: "border rounded",
                        title: "Презентации/видеоролики",
                    },
                    content: <>Презентации/видеоролики</>,
                },
                exe: {
                    params: {
                        className: "border rounded",
                        title: "Исполняемые файлы",
                    },
                    content: <>Исполняемые файлы</>,
                },
            },
        },
    };

    const onSelect = (key, parents) => {
        localStorage.setItem(
            "activeTabs",
            (parents || []).join("-") + (parents ? "-" : "") + key
        );
    };

    const activeTabs = localStorage.getItem("activeTabs");
    const activeKeyStack = activeTabs ? activeTabs.split("-") : [];
    return (
        <TabSetGenerator
            activeKeyStack={activeKeyStack}
            onSelect={onSelect}
            {...tabs}
        ></TabSetGenerator>
    );
};

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    const ka_topic_id = window.location.pathname.split("/").slice(-1)[0];
    ReactDOM.render(
        <TopicDataTabs ka_topic_id={ka_topic_id} />,
        document.getElementById("topic-data-tabs")
    );
});
