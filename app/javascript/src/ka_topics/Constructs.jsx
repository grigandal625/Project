import React, { useEffect, useState } from "react";
import Cookies from "universal-cookie";
import { Spinner, Container, Stack, Button } from "react-bootstrap";
import { Modal } from "react-bootstrap";

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

    let data = await response.json();
    return data;
};

const RemoveMarkConfirm = ({ ka_topic_id, construct_id, show, handleClose }) => (
    <Modal show={show} onHide={handleClose}>
        <Modal.Header>Удалить оценку?</Modal.Header>
        <Modal.Footer>
            <a className="text-decoration-none" href={`/constructs/${construct_id}/detach_from/${ka_topic_id}`}>
                <Button variant="danger">Удалить</Button>
            </a>
            <Button onClick={handleClose} variant="secondary-outline">
                Отмена
            </Button>
        </Modal.Footer>
    </Modal>
);

const AddConstructModal = ({ ka_topic_id, construct, handleClose }) => {
    const [mark, setMark] = useState();
    const close = () => handleClose();

    const submit = async () => {
        await attachConstruct({ topic_id: ka_topic_id, construct_id: construct.id, mark });
        handleClose();
    };

    return (
        <Modal show={construct} onHide={close}>
            <Modal.Header>Добавление оценки связи между элементом курса и конструктом {construct?.text || construct?.name}</Modal.Header>
            <Modal.Body>
                <Stack className="my-4" direction="horizontal" gap={2}>
                    <label>Оценка связи</label>
                    <input
                        type="number"
                        min={0}
                        step={1}
                        value={mark}
                        onChange={(e) => setMark(e.target.value)}
                        className="m-0 rounded"
                        name="weight"
                        placeholder="Введите оценку связи"
                    ></input>
                </Stack>
            </Modal.Body>
            <Modal.Footer>
                <Button onClick={submit}>Добавить оценку</Button>
                <Button onClick={close} variant="secondary-outline">
                    Отмена
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default ({ ka_topic_id }) => {
    const [constructs, setConstructs] = useState();
    const [relatedConstructs, setRelatedConstructs] = useState();
    const [currentConstruct, setCurrentConstruct] = useState();
    const [removingConstructId, setRemovingConstructId] = useState();

    useEffect(() => {
        loadRelatedConstructs(ka_topic_id, setRelatedConstructs).then(loadConstructs(setConstructs));
    }, []);

    const closeModal = () => {
        setCurrentConstruct();
        loadRelatedConstructs(ka_topic_id, setRelatedConstructs).then(loadConstructs(setConstructs));
    };

    const closeRemove = () => setRemovingConstructId();

    return constructs && relatedConstructs ? (
        <div fluid>
            <Stack><h3 className="my-3">Оценки связей с конструктами</h3><a href={`/triade/${ka_topic_id}/show_grid`} target="_blank">Редактировать репертуарную решетку</a></Stack>
            <table className="w-100 border-0 border-top">
                <tr className="p-2">
                    <th>Конструкт</th>
                    <th>Оценка</th>
                    <th>Действия</th>
                </tr>
                {constructs.map((construct) => (
                    <tr>
                        <td>{construct.name}</td>
                        <td>
                            {relatedConstructs.find((c) => c.construct_id == construct.id)
                                ? relatedConstructs.find((c) => c.construct_id == construct.id).mark
                                : "Оценка не задана"}
                        </td>
                        <td>
                            {relatedConstructs.find((c) => c.construct_id == construct.id) ? (
                                <a className="text-decoration-none cursor-pointer" onClick={() => setRemovingConstructId(construct.id)}>
                                    Удалить оценку
                                </a>
                            ) : (
                                <a className="text-decoration-none cursor-pointer" onClick={() => setCurrentConstruct(construct)}>
                                    Добавить оценку
                                </a>
                            )}
                        </td>
                    </tr>
                ))}
            </table>
            <AddConstructModal ka_topic_id={ka_topic_id} construct={currentConstruct} handleClose={closeModal} />
            <RemoveMarkConfirm ka_topic_id={ka_topic_id} construct_id={removingConstructId} show={removingConstructId} handleClose={closeRemove} />
        </div>
    ) : (
        <Spinner />
    );
};
