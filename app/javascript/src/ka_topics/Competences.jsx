import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import { Spinner, Container, ModalHeader } from "react-bootstrap";
import { Modal } from "react-bootstrap";

const loadRelatedCompetences = async (ka_topic_id, setRelatedCompetences) => {
    let cookies = new Cookies();
    let response = await fetch(`/ka_topics/${ka_topic_id}/competences`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
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
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
    });

    let data = await response.json();
    setCompetences(data);
};

const CompetenceRelationModal = ({ka_topic_id, competence, close}) =>{
    return <Modal show={competence} onHide={close}>
        <Modal.Header>
            
        </Modal.Header>
        <Modal.Body>

        </Modal.Body>
        <Modal.Footer>

        </Modal.Footer>
    </Modal>

}
export default ({ ka_topic_id }) => {
    const [competences, setCompetences] = useState();
    const [relatedCompetences, setRelatedCompetences] = useState();
    const [currentCompetence, setCurrentCompetence] = useState();

    const closeModal = () => {
        debugger;
        setCurrentCompetence()
    }
    useEffect(() => {
        loadRelatedCompetences(ka_topic_id, setRelatedCompetences).then(() =>
            loadCompetences(setCompetences)
        );
    }, []);
    return competences ? (
        <Container>
            <h3 className="my-3">Связи с компетенциями</h3>
            <table className="w-100 border-0 border-top">
                <tr className="p-2">
                    <th>Компетенция</th>
                    <th>Вес связи</th>
                    <th>Действия</th>
                </tr>
                {competences.map((competence) => (
                    <tr className="p-2">
                        <td>
                            <a
                                className="text-decoration-none"
                                href={`/competences/${competence.id}/edit`}
                            >
                                {competence.code} - {competence.description}
                            </a>
                        </td>
                        <td>
                            {relatedCompetences.find(
                                (c) => c.competence_id == competence.id
                            )
                                ? relatedCompetences.find(
                                      (c) => c.competence_id == competence.id
                                  ).weight
                                : "Связь отсутствует"}
                        </td>
                        <td>
                            {relatedCompetences.find(
                                (c) => c.competence_id == competence.id
                            ) ? (
                                <a className="text-decoration-none">
                                    Удалить связь
                                </a>
                            ) : (
                                <a className="text-decoration-none" onClick={() => setCurrentCompetence(competence)}>
                                    Добавить связь
                                </a>
                            )}
                        </td>
                    </tr>
                ))}
            </table>
            <CompetenceRelationModal ka_topic_id={ka_topic_id} competence={currentCompetence} close={closeModal} /> 
            
        </Container>
    ) : (
        <Spinner />
    );
};
