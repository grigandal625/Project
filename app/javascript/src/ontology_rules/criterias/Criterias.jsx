import React, { useState, useEffect } from "react";
import {
    Container,
    Table,
    Dropdown,
    Spinner,
    Modal,
    Row,
    Col,
} from "react-bootstrap";
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
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
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
            <h3 className="d-flex justify-content-between">
                <span>Критерии</span>
                <a href="/ontology_rules/criterias/print" target="_blank">
                    Версия для печати
                </a>
            </h3>
            <Table bordered style={{ overflow: "scroll", maxHeight: "100%" }}>
                <thead>
                    <tr>
                        <th>Критерий</th>
                        <th>Параметры</th>
                        <th>Значения</th>
                        <th>Опции</th>
                    </tr>
                </thead>
                <tbody>
                    {criterias.map((criteria) => (
                        <tr>
                            <td>{criteria.label}</td>
                            <td>
                                {criteria.parameters.map((parameter) => (
                                    <div className="m-1 p-2 border criteria-badge">
                                        {parameter.label}
                                    </div>
                                ))}
                            </td>
                            <td>
                                {criteria.values.map((value) => (
                                    <div className="m-1 p-2 border criteria-badge">
                                        {value.label}
                                    </div>
                                ))}
                            </td>
                            <td>
                                <Dropdown>
                                    <Dropdown.Toggle></Dropdown.Toggle>
                                    <Dropdown.Menu>
                                        <Dropdown.Item
                                            onClick={() =>
                                                setTestingCriteria(criteria)
                                            }
                                        >
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
                show={testingCriteria ? true : false}
                onHide={() => setTestingCriteria(null)}
            >
                <Modal.Header closeButton>
                    <Modal.Title>
                        Тестирование критерия{" "}
                        {testingCriteria
                            ? '"' + testingCriteria.label + '"'
                            : ""}
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Container>
                        {testingCriteria ? (
                            <TestForm criteria={testingCriteria} />
                        ) : (
                            <></>
                        )}
                    </Container>
                </Modal.Body>
            </Modal>
        </>
    ) : (
        <Spinner />
    );
};

export default () => {
    const [criterias, setCriterias] = useState(null);
    useEffect(() => {
        loadCriterias(setCriterias);
    }, []);

    return (
        <>
            <Menu active={2} />
            <br />
            <div className="px-5">
                <CriteriasTable criterias={criterias} />
            </div>
        </>
    );
};
