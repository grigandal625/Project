import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import { Spinner, Container, Stack, Alert } from "react-bootstrap";
import { Form, Input, InputNumber, Checkbox, Row, Col, Table, Button, Space, Modal } from "antd";
import { DeleteOutlined, PlusCircleOutlined } from "@ant-design/icons";

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
                <Form.Item {...field} name={`answer_${i}_text`} rules={[requiredRule]}>
                    <Input placeholder="Введите текст ответа" />
                </Form.Item>
            ),
        },
        {
            title: "Корректность",
            key: "answerCorrect",
            render: (field, _, i) => (
                <Form.Item {...field} name={`answer_${i}_correct`}>
                    <CheckboxField />
                </Form.Item>
            ),
        },
        {
            title: (
                <Space>
                    <span>Действия</span>
                    <Button type="link" onClick={add} icon={<PlusCircleOutlined />} />
                </Space>
            ),
            key: "answerDelete",
            render: (_, __, i) => <Button danger type="link" icon={<DeleteOutlined />} onClick={() => remove(i)} />,
        },
    ];
    return <Table columns={columns} dataSource={fields} />;
};

const QuestionForm = ({ form, ...props }) => {
    return (
        <Form layout="vertical" form={form} {...props}>
            <Row wrap={false} gutter={5}>
                <Col flex="auto">
                    <Form.Item name="text" label="Текст вопроса" rules={[requiredRule]}>
                        <Input placeholder="Введите текст вопроса" />
                    </Form.Item>
                </Col>
                <Col>
                    <Form.Item name="difficulty" label="Текст вопроса" rules={[requiredRule]}>
                        <InputNumber min={1} max={3} step={1} placeholder="Укажите сложность вопроса" />
                    </Form.Item>
                </Col>
            </Row>
            <Form.Item>
                <Form.List>{(fields, { add, remove }) => <Answers fields={fields} add={add} remove={remove} />}</Form.List>
            </Form.Item>
        </Form>
    );
};

const CreateQuestionModal = ({ ka_topic_id, show, handleClose }) => {
    const [answers, setAnswers] = useState([{ text: "Нет правильного ответа", correct: true }]);
    return (
        <Modal size="lg" show={show} onHide={handleClose}>
            <Form action="/ka_questions/new" method="post">
                <Modal.Header closeButton>
                    <Modal.Title>Создание вопроса</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <input type="hidden" name="topic_id" value={ka_topic_id}></input>
                    <Stack direction="horizontal" className="my-3" gap={2}>
                        <Form.Group className="mb-3">
                            <Stack direction="horizontal" gap={2}>
                                <Form.Label className="m-0">Текст вопроса</Form.Label>
                                <Form.Control className="m-0" name="text" required placeholder="Введите вопрос"></Form.Control>
                            </Stack>
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Stack direction="horizontal" gap={2}>
                                <Form.Label className="m-0">Сложность</Form.Label>
                                <Form.Control className="m-0 rounded" name="difficulty" required type="number" placeholder="Введите сложность"></Form.Control>
                            </Stack>
                        </Form.Group>
                    </Stack>
                    <h3 className="my-3">Варианты ответов</h3>
                    <table className="w-100 border-0 border-top">
                        <tr>
                            <th>Текст ответа</th>
                            <th>Корректность</th>
                            <td>
                                <a className="text-decoration-none" onClick={() => setAnswers(answers.concat([{ text: "", correct: false }]))}>
                                    Добавить ответ
                                </a>
                            </td>
                        </tr>
                        {answers.map((answer, i) => (
                            <tr>
                                <td>
                                    <Form.Group>
                                        <Form.Control
                                            name={`answer_${i}_text`}
                                            required
                                            placeholder="Введите текст ответа"
                                            className="border-0"
                                            value={answer.text}
                                            onChange={(e) => {
                                                setAnswers(answers.map((a, idx) => (idx == i ? { ...a, text: e.target.value } : a)));
                                            }}
                                        ></Form.Control>
                                    </Form.Group>
                                </td>
                                <td>
                                    <Form.Group>
                                        <Form.Check
                                            name={`answer_${i}_correct`}
                                            onChange={(e) => {
                                                setAnswers(answers.map((a, idx) => (idx == i ? { ...a, correct: e.target.checked } : a)));
                                            }}
                                            checked={answer.correct}
                                        ></Form.Check>
                                    </Form.Group>
                                </td>
                                <td>
                                    <a onClick={() => setAnswers(answers.filter((a, idx) => idx !== i))} className="text-decoration-none">
                                        Удалить
                                    </a>
                                </td>
                            </tr>
                        ))}
                    </table>
                </Modal.Body>
                <Modal.Footer>
                    <Button type="submit">Добавить</Button>
                    <Button onClick={handleClose} variant="secondary-outline">
                        Отмена
                    </Button>
                </Modal.Footer>
            </Form>
        </Modal>
    );
};

const RemoveQuestionConfirm = ({ question_id, show, handleClose }) => (
    <Modal show={show} onHide={handleClose}>
        <Modal.Header>Удалить вопрос?</Modal.Header>
        <Modal.Footer>
            <a className="text-decoration-none" href={`/ka_questions/destroy/${question_id}`}>
                <Button variant="danger">Удалить</Button>
            </a>
            <Button onClick={handleClose} variant="secondary-outline">
                Отмена
            </Button>
        </Modal.Footer>
    </Modal>
);

export default ({ ka_topic_id }) => {
    const [questions, setQuestions] = useState();
    const [show, setShow] = useState(false);
    const handleClose = () => setShow(false);

    const [confirmingId, setDeleteShow] = useState(false);
    const handleDeleteClose = () => setDeleteShow(false);

    useEffect(() => {
        loadQuestions(ka_topic_id, setQuestions);
    }, []);

    const [modal, contextHolder] = Modal.useModal();
    const [questionForm] = Form.useForm()

    const handleAdd = () => {
        questionForm.setFieldsValue({});
        modal.confirm({
            title: "Создание вопроса к вершине",
            content: <QuestionForm form={questionForm} />,
            width: 700
        })
    }

    return questions ? (
        <div fluid>
            <Stack className="my-3" direction="horizontal" gap={2}>
                <h3>Список вопросов</h3>
                <div className="ms-auto">
                    <Button onClick={handleAdd}>Добавить</Button>
                </div>
            </Stack>
            {questions.length ? (
                <table className="w-100 border-0 border-top border-bottom">
                    <tr>
                        <th>Вопрос</th>
                        <th>Сложность</th>
                        <th>Действия</th>
                    </tr>
                    {questions.map((q) => (
                        <tr>
                            <td>
                                <a className="text-decoration-none" href={`/ka_questions/show/${q.id}`} target="_blank">
                                    {q.text}
                                </a>
                            </td>
                            <td>{q.difficulty}</td>
                            <td>
                                <a className="text-decoration-none" onClick={() => setDeleteShow(q.id)}>
                                    Удалить
                                </a>
                            </td>
                        </tr>
                    ))}
                </table>
            ) : (
                <Alert variant="primary">Вопросов не добавлено</Alert>
            )}
            {contextHolder}
        </div>
    ) : (
        <Spinner />
    );
};
