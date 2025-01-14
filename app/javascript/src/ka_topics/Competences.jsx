import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import { Spinner, Container, Stack } from "react-bootstrap";
import { Table, Button, Typography, Modal, message, Form, InputNumber, Row, Col } from "antd";

const loadRelatedCompetences = async (ka_topic_id, setRelatedCompetences) => {
    let cookies = new Cookies();
    let response = await fetch(`/ka_topics/${ka_topic_id}/competences`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setRelatedCompetences(data);
};

const loadCompetences = async (setCompetences) => {
    let cookies = new Cookies();
    let response = await fetch(`/competences.json`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setCompetences(data);
};

const WeightForm = ({ form, ka_topic_id, competence, ...props }) => {
    const [actualForm] = form ? [form] : Form.useForm();

    return (
        <>
            <Typography.Title level={5}>Добавление связи между элементом курса и компетенцией {competence?.code}</Typography.Title>
            <Form form={actualForm} {...props}>
                <Form.Item hidden name="parent_id">
                    <InputNumber value={ka_topic_id} />
                </Form.Item>
                <Form.Item label="Вес связи" name="weight" rules={[{ required: true, message: "Укажите вес" }]}>
                    <InputNumber style={{ width: "100%" }} placeholder="Укажите вес" />
                </Form.Item>
            </Form>
        </>
    );
};

export default ({ ka_topic_id }) => {
    const [competences, setCompetences] = useState();
    const [relatedCompetences, setRelatedCompetences] = useState();

    useEffect(() => {
        loadRelatedCompetences(ka_topic_id, setRelatedCompetences).then(() => loadCompetences(setCompetences));
    }, [ka_topic_id]);

    const [modal, contextHolder] = Modal.useModal();

    const performDelete = (competence) => async () => {
        let cookies = new Cookies();
        let response = await fetch(`/ka_topics/${ka_topic_id}/delete_competence_relation/${competence.id}`, {
            headers: {
                Authorization: `Token ${cookies.get("auth_token")}`,
                "Content-Type": "application/json",
                "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
            },
        });
        if (response.ok) {
            setRelatedCompetences(relatedCompetences.filter((r) => r.competence_id !== competence.id));
        } else {
            const text = await response.text();
            console.error(text);
            message.error("Ошибка");
        }
    };

    const handleDelete = (competence) => {
        modal.confirm({
            title: "Удаление связи темы с компетенцией",
            content: (
                <Typography.Text>
                    Удалить связь с компетенцией <b>{competence.code}</b> ?
                </Typography.Text>
            ),
            onOk: performDelete(competence),
            okText: "Удалить",
            cancelText: "Отмена",
            okButtonProps: { danger: true },
        });
    };

    const [form] = Form.useForm();

    const performCreate = (competence) => async () => {
        let cookies = new Cookies();
        const data = await form.validateFields();
        let response = await fetch(`/ka_topics/${ka_topic_id}/set_competence_relation/${competence?.id}`, {
            method: "POST",
            headers: {
                Authorization: `Token ${cookies.get("auth_token")}`,
                "Content-Type": "application/json",
                "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
            },
            body: JSON.stringify(data),
        });
        if (response.ok) {
            setRelatedCompetences([
                ...relatedCompetences,
                {
                    competence_id: competence.id,
                    ...data,
                },
            ]);
        } else {
            const text = await response.text();
            console.error(text);
            message.error("Ошибка");
        }
    };

    const handleCreate = (competence) => {
        form.resetFields();
        modal
            .confirm({
                title: "Добавление связи с компетенцией",
                content: <WeightForm form={form} competence={competence} ka_topic_id={ka_topic_id} layout="vertical" />,
                onOk: performCreate(competence),
                okText: "Добавить связь",
                cancelText: "Отмена",
            })
            .then()
            .catch();
    };

    const columns = [
        {
            key: "competence",
            title: "Компетенция",
            render: (competence) => (
                <a className="text-decoration-none" href={`/competences/${competence.id}/edit`}>
                    {competence.code} - {competence.description}
                </a>
            ),
        },
        {
            key: "weight",
            title: "Вес связи",
            render: (competence) => relatedCompetences.find((c) => c.competence_id == competence.id)?.weight || "Связь отсутствует",
        },
        {
            key: "actions",
            title: "Действия",
            render: (competence) =>
                relatedCompetences.find((c) => c.competence_id == competence.id) ? (
                    <Button type="link" danger onClick={() => handleDelete(competence)}>
                        Удалить связь
                    </Button>
                ) : (
                    <Button type="link" onClick={() => handleCreate(competence)}>
                        Добавить связь
                    </Button>
                ),
        },
    ];

    return competences && relatedCompetences ? (
        <div>
            <Row wrap={false} align="bottom">
                <Col flex="auto">
                    <Typography.Title level={5}>Связи с компетенциями</Typography.Title>
                </Col>
                <Col>
                    <a href={`/ka_topics/${ka_topic_id}/all_competences`}>Посмотреть все связи компетенций с элементами курса</a>
                </Col>
            </Row>

            <Table size="small" dataSource={competences} columns={columns} pagination={false} />
            {contextHolder}
        </div>
    ) : (
        <Spinner />
    );
};
