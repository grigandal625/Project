import React, { useEffect, useState } from "react";
import { Modal, Button, Dropdown, Form, Row, Col, Spinner, DropdownButton } from "react-bootstrap";
import Cookies from "universal-cookie";

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

const loadExpressions = async (setExpressions) => {
    let cookies = new Cookies();
    let response = await fetch("/ontology_rules/expressions", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        credentials: "include",
    });
    let expressions = await response.json();
    setExpressions(expressions);
};

const loadActions = async (setActions) => {
    let cookies = new Cookies();
    let response = await fetch("/ontology_rules/actions", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        credentials: "include",
    });
    let actions = await response.json();
    setActions(actions);
};

const createRule = async (data, close) => {
    let cookies = new Cookies();
    let response = await fetch("/ontology_rules/create", {
        method: "post",
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        body: JSON.stringify(data),
        credentials: "include",
    });
    let result = await response.json();
    close(result);
};

const findCriteriaByValue = (criterias, current) =>
    criterias.filter(
        (c) => c.values.filter((v) => v.id == current.value.id && v.label == current.value.label).length
    )[0];

const CriteriaValues = ({ condition, current, setCondition }) => {
    const [criterias, setCriterias] = useState(null);
    const [selected, setSelected] = useState(null);
    useEffect(() => {
        loadCriterias(setCriterias);
    }, []);

    useEffect(() => {
        if (criterias) {
            const selectedCriteria =
                criterias && current.value && current.value.id && current.value.label
                    ? findCriteriaByValue(criterias, current)
                    : null;
            setSelected(selectedCriteria);
        }
    }, [criterias]);

    return criterias ? (
        <Row>
            <Col>
                <Form.Select
                    size="sm"
                    value={selected ? selected.id : undefined}
                    onChange={(e) => setSelected(criterias.filter((c) => c.id == e.target.value)[0])}
                >
                    <option>--- выберите критерий ---</option>
                    {criterias.map((c) => (
                        <option value={c.id}>{c.label}</option>
                    ))}
                </Form.Select>
            </Col>
            <Col>
                <Form.Select
                    onChange={(e) => {
                        current.value = selected.values.filter((v) => v.id == e.target.value)[0];
                        setCondition({ ...condition });
                    }}
                    disabled={selected ? false : true}
                    size="sm"
                    value={current.value? current.value.id : undefined}
                >
                    <option>--- выберите значение критерия ---</option>
                    {selected ? selected.values.map((v) => <option value={v.id}>{v.label}</option>) : <></>}
                </Form.Select>
            </Col>
        </Row>
    ) : (
        <Spinner size="sm" />
    );
};

const ValueExpression = ({ condition, current, setCondition }) => {
    const [type, setType] = useState(
        current.value
            ? typeof current.value == typeof String("")
                ? 1
                : typeof current.value == typeof Number(0)
                ? 2
                : typeof current.value == typeof Boolean()
                ? 3
                : typeof current.value == typeof Object({})
                ? 4
                : 1
            : 1
    );
    return (
        <Row xs="auto" className="ml-2 mt-2 p-1 border">
            <Col>
                <Form.Group>
                    <Row>
                        <Col>
                            <Form.Label>Тип значения</Form.Label>
                        </Col>
                        <Col>
                            <Form.Select
                                size="sm"
                                value={type}
                                onChange={(e) => setType(e.target.value)}
                                placeholder="Выберите тип значения"
                            >
                                <option value={1}>Строка</option>
                                <option value={2}>Число</option>
                                <option value={3}>Логический</option>
                                <option value={4}>Значение критерия</option>
                            </Form.Select>
                        </Col>
                    </Row>
                </Form.Group>
            </Col>
            <Col>
                <Form.Group>
                    <Row>
                        <Col lg={3}>
                            <Form.Label>Значение</Form.Label>
                        </Col>
                        <Col>
                            {type == 1 ? (
                                <Form.Control
                                    size="sm"
                                    onChange={(e) => {
                                        current.value = e.target.value;
                                        setCondition({ ...condition });
                                    }}
                                    value={current.value}
                                ></Form.Control>
                            ) : type == 2 ? (
                                <Form.Control
                                    size="sm"
                                    type="number"
                                    value={current.value}
                                    onChange={(e) => {
                                        current.value = Number(e.target.value);
                                        setCondition({ ...condition });
                                    }}
                                ></Form.Control>
                            ) : type == 3 ? (
                                <Row>
                                    <Col>
                                        <Form.Check
                                            onChange={(e) => {
                                                current.value = e.target.checked;
                                                setCondition({ ...condition });
                                            }}
                                            checked={current.value}
                                        ></Form.Check>
                                    </Col>
                                    <Col>{current.value ? "True" : "False"}</Col>
                                </Row>
                            ) : (
                                <CriteriaValues {...{ condition, current, setCondition }} />
                            )}
                        </Col>
                    </Row>
                </Form.Group>
            </Col>
        </Row>
    );
};

