import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import "./SubTopics.css";
import { Button, Empty, Skeleton, Tree, Modal, Form, Input, Row, Col, Typography } from "antd";
import { DeleteOutlined, PlusOutlined } from "@ant-design/icons";

const loadChildren = async (ka_topic_id, setChildren) => {
    let cookies = new Cookies();
    let response = await fetch(`/ka_topics/${ka_topic_id}/children`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setChildren(data);
};

const loadStruct = async (ka_topic_id, setStruct) => {
    let cookies = new Cookies();
    let response = await fetch(`/ka_topics/${ka_topic_id}/get_struct`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setStruct(data);
};

const NewTopicForm = ({ form, ...props }) => (
    <Form form={form} {...props}>
        <Form.Item name="text" label="Название вершины" rules={[{ required: true, message: "Заполните" }]}>
            <Input placeholder="Укажите название вершины" />
        </Form.Item>
    </Form>
);

/*
<form method="post" action="/ka_topics/new">
                <input type="hidden" name="parent_id" value={ka_topic_id}></input>
                <Stack className="my-4" direction="horizontal" gap={2}>
                    <input
                        type="text"
                        className="m-0 rounded"
                        name="text"
                        placeholder="Введите имя новой подтемы"
                    ></input>
                    <div className="ms-auto">
                        <Button className="text-nowrap" type="submit">
                            Создать подтему
                        </Button>
                    </div>
                </Stack>
            </form>
*/

export default ({ ka_topic_id }) => {
    const [struct, setStruct] = useState();
    useEffect(() => {
        loadStruct(ka_topic_id, setStruct);
    }, []);

    const [modal, contextHolder] = Modal.useModal();

    const goTo = (link) => {
        const a = document.createElement("a");
        a.href = link;
        a.click();
    };

    const confirmDelete = (topic) => () => {
        modal.confirm({
            title: "Подтвердите действие",
            content: (
                <>
                    Удалить вершину <b>{topic.name}</b>?
                </>
            ),
            okText: "Удалить",
            okButtonProps: { danger: true },
            cancelText: "Отмена",
            onOk: () => goTo(`/ka_topics/destroy/${topic.id}`),
        });
    };

    const [form] = Form.useForm();

    const handleAdd = () =>
        modal.info({
            title: "Добавление подтемы",
            content: <NewTopicForm layout="vertical" form={form} />,
            okText: "Создать",
            cancelText: "Отмена",
            okCancel: true,
            onOk: async () => {
                const data = await form.validateFields();
                const cookies = new Cookies();
                const response = await fetch("/ka_topics/new", {
                    method: "POST",
                    headers: {
                        Authorization: `Token ${cookies.get("auth_token")}`,
                        "Content-Type": "application/json",
                        "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
                        Accept: "application/json",
                    },
                    body: JSON.stringify({ ...data, parent_id: ka_topic_id }),
                });
                if (response.ok) {
                    const newTopic = await response.json();
                    setStruct({ ...struct, children: [...struct.children, newTopic] });
                }
            },
        });

    const prepareChildren = (children) =>
        children.map((child) => ({
            title: (
                <Row wrap={false} gutter={10}>
                    <Col flex="auto">{child.name}</Col>
                    <Col>
                        <a href={`/ka_topics/edit/${child.id}`}>Редактировать</a>
                    </Col>
                    <Col>
                        <Button danger size="small" type="link" onClick={confirmDelete(child)} icon={<DeleteOutlined />} />
                    </Col>
                </Row>
            ),
            children: prepareChildren(child.children || []),
            style: { width: "100%" },
        }));
    const treeData = prepareChildren(struct?.children || []);

    return struct ? (
        <div>
            <Typography.Title level={3}>Подтемы</Typography.Title>
            {struct.children && struct.children.length ? (
                <div>
                    <div>
                        <Button icon={<PlusOutlined />} onClick={handleAdd} style={{ width: "100%", marginBottom: 5 }}>
                            Добавить
                        </Button>
                    </div>
                    <div>
                        <Tree treeData={treeData} />
                    </div>
                </div>
            ) : (
                <Empty description="Подтемы не созданы">
                    <Button onClick={handleAdd} icon={<PlusOutlined />}>
                        Добавить
                    </Button>
                </Empty>
            )}
            {contextHolder}
        </div>
    ) : (
        <Skeleton />
    );
};
