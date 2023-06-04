import React, { useState, useEffect } from "react";
import { Container, Table, Dropdown, Spinner, Modal } from "react-bootstrap";
import Menu from "../Menu";
import Cookies from "universal-cookie";
import TestForm from "./TestForm";
import "./Criterias.css";

const navigate = (url) => {
    let a = window.document.createElement("a");
    a.href = url;
    a.click();
};

const loadCriterias = async (setCriterias) => {
    let cookies = new Cookies();
    let response = await fetch("/ontology_rules/criterias.json", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        credentials: "include",
    });
    let criterias = await response.json();
    setCriterias(criterias);
};

const CriteriasTable = ({ criterias }) => {
    const [testingCriteria, setTestingCriteria] = useState(null);
    const className = testingCriteria ? "" : "no-dis";
    return criterias ? (
        <>
            <Table bordered>
                <thead>
                    <tr>
                        <th>Критерий</th>
                        <th>Действия</th>
                    </tr>
                </thead>
                <tbody>
                    {criterias.map((criteria) => (
                        <tr>
                            <td>{criteria.label}</td>
                            <td>
                                <Dropdown>
                                    <Dropdown.Toggle>...</Dropdown.Toggle>
                                    <Dropdown.Menu>
                                        <Dropdown.Item onClick={() => setTestingCriteria(criteria)}>
                                            Протестировать
                                        </Dropdown.Item>
                                    </Dropdown.Menu>
                                </Dropdown>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </Table>
            <Modal
                style={{ zIndex: 0 }}
                className={className}
                fullscreen
                show={true}
                onHide={() => setTestingCriteria(null)}
            >
                <Modal.Header closeButton>
                    <Modal.Title>
                        Тестирование критерия {testingCriteria ? '"' + testingCriteria.label + '"' : ""}
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Container>{testingCriteria ? <TestForm criteria={testingCriteria} /> : <></>}</Container>
                </Modal.Body>
            </Modal>
        </>
    ) : (
        <Spinner />
    );
};

export default () => {
    const [criterias, setCriterias] = useState(null);
    useEffect(() => {loadCriterias(setCriterias)}, []);

    return (
        <>
            <Menu active={2} />
            <br />
            <Container>
                <CriteriasTable criterias={criterias} />
            </Container>
        </>
    );
};
