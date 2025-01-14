import React, { useEffect, useState } from "react";
import Cookies from "universal-cookie";
import { Col, Row, Skeleton, Typography, Button, Table, Modal, message, Form, InputNumber } from "antd";

const loadRelatedConstructs = async (ka_topic_id, setRelatedConstructs) => {
    let cookies = new Cookies();
    let response = await fetch(`/ka_topics/${ka_topic_id}/constructs`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setRelatedConstructs(data);
};

const loadConstructs = async (setConstructs) => {
    let cookies = new Cookies();
    let response = await fetch(`/constructs.json`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setConstructs(data);
};

const attachConstruct = async ({ topic_id, construct_id, mark }) => {
    let cookies = new Cookies();
    let response = await fetch(`/constructs/attach`, {
        method: "POST",
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            accept: "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        body: JSON.stringify({ topic_id, construct_id, mark }),
    });

    return response;
};

const MarkForm = ({ form, construct, ...props }) => {
    const [actualForm] = form ? [form] : Form.useForm();

    return (
        <>
            <Typography.Title level={5}>Добавление оценки конструкта {construct?.text || construct?.name} для вершины</Typography.Title>
            <Form form={actualForm} {...props}>
                <Form.Item name="mark" label="Оценка" rules={[{ required: true, message: "Укажите оценку" }]}>
                    <InputNumber style={{width: "100%"}} min={0} max={100} precision={0} placeholder="Укажите оценку" />
                </Form.Item>
            </Form>
        </>
    );
};

export default ({ ka_topic_id }) => {
    const [constructs, setConstructs] = useState();
    const [relatedConstructs, setRelatedConstructs] = useState();
    const [modal, contextHolder] = Modal.useModal();

    useEffect(() => {
        loadRelatedConstructs(ka_topic_id, setRelatedConstructs).then(loadConstructs(setConstructs));
    }, []);

    const performDelete = (construct) => async () => {
        let cookies = new Cookies();
        let response = await fetch(`/constructs/${construct.id}/detach_from/${ka_topic_id}`, {
            headers: {
                Authorization: `Token ${cookies.get("auth_token")}`,
                "Content-Type": "application/json",
                "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
            },
        });
        if (response.ok) {
            setRelatedConstructs(relatedConstructs.filter((r) => r.construct_id !== construct.id));
        } else {
            const text = await response.text();
            console.error(text);
            message.error("Ошибка");
        }
    };

    const handleDelete = (construct) => {
        modal.confirm({
            title: "Удаление оценки конструкта",
            content: (
                <Typography.Text>
                    Удалить оценку конструкта <b>{construct.name}</b> для данной вершины?
                </Typography.Text>
            ),
            onOk: performDelete(construct),
            okText: "Удалить",
            cancelText: "Отмена",
            okButtonProps: { danger: true },
        });
    };

    const [form] = Form.useForm();

    const performCreate = (construct) => async () => {
        const data = await form.validateFields();
        const response = await attachConstruct({ topic_id: ka_topic_id, construct_id: construct.id, ...data });
        if (response.ok) {
            setRelatedConstructs([...relatedConstructs, { construct_id: construct.id, ...data }]);
        } else {
            const text = await response.text();
            console.error(text);
            message.error("Ошибка");
        }
    };

    const handleCreate = (construct) => {
        form.resetFields();
        modal
            .confirm({
                title: "Добавление оценки конструкта",
                content: <MarkForm form={form} construct={construct} />,
                onOk: performCreate(construct),
                okText: "Добавить",
                cancelText: "Отмена",
            })
            .then()
            .catch();
    };

    const columns = [
        {
            key: "construct",
            title: "Конструкт",
            dataIndex: "name",
        },
        {
            key: "mark",
            title: "Оценка",
            render: (construct) => relatedConstructs.find((c) => c.construct_id == construct.id)?.mark.toString() || "Оценка не задана",
        },
        {
            key: "actions",
            title: "Действия",
            render: (construct) => relatedConstructs.find((c) => c.construct_id == construct.id) ? (
                <Button type="link" danger onClick={() => handleDelete(construct)}>
                    Удалить оценку
                </Button>
            ) : (
                <Button type="link" onClick={() => handleCreate(construct)}>
                    Добавить оценку
                </Button>
            ),
        },
    ];

    return constructs && relatedConstructs ? (
        <div>
            <Row gutter={10} align="bottom">
                <Col flex="auto">
                    <Typography.Title level={5}>Оценки связей с конструктами</Typography.Title>
                </Col>
                <Col>
                    <Typography.Link href={`/triade/${ka_topic_id}/show_grid`} target="_blank">
                        Редактировать репертуарную решетку
                    </Typography.Link>
                </Col>
            </Row>
            <Table size="small" dataSource={constructs} columns={columns} pagination={false} />
            {contextHolder}
        </div>
    ) : (
        <Skeleton active />
    );
};
