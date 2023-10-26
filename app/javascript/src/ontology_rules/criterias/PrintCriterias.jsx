import React, { useState, useEffect } from "react";
import Cookies from "universal-cookie";
import "./PrintCriterias.css";

const loadCriterias = async (setCriterias) => {
    let cookies = new Cookies();
    let response = await fetch("/ontology_rules/criterias.json", {
        headers: {
            Authorization: `Token ${cookies.get("auth_token")}`,
            "Content-Type": "application/json",
            "X-CSRF-Token": window.document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content"),
        },
        credentials: "include",
    });
    let criterias = await response.json();
    setCriterias(criterias);
};

export default () => {
    const [criterias, setCriterias] = useState(null);
    useEffect(() => {
        loadCriterias(setCriterias);
    }, []);

    return criterias ? (
        <table>
            <thead>
                <tr>
                    <th>Критерий</th>
                    <th>Параметры</th>
                    <th>Значения</th>
                </tr>
            </thead>
            <tbody>
                {criterias.map((criteria) => (
                    <>
                        <tr className="bold-row">
                            <td
                                rowSpan={Math.max(
                                    criteria.parameters.length,
                                    criteria.values.length
                                )}
                            >
                                {criteria.label}
                            </td>
                            <td>{criteria.parameters[0].label}</td>
                            <td>{criteria.values[0].label}</td>
                        </tr>
                        {Array.apply(
                            null,
                            Array(
                                Math.max(
                                    criteria.parameters.length,
                                    criteria.values.length
                                ) - 1
                            )
                        ).map((_, i) =>
                            criteria.parameters.length != 1 ||
                            criteria.values.length != 1 ? (
                                <tr>
                                    {criteria.parameters.length - 1 > i ? (
                                        <td>
                                            {criteria.parameters[i + 1].label}
                                        </td>
                                    ) : criteria.parameters.length - 1 == i ? (
                                        criteria.values.length !=
                                        criteria.parameters.length ? (
                                            <td
                                                rowSpan={
                                                    criteria.values.length -
                                                    criteria.parameters.length
                                                }
                                            ></td>
                                        ) : (
                                            <></>
                                        )
                                    ) : (
                                        <></>
                                    )}
                                    {criteria.values.length - 1 > i ? (
                                        <td>{criteria.values[i + 1].label}</td>
                                    ) : criteria.values.length - 1 == i ? (
                                        criteria.values.length !=
                                        criteria.parameters.length ? (
                                            <td
                                                rowSpan={
                                                    criteria.parameters.length -
                                                    criteria.values.length
                                                }
                                            ></td>
                                        ) : (
                                            <></>
                                        )
                                    ) : (
                                        <></>
                                    )}
                                </tr>
                            ) : (
                                <></>
                            )
                        )}
                    </>
                ))}
            </tbody>
        </table>
    ) : (
        <></>
    );
};
