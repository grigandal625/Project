import React, { useState } from "react";
import TreeEditor from "./TreeEditor";
import TopicSelector from "src/utz/TopicSelector";
import {
    Form,
    Nav,
    Navbar,
    Button,
    Container,
    FormGroup,
    Row,
    Col,
} from "react-bootstrap";
import Cookies from "universal-cookie";

const navigate = (url) => {
    let a = window.document.createElement("a");
    a.href = url;
    a.click();
};

const sendUTZ = async (name, description, data, ka_topic_id, weight) => {
    let cookies = new Cookies();
    const body = {
        name,
        description,
        data: JSON.stringify(data),
        ka_topic_id,
        weight,
    };
    let response = await fetch("/hierarchy_utz", {
        method: "post",
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
        body: JSON.stringify(body),
        credentials: "include",
        redirect: "follow",
    });
    navigate(response.url);
};

const UTZConstructor = () => {
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
                    <Navbar.Brand>
                        Создание УТЗ "Построение иерархической структуры"
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
            <Container>
                <Row>
                    <Col xs={10}>
                        <Form.Label>Заполните данные УТЗ</Form.Label>
                    </Col>
                    <Col xs={2} className="text-right">
                        <Button
                            style={{ width: "100%" }}
                            onClick={() =>
                                sendUTZ(
                                    name,
                                    desc,
                                    JSON.stringify(nodes[0]),
                                    topic,
                                    weight
                                )
                            }
                        >
                            Создать
                        </Button>
                    </Col>
                </Row>
                <FormGroup>
                    <Form.Label htmlFor="name">Название</Form.Label>
                    <Form.Control
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        name="name"
                        placeholder="Введите название УТЗ"
                    ></Form.Control>
                </FormGroup>
                <FormGroup>
                    <Form.Label htmlFor="desc">Описание задания</Form.Label>
                    <Form.Control
                        value={desc}
                        onChange={(e) => setDesc(e.target.value)}
                        as="textarea"
                        placeholder="Введите описание задания"
                        name="desc"
                    ></Form.Control>
                </FormGroup>
                <FormGroup>
                    <Form.Label>Структура</Form.Label>
                    <TreeEditor {...{ nodes, setNodes }}></TreeEditor>
                </FormGroup>
                <Row>
                    <Col>
                        <FormGroup>
                            <Form.Label>Элемент курса/дисциплины:</Form.Label>
                            <TopicSelector onChange={setTopic}></TopicSelector>
                        </FormGroup>
                    </Col>
                    <Col>
                        <FormGroup>
                            <Form.Label>Вес:</Form.Label>
                            <Form.Control
                                type="number"
                                placeholder="Укажите вес"
                                value={weight}
                                onChange={(e) => setWeight(e.target.value)}
                            ></Form.Control>
                        </FormGroup>
                    </Col>
                </Row>
            </Container>
        </>
    );
};

export default UTZConstructor;
