import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import { Form, Input, InputNumber, Checkbox, Row, Col, Table, Button, Space, Modal, Empty, Spin, Typography } from "antd";
import { DeleteOutlined, PlusCircleOutlined, PlusOutlined } from "@ant-design/icons";

const requiredRule = { required: true, message: "Заполните" };

const loadQuestions = async (ka_topic_id, setQuestions) => {
    let cookies = new Cookies();
    let response = await fetch(`/ka_topics/${ka_topic_id}/questions`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
    });

    let data = await response.json();
    setQuestions(data);
};

const CheckboxField = ({ value, onChange, ...props }) => <Checkbox {...props} checked={value} onChange={(e) => onChange(e.target.checked)} />;

const Answers = ({ fields, add, remove }) => {
    const columns = [
        {
            title: "Текст ответа",
            key: "answerText",
            render: (field, _, i) => (
                <Form.Item {...field} name={[field.name, "text"]} rules={[requiredRule]}>
                    <Input placeholder="Введите текст ответа" />
                </Form.Item>
            ),
        },
        {
            title: "Корректность",
            key: "answerCorrect",
            render: (field, _, i) => (
                <Form.Item {...field} name={[field.name, "correct"]}>
                    <CheckboxField />
                </Form.Item>
            ),
        },
        {
            title: (
                <Space>
                    <span>Действия</span>
                    <Button type="link" onClick={() => add()} icon={<PlusCircleOutlined />}>
                        Добавить
                    </Button>
                </Space>
            ),
            key: "answerDelete",
            render: (_, __, i) => <Button danger type="link" icon={<DeleteOutlined />} onClick={() => remove(i)} />,
        },
    ];
    return (
        <Table
            locale={{
                emptyText: <Empty description="Вариантов ответа не добавлено" />,
            }}
            size="small"
            columns={columns}
            dataSource={fields}
            pagination={false}
        />
    );
};

export const QuestionForm = ({ form, ...props }) => {
    return (
        <Form layout="vertical" form={form} {...props}>
            <Row wrap={false} gutter={5}>
                <Col flex="auto">
                    <Form.Item name="text" label="Текст вопроса" rules={[requiredRule]}>
                        <Input placeholder="Введите текст вопроса" />
                    </Form.Item>
                </Col>
                <Col>
                    <Form.Item name="difficulty" label="Сложность" rules={[requiredRule]}>
                        <InputNumber min={1} max={3} step={1} placeholder="Укажите сложность вопроса" />
                    </Form.Item>
                </Col>
            </Row>
            <Form.Item label="Варианты ответа">
                <Form.List name="answers">{(fields, { add, remove }) => <Answers fields={fields} add={add} remove={remove} />}</Form.List>
            </Form.Item>
        </Form>
    );
};

export default ({ ka_topic_id }) => {
    const [questions, setQuestions] = useState();

    useEffect(() => {
        loadQuestions(ka_topic_id, setQuestions);
    }, []);

    const [modal, contextHolder] = Modal.useModal();
    const [questionForm] = Form.useForm();

    const performAdd = async () => {
        const { text, difficulty, answers } = await questionForm.validateFields();
        const question = { text, difficulty, topic_id: ka_topic_id };
        answers.forEach(({ text, correct }, i) => {
            question[`answer_${i}_text`] = text;
            question[`answer_${i}_correct`] = Boolean(correct);
        });

        const cookies = new Cookies();
        const response = await fetch(`/ka_questions/new`, {
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
            setQuestions([...questions, data]);
        }
    };

    const handleAdd = () => {
        questionForm.setFieldsValue({ answers: [] });
        modal.confirm({
            title: "Создание вопроса к вершине",
            content: <QuestionForm form={questionForm} />,
            width: 1200,
            onOk: performAdd,
            okText: "Добавить",
            cancelText: "Отмена",
        });
    };

    const performEdit = (id) => async () => {
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
            setQuestions(questions.map((q) => (q.id === data.id ? data : q)));
        }
    };

    const handleEdit = (question) => () => {
        questionForm.setFieldsValue({ ...question, answers: question.ka_answer });
        modal.confirm({
            title: "Редактирование вопроса",
            content: <QuestionForm form={questionForm} />,
            width: 1200,
            onOk: performEdit(question.id),
            okText: "Сохранить",
            cancelText: "Отмена",
        });
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
                        const json = await response.json();
                        setQuestions(questions.filter(({ id }) => id !== parseInt(json.id)));
                    }
                },
            });
        };

    const collumns = [
        {
            key: "text",
            title: "Текст вопроса",
            render: (q) => <Typography.Link onClick={handleEdit(q)}>{q.text}</Typography.Link>,
        },
        {
            key: "diffigulty",
            title: "Сложность",
            dataIndex: "difficulty",
        },
        {
            key: "actions",
            title: (
                <Space>
                    <span>Действия</span>
                    <Button type="link" icon={<PlusCircleOutlined />} onClick={handleAdd}>
                        Добавить
                    </Button>
                </Space>
            ),
            render: (q) => <Button type="link" danger icon={<DeleteOutlined />} onClick={confirmDelete(q)} />,
        },
    ];

    return questions ? (
        <div>
            {questions.length ? (
                <Table pagination={false} size="small" columns={collumns} dataSource={questions} />
            ) : (
                <Empty description="Вопросов не добавлено">
                    <Button icon={<PlusOutlined />} onClick={handleAdd}>
                        Добавить
                    </Button>
                </Empty>
            )}
            {contextHolder}
        </div>
    ) : (
        <Spin />
    );
};
