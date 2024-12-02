import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import "./SubTopics.css";
import { Button, Empty, Skeleton, Tree, Modal, Form, Input, Space } from "antd";
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

    const prepareChildren = (children) =>
        children.map((child) => ({
            title: (
                <Space>
                    <a href={`/ka_topics/edit/${child.id}`}>{child.name}</a>
                    <Button danger size="small" type="link" onClick={confirmDelete(child)} icon={<DeleteOutlined />} />
                </Space>
            ),
            children: prepareChildren(child.children || []),
        }));
    const treeData = prepareChildren(struct?.children || []);

    return struct ? (
        <div>
            <h5 className="my-3">Подтемы</h5>
            {struct.children && struct.children.length ? (
                <div>
                    <div>
                        <Button icon={<PlusOutlined />} style={{ width: "100%", marginBottom: 5 }}>
                            Добавить
                        </Button>
                    </div>
                    <div>
                        <Tree treeData={treeData} />
                    </div>
                </div>
            ) : (
                <Empty description="Подтемы не созданы">
                    <Button icon={<PlusOutlined />}>Добавить</Button>
                </Empty>
            )}
            {contextHolder}
        </div>
    ) : (
        <Skeleton />
    );
};
