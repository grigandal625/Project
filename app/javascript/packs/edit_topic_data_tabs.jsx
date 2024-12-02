import React, { useState } from "react";
import ReactDOM from "react-dom";

import { Row, Col, Tabs } from "antd";
import Questions from "../src/ka_topics/Questions";
import SubTopics from "../src/ka_topics/SubTopics";
import Competences from "../src/ka_topics/Competences";
import Constructs from "../src/ka_topics/Constructs";
import Relations from "../src/ka_topics/Relations";

const TabSetGenerator = ({ params, activeKeyStack, parents, onSelect, ...tabs }) => {
    const items = Object.entries(tabs).map(([key, tab]) => ({
        key,
        label: tab.params.title,
        children: tab.content ? (
            tab.content
        ) : tab.subtabs ? (
            <TabSetGenerator parents={(parents || []).concat([key])} onSelect={onSelect} activeKeyStack={activeKeyStack.slice(1)} {...tab.subtabs} />
        ) : (
            <></>
        ),
    }));

    return (
        <Tabs
            defaultActiveKey={Object.keys(tabs).includes(activeKeyStack[0]) ? activeKeyStack[0] : Object.keys(tabs)[0]}
            {...params}
            onSelect={(key) => onSelect(key, parents)}
            items={items}
        />
    );
};

const TopicDataTabs = ({ ka_topic_id, opened_tab }) => {
    const tabs = {
        params: { className: "border-bottom-0" },
        questions: {
            params: { className: "border rounded", title: "Вопросы" },
            content: <Questions ka_topic_id={ka_topic_id} />,
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
                    content: <Constructs ka_topic_id={ka_topic_id} />,
                },
                calculated: {
                    params: {
                        className: "border rounded",
                        title: "Построенные связи",
                    },
                    content: <Relations ka_topic_id={ka_topic_id} />,
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
        localStorage.setItem("activeTabs", (parents || []).join("-") + (parents ? "-" : "") + key);
    };

    const activeTabs = localStorage.getItem("activeTabs");
    const activeKeyStack = activeTabs ? activeTabs.split("-") : [];
    return <TabSetGenerator activeKeyStack={activeKeyStack} onSelect={onSelect} {...tabs}></TabSetGenerator>;
};

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    const ka_topic_id = window.location.pathname.split("/").slice(-1)[0];
    ReactDOM.render(
        <Row gutter={5}>
            <Col span={7}>
                <SubTopics ka_topic_id={ka_topic_id} />
            </Col>
            <Col span={17}>
                <TopicDataTabs ka_topic_id={ka_topic_id} />
            </Col>
        </Row>,
        document.getElementById("topic-data-tabs")
    );
});
