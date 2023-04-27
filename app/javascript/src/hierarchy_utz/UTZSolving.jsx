import React, { useState, useEffect } from "react";
import TreeFiller from "./TreeFiller";
import {
    Form,
    Nav,
    Navbar,
    Button,
    Container,
    FormGroup,
    Row,
    Col,
    Spinner,
} from "react-bootstrap";
import Cookies from "universal-cookie";

const loadUTZ = async (id, setUTZ) => {
    let cookies = new Cookies();
    let response = await fetch(`/hierarchy_utz/${id}.json`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
        credentials: "include",
    });
    switch (response.status) {
        case 200:
            let utz = await response.json();
            utz.data = JSON.parse(JSON.parse(utz.data));
            setUTZ(utz);
            break;
        default:
            break;
    }
};

const getUTZId = () => window.location.pathname.split("/").reverse()[0];

const UTZForm = (utz) => {
    return utz ? (
        <>
            <Row>
                <Col xs={10}>
                    <h3>{utz.text}</h3>
                </Col>
                <Col xs={2} className="text-right">
                    <Button style={{ width: "100%" }} onClick={() => {}}>
                        Проверить
                    </Button>
                </Col>
            </Row>
            <FormGroup>
                <p>{utz.description}</p>
            </FormGroup>
            <FormGroup>
                <Form.Label>Заполните структуру</Form.Label>
                <TreeFiller actualNodes={[utz.data]}></TreeFiller>
            </FormGroup>
        </>
    ) : (
        <Spinner></Spinner>
    );
};

const UTZSolving = () => {
    const [utz, setUTZ] = useState(null);
    useEffect(() => (!utz ? loadUTZ(getUTZId(), setUTZ)._ : null), [utz]);

    return (
        <>
            <Navbar bg="light" expand="lg">
                <Container>
                    <Navbar.Brand>
                        Решение УТЗ "Построение иерархической структуры"
                    </Navbar.Brand>
                    <Navbar.Toggle aria-controls="basic-navbar-nav" />
                    <Navbar.Collapse id="basic-navbar-nav">
                        <Nav>
                            <Nav.Link href="/utz/index">К списку УТЗ</Nav.Link>
                        </Nav>
                    </Navbar.Collapse>
                </Container>
            </Navbar>
            <br />
            <Container>{UTZForm(utz)}</Container>
        </>
    );
};

export default UTZSolving;
