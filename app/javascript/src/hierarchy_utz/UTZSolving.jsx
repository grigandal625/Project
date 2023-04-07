import React, { useState } from "react";
import TreeFiller from "./TreeFiller";
import { Form, Nav, Navbar, Button, Container, FormGroup, Row, Col } from "react-bootstrap";
import Cookies from "universal-cookie";

const loadUTZ = async (id, setUTZ) => {
    let cookies = new Cookies();
    let response = await fetch(`/hierarchy_utz/${id}`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        credentials: "include",
    });
    switch (response.status) {
        case 200:
            let utz = await response.json();
            utz.data = JSON.parse(utz.data);
            setUTZ(utz);
            break;
        default:
            break;
    }
};

const UTZSolving = () => {
    const [nodes, setNodes] = useState([
        {
            id: 1,
            text: "",
            placeholder: "Введите корневой элемент иерархии",
            children: [],
        },
    ]);

    const [name, setName] = useState("");
    const [desc, setDesc] = useState("");
    const [topic, setTopic] = useState(undefined);
    const [weight, setWeight] = useState(null);
    return (
        <>
            <Navbar bg="light" expand="lg">
                <Container>
                    <Navbar.Brand>Решение УТЗ "Построение иерархической структуры"</Navbar.Brand>
                    <Navbar.Toggle aria-controls="basic-navbar-nav" />
                    <Navbar.Collapse id="basic-navbar-nav">
                        <Nav>
                            <Nav.Link href="/utz/index">К списку УТЗ</Nav.Link>
                        </Nav>
                    </Navbar.Collapse>
                </Container>
            </Navbar>
            <br />
            <Container>
                <Row>
                    <Col xs={10}>
                        <Form.Label>{utz.text}</Form.Label>
                    </Col>
                    <Col xs={2} className="text-right">
                        <Button style={{ width: "100%" }} onClick={() => {}}>
                            Проверить
                        </Button>
                    </Col>
                </Row>
                <FormGroup>
                    <Form.Label>{utz.text}</Form.Label>
                </FormGroup>
                <FormGroup>
                    <Form.Label>{utz.description}</Form.Label>
                </FormGroup>
                <FormGroup>
                    <Form.Label>Заполните структуру</Form.Label>
                    <TreeFiller></TreeFiller>
                </FormGroup>
            </Container>
        </>
    );
};

export default UTZSolving;
