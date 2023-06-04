import React from "react";
import { Nav, Navbar, Container } from "react-bootstrap";
export default ({ active }) => (
    <Navbar bg="dark" variant="dark" expand="lg">
        <Container>
            <Navbar.Brand>Критерии</Navbar.Brand>
            <Navbar.Toggle aria-controls="basic-navbar-nav" />
            <Navbar.Collapse>
                <Nav>
                    <Nav.Link active={active === 1} href="/ontology_rules">
                        Правила
                    </Nav.Link>
                    <Nav.Link active={active === 2} href="/ontology_rules/criterias">
                        Критерии
                    </Nav.Link>
                </Nav>
            </Navbar.Collapse>
            <Navbar.Collapse className="justify-content-end">
                <Nav>
                    <Nav.Link href="/ka_topics">Редактор</Nav.Link>
                    <Nav.Link href="/">На главную</Nav.Link>
                </Nav>
            </Navbar.Collapse>
        </Container>
    </Navbar>
);
