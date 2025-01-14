import React from "react";
import { loadQuestion, QuestionForm, updateQuestion } from "../src/ka_topics/Questions";
import { Typography, Button, Skeleton, Form, Row, Col, message } from "antd";
import { useState } from "react";
import { useEffect } from "react";

const QuestionEditor = ({ question_id }) => {
    const [question, setQuestion] = useState();
    const [form] = Form.useForm();

    useEffect(() => {
        loadQuestion(question_id).then((question) => {
            question.answers = question.ka_answer;
            setQuestion(question);
            form.setFieldsValue(question);
        });
    }, [question_id]);

    const handleSubmit = async () => {
        const question = await questionForm.validateFields();
        const cookies = new Cookies();
        const response = await fetch(`/ka_questions/edit/${id}`, {
            method: "POST",
            headers: {
                Authorization: `Token ${cookies.get("auth_token")}`,
                "Content-Type": "application/json",
                "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
                Accept: "application/json",
            },
            body: JSON.stringify(question),
        });
        if (response.ok) {
            let data = await response.json();
            setQuestion(data);
            message.success("Вопрос изменен");
        } else {
            message.error("Ошибка");
        }
    };

    return question ? (
        <>
            <Typography.Title level={5}>Редактирование вопроса</Typography.Title>
            <Typography.Link href={`/ka_topics/edit/${question.ka_topic_id}`}>Редактировать вершину онтологии</Typography.Link>
            <QuestionForm form={form} />
            <Button onClick={handleSubmit} type="primary" />
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
