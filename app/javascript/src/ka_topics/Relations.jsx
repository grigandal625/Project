import React, { useState, useEffect } from "react";
import { Spinner, Container, Button } from "react-bootstrap";
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

    return (
        <Container>
            <h3 className="my-3">Построенные связи между элементами курса</h3>
            {relations ? (
                <>
                    <div className="p-1">
                        <Button onClick={calcRels}>Пересчитать связи (АМРР)</Button>
                    </div>
                    {relations.length ? (
                        <table className="w-100 border-0 border-top">
                            <thead>
                                <tr className="p-2">
                                    <th>Текущая вершина</th>
                                    <th>Связанная вершина</th>
                                    <th>Тип связи</th>
                                </tr>
                            </thead>
                            <tbody>
                                {relations.map((rel) => (
                                    <tr>
                                        <td>{rel.topic.text}</td>
                                        <td>
                                            <a href={`/ka_topics/edit/${rel.related_topic.id}`} target="_blank">
                                                {rel.related_topic.text}
                                            </a>
                                        </td>
                                        <td>{{ 0: "Агрегация (сильная)", 1: "Ассоциация (средняя)", 2: "Слабая" }[rel.relation_type]}</td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    ) : (
                        <div>Нет связей</div>
                    )}
                </>
            ) : (
                <Spinner />
            )}
        </Container>
    );
};
