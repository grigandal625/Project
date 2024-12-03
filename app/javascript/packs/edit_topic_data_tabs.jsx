import React, { useState } from "react";
import ReactDOM from "react-dom";

import { Row, Col, Tabs, Form, Input, Button, Typography, Space, message } from "antd";
import Questions from "../src/ka_topics/Questions";
import SubTopics from "../src/ka_topics/SubTopics";
import Competences from "../src/ka_topics/Competences";
import Constructs from "../src/ka_topics/Constructs";
import Relations from "../src/ka_topics/Relations";
import { BackwardOutlined } from "@ant-design/icons";
import Cookies from "universal-cookie";

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

const TopicNameForm = ({ topic, setTopic }) => {
    const cookies = new Cookies();
    return <Form
        onFinish={async (data) => {
            const response = await fetch(`/ka_topics/edit_text/${topic.id}`, {
                method: "POST",
                headers: {
                    Authorization: `Token ${cookies.get("auth_token")}`,
                    "Content-Type": "application/json",
                    "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
                    Accept: "application/json",
                },
                body: JSON.stringify(data),
            });
            if (response.ok) {
                message.success("Данные обновлены");
                const json = await response.json();
                setTopic({ ...topic, ...json });
            }
        }}
        initialValues={topic}
    >
        <Row wrap={false} gutter={10}>
            <Col flex="auto" style={{ whiteSpace: "nowrap" }}>
                <Form.Item label="Название вершины" rules={[{ required: true, message: "Заполните" }]} name="text">
                    <Input style={{ width: "100%" }} placeholder="Укажите название" />
                </Form.Item>
            </Col>
            <Form.Item>
                <Button htmlType="submit" type="primary">
                    Переименовать
                </Button>
            </Form.Item>
        </Row>
    </Form>
};

const TopicHeader = () => {
    const [topic, setTopic] = useState(window.__TOPIC__);

    return topic ? (
        <>
            <div>
                {topic.parent ? (
                    <a href={`/ka_topics/edit/${topic.parent}`}>
                        <Space>
                            <BackwardOutlined />
                            <span>К родителской теме</span>
                        </Space>
                    </a>
                ) : (
                    <></>
                )}{" "}
            </div>
            <Typography.Title level={2}>{topic.text}</Typography.Title>
            <TopicNameForm topic={topic} setTopic={setTopic} />
        </>
    ) : (
        <></>
    );
};

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    const ka_topic_id = window.location.pathname.split("/").slice(-1)[0];
    ReactDOM.render(
        <div>
            <TopicHeader />
            <Row gutter={15}>
                <Col span={7}>
                    <SubTopics ka_topic_id={ka_topic_id} />
                </Col>
                <Col span={17}>
                    <TopicDataTabs ka_topic_id={ka_topic_id} />
                </Col>
            </Row>
        </div>,
        document.getElementById("topic-data-tabs")
    );
});
