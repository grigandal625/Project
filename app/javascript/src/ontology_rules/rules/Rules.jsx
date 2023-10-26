import React, { useState, useEffect } from "react";
import Menu from "../Menu";
import {
    Spinner,
    Table,
    Container,
    Button,
    Dropdown,
    Modal,
    Badge,
} from "react-bootstrap";
import Cookies from "universal-cookie";
import "./Rules.css";
import CreateRuleModal from "./CreateRuleModal";

const loadRules = async (setRules) => {
    let cookies = new Cookies();
    let response = await fetch("/ontology_rules.json", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
        credentials: "include",
    });
    let rules = await response.json();
    setRules(rules);
};

const loadActions = async (setActions) => {
    let cookies = new Cookies();
    let response = await fetch("/ontology_rules/actions", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
        credentials: "include",
    });
    let actions = await response.json();
    setActions(actions);
};

const removeRule = async (ruleID) => {
    let cookies = new Cookies();
    let response = await fetch(`/ontology_rules/delete/${ruleID}`, {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
        credentials: "include",
    });
    return response.ok;
};

const RemoveRuleModal = ({ rule, close }) => {
    const [loading, setLoading] = useState(false);
    const performRemove = async () => {
        setLoading(true);
        let res = removeRule(rule.id);
        setLoading(false);
        close(res);
    };
    return (
        <Modal style={{ zIndex: 0 }} show={rule ? true : false}>
            <Modal.Header>
                <Modal.Title>Подтвердите действие</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Container>
                    <p>Удалить правило {rule ? rule.id : ""}?</p>
                </Container>
            </Modal.Body>
            <Modal.Footer>
                <Button disabled={loading} onClick={performRemove}>
                    Удалить
                </Button>
                <Button
                    disabled={loading}
                    onClick={() => close(false)}
                    variant="danger"
                >
                    Отмена
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

const ConditionPreview = ({ condition }) =>
    condition.type ? (
        condition.type == "value_expression" ? (
            condition.value !== undefined ? (
                <>
                    {condition.value.label
                        ? condition.value.label
                        : JSON.stringify(condition.value)}
                </>
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

const RulesTable = () => {
    const [rules, setRules] = useState(null);
    const [deletingRule, setDeletingRule] = useState(null);
    const [createRule, setCreateRule] = useState(false);
    const [testingRule, setTestingRule] = useState(null);
    const [actions, setActions] = useState(null);

    useEffect(() => {
        const load = async () => {
            await loadRules(setRules);
            await loadActions(setActions);
        };
        load();
    }, []);

    return rules ? (
        <>
            <h3 className="d-flex justify-content-between">
                <span>Правила</span>
                <Button onClick={() => setCreateRule(true)}>
                    Создать правило
                </Button>
            </h3>
            <Table bordered>
                <thead>
                    <tr>
                        <th>№</th>
                        <th>Описание</th>
                        <th>Условие</th>
                        <th>Действия</th>
                        <th>Коэффициент уверенности</th>
                        <th>Опции</th>
                    </tr>
                </thead>
                <tbody>
                    {rules.map((rule) => (
                        <tr>
                            <td>{rule.id}</td>
                            <td>{rule.description}</td>
                            <td>
                                Если{" "}
                                <ConditionPreview condition={rule.condition} />
                            </td>
                            <td>
                                {actions ? (
                                    rule.actions.map((action) => (
                                        <div className="m-1 p-2 border action-badge">
                                            {
                                                actions.filter(
                                                    (a) => a.type == action
                                                )[0].label
                                            }
                                        </div>
                                    ))
                                ) : (
                                    <Spinner size="sm" />
                                )}
                            </td>
                            <td>{rule.cf}</td>
                            <td>
                                <Dropdown>
                                    <Dropdown.Toggle></Dropdown.Toggle>
                                    <Dropdown.Menu>
                                        <Dropdown.Item
                                            onClick={() => setTestingRule(rule)}
                                        >
                                            Протестировать
                                        </Dropdown.Item>
                                        <Dropdown.Item
                                            onClick={() =>
                                                setCreateRule({ ...rule })
                                            }
                                        >
                                            Дублировать
                                        </Dropdown.Item>
                                        <Dropdown.Item
                                            onClick={() =>
                                                setDeletingRule(rule)
                                            }
                                        >
                                            Удалить
                                        </Dropdown.Item>
                                    </Dropdown.Menu>
                                </Dropdown>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </Table>
            <RemoveRuleModal
                rule={deletingRule}
                close={(deleted) => {
                    if (deleted) {
                        setRules(rules.filter((r) => r.id !== deletingRule.id));
                    }
                    setDeletingRule(null);
                }}
            />
            <CreateRuleModal
                show={createRule}
                close={(rule) => {
                    if (rule) {
                        setRules(rules.concat([rule]));
                    }
                    setCreateRule(false);
                }}
                initial={
                    typeof createRule == typeof Boolean() ? {} : createRule
                }
            />
        </>
    ) : (
        <Spinner />
    );
};

export default () => (
    <>
        <Menu active={1} />
        <br />
        <div className="px-5">
            <RulesTable />
        </div>
    </>
);
