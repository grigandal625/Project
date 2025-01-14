import { Tag, Table, Button, Skeleton, Typography, Empty, Row, Col } from "antd";
import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";

const loadRelations = async (ka_topic_id, setRelations) => {
    let cookies = new Cookies();
    const response = await fetch(`/ka_topics/show_all_relations/${ka_topic_id}.json`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    const data = await response.json();
    setRelations(data);
};

const execAmrr = async (ka_topic_id, setRelations) => {
    let cookies = new Cookies();
    const response = await fetch(`/ka_topics/calc_rel/${ka_topic_id}.json`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    const data = await response.json();
    setRelations(data);
};

export default ({ ka_topic_id }) => {
    const [relations, setRelations] = useState();

    useEffect(async () => {
        await loadRelations(ka_topic_id, setRelations);
    }, [ka_topic_id]);

    const calcRels = async () => {
        setRelations();
        await execAmrr(ka_topic_id, setRelations);
    };

    const columns = [
        {
            key: "vertex",
            title: "Текущая вершина",
            render: (rel) => rel.topic.text,
        },
        {
            key: "relatedVertex",
            title: "Связанная вершина",
            render: (rel) => (
                <a href={`/ka_topics/edit/${rel.related_topic.id}`} target="_blank">
                    {rel.related_topic.text}
                </a>
            ),
        },
        {
            key: "relationType",
            title: "Тип связи",
            render: (rel) => (
                <Tag color={{ 0: "red", 1: "yellow", 2: "green" }[rel.relation_type]}>
                    {{ 0: "Агрегация (сильная)", 1: "Ассоциация (средняя)", 2: "Слабая" }[rel.relation_type]}
                </Tag>
            ),
        },
    ];

    return (
        <div>
            {relations ? (
                <>
                    <Row wrap={false} gutter={10} align="bottom">
                        <Col flex="auto">
                            <Typography.Title level={5}>Построенные связи между элементами курса</Typography.Title>
                        </Col>
                        <Col>
                            <Button type="primary" onClick={calcRels}>
                                Пересчитать связи (АМРР)
                            </Button>
                        </Col>
                    </Row>

                    {relations.length ? <Table size="small" dataSource={relations} columns={columns} pagination={false} /> : <Empty description="Нет связей" />}
                </>
            ) : (
                <Skeleton active />
            )}
        </div>
    );
};