const CriteriaExpression = ({ condition, current, setCondition }) => {
    const [criterias, setCriterias] = useState(null);
    useEffect(() => {
        loadCriterias(setCriterias);
    }, []);
    return criterias ? (
        <Form.Select
            value={current.criteria}
            onChange={(e) => {
                current.criteria = Number(e.target.value);
                current.criteriaLabel = e.target.value
                    ? criterias.filter((c) => c.id == e.target.value)[0].label
                    : " - ";
                setCondition({ ...condition });
            }}
            size="sm"
        >
            <option>--- выберите критерий ---</option>
            {criterias.map((c) => (
                <option value={c.id}>{c.label}</option>
            ))}
        </Form.Select>
    ) : (
        <Spinner size="sm" />
    );
};

const SignedExpression = ({ condition, current, setCondition }) => {
    current.left = current.left || {};
    current.right = current.right || {};
    return (
        <div className="border p-2">
            <Form.Group>
                <Row className="my-3">
                    <Col>
                        <Form.Label>Знак выражения:</Form.Label>
                    </Col>
                    <Col>
                        <Form.Select
                            onChange={(e) => {
                                current.sign = e.target.value;
                                setCondition({ ...condition });
                            }}
                            size="sm"
                            value={current.sign}
                        >
                            <option>--- выберите знак ---</option>
                            {["+", "-", "*", "/", ">", "<", "==", "!=", ">=", "<=", "&&", "||"].map((s) => (
                                <option value={s}>{s}</option>
                            ))}
                        </Form.Select>
                    </Col>
                </Row>
            </Form.Group>
            <Form.Group>
                <Row className="my-3">
                    <Col lg={2}>Левая часть:</Col>
                    <Col lg={10} className="border">
                        <Condition {...{ condition, current: current.left, setCondition }} />
                    </Col>
                </Row>
            </Form.Group>
            <Form.Group>
                <Row className="my-3">
                    <Col lg={2}>Правая часть:</Col>
                    <Col lg={10} className="border">
                        <Condition {...{ condition, current: current.right, setCondition }} />
                    </Col>
                </Row>
            </Form.Group>
        </div>
    );
};

const ConditionContent = ({ condition, current, setCondition }) => {
    switch (current.type) {
        case "value_expression":
            return <ValueExpression {...{ condition, current, setCondition }} />;
        case "criteria_expression":
            return <CriteriaExpression {...{ condition, current, setCondition }} />;
        case "signed_expression":
            return <SignedExpression {...{ condition, current, setCondition }} />;
        default:
            return <></>;
    }
};

const Condition = ({ condition, current, setCondition }) => {
    const [expressions, setExpressions] = useState(null);
    useEffect(() => {
        loadExpressions(setExpressions);
    }, []);
    return expressions ? (
        <div className="p-2">
            <Form.Group>
                <Form.Label className="mt-2">Тип выражения</Form.Label>
                <Form.Select
                    size="sm"
                    value={current.type}
                    onChange={(e) => {
                        current.type = e.target.value;
                        setCondition({ ...condition });
                    }}
                    placeholder="Выберите тип выражения"
                >
                    <option>--- выберите тип выражения ---</option>
                    {expressions.map((e) => (
                        <option value={e.type}>{e.label}</option>
                    ))}
                </Form.Select>
            </Form.Group>
            <ConditionContent {...{ condition, current, setCondition }} />
        </div>
    ) : (
        <Spinner />
    );
};

