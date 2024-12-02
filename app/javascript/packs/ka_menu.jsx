import ReactDOM from "react-dom";
import { Menu } from "antd";
import React from "react";
import { createRoot } from "react-dom/client";

const MainMenu = () => {
    const items = (window.__MENU__ || []).map(({ label, path }, i) => ({ key: (i + 1).toString(), label: <a href={path}>{label}</a> }));

    return <Menu mode="horizontal" theme="dark" items={items} />;
};

document.addEventListener("DOMContentLoaded", () => {
    console.log("READY");
    createRoot(document.getElementById("main_menu")).render(<MainMenu />);
});
