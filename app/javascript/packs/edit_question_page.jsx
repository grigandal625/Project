import React from "react";
import { loadQuestion, QuestionForm, updateQuestion } from "../src/ka_topics/Questions";
import { Typography, Button, Skeleton, Form, message, Row, Col, Modal } from "antd";
import { useState } from "react";
import { useEffect } from "react";
import Cookies from "universal-cookie";
import ReactDOM from "react-dom";

const QuestionEditor = ({ question_id }) => {
    const [question, setQuestion] = useState();
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false)
    const [modal, contextHolder] = Modal.useModal()

    useEffect(() => {
        loadQuestion(question_id).then((question) => {
            question.answers = question.ka_answer;
            setQuestion(question);
            form.setFieldsValue(question);
        });
    }, [question_id]);

    const handleSubmit = async () => {
        setLoading(true)
        const question = await form.validateFields();
        const response = await updateQuestion(question_id, question);
        if (response.ok) {
            let data = await response.json();
            setQuestion(data);
            message.success("Вопрос изменен");
        } else {
            message.error("Ошибка");
        }
        setLoading(false)
    };

    const confirmDelete =
        ({ id, text }) =>
        () => {
            modal.confirm({
                title: "Удаление вопроса",
                content: (
                    <>
                        Удалить вопрос <b>{text}</b>?
                    </>
                ),
                okText: "Удалить",
                okButtonProps: { danger: true },
                cancelText: "Отмена",
                onOk: async () => {
                    const cookies = new Cookies();
                    const response = await fetch(`/ka_questions/destroy/${id}`, {
                        headers: {
                            Authorization: `Token ${cookies.get("auth_token")}`,
                            "Content-Type": "application/json",
                            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
                            Accept: "application/json",
                        },
                    });
                    if (response.ok) {
                        const a = document.createElement('a')
                        a.href = '/ka_questions'
                        a.click()
                    }
                },
            });
        };

    return question ? (
        <>
            <Row style={{marginBottom: 20}} wrap={false} gutter={10} align="bottom">
                <Col flex="auto">
                    <Typography.Title style={{ margin: 0 }} level={5}>
                        Редактирование вопроса
                    </Typography.Title>
                </Col>
                <Col>
                    <Button loading={loading} onClick={handleSubmit} type="primary">
                        Сохранить
                    </Button>
                </Col>
                <Col>
                    <Button onClick={confirmDelete(question)} danger>
                        Удалить вопрос
                    </Button>
                </Col>
                <Col>
                    <a href={`/ka_topics/edit/${question.ka_topic_id}`}>
                        <Button type="link">Редактировать вершину онтологии</Button>
                    </a>
                </Col>
            </Row>
            <QuestionForm form={form} />
            <Row gutter={10}>
                <Col>
                    <Button loading={loading} onClick={handleSubmit} type="primary">
                        Сохранить
                    </Button>
                </Col>
                <Col>
                    <Button onClick={confirmDelete(question)} danger>
                        Удалить вопрос
                    </Button>
                </Col>
                <Col>
                    <a href={`/ka_topics/edit/${question.ka_topic_id}`}>
                        <Button type="link">Редактировать вершину онтологии</Button>
                    </a>
                </Col>
            </Row>
            {contextHolder}
        </>
    ) : (
        <Skeleton active />
    );
};

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    const question_id = window.location.pathname.split("/").slice(-1)[0];
    ReactDOM.render(<QuestionEditor question_id={question_id} />, document.getElementById("question-root"));
});
