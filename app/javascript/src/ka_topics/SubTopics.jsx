import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import { Spinner, Container, Alert, Button, Stack, Modal } from "react-bootstrap";

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

const RemoveSubTopicConfirm = ({ topic_id, show, handleClose }) => (
    <Modal show={show} onHide={handleClose}>
        <Modal.Header>Удалить подтему и все дочерние подтемы/разделы/подразделы/понятия?</Modal.Header>
        <Modal.Footer>
            <a className="text-decoration-none" href={`/ka_topics/destroy/${topic_id}`}>
                <Button variant="danger">Удалить</Button>
            </a>
            <Button onClick={handleClose} variant="secondary-outline">
                Отмена
            </Button>
        </Modal.Footer>
    </Modal>
);

export default ({ ka_topic_id }) => {
    const [children, setChildren] = useState();
    useEffect(() => {
        loadChildren(ka_topic_id, setChildren);
    }, []);

    const [confirmDeleteTopicId, setDeleteShow] = useState(false);
    const handleDeleteClose = () => setDeleteShow(false);

    return children ? (
        <Container>
            <h3 className="my-3">Создать подтему</h3>
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
            <h3 className="my-3">Список подтем</h3>
            {children.length ? (
                <table className="w-100 border-0 border-top border-bottom">
                    <tr>
                        <th>Подтема</th>
                        <th>Действия</th>
                    </tr>
                    {children.map((child) => (
                        <tr>
                            <td>
                                <a className="text-decoration-none" href={`/ka_topics/edit/${child.id}`}>
                                    {child.text}
                                </a>
                            </td>
                            <td>
                                <a className="text-decoration-none" onClick={() => setDeleteShow(child.id)}>
                                    Удалить
                                </a>
                            </td>
                        </tr>
                    ))}
                </table>
            ) : (
                <Alert variant="primary">Подтем не добавлено</Alert>
            )}
            <RemoveSubTopicConfirm
                show={confirmDeleteTopicId}
                topic_id={confirmDeleteTopicId}
                handleClose={handleDeleteClose}
            />
        </Container>
    ) : (
        <Spinner />
    );
};
