import React from "react";
import Draggable from "react-draggable";
import Cookies from "universal-cookie";

const navigate = (url) => {
    let a = window.document.createElement("a");
    a.href = url;
    a.click();
};

export default class GroupWrapper extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            elements: this.props.elements,
            groups: [],
            hoveredGroupIndex: null,
            draggingElement: null,
        };
        this.onDragStop = this.onDragStop.bind(this);
        this.setDraggingElement = this.setDraggingElement.bind(this);
    }

    elementIsUsed = (e) => {
        for (let i in this.state.groups) {
            if (this.state.groups[i].includes(e)) {
                return true;
            }
        }
        return false;
    };

    get usedElemenst() {
        let elements = this.state.elements.filter((e) => this.elementIsUsed(e));
        return elements;
    }

    get unusedElements() {
        return this.state.elements.filter(
            (e) => !this.usedElemenst.includes(e)
        );
    }

    renderAddingElement = (index) =>
        index === this.state.hoveredGroupIndex ? <div>+</div> : <></>;

    dragOverGroup =
        (index, enter = true) =>
        () => {
            this.setState((state) => {
                state.hoveredGroupIndex =
                    enter && state.draggingElement ? index : null;
                return state;
            });
        };

    deleteGroup = (index) => () => {
        this.setState((state) => {
            state.groups = state.groups.filter((g, i) => i != index);
            return state;
        });
    };

    renderGroup = (group, index) => {
        return (
            <div
                onMouseEnter={this.dragOverGroup(index)}
                onMouseLeave={this.dragOverGroup(index, false)}
                style={{
                    border: "1px solid white",
                    padding: 20,
                }}
            >
                <div>
                    <span>Группа {index + 1}</span>
                    <button
                        className="btn btn-danger delete-group-btn"
                        onClick={this.deleteGroup(index)}
                    >
                        Удалить группу
                    </button>
                </div>
                {group.map((element) =>
                    this.renderDraggableElement(element, true)
                )}
                {this.renderAddingElement(index)}
            </div>
        );
    };

    addGroup = () => {
        this.setState((state) => {
            state.groups.push([]);
            return state;
        });
    };

    renderDraggableElement = (e, removable = false) => (
        <DraggableElement
            onDragStart={this.setDraggingElement}
            onDragStop={this.onDragStop}
            element={e}
            removable={removable}
            removeElement={this.removeElement.bind(this)}
        ></DraggableElement>
    );

    onDragStop = (element) => {
        if (this.state.hoveredGroupIndex !== null) {
            this.setState((state) => {
                state.groups = state.groups.map((g, i) => {
                    return i === state.hoveredGroupIndex
                        ? g.includes(element)
                            ? g
                            : g.concat([element])
                        : g.filter((e) => e != element);
                });
                state.hoveredGroupIndex = null;
                state.draggingElement = null;
                return state;
            });
        } else {
            this.setState((state) =>
                Object({ ...state, draggingElement: null })
            );
            this.forceUpdate();
        }
    };

    removeElement = (element) => {
        this.setState((state) => {
            debugger;
            state.groups = state.groups.map((g) =>
                g.filter((e) => e != element)
            );
            return state;
        });
    };

    setDraggingElement = (element) => {
        this.setState((state) =>
            Object({ ...state, draggingElement: element })
        );
    };

    sendGroups = async () => {
        let data = this.state.groups.reduce((accum, group, i) => {
            let field = `group_${i + 1}`;
            accum[field] = group;
            return accum;
        }, {});

        let cookies = new Cookies();

        let response = await fetch("/personality_tests/free_sort_objects", {
            method: "POST",
            body: JSON.stringify({ data: data }),
            headers: {
                Authorization: `Token ${cookies.get("auth_token")}`,
                "Content-Type": "application/json",
                "X-CSRF-Token": window.document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute("content"),
            },
            credentials: "include",
            redirect: "follow",
        });
        navigate(response.url);
    };

    render() {
        return (
            <div>
                <div
                    style={{
                        border: "1px solid white",
                        padding: 20,
                    }}
                >
                    {this.unusedElements.map((e) =>
                        this.renderDraggableElement(e)
                    )}
                </div>
                <div>
                    {this.state.groups.map((g, i) => this.renderGroup(g, i))}
                    <button
                        style={{ color: "black" }}
                        className="btn"
                        onClick={this.addGroup}
                    >
                        Добавить группу
                    </button>
                    <button
                        className="btn btn-success"
                        onClick={this.sendGroups}
                        disabled={Boolean(this.unusedElements.length)}
                    >
                        Отправить ответ
                    </button>
                </div>
            </div>
        );
    }
}

class DraggableElement extends React.Component {
    constructor(props) {
        super(props);
        this.state = { drag: false, pos: null, delta: [0, 0] };
    }
    get style() {
        return { pointerEvents: this.state.drag ? "none" : "auto" };
    }

    get removeBtn() {
        const style = { cursor: "pointer", marginLeft: 7 };
        const onClick = () => this.props.removeElement(this.props.element);
        return this.props.removable ? (
            <a style={style} onClick={onClick}>
                x
            </a>
        ) : (
            <></>
        );
    }

    render() {
        return (
            <Draggable
                position={this.state.pos}
                cancel="a"
                onStart={() => {
                    this.setState({ drag: true });
                    this.props.onDragStart(this.props.element);
                }}
                onStop={() => {
                    this.setState({ drag: false, pos: { x: 0, y: 0 } });
                    this.props.onDragStop(this.props.element);
                }}
                onDrag={(e, { x, y }) => {
                    this.setState({ pos: { x, y } });
                }}
            >
                <div style={this.style} className="dragging-element">
                    <span>{this.props.element}</span>
                    {this.removeBtn}
                </div>
            </Draggable>
        );
    }
}