const ConditionPreview = ({ condition }) =>
    condition.type ? (
        condition.type == "value_expression" ? (
            condition.value !== undefined ? (
                <>{condition.value.label ? condition.value.label : JSON.stringify(condition.value)}</>
            ) : (
                " - "
            )
        ) : condition.type == "criteria_expression" ? (
            condition.criteriaLabel || " - "
        ) : condition.type == "signed_expression" ? (
            <>
                {"("}
                <ConditionPreview condition={condition.left || {}} />
                {" " + (condition.sign || "#") + " "}
                <ConditionPreview condition={condition.right || {}} />
                {")"}
            </>
        ) : (
            " - "
        )
    ) : (
        " - "
    );

const Actions = ({ actions, setActions }) => {
    const [acts, setActs] = useState(null);
    useEffect(() => {
        loadActions(setActs);
    }, []);

    const unused = acts ? acts.filter((a) => !actions.includes(a.type)) : [];
    const used = acts ? acts.filter((a) => actions.includes(a.type)) : [];

    return acts ? (
        <div>
            <div>
                {used.map((action) => (
                    <Row className="mb-1">
                        <Col lg={11}>{action.label}</Col>
                        <Col lg={1}>
                            <Button
                                onClick={() => setActions(actions.filter((a) => a != action.type))}
                                variant="danger"
                                size="sm"
                            >
                                Удалить
                            </Button>
                        </Col>
                    </Row>
                ))}
            </div>
            <div>
                <DropdownButton style={{ width: "100%" }} title="Добавить действие">
                    {unused.length ? (
                        unused.map((action) => (
                            <Dropdown.Item onClick={() => setActions(actions.concat([action.type]))}>
                                {action.label}
                            </Dropdown.Item>
                        ))
                    ) : (
                        <Dropdown.Item>(нет доступных действий)</Dropdown.Item>
                    )}
                </DropdownButton>
            </div>
        </div>
    ) : (
        <Spinner />
    );
};

const CreateRuleForm = ({ close, initial }) => {
    const [condition, setCondition] = useState(initial.condition || {});
    const [actions, setActions] = useState(initial.actions || []);
    const [cf, setCf] = useState(initial.cf || undefined);
    const [loading, setLoading] = useState(false);
    const [description, setDescription] = useState(initial.description || undefined);
    return (
        <>
            <Modal.Body>
                <h4>Описание</h4>
                <Form.Control
                    as="textarea"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Описание правила на ЕЯ"
                    style={{ minHeight: 120 }}
                ></Form.Control>
                <Form.Group>
                    <Row className="mt-3">
                        <Col lg={3}>
                            <Form.Label>Коэффициент уверенности</Form.Label>
                        </Col>
                        <Col lg={9}>
                            <Form.Control
                                size="sm"
                                value={cf}
                                onChange={(e) => setCf(Number(e.target.value))}
                                type="number"
                                min={0}
                                max={1}
                                step={0.01}
                            />
                        </Col>
                    </Row>
                </Form.Group>
                <h4>Условие</h4>
                <p>Предпросмотр</p>
                <p className="border p-2 my-2">
                    Если <ConditionPreview condition={condition} />
                </p>
                <Condition condition={condition} current={condition} setCondition={setCondition} />
                <hr />
                <h4>Действия</h4>
                <Actions actions={actions} setActions={setActions} />
            </Modal.Body>
            <Modal.Footer>
                <Button disabled={loading} onClick={() => createRule({ condition, actions, cf, description }, close)}>
                    Создать
                </Button>
                <Button disabled={loading} variant="danger" onClick={() => close(false)}>
                    Отмена
                </Button>
            </Modal.Footer>
        </>
    );
};

export default ({ show, close, initial }) => (
    <Modal show={show} fullscreen onHide={() => close(false)}>
        <Modal.Header closeButton>Создание правила</Modal.Header>
        <CreateRuleForm close={close} initial={initial || {}} />
    </Modal>
);
