import { useState } from "react";
import React from "react";
import { Form, Button, Table, Spinner } from "react-bootstrap";
import VertexParameter from "./parameters/VertexParameter";
import Cookies from "universal-cookie";
import StudentParameter from "./parameters/StudentParameter";
import GroupParameter from "./parameters/GroupParameter";

const evaluateCriteria = async (id, data, setData, setLoading) => {
    setLoading(true);
    let cookies = new Cookies();
    let response = await fetch(`/ontology_rules/criterias/evaluate/${id}`, {
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
    setData(result);
    setLoading(false);
};

const Results = ({ data, loading, parameters }) => {
    const valueHandlers = {
        vertex: (v) => v.text,
        student: (s) => `${s.fio} - ${s.group.number}`,
        group: (g) => g.number,
        threshold: (v) => v.toString(),
    };

    data = !data ? data : data.hasOwnProperty("length") ? data : [data];
    return loading ? (
        <Spinner />
    ) : data ? (
        <>
            <h3>Результат</h3>
            <Table bordered>
                <thead>
                    <tr>
                        <th colSpan={Object.keys(parameters).length}>Параметры</th>
                        <th style={{ borderBottom: "0px" }}>Значение критерия</th>
                    </tr>
                    <tr>
                        {Object.keys(parameters).map((p) => (
                            <th>{parameters[p].label}</th>
                        ))}
                        <th style={{ borderTop: "0px" }}></th>
                    </tr>
                </thead>
                <tbody>
                    {data.map((row) => (
                        <tr>
                            {Object.keys(parameters).map((p) => (
                                <td>{valueHandlers[p](row.parameters[p])}</td>
                            ))}
                            <td>{row.value.label}</td>
                        </tr>
                    ))}
                </tbody>
            </Table>
        </>
    ) : (
        <></>
    );
};

export default ({ criteria }) => {
    const parameterClasses = { vertex: VertexParameter, student: StudentParameter, group: GroupParameter };
    const typeClasses = {
        number: ({ value, setter }) => (
            <Form.Control type="number" value={value} onChange={(e) => setter(e.target.value)} />
        ),
    };
    const parameters = criteria.parameters.reduce((accumulator, parameter) => {
        let [value, setter] = useState("default" in parameter ? parameter.default : null);
        accumulator[parameter.name] = { value, setter, label: parameter.label };
        return accumulator;
    }, {});

    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(false);
    const parameterHandlers = {
        vertex: (v) => Object({ id: v.value }),
        student: (v) => v.value,
        threshold: (v) => v.value,
        group: (v) => v.value,
    };
    return (
        <>
            <Form>
                <h3>Параметры</h3>
                {criteria.parameters.map((p) => {
                    let ReactClass = parameterClasses[p.name] ? parameterClasses[p.name] : typeClasses[p.type];
                    let variables = parameters[p.name];
                    return ReactClass ? (
                        <Form.Group>
                            <Form.Label>{p.label}</Form.Label>
                            <ReactClass {...variables} parameter={p}></ReactClass>
                        </Form.Group>
                    ) : (
                        <></>
                    );
                })}
                <hr />
                <Form.Group>
                    <Button
                        disabled={loading}
                        onClick={() => {
                            let d = Object.entries(parameters).reduce((accumulator, [name, value]) => {
                                accumulator[name] = parameterHandlers[name](value);
                                return accumulator;
                            }, {});
                            evaluateCriteria(criteria.id, d, setData, setLoading);
                        }}
                    >
                        Протестировать
                    </Button>
                </Form.Group>
            </Form>
            <br />
            <Results data={data} loading={loading} parameters={parameters} />
        </>
    );
};
